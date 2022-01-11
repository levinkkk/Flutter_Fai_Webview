import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fai_webview/flutter_fai_webview.dart';

///  通过 htmlBlockData 加载 Html 数据 并添加移动适配
class HtmlAssetStringPage extends StatefulWidget {
  @override
  DefaultHtmlBlockDataPageState createState() =>
      DefaultHtmlBlockDataPageState();
}

class DefaultHtmlBlockDataPageState extends State<HtmlAssetStringPage> {
  //原生 发送给 Flutter 的消息
  String message = "--";
  double webViewHeight = 100;

  //要显示的页面内容
  Widget ?childWidget;
  String htmlBlockData =
      "<!DOCTYPE html><html> <head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1\"> </head> <body><p>加载中</p></body></html>";

  String htmlDataw =
      "<p><img src='https://zc-oss.zcrubber.com/upload/files/2020/08/13/微信图片1.jpg'></p >";
  static String html = """
<div>
    <div style="display: flex;align-items: center;margin:0px 10px 6px 10px;">徒弟首次提现完成奖师傅 <div style="margin:0 6px;flex:1;height:1px;border-top:1px #ccc dotted;"></div>
      <div style="color: #F3150B;font-weight: 600;">1元</div>
    </div>
    <div style="display: flex;align-items: center;margin:0px 10px 6px 10px;">徒弟第二次提现完成奖师傅 <div style="margin:0 6px;flex:1;height:1px;border-top:1px #ccc dotted;"></div>
      <div style="color: #F3150B;font-weight: 600;">2元</div>
    </div>
    <div style="display: flex;align-items: center;margin:0px 10px 6px 10px;">徒弟第三次提现完成奖师傅 <div style="margin:0 6px;flex:1;height:1px;border-top:1px #ccc dotted;"></div>
      <div style="color: #F3150B;font-weight: 600;">3元</div>
    </div>
    <div style="display: flex;align-items: center;margin:0px 10px 6px 10px;">徒弟第四次提现完成奖师傅 <div style="margin:0 6px;flex:1;height:1px;border-top:1px #ccc dotted;"></div>
      <div style="color: #F3150B;font-weight: 600;">5元</div>
    </div>
    <div style="display: flex;align-items: center;margin:0px 10px 6px 10px;">徒弟提现满100一次性再奖师傅 <div style="margin:0 6px;flex:1;height:1px;border-top:1px #ccc dotted;"></div>
      <div style="color: #F3150B;font-weight: 600;">8元</div>
    </div>
    <div style="display: flex;align-items: center;margin:0px 10px 6px 10px;">徒弟提现满500一次性再奖师傅 <div style="margin:0 6px;flex:1;height:1px;border-top:1px #ccc dotted;"></div>
      <div style="color: #F3150B;font-weight: 600;">10元</div>
      
    </div>
""";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 28,
          alignment: Alignment(0, 0),
          color: Color.fromARGB(90, 0, 0, 0),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
      body: Container(
        ///使用异步来加载
//        child: buildFutureBuilder(),
        child: FaiWebViewWidget(
          //webview 加载本地html数据
          htmlBlockData: html,
          //webview 加载信息回调
          callback: callBack,
          //输出日志
          isLog: true,
        ),
      ),
    );
  }

  ///异步加载静态资源目录下的Html
  FutureBuilder<String> buildFutureBuilder() {
    return FutureBuilder<String>(
      ///异步加载数据
      future: loadingLocalAsset(),

      ///构建
      builder: (BuildContext context, var snap) {
        ///加载完成的html数据
        String? htmlData = snap.data;
        //使用插件 FaiWebViewWidget
        if (htmlData == null) {
          return CircularProgressIndicator();
        }

        ///通过配置 htmlBlockData 来渲染
        return FaiWebViewWidget(
          //webview 加载本地html数据
          htmlBlockData: htmlData,
          //webview 加载信息回调
          callback: callBack,
          //输出日志
          isLog: true,
        );
      },
    );
  }

  callBack(int ?code, String ?msg, content) {
    //加载页面完成后 对页面重新测量的回调
    //这里没有使用到
    //当FaiWebViewWidget 被嵌套在可滑动的 widget 中，必须设置 FaiWebViewWidget 的高度
    //设置 FaiWebViewWidget 的高度 可通过在 FaiWebViewWidget 嵌套一层 Container 或者 SizeBox
    if (code == 201) {
      webViewHeight = content;
      print("webViewHeight " + webViewHeight.toString());
    } else {
      //其他回调
    }
    setState(() {
      message = "回调：code[" + code.toString() + "]; msg[" + msg.toString() + "]";
    });
  }

  ///读取静态Html
  Future<String> loadingLocalAsset() async {
    ///加载
    String htmlData = await rootBundle.loadString('assets/html/test.html');

    ///测试数据2
    String htmlData2 = await rootBundle.loadString('assets/html/test3.html');
    print("加载数据完成 $htmlData");
    return htmlData2;
  }
}
