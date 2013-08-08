
require! fs

{ tail
, lines
, compact
, fold
, words
, map
} = require 'prelude-ls'

### INPUT PARSING ###

# Parse "N R T M" line to an object
parse-line = (event) ->
  [visitor, room, type, minutes] = words event

  room: +room
  visitor: +visitor
  minutes: if type is "O" => +minutes + 1
           else -minutes
  visitors: if type is "O" => 1
            else 0

# Parse text file input into lines
parse-input = (.to-string!) >> tail >> lines >> compact

# Parse file input into a estructured value
input-to-info = parse-input >> (map parse-line)


### COLLECTING THE EVENTS INTO STATS ###

# Merge an existing event with a new one
merge-events = (dest, event) ->
  return event if not dest?

  {room:r1, minutes:m1, visitors:v1} = dest
  {room:r2, minutes:m2, visitors:v2} = event

  room: r1
  minutes: m1 + m2
  visitors: v1 + v2

# Merge event on its room stat
collect-event = (stats, {room}:event) ->
  stats[room] = merge-events stats[room], event
  stats

collect-events = fold collect-event, []

# Calculate average minutes as requested
fill-average = (stat) ->
  stat?.avg-minutes = Math.floor stat.minutes / stat.visitors
  stat

make-averages = map fill-average

collect-stats = collect-events >> make-averages


### START ###

do
  console.log \\n

  input-path = process.argv[2]

  (err, data) <- fs.readFile input-path
  throw new Error('Could\'nt read file') if err?

  stats = data |> input-to-info |> collect-stats

  for room, idx in stats when room
    console.log "Room #{idx}, #{room.avg-minutes} minute average visit, #{room.visitors} visitor(s) total"

