
void main(){
  Set<String> tags = {'urgent', 'home', 'work'};
  print('Tags Set: $tags');
  tags.add('personal');
  print('Tags Set after adding personal: $tags');
  tags.remove('work');
  print('Tags Set after removing work: $tags');
  print('Tags Set length: ${tags.length}');
  
  print('Does tags contain urgent? ${tags.contains('urgent')}');
  tags.clear();
  print('Tags Set after clearing: $tags');
}