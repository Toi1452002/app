import 'package:ttpmn/controllers/xuly/tinhtoan_controller.dart';
import 'package:ttpmn/function/extension.dart';
import 'kiem_loi/hamchung.dart';

List<String> listDao = [];
TinhToanController controller = TinhToanController();

tachTinSoDanh(String str, var maDai) {
  var result = [];
  var arrayDai = [];
  var a = 0;
  var arrayTin = str.split('.');
  int key_1 = arrayDai.length;
  for (int i = 0; i < arrayTin.length; i++) {
    if (maDai.contains(arrayTin[i])) {
      arrayDai.add(arrayTin[i]);
    }
  }
  arrayTin.removeRange(0, arrayDai.length);
  if (str != "") {
    for (int i = 0; i < arrayTin.length; i++) {
      if (arrayTin[i].isNumeric || arrayTin[i][0].isNumeric) {
        if (i - key_1 > 1) {
          result.add(
              "${arrayDai.join(".")}.${(arrayTin.skip(a).take(i - a)).join(".")}");
          a = i;
        }
        key_1 = i;
      }
    }
  }

  result.add("${arrayDai.join(".")}.${(arrayTin.skip(a)).join(".")}");

  return result;
}

int lay_so_lo_mn_mt({required String kieudanh, required String sodanh}) {
  int result = 0;
  switch (kieudanh) {
    case "b":
      result = 20 - sodanh.length;
      break;
    case "xc":
    case "dd":
      result = 2;
      break;
    case "dau":
      result = sodanh.length == 4 ? 3 : 1;
      break;
    case "dui":
      result = 1;
      break;
    case "dt":
      result = 36;
      break;
    case "dx":
      result = 72;
      break;

    //b1l---b9l
    default:
      String lo = "";
      for (int i = 0; i < kieudanh.length; i++) {
        if (kieudanh[i].isNumeric) {
          lo += kieudanh[i];
        }
      }
      result = int.parse(lo);
      break;
  }

  return result;
}

int lay_so_lo_mb({required String kieudanh, required String sodanh}) {
  int result = 0;
  switch (kieudanh) {
    case "b":
      Map<int, int> lo = {2: 27, 3: 23, 4: 20};
      result = lo[sodanh.length]!;
      break;
    case "xc":
      result = 4;
      break;
    case "dd":
      if (sodanh.length == 2) {
        result = 5;
      } else if (sodanh.length == 3) {
        result = 4;
      } else if (sodanh.length == 4) {
        result = 7;
      }
      break;
    case "dau":
      result = 6 - sodanh.length;
      break;
    case "dui":
      result = 1;
      break;
    case "dt":
      result = 54;
      break;
    default:
      String lo = "";
      for (int i = 0; i < kieudanh.length; i++) {
        if (kieudanh[i].isNumeric) {
          lo += kieudanh[i];
        }
      }
      result = int.parse(lo);
      break;
  }
  return result;
}

getSoDanhCt(String kieudanh, List<String> listSoDanh, {List<String> lstKD =const []}) {
  List<String> result = [];
  List<String> so = [];

  for (String x in listSoDanh) {

    ///Đến kéo
    if (x.length == 7 && ["den", "keo"].contains(x.substring(2, 5))) {
      so.addAll(layKeoDen(x));
    } else if (x.length == 9 && ["den", "keo"].contains(x.substring(3, 6))) {
      so.addAll(layKeoDen(x));
    } else if (x.length == 11 && ["den", "keo"].contains(x.substring(4, 7))) {
      so.addAll(layKeoDen(x));
    } else if (CumTu.contains(x)) {
      so.addAll(lstSoHang.where((e) => e["CumTu"]==x).first["ThayThe"].split("."));
    } else {
      if(x.length==4 && lstKD.isNotEmpty && lstKD.where((e) => e=="b").length>1){
        so.add(x.substring(1));
      }else{
        so.add(x);
      }

    }
  }
  switch (kieudanh) {
    case "da":
    case "dt":
    case "dx":
    case "dv":
      for (int i = 0; i < so.length; i++) {
        for (int j = i + 1; j < so.length; j++) {
          result.add("${so[i]}.${so[j]}");
        }
      }
      break;
    case "db":
    case "db7l":
    case "ddau":
    case "ddui":
    case "dlo":
    case "ddd":
    case "dxc":

      for (String item in so) {
        if(lstKD.where((e) => e=="b").length>1 && item.length==4){
          item = item.substring(1);
        }
        if (item.isNumeric) {
          dao(item.split('').map(int.parse).toList());
          result.addAll(listDao.toSet().toList());
          listDao.clear();
        }
      }
      break;
    default:
      for (String item in so) {
        if (item.isNumeric) {
          result.add(item);
        }
      }
      break;
  }
  return result;
}

List<String> HamDao(String str) {
  dao(str);
  return listDao;
}

void dao(var str, [int cid = 0]) {
  if (cid == str.length) {
    listDao.add(str.join());
    return;
  }
  for (int i = cid; i < str.length; i++) {
    swap(str, i, cid);
    dao(str, cid + 1);
    swap(str, i, cid);
  }
}

void swap(var a, int i, int j) {
  int tmp = a[i];
  a[i] = a[j];
  a[j] = tmp;
}

