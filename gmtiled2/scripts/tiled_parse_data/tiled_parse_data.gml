// get tileset data
var layer_index = argument0;
var layer_map = ds_list_find_value(layers, layer_index);

ds_map_add(layer_map, "encoding", DerpXmlRead_CurGetAttribute("encoding"));
ds_map_add(layer_map, "compression", DerpXmlRead_CurGetAttribute("compression"));

while DerpXmlRead_Read() {
    show_debug_message("Parse data: " + DerpXmlRead_CurType() + ", " + DerpXmlRead_CurValue())
	switch (DerpXmlRead_CurType()) {
		case "Whitespace":
			break;
		case "Text":
			ds_map_add(layer_map, "data", DerpXmlRead_CurValue());
			break;
		case "OpenTag":
			break;
		case "CloseTag":
			return;
		default:
			show_error("Tiled Parse error: " + DerpXmlRead_CurType() + " not supported in data", true)
			break;
	}
}