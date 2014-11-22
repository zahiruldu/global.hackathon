#
# # Gulpfile
#
path    = require 'path'
gulp    = require 'gulp'
concat  = require 'gulp-concat'
tap     = require 'gulp-tap'
util    = require 'gulp-util'



# The handler for gulp-tap
tap_json = (file, t) ->
  filename = path.basename file.path
  if filename is 'README.template.md' then return

  try
    data = JSON.parse file.contents.toString()
  catch e
    util.log util.colors.red('Warning'), "Failed to parse json file.
      Invalid JSON syntax. File: #{file.path}"
    file.contents = new Buffer ''
    return

  str = format_json data, file.path
  if not str?
    util.log util.colors.red('Warning'), "The JSON data couldn't be formatted
      into the table for an unknown reason. File: #{file.path}"
    file.contents = new Buffer ''
    return

  # Everything is successful
  file.contents = new Buffer str


# Format a member object into a link
format_member = (member) ->
  "[#{member?.name}](https://koding.com/#{member?.koding})"



# Format a data object, and return a string to be
# appended to the readme
format_json = (data, filepath) ->
  teamPathName = path.basename path.dirname filepath

  # Get the lead, ahead of time.
  teamLead = null
  if data.members? and data.members instanceof Array
    for member in data.members
      if member.lead is true
        teamLead = member
        break

  output = '|'
  # First column, #TeamName
  if data.teamName?
    output += " <a target='_blank'
      href='https://twitter.com/home?status=Go team
      %23#{data.teamName.replace /\W+/g, ""}
      for @koding %23hackathon\
      #{if teamLead?.twitter? then " led by @"+teamLead.twitter else ''}
      https://koding.com/Hackathon'>
      <img src='https://g.twimg.com/Twitter_logo_blue.png' height='14'/>
      ##{data.teamName}
      </a> |"
  else
    output += " |"

  # Second column, TeamLead
  if teamLead?
    output += "#{format_member teamLead} |"
  else
    output += " |"

  # Third column, TeamMembers
  if data.members? and data.members instanceof Array
    for member in data.members
      output += "#{format_member member}
        #{member.location ? ''}<br>"
  output += " |"

  # Fourth column, TeamPage
  if data.teamName? then teamName = data.teamName
  else teamName = teamPathName
  output += " [#{teamName}](./Teams/#{teamPathName}/ABOUT.md) |"

  # Add a newline to end this row.
  output += '\n'
  # Return the final output
  output




gulp.task 'run', ->
  gulp.src [
    'README.template.md'
    './Teams/**/TeamKoders/team.json'
    './Teams/**/team.json'
  ]
    .pipe tap tap_json
    .pipe concat 'README.md', newLine: ''
    .pipe gulp.dest './'

gulp.task 'default', ['run']
