/// @desc Parse <map><layer>

// get attributes
var layer_map = ds_map_create();
ds_map_add(layer_map, "type", "tile");
ds_map_add(layer_map, "id", DerpXmlRead_CurGetAttribute("id"));
ds_map_add(layer_map, "name", DerpXmlRead_CurGetAttribute("name"));
ds_map_add(layer_map, "width", real_or_undef(DerpXmlRead_CurGetAttribute("width")));
ds_map_add(layer_map, "height", real_or_undef(DerpXmlRead_CurGetAttribute("height")));
ds_map_add(layer_map, "offsetx", real_or_undef(DerpXmlRead_CurGetAttribute("offsetx")));
ds_map_add(layer_map, "offsety", real_or_undef(DerpXmlRead_CurGetAttribute("offsety")));
var layer_index = ds_list_size(layers);
ds_list_add(layers, layer_map);
ds_list_mark_as_map(layers, layer_index);

// get children
while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <layer>: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace":
			break;
		case "OpenTag":
			switch (value) {
				case "data":
					tiled_parse_data(layer_map);
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + DerpXmlRead_CurValue() + " not supported in layer", true)
			}
			break;
		case "CloseTag":
			if (value == "layer") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in layer", true)
			}
		default:
			show_error("Tiled Parse error: " + type + " not supported in layer", true)
			break;
	}
}