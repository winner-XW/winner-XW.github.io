---
title: 聚合支付H5
date: 2021/03/14
tags: HTML,JS,支付
categories: WEBAPP
description: 聚合支付是一种新兴的支付方式。这种新的支付方式不同于微信支付、支付宝支付，不是与单一APP对接的，而是与多种支付通道对接，就像一个多头充电线，自身携带数个不同接口，可以同时满足安卓手机、苹果手机等不同机型的充电需求……这种新兴的支付方式就是聚合支付。
keywords: 聚合支付,微信,支付宝
cover: /img/md/pay.png
---

# 聚合支付-商家二维码
>聚合支付：也称“融合支付”，是指只从事“支付、结算、清算”服务之外的“支付服务”，依托银行、非银机构或清算组织，借助银行、非银机构或清算组织的支付通道与清结算能力，利用自身的技术与服务集成能力，将一个以上的银行、非银机构或清算组织的支付服务，整合到一起，为商户提供包括但不限于“支付通道服务”、“集合对账服务”、“技术对接服务”、“差错处理服务”、“金融服务引导”、“会员账户服务”、“作业流程软件服务”、“运行维护服务”、“终端提供与维护”等服务内容，以此减少商户接入、维护支付结算服务时面临的成本支出，提高商户支付结算系统运行效率的，并收取增值收益的支付服务。


## 实现目标
扫描二维码-->识别支付平台-->展现支付画面-->完成支付

