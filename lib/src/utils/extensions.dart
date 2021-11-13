// import 'package:flutter/material.dart';

// class Demo extends StatefulWidget {
//   const Demo({Key key}) : super(key: key);

//   @override
//   _DemoState createState() => _DemoState();
// }

// class _DemoState extends State<Demo> {
//   final _messages = <String>[
//     ">Hello",
//     "<Hi there",
//     "<How are you?",
//     ">Fine",
//   ];

//   void _reset() {
//     setState(() => _messages.removeRange(4, _messages.length));
//   }

//   void _addRandomMessage() {
//     setState(() => _messages
//         .add(DateTime.now().second.isOdd ? '>That\'s all' : '<Bye bye.'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: const EdgeInsets.all(12),
//         children: [
//           ..._messages.map3((message, {prev, next}) {
//             final isMe = message[0] == '>';
//             final color = isMe ? Colors.teal : Colors.amber;
//             final isFirst = prev == null || prev[0] != message[0];
//             final isLast = next == null || next[0] != message[0];
//             const radius = Radius.elliptical(12, 6);
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 6),
//               child: ListTile(
//                 shape: RoundedRectangleBorder(
//                     side: BorderSide(color: color),
//                     borderRadius: BorderRadius.only(
//                       topLeft: isFirst ? radius : Radius.zero,
//                       topRight: isFirst ? radius : Radius.zero,
//                       bottomLeft: isLast ? radius : Radius.zero,
//                       bottomRight: isLast ? radius : Radius.zero,
//                     )),
//                 dense: true,
//                 tileColor: color,
//                 title: Text(
//                   message.substring(1),
//                   textAlign: isMe ? TextAlign.start : TextAlign.end,
//                 ),
//                 subtitle: next == null
//                     ? Text(
//                         DateTime.now().format('dd.MM.YYYY hh:mm'),
//                         textAlign: isMe ? TextAlign.start : TextAlign.end,
//                         textScaleFactor: 0.7,
//                       )
//                     : null,
//               ),
//             );
//           })
//         ],
//       ),
//       floatingActionButton: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FloatingActionButton(
//             mini: true,
//             onPressed: _reset,
//             child: const Icon(Icons.clear_all),
//           ),
//           FloatingActionButton(
//             onPressed: _addRandomMessage,
//             child: const Icon(Icons.add),
//           ),
//         ],
//       ),
//     );
//   }
// }

// extension<E> on Iterable<E> {
//   Iterable<F> map3<F>(F Function(E, {E? next, E? prev}) transform) {
//     final p = <E?>[null].followedBy(cast<E?>()).iterator;
//     final n = skip(1).cast<E?>().followedBy(<E?>[null]).iterator;
//     return map((e) {
//       p.moveNext();
//       n.moveNext();
//       return transform(e, prev: p.current, next: n.current);
//     });
//   }
// }

// extension on DateTime {
//   String format(String fmt) {
//     String pad(int value, [int width = 2]) => '$value'.padLeft(width, '0');
//     return fmt.replaceAllMapped(RegExp('dd|MM|YY(?:YY)?|hh|mm'), (m) {
//       if (m[0] == 'dd') return pad(day);
//       if (m[0] == 'MM') return pad(month);
//       if (m[0] == 'YY') return pad(year % 100);
//       if (m[0] == 'YYYY') return pad(year, 4);
//       if (m[0] == 'hh') return pad(hour);
//       if (m[0] == 'mm') return pad(minute);
//       throw Error();
//     });
//   }
// }
