/// @desc Parse <map><objectgroup><object><properties><property>
/// @arg properties_map the index of the map containing the properties
var properties_list = argument0;

// get attributes
var property_map = ds_map_create();
ds_map_add(property_map, "name", DerpXmlRead_CurGetAttribute("name"));
ds_map_add(property_map, "type", DerpXmlRead_CurGetAttribute("type"));
ds_map_add(property_map, "value", DerpXmlRead_CurGetAttribute("value"));
ds_map_add(property_map, "visible", DerpXmlRead_CurGetAttribute("visible"));
ds_list_add(properties_list, property_map)
ds_list_mark_as_map(properties_list, ds_list_size(properties_list)-1);

// get children
while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <property>: " + type + ", " + value)
	
	switch (type) {
		case DerpXmlType_Whitespace:
			break;
		case DerpXmlType_OpenTag:
			Xtiled_parse_skip(value);
			break;
		case DerpXmlType_CloseTag:
			if (value == "property") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in property", true)
			}
		default:
			show_error("Tiled Parse error: " + value + " not supported in property", true)
			break;
	}
}