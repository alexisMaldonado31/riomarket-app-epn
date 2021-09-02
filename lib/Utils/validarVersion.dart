bool validarVersion(String versionAppStore, String versionDispositivo){
  final numVersionAppStore = versionAppStore.split('.');
  final numVersionDispositivo = versionDispositivo.split('.');

  if(int.parse(numVersionDispositivo[0]) < int.parse(numVersionAppStore[0])){
    return false;
  }else if(int.parse(numVersionDispositivo[1]) < int.parse(numVersionAppStore[1])){
    return false;
  }else if (int.parse(numVersionDispositivo[2]) < int.parse(numVersionAppStore[2])){
    return false;
  }

  return true;
}