// import 'package:flutter/material.dart';
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:remove_diacritic/remove_diacritic.dart';
// import 'package:ttpmn/controllers/xuly/tinhtoan_controller.dart';
// import 'package:ttpmn/controllers/xuly/xuly_controller.dart';
//
// import '../../function/kiem_loi/hamSoDanh.dart';
//
// class TinSMS extends StatefulWidget {
//   const TinSMS({Key? key}) : super(key: key);
//
//   @override
//   State<TinSMS> createState() => _TinSMSState();
// }
//
// class _TinSMSState extends State<TinSMS>  with AutomaticKeepAliveClientMixin{
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     // XulyController().to.getAllMessages();
//     return Scaffold(
//       backgroundColor: Colors.blueGrey[100],
//       appBar: AppBar(
//         title: Text(Get.parameters["MaKhach"]!),
//       ),
//       body: GetBuilder<XulyController>(
//         builder: (controller) {
//           List<SmsMessage> sms = controller.tinSMS.value;
//           if(sms.isEmpty){
//             return const Center(child: Text("Không có tin nhắn!", style: TextStyle(color: Colors.blueGrey,fontSize: 30),),);
//           }
//           return ListView.builder(
//               // addRepaintBoundaries: false,
//               reverse: true,
//               key: const PageStorageKey<String>('listvew1'),
//               itemBuilder: (context, i) {
//                 return PopupMenuButton(
//                   offset: const Offset(300, 0),
//                   itemBuilder: (context) => [
//                     const PopupMenuItem(
//                       value: 1,
//                       child: Text("Xử lý"),
//                     ),
//                     const PopupMenuItem(
//                       value: 2,
//                       child: Text("Xem tin nhắn"),
//                     ),
//                   ],
//                   child: Card(
//                     color: Colors.white,
//                     margin: EdgeInsets.all(5),
//                     shadowColor: Theme.of(context).primaryColor,
//                     child: ListTile(
//                       title: Text(
//                         sms[i].body.toString(),
//                         maxLines: 15,
//                         overflow: TextOverflow.fade,
//                       ),
//                       subtitle: Text(
//                           "Ngày ${DateFormat("dd-MM-yyyy HH:mm").format(sms[i].date!)}"),
//                     ),
//                   ),
//                   onSelected: (value) {
//                     switch (value) {
//                       case 1:
//                         TinhToanController().to.ChoPhepTinhToan(false);
//                         XulyController().to.clearError();
//                         String tin =  ThayKyTu_TV(sms[i].body.toString());
//                         XulyController().to.tinXLController.value.text = tin;
//                         XulyController().to.updateTinGoc(tin);
//                         Get.back();
//                         break;
//                       case 2:
//                         Get.dialog(Dialog(
//                           child: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(5))),
//                             width: Get.width * .9,
//                             height: Get.height * .6,
//                             child: SingleChildScrollView(
//                                 child: Text(sms[i].body.toString())),
//                           ),
//                         ));
//                         break;
//                     }
//                   },
//                 );
//               },
//               itemCount: sms.length);
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Theme.of(context).primaryColor,
//         onPressed: () {
//           // XulyController().to.getAllMessages();
//         },
//         child: const Icon(Icons.refresh_outlined),
//       ),
//     );
//   }
//
//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
//
// }