## 技术栈
1.JavaScript  
2.java  
3.[微信](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=7_1)   
4.[支付宝](https://opendocs.alipay.com/open/203)  
5.[支付宝沙箱环境](https://openhome.alipay.com/platform/appDaily.htm?tab=info)

## 具体实现

### 判断扫码平台展示不同页面
```javascript
function isAlipayOrWechat() {
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.match(/Alipay/i) == 'alipay') {
		return 'Alipay'
	} else if (userAgent.match(/MicroMessenger/i) == 'micromessenger') {
		return 'Weixin'
	}
	return undefined;
}
```

### 微信JSAPI
#### 开发前准备

- 获取微信支付所需要的参数（appid、appsecret、mch_id、paternerKey）
- 首先要想支持微信支付,必须拥有两个账号：①微信公众已认证的服务号；②微信商户平台账号。
  
微信公众平台：  
	公众APPID：wx15*********a8  
    APPSECEPT ：****  

微信商户平台：  
    商户ID：14******42  
    API密钥：5d5************b35b 

【注】
- 商户的API密钥:在商户平台的账户中心下:需要用户自行下载证书及安装。
- 对于调取微信退款还需要微信的商户证书，获取步骤见文章“微信退款”小节部分。
- 微信只接受80端口  
  
[内网穿透工具](https://natapp.cn/)  
[支付接口签名校验工具](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=20_1)

#### 开发步骤

![开发图解](/img/md/pictures/1557069758593-575ee124-6e4d-4198-8601-1e61b095313b.jpeg)

>1. 设置支付目录  
1. 设置授权域名
2. 获取openId
3. 统一下单
4. 微信内H5调起支付

##### 设置支付目录  
● 配置支付目录：微信商户平台->产品中心->开发配置->公众号支付授权目录
     配置此目录是项目代码中“微信支付”所在支付页面地址.目录必须以“/”结尾，至少设置二级以上目录。  
eg: 如发起支付页面为：http://baidu.com/wxpay/index.html,则目录配置为：http://baidu.com/;
下面“代码实例”中的配置为：  http://dvnq2b.natappfree.cc/


##### 设置授权域名  
● 配置授权域名:微信公众平台->设置->公众号设置  
1、支付过程需要获取用户openid,必须经过网页授权配置才可以,要不然获取不到openid。  
2、查看网页回调地址是否已经配置好，在这里我将所有的域名配置都配置好了。  
（腾讯的坑）必须将MP_verify_MHYOHtHKmJzSkCj0.txt文件放置到项目的根目录下，如配置域名：dvnq2b.natappfree.cc,则访问http://dvnq2b.natappfree.cc/MP_verify_MHYOHtHKmJzSkCj0.txt时访问得到就表示配置成功。

##### 获取openId  
[授权获取用户信息官方文档](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/Wechat_webpage_authorization.html)

用户同意授权地址，获取code
```
https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect

链接中情求参数说明：
1. redirect_uri参数：授权后重定向的回调链接地址, 请使用 urlEncode 对链接进行处理。
2. scope: 应用授权作用域，snsapi_base （不弹出授权页面，直接跳转，只能获取用户openid），snsapi_userinfo （弹出授权页面，可通过openid拿到昵称、性别、所在地。并且， 即使在未关注的情况下，只要用户授权，也能获取其信息 ）
```

使用上面获取的code作为请求参数，请求下面链接来获取openid

```
 https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code

链接中参数说明：
1、secret： 公众号的appsecret
2、grant_type： 填写为authorization_code
```

请求后会有如下的返回结果：  
```json
{ 
	"access_token":"ACCESS_TOKEN",
	"expires_in":7200,
	"refresh_token":"REFRESH_TOKEN",
	"openid":"******",//拿到这个openid的值
	"scope":"SCOPE" 
}
```

##### 统一下单
```java
/**
    *
    * @Description 微信浏览器内微信支付/公众号支付(JSAPI)
    * @param request
    * @param
    * @return AjaxResult
    */
@RequestMapping(value="orders", method = { RequestMethod.POST, RequestMethod.GET })
@ResponseBody
public AjaxResult orders (@RequestParam("total_fee") String total_fee, HttpServletRequest request) {
    String openId = (String) request.getSession().getAttribute("openId");
    System.out.println("支付接口，从session获取的openid:"+openId);
    if (!StringUtils.isNotEmpty(openId)) {
        result.addError("openId is null");
        return result;
    }
    try {
        //拼接统一下单地址参数
        Map<String, String> paraMap = new HashMap<String, String>();
        //获取请求ip地址
        String ip = WXPayUtil.getIp(request);

        paraMap.put("appid", appId);
        paraMap.put("body", "订单支付");
        paraMap.put("mch_id", mchId);
        paraMap.put("nonce_str", WXPayUtil.generateNonceStr());
        paraMap.put("openid", openId);
        paraMap.put("out_trade_no", WXPayUtil.generateNonceStr());//订单号
        paraMap.put("spbill_create_ip", ip);
        paraMap.put("total_fee",total_fee);
        paraMap.put("trade_type", String.valueOf(WxPayApi.TradeType.JSAPI));
        paraMap.put("notify_url", notifyUrl);// 此路径是微信服务器调用支付结果通知路径
        String sign = WXPayUtil.generateSignature(paraMap, paternerKey);
        paraMap.put("sign", sign);
        String xml = WXPayUtil.mapToXml(paraMap);//将所有参数(map)转xml格式

        // 统一下单
        String unifiedorder_url = WxPayApi.unifiedorder_url;

        String xmlStr = HttpRequest.sendPost(unifiedorder_url, xml);//发送post请求"统一下单接口"返回预支付id:prepay_id

        //以下内容是返回前端页面的json数据
        String prepay_id = "";//预支付id
        if (xmlStr.indexOf("SUCCESS") != -1) {
            Map<String, String> map = WXPayUtil.xmlToMap(xmlStr);
//                String return_code = map.get("return_code");
//                String return_msg = map.get("return_msg");
            prepay_id = (String) map.get("prepay_id");
        }
        Map<String, String> payMap = new HashMap<String, String>();
        payMap.put("appId", appId);
        payMap.put("timeStamp", WXPayUtil.getCurrentTimestamp()+"");
        payMap.put("nonceStr", WXPayUtil.generateNonceStr());
        payMap.put("signType", "MD5");
        payMap.put("package", "prepay_id=" + prepay_id);
        String paySign = WXPayUtil.generateSignature(payMap, paternerKey);
        payMap.put("paySign", paySign);
        String jsonStr = JSON.toJSONString(payMap);
        result.success(jsonStr);
        return result;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
```

##### 微信内H5调起支付
```javascript
<script type="text/javascript">
var appId,timeStamp,nonceStr,package,signType,paySign;  
 function pay(){
	var code = $("#total_fee").attr("total_fee");//支付金额
	if(code){
		var url = "http://***/orders?total_fee"+total_fee;
	  	$.get(url,function(result) {
  			if (res.code == 0) {
				var data = $.parseJSON(res.data);

				if (typeof WeixinJSBridge == "undefined") {
					if (document.addEventListener) {
						document.addEventListener('WeixinJSBridgeReady',
								onBridgeReady(data), false);
					} else if (document.attachEvent) {
						document.attachEvent('WeixinJSBridgeReady',
								onBridgeReady(data));
						document.attachEvent('onWeixinJSBridgeReady',
								onBridgeReady(data));
					}
				} else {
					onBridgeReady(data);
				}
			} else {
				if (res.code == 2) {
					layer.alert(res.message);
				} else {
					layer.msg("error：" + res.message, {
						shift : 6
					});
				}
			}
			});
		} else {
			alert(“服务器错误”)
		}
	}
function onBridgeReady(json) {
    WeixinJSBridge.invoke('getBrandWCPayRequest', json, function(res) {
        // 使用以上方式判断前端返回,微信团队郑重提示：res.err_msg将在用户支付成功后返回    ok，但并不保证它绝对可靠。
        if (res.err_msg == "get_brand_wcpay_request:ok") {
            layer.msg("支付成功", {
                shift : 6
            });

            self.location = "#(ctxPath)/success";

        } else {
            layer.msg("支付失败", {
                shift : 6
            });
        }
    });
}
</script>

```

微信付款后回调返回数据示例：
```xml
----接收到的数据如下：---
<xml><appid><![CDATA[wxc293f61341667af1]]></appid>
<bank_type><![CDATA[CFT]]></bank_type>
<cash_fee><![CDATA[1]]></cash_fee>
<fee_type><![CDATA[CNY]]></fee_type>
<is_subscribe><![CDATA[Y]]></is_subscribe>
<mch_id><![CDATA[1532968631]]></mch_id>
<nonce_str><![CDATA[Pklbx7HIrnsytXqR3aelHrRsGfr6gz7Q]]></nonce_str>
<openid><![CDATA[o54ZOwPhVmMP4_7xgU7jHgXsXzMw]]></openid>
<out_trade_no><![CDATA[HTorCq5g4ATpnlWVoltuSRXKIyPS6B8H]]></out_trade_no>
<result_code><![CDATA[SUCCESS]]></result_code>
<return_code><![CDATA[SUCCESS]]></return_code>
<sign><![CDATA[FE665BD9303D2015DE294B54133269D5]]></sign>
<time_end><![CDATA[20190423172200]]></time_end>
<total_fee>1</total_fee>
<trade_type><![CDATA[JSAPI]]></trade_type>
<transaction_id><![CDATA[4200000296201904233313608005]]></transaction_id>
</xml>
```

##### 微信回调
```java
 /**
    * 微信支付成功回调
    * 处理自己的业务
    */
@RequestMapping("callback")
public String callBack(HttpServletRequest request,HttpServletResponse response){
    //System.out.println("微信支付成功,微信发送的callback信息,请注意修改订单信息");
    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");
    InputStream is = null;
    try {
        is = request.getInputStream();//获取请求的流信息(这里是微信发的xml格式所有只能使用流来读)
        String xml = WXPayUtil.inputStream2String(is, "UTF-8");
        System.out.println("----接收到的数据如下：---" + xml);
        Map<String, String> notifyMap = WXPayUtil.xmlToMap(xml);//将微信发的xml转map

        if(notifyMap.get("return_code").equals("SUCCESS")){
            if(notifyMap.get("result_code").equals("SUCCESS")){
                String ordersSn = notifyMap.get("out_trade_no");//商户订单号
                String amountpaid = notifyMap.get("total_fee");//实际支付的订单金额:单位 分
                BigDecimal amountPay = (new BigDecimal(amountpaid).divide(new BigDecimal("100"))).setScale(2);//将分转换成元-实际支付金额:元
                //String openid = notifyMap.get("openid");  //如果有需要可以获取
                //String trade_type = notifyMap.get("trade_type");

                /*以下是自己的业务处理------仅做参考
                    * 更新order对应字段/已支付金额/状态码
                    */
//                    Orders order = ordersService.selectOrdersBySn(ordersSn);
//                    if(order != null) {
//                        order.setLastmodifieddate(new Date());
//                        order.setVersion(order.getVersion().add(BigDecimal.ONE));
//                        order.setAmountpaid(amountPay);//已支付金额
//                        order.setStatus(2L);//修改订单状态为待发货
//                        int num = ordersService.updateOrders(order);//更新order
//
//                        String amount = amountPay.setScale(0, BigDecimal.ROUND_FLOOR).toString();//实际支付金额向下取整-123.23--123
//	                	/*
//	                	 * 更新用户经验值
//	                	 */
//                        Member member = accountService.findObjectById(order.getMemberId());
//                        accountService.updateMemberByGrowth(amount, member);
//
//	                	/*
//	                	 * 添加用户积分数及添加积分记录表记录
//	                	 */
//                        pointService.updateMemberPointAndLog(amount, member, "购买商品,订单号为:"+ordersSn);
//
//                    }
            }
        }
        //告诉微信服务器收到信息了，不要在调用回调action了========这里很重要回复微信服务器信息用流发送一个xml即可
        response.getWriter().write("<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>");
        is.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
```

#### 问题点
- 支付报错mch_id与appid不匹配  
商户号现在和微信公众号是分开的。所以，需要再商户号中的产品中心-》APPID授权管理中绑定微信公众号。


### 支付宝支付（Java）

#### 测试环境开发逻辑
- 配置沙箱环境
- 服务端实现（maven项目）

##### 对于测试环境，配置沙箱环境如下
开发者调用接口前需要先生成RSA密钥，RSA密钥包含应用私钥(APP_PRIVATE_KEY)、应用公钥(APP_PUBLIC_KEY）。生成密钥后在开放平台管理中心进行密钥配置，配置完成后可以获取支付宝公钥(ALIPAY_PUBLIC_KEY)。


[官方生成密钥文档及工具](https://docs.open.alipay.com/291/105971)

将生成的**应用公钥**填于此处来获取**支付宝公钥**：
![操作方法](/img/md/pictures/1556591394826-cca04e50-6091-4597-9fb5-eafa66d869af.png)

下载沙箱app,支付提供了沙箱app的登录账号

##### 对于正式环境，配置步骤如下

**服务端实现**

- pom.xml中引入相关依赖

```java
<!--支付宝相关依赖-->
<!-- https://mvnrepository.com/artifact/com.alipay.sdk/alipay-sdk-java -->
<dependency>
    <groupId>com.alipay.sdk</groupId>
    <artifactId>alipay-sdk-java</artifactId>
    <version>3.7.4.ALL</version>
</dependency>
```

- 支付所需要的基本信息

>配置注意两点，一个是使用“应用私钥”，一个是使用“支付宝公钥”而不是“应用公钥”

```xml
## 支付宝配置
# appid
alipay.APPID=2016093000629739
# 应用私钥
alipay.RSA_PRIVATE_KEY=***
# 支付宝公钥
alipay.ALIPAY_PUBLIC_KEY=***
# 支付宝网关
alipay.URL=https://openapi.alipaydev.com/gateway.do
# 商户网关地址
alipay.domain = http://gzue.natapp1.cc
# 服务器异步通知页面路径
alipay.notify_url=http://gzue.natapp1.cc/alipay/notify_url
# 页面跳转同步通知页面路径
alipay.return_url=http://gzue.natapp1.cc/alipay/return_url
```

- 创建一个实体直接读取配置文件信息  

```java
@Component
@PropertySource(value = "classpath:alipayconfig.properties")
@ConfigurationProperties(prefix = "alipay")
public class AlipayConfig {
	// 商户appid
	public  String APPID;
	//私钥
	public  String RSA_PRIVATE_KEY;
	//公钥
	public  String ALIPAY_PUBLIC_KEY ;
	//
	public  String notify_url;
	//
	public  String return_url;
	//
	public  String URL;

	public  String domain;
	//
	public static String CHARSET = "UTF-8";
	//
	public static String FORMAT = "json";

	public static  String log_path = "/log";
	// RSA2
	public static  String SIGNTYPE = "RSA2";

	public  AlipayClient alipayClient;

//	public AlipayConfig() {
//	}

	public AlipayConfig build() {
		this.alipayClient = new DefaultAlipayClient(URL, APPID, RSA_PRIVATE_KEY, FORMAT, CHARSET, ALIPAY_PUBLIC_KEY, SIGNTYPE);
		return this;
	}
//	public  static  AlipayConfig NEW(){
//		return new AlipayConfig();
//	}

	public AlipayClient getAlipayClient() {
		if (this.alipayClient == null) {
			System.out.println("alipayClient null");
			throw new IllegalStateException("alipayClient null");
		} else {
			System.out.println(alipayClient);
			return this.alipayClient;
		}
	}

//此处省略get set 方法
}

```

- 处理wabpay支付请求接口、同步通知和异步通知路径接口

```java
Controller
@RequestMapping("alipay")
public class AlipayController {

    @Autowired
    AlipayConfig alipayConfig;
    @Autowired
    AliPayApi aliPayApi;
    /**
     * alipayClient只需要初始化一次，后续调用不同的API都可以使用同一个alipayClient对象
     */
//    AlipayClient alipayClient = new DefaultAlipayClient("https://openapi.alipay.com/gateway.do",APP_ID,APP_PRIVATE_KEY,"json",CHARSET,ALIPAY_PUBLIC_KEY);

//    public AlipayConfig getAlipayConfig() {
//        return alipayConfig.build();
//    }
    /**
     * 手机web支付
     */
    @RequestMapping(value = "/wapPay")
    @ResponseBody
    public void wapPay(HttpServletResponse response) {
//        getAlipayConfig();
        String body = "测试数据";
        String subject = "支付测试";
        String totalAmount = "1";
        String passbackParams = "1";
        String returnUrl =   alipayConfig.getReturn_url();
        String notifyUrl =  alipayConfig.getNotify_url();

        AlipayTradeWapPayModel model = new AlipayTradeWapPayModel();
        model.setBody(body);
        model.setSubject(subject);
        model.setTotalAmount(totalAmount);
        model.setPassbackParams(passbackParams);
        String outTradeNo = StringUtils.getOutTradeNo();
        System.out.println("wap outTradeNo>"+outTradeNo);
        model.setOutTradeNo(outTradeNo);
        model.setProductCode("QUICK_WAP_PAY");

        try {
            aliPayApi.wapPay(response, model, returnUrl, notifyUrl);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/return_url")
    @ResponseBody
    public String return_url(HttpServletRequest request) {
        try {
            // 获取支付宝GET过来反馈信息
            Map<String, String> map = AliPayApi.toMap(request);
            for (Map.Entry<String, String> entry : map.entrySet()) {
                System.out.println(entry.getKey() + " = " + entry.getValue());
            }

            boolean verify_result = AlipaySignature.rsaCheckV1(map, alipayConfig.getALIPAY_PUBLIC_KEY(), "UTF-8",
                    "RSA2");

            if (verify_result) {// 验证成功
                // TODO 请在这里加上商户的业务逻辑程序代码
                System.out.println("return_url 验证成功");

                return "success";
            } else {
                System.out.println("return_url 验证失败");
                // TODO
                return "failure";
            }
        } catch (AlipayApiException e) {
            e.printStackTrace();
            return "failure";
        }
    }



    @RequestMapping(value = "/notify_url")
    @ResponseBody
    public String  notify_url(HttpServletRequest request) {
        try {
            // 获取支付宝POST过来反馈信息
            Map<String, String> params = AliPayApi.toMap(request);

            for (Map.Entry<String, String> entry : params.entrySet()) {
                System.out.println(entry.getKey() + " = " + entry.getValue());
            }

            boolean verify_result = AlipaySignature.rsaCheckV1(params, alipayConfig.getALIPAY_PUBLIC_KEY(), "UTF-8",
                    "RSA2");

            if (verify_result) {// 验证成功
                // TODO 请在这里加上商户的业务逻辑程序代码 异步通知可能出现订单重复通知 需要做去重处理
                System.out.println("notify_url 验证成功succcess");
                return "success";
            } else {
                System.out.println("notify_url 验证失败");
                // TODO
                return "failure";
            }
        } catch (AlipayApiException e) {
            e.printStackTrace();
            return "failure";
        }
    }
}
```

- 上面所使用到的一个请求api接口

```java
@Component
public class AliPayApi  {
    @Autowired
    AlipayConfig alipayConfig;

//    private static final String ALIPAY_GATEWAY_NEW = "https://mapi.alipay.com/gateway.do?";

//    private static final String ALIPAY_GATEWAY_NEW = alipayConfig.getURL();
    public AliPayApi() {

    }

    public  AlipayConfig getAlipayConfig() {
        return alipayConfig.build();
    }

    public  void wapPay(HttpServletResponse response, AlipayTradeWapPayModel model, String returnUrl, String notifyUrl) throws AlipayApiException, IOException {
        String form = wapPayStr(response, model, returnUrl, notifyUrl);
        response.setContentType("text/html;charset=" + AlipayConfig.CHARSET);
        response.getWriter().write(form);
        response.getWriter().flush();
    }

    public  String wapPayStr(HttpServletResponse response, AlipayTradeWapPayModel model, String returnUrl, String notifyUrl) throws AlipayApiException, IOException {
        getAlipayConfig();
//        AlipayClient alipayClient = new DefaultAlipayClient(alipayConfig.getURL(), alipayConfig.getAPPID(), alipayConfig.getRSA_PRIVATE_KEY(), AlipayConfig.FORMAT, AlipayConfig.CHARSET, alipayConfig.getALIPAY_PUBLIC_KEY(), AlipayConfig.SIGNTYPE);
        AlipayTradeWapPayRequest alipayRequest = new AlipayTradeWapPayRequest();
        alipayRequest.setReturnUrl(returnUrl);
        alipayRequest.setNotifyUrl(notifyUrl);
        alipayRequest.setBizModel(model);
        return ((AlipayTradeWapPayResponse)alipayConfig.getAlipayClient().pageExecute(alipayRequest)).getBody();
    }

    public static Map<String, String> toMap(HttpServletRequest request) {
        Map<String, String> params = new HashMap();
        Map<String, String[]> requestParams = request.getParameterMap();
        Iterator iter = requestParams.keySet().iterator();

        while(iter.hasNext()) {
            String name = (String)iter.next();
            String[] values = (String[])((String[])requestParams.get(name));
            String valueStr = "";

            for(int i = 0; i < values.length; ++i) {
                valueStr = i == values.length - 1 ? valueStr + values[i] : valueStr + values[i] + ",";
            }

            params.put(name, valueStr);
        }

        return params;
    }
}

```

- 调用支付请求接口http://gzue.natapp1.cc/alipay/wapPay 进行测试

#### 问题点
- 当我们自定义了支付页面，并在支付宝中直接访问，调取支付接口后，支付宝会返回一个支付表单给我们，那么此时，我们要进行页面覆盖：

```javascript
/*
    支付宝支付start
*/
function alipay() {
    $.showLoading("正在加载...");
    var totalAmount = $.trim($("#web_money").val());
    $.post("#(ctxPath)/alipay/wapPay", {
        totalAmount : totalAmount,
    }, function(res) {
    //返回的支付表单页面res
//            alert(res);
        $.hideLoading();
        const div = document.createElement('div');
        div.innerHTML = res; // html code
        document.body.appendChild(div);
//            document.forms[0].setAttribute('target', '_blank');
        document.forms[0].submit();
    });
}
/*
    支付宝支付end
*/
```
### 支付宝JSAPI
>
1.引入资源文件  
2.授权获取用户信息  
3.获取userid  
4.~~服务端调用接口发起下单请求获取 trade_no~~  
5.支付宝内H5调起支付  

#### 引入资源文件
- 页面引入：

```javascript
<script src = "https://gw.alipayobjects.com/as/g/h5-lib/alipayjsapi/3.1.1/alipayjsapi.min.js"> </script> 
```

#### 授权获取用户信息

如上图所示，对于开发者而言，需要完成以下工作：
>
1. 按照规则拼接授权页面的链接，并且引导用户跳转至该链接；
2. 用户在授权页面上确认授权后，将跳转到开发者指定的回调页，并且带上 auth_code；
3. 开发者通过 auth_code 换取 access_token 及用户的 userId；
4. 如果需要除 userId 以外的其他信息，则使用access_token调用用户信息共享接口获取。

url 拼接规则：
```
https://openauth.alipay.com/oauth2/publicAppAuthorize.htm?app_id=APPID&scope=SCOPE&redirect_uri=ENCODED_URL&state=state

url 参数说明：
app_id
是
开发者应用的app_id

scope
是
接口权限值，目前只支持auth_userinfo和auth_base两个值

redirect_uri
是
回调页面，是 经过转义 的url链接（url必须以http或者https开头），比如：http%3A%2F%2Fexample.com 在请求之前，开发者需要先到开发者中心对应应用内，配置授权回调地址。

state
否
商户自定义参数，用户授权后，重定向到redirect_uri时会原样回传给商户。 为防止CSRF攻击，建议开发者请求授权时传入state参数，该参数要做到既不可预测，又可以证明客户端和当前第三方网站的登录认证状态存在关联。
```

使用场景举例：开发者通过URL拼接方案，构造授权页面，并且引导用户授权。

#### 获取userid

- 前端使用 my.getAuthCode 获取授权码
- 后端使用 alipay.system.oauth.token 接口获取用户userid

[文档地址](https://opendocs.alipay.com/support/01rb05)

#### 服务端调用接口发起下单请求获取 trade_no

#### 支付宝内H5调起支付
```javascript
function callAliPay(tradeNO) {
	function ready(callback) {
		// 如果jsbridge已经注入则直接调用
		if (window.AlipayJSBridge) {
			callback && callback();
		} else {
			// 如果没有注入则监听注入的事件
			document.addEventListener('AlipayJSBridgeReady', callback, false);
		}
	}
	ready(function() {
		AlipayJSBridge.call('tradePay', {
			tradeNO: tradeNO
		}, function(result) {
			if(result.resultCode == 9000) {
                alert('支付成功')
				AlipayJSBridge.call('closeWebview');
			}else{
                alert('支付失败')
            }
		});
	});
}
```

### js关闭当前页面
>
在微信 , 支付宝 , app 中打开外部链接 , 都是使用webview打开页面的 , 所以需要app提供映射方法。
对于微信  , 支付宝 , 我们能通过开放平台找到对应的方法。

#### 微信
```javascript
window.WeixinJSBridge.call('closeWindow')
```

#### 支付宝
```javascript
window.AlipayJSBridge.call('closeWebview')
```