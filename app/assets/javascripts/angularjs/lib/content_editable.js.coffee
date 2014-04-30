angular.module('mitsumottaroApp').directive 'contenteditable', ($parse) ->
  {
    restrict: 'A'
    require: 'ngModel',
    link: (scope, elm, attrs, model) ->
      nameHash = Math.round(Math.random() * 1e15).toString(36)

      fn = $parse attrs.mtBlur
      elm.on 'blur', ->
        scope.$apply ->
          updateModel()
          if !attrs.noErrMsg
            $("##{nameHash}_required").hide()
            $("##{nameHash}_pattern").hide()
          if model.$valid
            fn(scope)
          else
            elm.focus()
            if !attrs.noErrMsg
              if model.$error.required
                $("##{nameHash}_required").show()
              if model.$error.pattern
                $("##{nameHash}_pattern").show()
            model && model.$cancelUpdate && model.$cancelUpdate()

      model.$render = ->
        elm.text(model.$viewValue || '')

      updateModel = ->
        html = elm.html()
        if html == '<br>'
          html = ''
        model.$setViewValue(html)

      # initialize
      elm.text(model.$viewValue)
      if attrs.ngRequired && !attrs.noErrMsg
        elm.after($("<div class='alert alert-error' id='#{nameHash}_required'/>").text("入力してください。").hide())
      if attrs.ngPattern && !attrs.noErrMsg
        elm.after($("<div class='alert alert-error' id='#{nameHash}_pattern'/>").text("正しい形式で入力してください。").hide())

      # This is not one of the input element, ngPattern is not supported in AngularJS 1.2.16
      # The following code comes from AngularJS 1.2.16's input validator definition
      (() ->
        validate = (ctrl, validatorName, validity, value) ->
          ctrl.$setValidity(validatorName, validity)
          if validity then value else undefined

        pattern = attrs.ngPattern
        if pattern
          validateRegex = (regexp, value) ->
            validate(model, 'pattern', model.$isEmpty(value) || regexp.test(value), value)

          match = pattern.match(/^\/(.*)\/([gim]*)$/)
          if match
            pattern = new RegExp(match[1], match[2])
            patternValidator = (value) ->
              validateRegex(pattern, value)
          else
            patternValidator = (value) ->
              patternObj = scope.$eval(pattern)

              if !patternObj || !patternObj.test
                throw minErr('ngPattern')('noregexp',
                  'Expected {0} to be a RegExp but was {1}. Element: {2}', pattern,
                  patternObj, startingTag(element))

              validateRegex(patternObj, value)

          model.$formatters.push(patternValidator)
          model.$parsers.push(patternValidator)
      )()
  }
