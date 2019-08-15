/// @desc Parse <map><objectgroup><object>
/// @arg instances_list the index of the list needed to add objects to

// get attributes
var instances_list = argument0;

var object_map = ds_map_create();
ds_map_add(object_map, "name", DerpXmlRead_CurGetAttribute("name"));
ds_map_add(object_map, "x", real_or_undef(DerpXmlRead_CurGetAttribute("x")));
ds_map_add(object_map, "y", real_or_undef(DerpXmlRead_CurGetAttribute("y")));
var properties_list = ds_list_create();
ds_map_add_list(object_map, "properties", properties_list);
ds_list_add(instances_list, object_map)
ds_list_mark_as_map(instances_list, ds_list_size(instances_list)-1);

// get children
while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <object>: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace":
			break;
		case "OpenTag":
			switch (value) {
				case "properties":
					tiled_parse_properties(properties_list);
					break;
				default:
					tiled_parse_skip(value);
			}
			break;
		case "CloseTag":
			if (value == "object") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in object", true)
			}
		default:
			show_error("Tiled Parse error: " + value + " not supported in object", true)
			break;
	}
}