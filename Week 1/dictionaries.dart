void main(){
  Map<String, String> taskDetails = {'Buy Milk': 'High'};
   print('Task Details Map: $taskDetails');

   taskDetails['Walk Dog'] = 'Medium';
   print('Task Details Map after adding Walk Dog: $taskDetails');

   taskDetails.remove('Buy Milk');
   print('Task Details Map after removing Buy Milk: $taskDetails');

   print('Task Details Map length: ${taskDetails.length}');

   print('Task Details Map keys: ${taskDetails.keys}');

   print('Task Details Map values: ${taskDetails.values}');

   taskDetails.clear();
   print('Task Details Map after clearing: $taskDetails');
}