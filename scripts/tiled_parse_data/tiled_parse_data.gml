/// @desc Parse <map><tileset><image>
/// @arg layer_index the index of the layer, needed for adding to the right ds_map

// get attributes
var layer_index = argument0;
var layer_map = ds_list_find_value(layers, layer_index);
ds_map_add(layer_map, "encoding", DerpXmlRead_CurGetAttribute("encoding"));
ds_map_add(layer_map, "compression", DerpXmlRead_CurGetAttribute("compression"));

// get children
while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <image>: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace":
			break;
		case "Text":
			ds_map_add(layer_map, "data", value);
			break;
		case "OpenTag":
			break;
		case "CloseTag":
			if (value == "data") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in data", true)
			}
		default:
			show_error("Tiled Parse error: " + value + " not supported in data", true)
			break;
	}
}