
/// 判断 List 是否不为空
bool listNotEmpty(List list) {
  if (list == null) {
    return false;
  }
  if (list.length == 0) {
    return false;
  }
  return true;
}
