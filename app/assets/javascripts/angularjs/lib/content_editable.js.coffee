angular.module('mitsumottaroApp').directive 'contenteditable', ['$parse', ($parse) ->
  {
    restrict: 'A'
    require: 'ngModel',
    link: (scope, elm, attrs, model) ->
      nameHash = Math.round(Math.random() * 1e15).toString(36)

      fn = $parse attrs.mtBlur
      elm.on 'blur', ->
        updateModel()
        if !attrs.noErrMsg
          $("##{nameHash}_required").hide()
          $("##{nameHash}_pattern").hide()
        if model.$valid
          if  model.$dirty
            fn(scope)
            model.$setPristine()
        else
          elm.focus()
          if !attrs.noErrMsg
            if model.$error.required
              $("##{nameHash}_required").show()
            if model.$error.pattern
              $("##{nameHash}_pattern").show()
          model && model.$cancelUpdate && model.$cancelUpdate()

      if attrs.selectOnFocus
        elm.on 'focus', ->
          window.setTimeout ->
            if window.getSelection && document.createRange
                range = document.createRange()
                range.selectNodeContents elm[0]
                sel = window.getSelection()
                sel.removeAllRanges()
                sel.addRange range
            else if document.body.createTextRange
                range = document.body.createTextRange()
                range.moveToElementText elm[0]
                range.select()
          , 1



      model.$render = ->
        value = if model.$viewValue? then model.$viewValue else ''
        elm.text(value)

        if attrs.moveCaretToEndOnChange
          el = elm[0]
          range = document.createRange()
          sel = window.getSelection()
          if el.childNodes.length > 0
            el2 = el.childNodes[el.childNodes.length - 1]
            range.setStartAfter el2
          else
            range.setStartAfter el
          range.collapse true
          sel.removeAllRanges()
          sel.addRange range


      updateModel = ->
        text = elm.text().replace /\r?\n/, ""
        if (!model.$viewValue? || model.$viewValue == "") && (!text? || text == "")
          # do nothing
        else if String(model.$viewValue) != text
          model.$setViewValue(text)
        elm.html('')  # This line is necessory to remove '<br>'
        elm.text(text)

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
                  patternObj, startingTag(elm))

              validateRegex(patternObj, value)

          model.$formatters.push(patternValidator)
          model.$parsers.push(patternValidator)
      )()
  }
]
