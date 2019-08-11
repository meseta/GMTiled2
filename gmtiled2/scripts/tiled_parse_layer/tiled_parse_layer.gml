// get tileset data
var layer_map = ds_map_create();
ds_map_add(layer_map, "type", "tile");
ds_map_add(layer_map, "id", DerpXmlRead_CurGetAttribute("id"));
ds_map_add(layer_map, "name", DerpXmlRead_CurGetAttribute("name"));
ds_map_add(layer_map, "width", DerpXmlRead_CurGetAttribute("width"));
ds_map_add(layer_map, "height", DerpXmlRead_CurGetAttribute("height"));
var layer_index = ds_list_size(layers);
ds_list_add(layers, layer_map);
ds_list_mark_as_map(layers, layer_index);

while DerpXmlRead_Read() {
    show_debug_message("Parse layer: " + DerpXmlRead_CurType() + ", " + DerpXmlRead_CurValue())
	switch (DerpXmlRead_CurType()) {
		case "Whitespace":
			break;
		case "OpenTag":
			switch (DerpXmlRead_CurValue()) {
				case "data":
					tiled_parse_data(layer_index);
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + DerpXmlRead_CurValue() + " not supported in layer", true)
			}
			break;
		case "CloseTag":
			return;
		default:
			show_error("Tiled Parse error: " + DerpXmlRead_CurType() + " not supported in layer", true)
			break;
	}
}