/// @desc Skip all children of tag
/// @arg tag to skip
var tag_to_skip = argument0;

while (DerpXmlRead_Read()) {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
	
    show_debug_message("Parse to skip: " + type + ", " + value)
	if (type == DerpXmlType_CloseTag and value == tag_to_skip) {
		return;
	}
}