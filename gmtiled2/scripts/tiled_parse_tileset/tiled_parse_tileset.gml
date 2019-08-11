// get tileset data
var tileset_map = ds_map_create();
var tileset_name = DerpXmlRead_CurGetAttribute("name");
ds_map_add(tileset_map, "firstgid", DerpXmlRead_CurGetAttribute("firstgid"));
ds_map_add(tileset_map, "tilewidth", DerpXmlRead_CurGetAttribute("tilewidth"));
ds_map_add(tileset_map, "tileheight", DerpXmlRead_CurGetAttribute("tileheight"));
ds_map_add(tileset_map, "tilecount", DerpXmlRead_CurGetAttribute("tilecount"));
ds_map_add(tileset_map, "columns", DerpXmlRead_CurGetAttribute("columns"));
ds_map_add_map(tilesets, tileset_name, tileset_map);

while DerpXmlRead_Read() {
    show_debug_message("Parse tileset: " + DerpXmlRead_CurType() + ", " + DerpXmlRead_CurValue())
	switch (DerpXmlRead_CurType()) {
		case "Whitespace":
			break;
		case "OpenTag":
			switch (DerpXmlRead_CurValue()) {
				case "image":
					tiled_parse_image(tileset_name);
					break;
				case "tile":
					tiled_parse_skip("tile");
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + DerpXmlRead_CurValue() + " not supported in tileset", true)
			}
			break;
		case "CloseTag":
			return;
		default:
			show_error("Tiled Parse error: " + DerpXmlRead_CurType() + " not supported in tileset", true)
			break;
	}
}