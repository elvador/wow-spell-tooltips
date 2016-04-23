module.exports =
class WowSpellTooltipView
  constructor: ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('wow-spell-tooltip')

    @spellNameSpan = document.createElement('span')
    @element.appendChild(@spellNameSpan)
    @element.appendChild(document.createElement('br'))

    @rangeSpan = document.createElement('span')
    @element.appendChild(@rangeSpan)
    @element.appendChild(document.createElement('br'))

    @castSpan = document.createElement('span')
    @element.appendChild(@castSpan)
    @element.appendChild(document.createElement('br'))

    @descSpan = document.createElement('span')
    @descSpan.classList.add('wow-spell-tooltip-desc')
    @element.appendChild(@descSpan)


  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setSpell: (line) ->
    data = line.split(',', 7)

    data[4] = parseInt(data[4])
    castTime = data[4]/1000 + " sec cast"
    if data[4] == 0
      castTime = "Instant"

    data[5] = parseInt(data[5])
    data[6] = parseInt(data[6])
    range = data[6]+" yd range"
    if data[6] == 0
      range = ""
    else if data[6] == 50000
      range = "Unlimited range"
    else if data[5] != 0
      range = data[5] + " - " + range

    # spell desc
    tokens = line.split(',').slice(7)
    desc = tokens.join(',')
    desc = desc.replace(/(?:\\[rn]|[\r\n]+)+/g, " ") # removing \r and \n
    desc = desc.replace(/\|c[0-9a-f]{6,8}/gi, "") # removing |cCOLOR
    desc = desc.replace(/\|r/gi, "") # removing |r

    @spellNameSpan.textContent = data[1] + " (id: " + data[0] + ")"
    @rangeSpan.textContent = range
    @castSpan.textContent = castTime
    @descSpan.textContent = desc
