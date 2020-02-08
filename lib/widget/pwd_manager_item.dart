import 'package:flutter/material.dart';
import 'package:password_manager/models/index.dart';

class PwdManagerItem extends StatefulWidget {
  final PwdManager pwdManager;

  PwdManagerItem(this.pwdManager) : super(key: ValueKey(pwdManager.id));

  @override
  _PwdManagerItemState createState() {
    return _PwdManagerItemState();
  }
}

class _PwdManagerItemState extends State<PwdManagerItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Material(
        color: Colors.white,
        shape: BorderDirectional(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.assignment),
                    Expanded(
                      child: Text(
                        widget.pwdManager.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.pwdManager.account,
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.pwdManager.password,
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
//              ListTile(
//                dense: true,
//                leading: Text(
//                  widget.pwdManager.account,
//                ),
//                trailing: Text(
//                  widget.pwdManager.password,
//                  textAlign: TextAlign.end,
//                  textDirection: TextDirection.rtl,
//                  style: TextStyle(
//                    fontSize: 15,
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