getSoDanh(List<String> listTin, List<String> dai) {
  List<String> result = [];

  if (listTin.isNotEmpty && listTin.isNotEmpty) {
    for (String item in listTin) {
      if (!dai.contains(item) &&
          (item[0].isNumeric || CumTu.contains(item))) {
        result.add(item);
      }
    }
  }
  return result;
}

getKieuDanh(List<String> listTin, List<String> dai) {
  List<String> result = [];
  if (listTin.isNotEmpty && listTin.length > 0) {
    for (String item in listTin) {
      if (!CumTu.contains(item) &&
          !dai.contains(item) &&
          !["dl", "bd", "dn", "qn", "sb"].contains(item) &&
          !item.isNumeric &&
          !item[0].isNumeric) {
        if (tachDauDui(item).isNotEmpty) {
          for (String dd in tachDauDui(item)) {
            result.add(dd);
          }
        } else {
          result.add(item);
        }
      }
    }
  }

  return result;
}

//b17l-->b1l
String tach_b7l(String str){
  if(str.lastChars(1)=="l" && str.lastChars(2)[0].isNumeric){
    if(str[0]=="b"){
      return "${str.substring(0,2)}l";
    }
    else if(str.substring(0,2)=="db"){
      return "${str.substring(0,3)}l";
    }
  }
  return str;
}


layKieuDanhVaTien(String str) {
  List<String> _arr = str.split('');
  Map<String, dynamic> result = {};
  if (!CumTu.contains(str)) {
    for (int i = _arr.length - 1; i >= 0; i--) {
      if (!_arr[i].isNumeric && _arr[i] != 'n' && _arr[i] != ',') {
        result["kieudanh"] = (str.substring(0, _arr.lastIndexOf(_arr[i]) + 1));

        break;
      }
    }
    if (str != "") {
      String sotien = str
          .substring(result["kieudanh"].length)
          .replaceAll(",", ".")
          .replaceAll("n", "");
      List st = sotien.split(".");
      if (st.length > 2) {
        sotien = st[0] + "." + st[1];
      }
      result["sotien"] = double.parse(sotien);
    }
  }
  result["kieudanh"] = tach_b7l( result["kieudanh"] );
  return result;
}

List<String> layKeoDen(String str) {
  List<String> result = [];
  String kieu = '';
  int sodau = 0;
  String sosau = '';
  double sokeo = 0;
  for (int i = 0; i < str.length; i++) {
    if (!str[i].isNumeric) {
      kieu = str.substring(i, i + 3);
      sodau = int.parse(str.substring(0, i));
      sosau = str.substring(i + 3);
      break;
    }
  }
  if (int.parse(sosau) > sodau) {
    sokeo = (int.parse(sosau) - sodau) /
        int.parse((int.parse(sosau) - sodau).toString()[0]);
    while (sodau <= int.parse(sosau)) {
      result.add("0" * (sosau.toString().length - sodau.toString().length) +
          sodau.toString());
      kieu == "den" ? sodau++ : sodau += sokeo.toInt();
    }
  }
  return result;
}

List<String> tachDauDui(String str) {
  List<String> arr_sotien = str.replaceAll('n', '').split('d');
  List<String> result = [];
  if (arr_sotien.length == 3 && arr_sotien[1] != "" && arr_sotien[2] != "") {
    result.add("dau${arr_sotien[1]}");
    result.add("dui${arr_sotien[2]}");
  }
  return result;
}

String thayDoiKieuDanh(String str, int soDai) {
  switch (str) {
    case 'bao':
    case 'bl':
    case 'lo':
    case 'db':
    case "dlo":
    case "c":
      str = 'b';
      break;
    case 'x':
    case 'dxc':
      str = 'xc';
      break;
    case "ddui":
    case "s":
    case "xdui":
    case "xduoi":
      str = "dui";
      break;
    case "ddau":
    case "a":
    case "xdau":
      str = "dau";
      break;
    case 'db7l':
      str = 'b7l';
      break;
    case "ddd":
      str = "dd";
      break;

    case "dv":
    case "da":
      str = soDai > 1 ? "dx" : "dt";
      break;
  }
  return str;
}

List<String> getDaiFunc(
    List<String> listTin, List<String> maDai, List<String> dai,
    {String mien = "", String ngay = ""}) {
  List<String> listDai = [];
  for (String item in listTin) {
    if (mien == 'N') {
      if (item == 'bt' && Thu(ngay) == 4) item = "bth";
      if (item == 'sb' && Thu(ngay) == 5) item = "bd";
    }
    if (mien == 'T') {
      if (item == 'dl' && Thu(ngay) == 2) item = "dlk";
      if (item == 'bd' && Thu(ngay) == 4) item = "bdi";
      if (item == 'dn' && [3, 6].contains(Thu(ngay))) item = "dng";
      if (item == 'qn' && [2, 6].contains(Thu(ngay))) item = "qnm";
    }
    if (dai.contains(item)) {
      if (item[0].isNumeric) {
        listDai.addAll(maDai.skip(0).take(int.parse(item[0])));
      } else {
        listDai.add(item);
      }
    }
  }
  if (listDai.isEmpty) {
    listDai = ["mb"];
  }
  return listDai;
}
