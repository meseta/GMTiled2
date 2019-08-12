/// @desc Parse <map><tileset><image>
/// @arg tileset_name the name of the tileset, needed for adding to the right ds_map

// get attributes
var tileset_name = argument0;
var tileset_map = ds_map_find_value(tilesets, tileset_name);
ds_map_add(tileset_map, "image_source", DerpXmlRead_CurGetAttribute("source"));
ds_map_add(tileset_map, "image_width", real_or_undef(DerpXmlRead_CurGetAttribute("width")));
ds_map_add(tileset_map, "image_height", real_or_undef(DerpXmlRead_CurGetAttribute("height")));

// get children
while (DerpXmlRead_Read()) {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <image>: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace":
			break;
		case "OpenTag":
			show_error("Tiled Parse error: OpenTag " + DerpXmlRead_CurValue() + " not supported in image", true)
			break;
		case "CloseTag":
			if (value == "image") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in image", true)
			}
		default:
			show_error("Tiled Parse error: " + DerpXmlRead_CurType() + " not supported in image", true)
			break;
	}
}