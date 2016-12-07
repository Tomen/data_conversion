part of data_conversion;


Map group(Iterable elements, groupableKeyEvaluator(element), [groupableValueEvaluator(element)]){

  if(groupableValueEvaluator == null){
    groupableValueEvaluator = (element)=>element;
  }

  Map<dynamic, List> result = {};

  for(var element in elements){
    var key = groupableKeyEvaluator(element);

    if(!result.containsKey(key)){
      result[key] = [];
    }

    var value = groupableValueEvaluator(element);

    result[key].add(value);
  }

  return result;
}