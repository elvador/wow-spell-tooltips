view = require './wow-spell-tooltips-view'
fs = require 'fs'
path = require 'path'

{CompositeDisposable} = require 'atom'

module.exports = WowSpellTooltips =
  view: null
  tooltip: null
  spellIds: null

  activate: (state) ->
    @view = new view()

    atom.workspace.observeTextEditors (editor) ->
      editor.observeCursors (cursor) ->
        cursor.onDidChangePosition (event) ->
          if editor.getTitle().endsWith(".lua")
            if WowSpellTooltips.spellIds == null
              WowSpellTooltips.loadCSV()

            selection = event.cursor.selection.getText()
            if selection and selection.trim().length > 0 and not isNaN(selection)
              number = parseInt selection.trim()

              if WowSpellTooltips.spellIds? and WowSpellTooltips.spellIds[number]
                WowSpellTooltips.view.setSpell(WowSpellTooltips.spellIds[number])
                WowSpellTooltips.tooltip.destroy() if WowSpellTooltips.tooltip
                WowSpellTooltips.tooltip = editor.decorateMarker(event.cursor.getMarker(), {type: 'overlay', class: 'my-line-class', item:WowSpellTooltips.view})
            else
              WowSpellTooltips.tooltip.destroy() if WowSpellTooltips.tooltip

  deactivate: ->
    @tooltip.destroy()
    @view.destroy()

  serialize: ->
    wordcountViewState: @view.serialize()

  loadCSV: ->
    @spellIds = []
    packagePath = atom.packages.getActivePackage('wow-spell-tooltips').path
    csvPath = path.join(packagePath, 'assets', 'SpellData.csv')
    fs.readFile csvPath, (err, data) =>
      return if err
      for line in data.toString().split('\n')
        spellData = line.split(",")
        @spellIds[spellData[0]] = line if spellData[0]
