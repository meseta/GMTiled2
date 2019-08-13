/// @desc Parse <map><tileset>

// get attributes
var tileset_map = ds_map_create();
var tileset_name = DerpXmlRead_CurGetAttribute("name");
ds_map_add(tileset_map, "firstgid", real_or_undef(DerpXmlRead_CurGetAttribute("firstgid")));
ds_map_add(tileset_map, "tilewidth", real_or_undef(DerpXmlRead_CurGetAttribute("tilewidth")));
ds_map_add(tileset_map, "tileheight", real_or_undef(DerpXmlRead_CurGetAttribute("tileheight")));
ds_map_add(tileset_map, "tilecount", real_or_undef(DerpXmlRead_CurGetAttribute("tilecount")));
ds_map_add(tileset_map, "columns", real_or_undef(DerpXmlRead_CurGetAttribute("columns")));
ds_map_add_map(tilesets, tileset_name, tileset_map);

// get children
while (DerpXmlRead_Read()) {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <tileset>: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace":
			break;
		case "OpenTag":
			switch (value) {
				case "image":
					tiled_parse_image(tileset_name);
					break;
				case "tile":
					tiled_parse_skip("tile");
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + value + " not supported in tileset", true)
			}
			break;
		case "CloseTag":
			if (value == "tileset") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in tileset", true)
			}
		default:
			show_error("Tiled Parse error: " + type + " not supported in tileset", true)
			break;
	}
}