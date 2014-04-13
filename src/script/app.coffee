width = 1080
height = 828
vis = d3.select(".app-map").append("svg")
  .attr("width", width).attr("height", height)
d3.json "assets/ottawa_neighborhood_survey.geojson", (json) ->

  # create a first guess for the projection
  center = d3.geo.centroid(json)
  scale = 150
  offset = [
    width / 1.5
    height / 3
  ]
  projection = d3.geo.mercator().scale(scale).center(center).translate(offset)

  # create the path
  path = d3.geo.path().projection(projection)

  # using the path determine the bounds of the current map and use
  # these to determine better values for the scale and translation
  bounds = path.bounds(json)
  hscale = scale * width / (bounds[1][0] - bounds[0][0])
  vscale = scale * height / (bounds[1][1] - bounds[0][1])
  scale = (if (hscale < vscale) then hscale else vscale)
  offset = [
    width - (bounds[0][0] + bounds[1][0]) / 2
    height - (bounds[0][1] + bounds[1][1]) / 2
  ]

  # new projection
  projection = d3.geo.mercator().center(center).scale(scale).translate(offset)
  path = path.projection(projection)

  # add a rectangle to see the bound of the svg
  vis.append("rect").attr("width", width).attr("height", height)
    .style "fill", "none"
  vis.selectAll("path").data(json.features).enter().append("path")
    .attr("d", path).style("fill", "red").style("stroke-width", "1")
    .style "stroke", "black"
  return

