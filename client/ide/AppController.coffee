class IDEAppController extends AppController

  KD.registerAppClass this,
    name         : 'IDE'
    route        : '/:name?/IDE'
    behavior     : 'application'
    preCondition :
      condition  : (options, cb)-> cb KD.isLoggedIn()
      failure    : (options, cb)->
        KD.singletons.appManager.open 'IDE', conditionPassed : yes
        KD.showEnforceLoginModal()

  constructor: (options = {}, data) ->
    options.appInfo =
      type          : 'application'
      name          : 'IDE'

    super options, data

    layoutOptions   =
      direction     : 'vertical'
      splitName     : 'BaseSplit'
      sizes         : [ '250px', null ]
      views         : [
        {
          type      : 'custom'
          name      : 'filesPane'
          paneClass : IDEFilesTabView
        },
        {
          type      : 'custom'
          name      : 'editorPane'
          paneClass : IDETabView
        }
      ]

    workspace = @workspace = new Workspace { layoutOptions }
    workspace.once 'ready', =>
      panel = workspace.getView()
      @getView().addSubView panel

      panel.once 'viewAppended', =>
        @setActiveTabView panel.getPaneByName 'editorPane'

  setActiveTabView: (tabView) ->
    @activeTabView = tabView

  splitTabView: (type = 'vertical') ->
    @activeTabView.convertToSplitView type

  mergeSplitView: ->
    @activeTabView.mergeSplitView()

  openFile: (file, contents) ->
    @activeTabView.openFile file, contents
