// get tileset data
var tileset_name = argument0;
var tileset_map = ds_map_find_value(tilesets, tileset_name);

ds_map_add(tileset_map, "image_source", DerpXmlRead_CurGetAttribute("source"));
ds_map_add(tileset_map, "image_width", DerpXmlRead_CurGetAttribute("width"));
ds_map_add(tileset_map, "image_height", DerpXmlRead_CurGetAttribute("height"));

while DerpXmlRead_Read() {
    show_debug_message("Parse image: " + DerpXmlRead_CurType() + ", " + DerpXmlRead_CurValue())
	switch (DerpXmlRead_CurType()) {
		case "Whitespace":
			break;
		case "OpenTag":
			show_error("Tiled Parse error: OpenTag " + DerpXmlRead_CurValue() + " not supported in tileset", true)
			break;
		case "CloseTag":
			return;
		default:
			show_error("Tiled Parse error: " + DerpXmlRead_CurType() + " not supported in image", true)
			break;
	}
}