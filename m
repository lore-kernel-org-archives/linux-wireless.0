Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:42510 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab3IIUkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 16:40:06 -0400
Received: by mail-wg0-f53.google.com with SMTP id x12so3396967wgg.8
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 13:40:01 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 9 Sep 2013 22:40:00 +0200
Message-ID: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com> (sfid-20130909_224054_804460_43A370A4)
Subject: No connection with TP-Link TL-WN823N (rtl8192cu)
From: Vincent Thiele <vincentthiele@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I use TL-WN823N usb-stick with ubuntu but native drivers disconnect
few seconds after boot. For wlan i need to install this package:
https://code.google.com/p/realtek-8188cus-wireless-drivers-3444749-ubuntu-1304/.
But this package can not be used with a kernel > 3.9. Please fix the
native drivers. Best regards

Syslog:
Sep  9 08:00:16 Arbeits-PC anacron[1126]: Job `cron.daily' terminated
Sep  9 08:00:16 Arbeits-PC anacron[1126]: Normal exit (1 job run)
Sep  9 08:00:19 Arbeits-PC kernel: [ 1406.751093] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:00:19 Arbeits-PC kernel: [ 1406.751337]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:00:29 Arbeits-PC kernel: [ 1416.756680] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:00:29 Arbeits-PC kernel: [ 1416.756687]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:00:33 Arbeits-PC kernel: [ 1420.759060] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:00:33 Arbeits-PC kernel: [ 1420.759308]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:00:35 Arbeits-PC kernel: [ 1422.760181] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:00:35 Arbeits-PC kernel: [ 1422.760188]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:00:37 Arbeits-PC kernel: [ 1424.761299] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:00:37 Arbeits-PC kernel: [ 1424.761547]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:00:39 Arbeits-PC kernel: [ 1426.762422] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:00:39 Arbeits-PC kernel: [ 1426.762430]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:00:43 Arbeits-PC kernel: [ 1430.764638] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:00:43 Arbeits-PC kernel: [ 1430.764766]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:00:51 Arbeits-PC kernel: [ 1438.769266] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:00:51 Arbeits-PC kernel: [ 1438.769273]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:00:55 Arbeits-PC kernel: [ 1442.771494] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:00:55 Arbeits-PC kernel: [ 1442.771603]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:00:59 Arbeits-PC kernel: [ 1446.773750] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:00:59 Arbeits-PC kernel: [ 1446.773757]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:01:04 Arbeits-PC kernel: [ 1450.775907] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:01:04 Arbeits-PC kernel: [ 1450.776049]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:01:54 Arbeits-PC kernel: [ 1500.804373] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:01:54 Arbeits-PC kernel: [ 1500.804380]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:01:58 Arbeits-PC kernel: [ 1504.806560] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:01:58 Arbeits-PC kernel: [ 1504.806687]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:02:00 Arbeits-PC kernel: [ 1506.807687] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:02:00 Arbeits-PC kernel: [ 1506.807692]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:02:02 Arbeits-PC kernel: [ 1508.808772] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:02:02 Arbeits-PC kernel: [ 1508.808892]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:02:06 Arbeits-PC kernel: [ 1512.811046] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:02:06 Arbeits-PC kernel: [ 1512.811053]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:02:10 Arbeits-PC kernel: [ 1516.813437] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:02:10 Arbeits-PC kernel: [ 1516.813565]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:02:12 Arbeits-PC kernel: [ 1518.845224] survey done event(12)
Sep  9 08:02:14 Arbeits-PC kernel: [ 1520.815703] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:02:14 Arbeits-PC kernel: [ 1520.815711]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:02:16 Arbeits-PC kernel: [ 1522.816796] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:02:16 Arbeits-PC kernel: [ 1522.816915]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:02:24 Arbeits-PC kernel: [ 1530.821276] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:02:24 Arbeits-PC kernel: [ 1530.821283]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:02:36 Arbeits-PC kernel: [ 1542.828150] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:02:36 Arbeits-PC kernel: [ 1542.828395]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:02:40 Arbeits-PC kernel: [ 1546.830344] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:02:40 Arbeits-PC kernel: [ 1546.830351]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:02:48 Arbeits-PC kernel: [ 1554.834955] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:02:48 Arbeits-PC kernel: [ 1554.835053]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:02:50 Arbeits-PC kernel: [ 1556.836090] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:02:50 Arbeits-PC kernel: [ 1556.836098]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:02:52 Arbeits-PC kernel: [ 1558.837200] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:02:52 Arbeits-PC kernel: [ 1558.837334]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:02:58 Arbeits-PC kernel: [ 1564.840574] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:02:58 Arbeits-PC kernel: [ 1564.840582]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:03:00 Arbeits-PC kernel: [ 1566.841684] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:03:00 Arbeits-PC kernel: [ 1566.841775]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:03:06 Arbeits-PC kernel: [ 1572.845202] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:03:06 Arbeits-PC kernel: [ 1572.845209]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:03:10 Arbeits-PC kernel: [ 1576.847444] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:03:10 Arbeits-PC kernel: [ 1576.847690]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:03:14 Arbeits-PC kernel: [ 1580.849665] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:03:14 Arbeits-PC kernel: [ 1580.849672]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:03:18 Arbeits-PC kernel: [ 1584.851871] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:03:18 Arbeits-PC kernel: [ 1584.851997]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:03:24 Arbeits-PC kernel: [ 1590.855413] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:03:24 Arbeits-PC kernel: [ 1590.855419]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:03:32 Arbeits-PC kernel: [ 1598.859871] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:03:32 Arbeits-PC kernel: [ 1598.860000]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:03:34 Arbeits-PC kernel: [ 1600.860994] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:03:34 Arbeits-PC kernel: [ 1600.861001]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:03:38 Arbeits-PC kernel: [ 1604.863240] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:03:38 Arbeits-PC kernel: [ 1604.863353]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:03:40 Arbeits-PC kernel: [ 1606.864499] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:03:40 Arbeits-PC kernel: [ 1606.864506]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:03:44 Arbeits-PC kernel: [ 1610.866738] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:03:44 Arbeits-PC kernel: [ 1610.866984]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:03:46 Arbeits-PC kernel: [ 1612.867833] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:03:46 Arbeits-PC kernel: [ 1612.867841]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:03:48 Arbeits-PC kernel: [ 1614.868991] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:03:48 Arbeits-PC kernel: [ 1614.869224]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:03:52 Arbeits-PC kernel: [ 1618.871203] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:03:52 Arbeits-PC kernel: [ 1618.871210]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:03:54 Arbeits-PC kernel: [ 1620.872320] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:03:54 Arbeits-PC kernel: [ 1620.872438]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:03:56 Arbeits-PC kernel: [ 1622.873560] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:03:56 Arbeits-PC kernel: [ 1622.873568]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:04:06 Arbeits-PC kernel: [ 1632.879191] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:04:06 Arbeits-PC kernel: [ 1632.879433]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:04:08 Arbeits-PC kernel: [ 1634.880303] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:04:08 Arbeits-PC kernel: [ 1634.880310]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:04:10 Arbeits-PC kernel: [ 1637.320532] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:04:10 Arbeits-PC kernel: [ 1637.320773]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:04:12 Arbeits-PC kernel: [ 1638.685516] survey done event(10)
Sep  9 08:04:12 Arbeits-PC kernel: [ 1638.882529] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:04:12 Arbeits-PC kernel: [ 1638.882536]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:04:18 Arbeits-PC kernel: [ 1644.886034] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:04:18 Arbeits-PC kernel: [ 1644.886280]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:04:22 Arbeits-PC kernel: [ 1648.888273] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:04:22 Arbeits-PC kernel: [ 1648.888280]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:04:24 Arbeits-PC kernel: [ 1650.889395] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:04:24 Arbeits-PC kernel: [ 1650.889640]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:04:26 Arbeits-PC kernel: [ 1652.890521] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:04:26 Arbeits-PC kernel: [ 1652.890528]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:04:30 Arbeits-PC kernel: [ 1656.892736] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:04:30 Arbeits-PC kernel: [ 1656.892854]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:04:32 Arbeits-PC kernel: [ 1658.893857] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:04:32 Arbeits-PC kernel: [ 1658.893864]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:04:40 Arbeits-PC kernel: [ 1666.898482] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:04:40 Arbeits-PC kernel: [ 1666.898732]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:04:42 Arbeits-PC kernel: [ 1668.899588] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:04:42 Arbeits-PC kernel: [ 1668.899596]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:04:48 Arbeits-PC kernel: [ 1674.902944] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:04:48 Arbeits-PC kernel: [ 1674.903062]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:04:50 Arbeits-PC kernel: [ 1676.904064] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:04:50 Arbeits-PC kernel: [ 1676.904072]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:04:52 Arbeits-PC kernel: [ 1678.905193] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:04:52 Arbeits-PC kernel: [ 1678.905306]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:04:56 Arbeits-PC kernel: [ 1682.907572] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:04:56 Arbeits-PC kernel: [ 1682.907580]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:05:00 Arbeits-PC kernel: [ 1686.909812] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:05:00 Arbeits-PC kernel: [ 1686.910058]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:05:06 Arbeits-PC kernel: [ 1692.913152] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:05:06 Arbeits-PC kernel: [ 1692.913157]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:05:08 Arbeits-PC kernel: [ 1694.914270] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:05:08 Arbeits-PC kernel: [ 1694.914386]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:08:12 Arbeits-PC kernel: [ 1878.330145] survey done event(10)
Sep  9 08:08:42 Arbeits-PC kernel: [ 1909.035662] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:08:42 Arbeits-PC kernel: [ 1909.035669]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:08:45 Arbeits-PC kernel: [ 1911.856884] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:08:45 Arbeits-PC kernel: [ 1911.857076]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:08:50 Arbeits-PC kernel: [ 1917.040127] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:08:50 Arbeits-PC kernel: [ 1917.040135]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:08:54 Arbeits-PC kernel: [ 1921.042486] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:08:54 Arbeits-PC kernel: [ 1921.042604]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:08:56 Arbeits-PC kernel: [ 1923.043606] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:08:56 Arbeits-PC kernel: [ 1923.043614]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:08:58 Arbeits-PC kernel: [ 1925.044570] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:08:58 Arbeits-PC kernel: [ 1925.044673]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:09:10 Arbeits-PC kernel: [ 1937.051453] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:09:10 Arbeits-PC kernel: [ 1937.051460]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:09:12 Arbeits-PC kernel: [ 1939.052663] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:09:12 Arbeits-PC kernel: [ 1939.052766]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:09:18 Arbeits-PC kernel: [ 1945.056081] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:09:18 Arbeits-PC kernel: [ 1945.056089]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:09:20 Arbeits-PC kernel: [ 1947.057149] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:09:20 Arbeits-PC kernel: [ 1947.057296]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:09:33 Arbeits-PC kernel: [ 1959.063899] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:09:33 Arbeits-PC kernel: [ 1959.063906]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:09:35 Arbeits-PC kernel: [ 1961.065142] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:09:35 Arbeits-PC kernel: [ 1961.065231]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:09:53 Arbeits-PC kernel: [ 1979.075374] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:09:53 Arbeits-PC kernel: [ 1979.075382]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:09:55 Arbeits-PC kernel: [ 1981.076496] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:09:55 Arbeits-PC kernel: [ 1981.076741]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:09:57 Arbeits-PC kernel: [ 1983.077590] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:09:57 Arbeits-PC kernel: [ 1983.077598]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:09:59 Arbeits-PC kernel: [ 1985.078725] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:09:59 Arbeits-PC kernel: [ 1985.078821]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:10:05 Arbeits-PC kernel: [ 1991.082077] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:10:05 Arbeits-PC kernel: [ 1991.082085]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:10:07 Arbeits-PC kernel: [ 1993.083197] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:10:07 Arbeits-PC kernel: [ 1993.083313]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:10:12 Arbeits-PC kernel: [ 1998.158452] survey done event(15)
Sep  9 08:10:21 Arbeits-PC kernel: [ 2007.091114] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:10:21 Arbeits-PC kernel: [ 2007.091122]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:10:23 Arbeits-PC kernel: [ 2009.092280] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:10:23 Arbeits-PC kernel: [ 2009.092522]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:10:31 Arbeits-PC kernel: [ 2017.096910] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:10:31 Arbeits-PC kernel: [ 2017.096917]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:10:33 Arbeits-PC kernel: [ 2019.097971] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:10:33 Arbeits-PC kernel: [ 2019.098083]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:10:43 Arbeits-PC kernel: [ 2029.103616] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:10:43 Arbeits-PC kernel: [ 2029.103623]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:10:45 Arbeits-PC kernel: [ 2031.104730] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:10:45 Arbeits-PC kernel: [ 2031.104847]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:12:01 Arbeits-PC kernel: [ 2107.147803] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:12:01 Arbeits-PC kernel: [ 2107.147810]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:12:07 Arbeits-PC kernel: [ 2113.151303] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:12:07 Arbeits-PC kernel: [ 2113.151556]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:12:12 Arbeits-PC kernel: [ 2117.987033] survey done event(14)
Sep  9 08:12:13 Arbeits-PC kernel: [ 2119.154621] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:12:13 Arbeits-PC kernel: [ 2119.154628]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:12:19 Arbeits-PC kernel: [ 2125.158011] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:12:19 Arbeits-PC kernel: [ 2125.158128]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:12:23 Arbeits-PC kernel: [ 2129.160342] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:12:23 Arbeits-PC kernel: [ 2129.160349]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:12:27 Arbeits-PC kernel: [ 2133.162634] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:12:27 Arbeits-PC kernel: [ 2133.162879]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:12:33 Arbeits-PC kernel: [ 2139.165976] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:12:33 Arbeits-PC kernel: [ 2139.165984]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:12:39 Arbeits-PC kernel: [ 2145.169478] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:12:39 Arbeits-PC kernel: [ 2145.169730]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:12:41 Arbeits-PC kernel: [ 2147.170602] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:12:41 Arbeits-PC kernel: [ 2147.170610]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:12:45 Arbeits-PC kernel: [ 2151.172842] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:12:45 Arbeits-PC kernel: [ 2151.173090]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:12:51 Arbeits-PC kernel: [ 2157.176192] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:12:51 Arbeits-PC kernel: [ 2157.176199]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:12:55 Arbeits-PC kernel: [ 2161.178434] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:12:55 Arbeits-PC kernel: [ 2161.178689]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:13:01 Arbeits-PC kernel: [ 2167.181930] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:13:01 Arbeits-PC kernel: [ 2167.181937]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:13:05 Arbeits-PC kernel: [ 2171.184145] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:13:05 Arbeits-PC kernel: [ 2171.184283]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:13:09 Arbeits-PC kernel: [ 2175.186390] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:13:09 Arbeits-PC kernel: [ 2175.186397]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:13:19 Arbeits-PC kernel: [ 2185.192138] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:13:19 Arbeits-PC kernel: [ 2185.192386]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:13:21 Arbeits-PC kernel: [ 2187.193255] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:13:21 Arbeits-PC kernel: [ 2187.193262]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:13:29 Arbeits-PC kernel: [ 2195.197718] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:13:29 Arbeits-PC kernel: [ 2195.197837]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:13:29 Arbeits-PC kernel: [ 2195.607006] EXT4-fs (sdb1):
mounted filesystem with ordered data mode. Opts: (null)
Sep  9 08:13:29 Arbeits-PC udisksd[2179]: Mounted /dev/sdb1 at
/media/vincent/c08c4653-e319-4cce-8862-07874a4d20e7 on behalf of uid
1000
Sep  9 08:13:30 Arbeits-PC dbus[910]: [system] Activating service
name='org.freedesktop.hostname1' (using servicehelper)
Sep  9 08:13:30 Arbeits-PC dbus[910]: [system] Successfully activated
service 'org.freedesktop.hostname1'
Sep  9 08:13:31 Arbeits-PC kernel: [ 2197.198815] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:13:31 Arbeits-PC kernel: [ 2197.198820]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:13:33 Arbeits-PC kernel: [ 2199.199910] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:13:33 Arbeits-PC kernel: [ 2199.200032]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:13:51 Arbeits-PC kernel: [ 2217.210171] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:13:51 Arbeits-PC kernel: [ 2217.210177]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:13:53 Arbeits-PC kernel: [ 2219.211271] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:13:53 Arbeits-PC kernel: [ 2219.211363]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:13:55 Arbeits-PC kernel: [ 2221.212552] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:13:55 Arbeits-PC kernel: [ 2221.212559]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:13:56 Arbeits-PC kernel: [ 2222.197438] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:13:56 Arbeits-PC kernel: [ 2222.197635]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:14:01 Arbeits-PC kernel: [ 2227.215912] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:14:01 Arbeits-PC kernel: [ 2227.215919]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:14:09 Arbeits-PC kernel: [ 2235.220378] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:14:09 Arbeits-PC kernel: [ 2235.220491]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:14:12 Arbeits-PC kernel: [ 2237.815347] survey done event(f)
Sep  9 08:14:17 Arbeits-PC kernel: [ 2243.225005] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:14:17 Arbeits-PC kernel: [ 2243.225012]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:14:19 Arbeits-PC kernel: [ 2245.226070] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:14:19 Arbeits-PC kernel: [ 2245.226195]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:14:23 Arbeits-PC kernel: [ 2249.228349] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:14:23 Arbeits-PC kernel: [ 2249.228356]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:14:29 Arbeits-PC kernel: [ 2255.231706] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:14:29 Arbeits-PC kernel: [ 2255.231821]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:14:31 Arbeits-PC kernel: [ 2257.232948] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:14:31 Arbeits-PC kernel: [ 2257.232955]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:14:37 Arbeits-PC kernel: [ 2263.236331] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:14:37 Arbeits-PC kernel: [ 2263.236571]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:14:47 Arbeits-PC kernel: [ 2273.241916] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:14:47 Arbeits-PC kernel: [ 2273.241923]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:14:49 Arbeits-PC kernel: [ 2275.243181] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:14:49 Arbeits-PC kernel: [ 2275.243422]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:14:51 Arbeits-PC kernel: [ 2277.244228] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:14:51 Arbeits-PC kernel: [ 2277.244234]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:14:55 Arbeits-PC kernel: [ 2281.246539] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:14:55 Arbeits-PC kernel: [ 2281.246783]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:14:57 Arbeits-PC kernel: [ 2283.247610] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:14:57 Arbeits-PC kernel: [ 2283.247617]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:14:59 Arbeits-PC kernel: [ 2285.248753] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:14:59 Arbeits-PC kernel: [ 2285.248873]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:15:01 Arbeits-PC kernel: [ 2287.249888] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:15:01 Arbeits-PC kernel: [ 2287.249895]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:15:09 Arbeits-PC kernel: [ 2295.254608] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:15:09 Arbeits-PC kernel: [ 2295.254728]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:15:11 Arbeits-PC kernel: [ 2297.255599] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:15:11 Arbeits-PC kernel: [ 2297.255606]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:15:13 Arbeits-PC kernel: [ 2299.256750] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:15:13 Arbeits-PC kernel: [ 2299.256990]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:15:17 Arbeits-PC kernel: [ 2303.258973] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:15:17 Arbeits-PC kernel: [ 2303.258980]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:15:19 Arbeits-PC kernel: [ 2305.260085] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:15:19 Arbeits-PC kernel: [ 2305.260204]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:15:21 Arbeits-PC kernel: [ 2307.261206] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:15:21 Arbeits-PC kernel: [ 2307.261212]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:15:29 Arbeits-PC kernel: [ 2315.265820] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:15:29 Arbeits-PC kernel: [ 2315.265932]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:15:31 Arbeits-PC kernel: [ 2317.266927] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:15:31 Arbeits-PC kernel: [ 2317.266934]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:15:37 Arbeits-PC kernel: [ 2323.270814] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:15:37 Arbeits-PC kernel: [ 2323.271056]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:15:41 Arbeits-PC kernel: [ 2327.272536] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:15:41 Arbeits-PC kernel: [ 2327.272543]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:15:49 Arbeits-PC kernel: [ 2335.277173] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:15:49 Arbeits-PC kernel: [ 2335.277406]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:15:51 Arbeits-PC kernel: [ 2337.278282] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:15:51 Arbeits-PC kernel: [ 2337.278289]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:15:53 Arbeits-PC kernel: [ 2339.279385] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:15:53 Arbeits-PC kernel: [ 2339.279496]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:15:55 Arbeits-PC kernel: [ 2341.280508] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:15:55 Arbeits-PC kernel: [ 2341.280516]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:15:57 Arbeits-PC kernel: [ 2343.281622] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:15:57 Arbeits-PC kernel: [ 2343.281739]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:16:01 Arbeits-PC kernel: [ 2347.283865] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:16:01 Arbeits-PC kernel: [ 2347.283872]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:16:03 Arbeits-PC kernel: [ 2349.284942] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:16:03 Arbeits-PC kernel: [ 2349.285068]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:16:12 Arbeits-PC kernel: [ 2357.643929] survey done event(15)
Sep  9 08:16:57 Arbeits-PC kernel: [ 2403.315603] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:16:57 Arbeits-PC kernel: [ 2403.315610]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:16:59 Arbeits-PC kernel: [ 2405.316727] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:16:59 Arbeits-PC kernel: [ 2405.316844]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:17:01 Arbeits-PC CRON[4339]: (root) CMD (   cd / &&
run-parts --report /etc/cron.hourly)
Sep  9 08:17:17 Arbeits-PC kernel: [ 2423.326937] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:17:17 Arbeits-PC kernel: [ 2423.326944]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:17:19 Arbeits-PC kernel: [ 2425.328213] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:17:19 Arbeits-PC kernel: [ 2425.328422]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:17:23 Arbeits-PC kernel: [ 2429.330446] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:17:23 Arbeits-PC kernel: [ 2429.330454]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:17:25 Arbeits-PC kernel: [ 2431.331517] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:17:25 Arbeits-PC kernel: [ 2431.331660]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:17:27 Arbeits-PC kernel: [ 2433.332682] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:17:27 Arbeits-PC kernel: [ 2433.332690]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:17:29 Arbeits-PC kernel: [ 2435.333783] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:17:29 Arbeits-PC kernel: [ 2435.333898]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:17:31 Arbeits-PC kernel: [ 2437.334893] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:17:31 Arbeits-PC kernel: [ 2437.334900]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:17:39 Arbeits-PC kernel: [ 2445.339528] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:17:39 Arbeits-PC kernel: [ 2445.339709]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:18:02 Arbeits-PC kernel: [ 2467.351923] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:18:02 Arbeits-PC kernel: [ 2467.351930]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:18:06 Arbeits-PC kernel: [ 2471.354162] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:18:06 Arbeits-PC kernel: [ 2471.354269]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:18:14 Arbeits-PC kernel: [ 2479.358767] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:18:14 Arbeits-PC kernel: [ 2479.358773]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:18:16 Arbeits-PC kernel: [ 2481.359766] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:18:16 Arbeits-PC kernel: [ 2481.359888]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:18:24 Arbeits-PC kernel: [ 2489.364368] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:18:24 Arbeits-PC kernel: [ 2489.364373]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:18:26 Arbeits-PC kernel: [ 2491.365484] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:18:26 Arbeits-PC kernel: [ 2491.365598]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:18:42 Arbeits-PC kernel: [ 2507.374649] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:18:42 Arbeits-PC kernel: [ 2507.374657]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:18:50 Arbeits-PC kernel: [ 2515.379041] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:18:50 Arbeits-PC kernel: [ 2515.379168]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:19:06 Arbeits-PC kernel: [ 2531.388187] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:19:06 Arbeits-PC kernel: [ 2531.388194]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:19:08 Arbeits-PC kernel: [ 2533.389268] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:19:08 Arbeits-PC kernel: [ 2533.389420]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:19:12 Arbeits-PC kernel: [ 2537.391689] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:19:12 Arbeits-PC kernel: [ 2537.391697]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:19:14 Arbeits-PC kernel: [ 2539.392779] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:19:14 Arbeits-PC kernel: [ 2539.392900]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:19:16 Arbeits-PC kernel: [ 2541.393927] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:19:16 Arbeits-PC kernel: [ 2541.393935]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:19:20 Arbeits-PC kernel: [ 2545.396105] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:19:20 Arbeits-PC kernel: [ 2545.396221]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:19:26 Arbeits-PC kernel: [ 2551.399495] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:19:26 Arbeits-PC kernel: [ 2551.399502]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:19:28 Arbeits-PC kernel: [ 2553.400604] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:19:28 Arbeits-PC kernel: [ 2553.400704]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:19:30 Arbeits-PC kernel: [ 2555.401876] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:19:30 Arbeits-PC kernel: [ 2555.401880]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:19:34 Arbeits-PC kernel: [ 2559.404138] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:19:34 Arbeits-PC kernel: [ 2559.404376]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:19:50 Arbeits-PC kernel: [ 2575.413175] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:19:50 Arbeits-PC kernel: [ 2575.413180]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:19:54 Arbeits-PC kernel: [ 2579.415464] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:19:54 Arbeits-PC kernel: [ 2579.415708]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:20:12 Arbeits-PC kernel: [ 2597.308523] survey done event(15)
Sep  9 08:20:16 Arbeits-PC kernel: [ 2601.427856] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:20:16 Arbeits-PC kernel: [ 2601.427864]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:20:18 Arbeits-PC kernel: [ 2603.428977] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:20:18 Arbeits-PC kernel: [ 2603.429085]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:20:36 Arbeits-PC kernel: [ 2621.439214] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:20:36 Arbeits-PC kernel: [ 2621.439222]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:20:38 Arbeits-PC kernel: [ 2623.440304] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:20:38 Arbeits-PC kernel: [ 2623.440413]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:20:42 Arbeits-PC kernel: [ 2627.442781] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:20:42 Arbeits-PC kernel: [ 2627.442788]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:20:44 Arbeits-PC kernel: [ 2629.443709] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:20:44 Arbeits-PC kernel: [ 2629.443941]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:20:58 Arbeits-PC kernel: [ 2643.451635] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:20:58 Arbeits-PC kernel: [ 2643.451641]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:21:00 Arbeits-PC kernel: [ 2645.452793] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:21:00 Arbeits-PC kernel: [ 2645.452906]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:21:02 Arbeits-PC kernel: [ 2647.454051] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:21:02 Arbeits-PC kernel: [ 2647.454059]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:21:04 Arbeits-PC kernel: [ 2649.455149] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:21:04 Arbeits-PC kernel: [ 2649.455266]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:21:06 Arbeits-PC kernel: [ 2651.456238] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:21:06 Arbeits-PC kernel: [ 2651.456245]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:21:08 Arbeits-PC kernel: [ 2653.457411] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:21:08 Arbeits-PC kernel: [ 2653.457594]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:21:16 Arbeits-PC kernel: [ 2661.461880] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:21:16 Arbeits-PC kernel: [ 2661.461887]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:21:18 Arbeits-PC kernel: [ 2663.462997] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:21:18 Arbeits-PC kernel: [ 2663.463111]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:21:22 Arbeits-PC kernel: [ 2667.465188] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:21:22 Arbeits-PC kernel: [ 2667.465195]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:21:24 Arbeits-PC kernel: [ 2669.466486] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:21:24 Arbeits-PC kernel: [ 2669.466595]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:21:26 Arbeits-PC kernel: [ 2671.467596] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:21:26 Arbeits-PC kernel: [ 2671.467604]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:21:28 Arbeits-PC kernel: [ 2673.468692] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:21:28 Arbeits-PC kernel: [ 2673.468808]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:21:30 Arbeits-PC kernel: [ 2675.469868] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:21:30 Arbeits-PC kernel: [ 2675.469875]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:21:34 Arbeits-PC kernel: [ 2679.472085] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:21:34 Arbeits-PC kernel: [ 2679.472198]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:21:36 Arbeits-PC kernel: [ 2681.473323] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:21:36 Arbeits-PC kernel: [ 2681.473329]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:21:38 Arbeits-PC kernel: [ 2683.474318] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:21:38 Arbeits-PC kernel: [ 2683.474447]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:21:44 Arbeits-PC kernel: [ 2689.477793] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:21:44 Arbeits-PC kernel: [ 2689.477800]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:21:46 Arbeits-PC kernel: [ 2691.478947] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:21:46 Arbeits-PC kernel: [ 2691.479192]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:21:48 Arbeits-PC kernel: [ 2693.480070] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:21:48 Arbeits-PC kernel: [ 2693.480077]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:21:54 Arbeits-PC kernel: [ 2699.483377] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:21:54 Arbeits-PC kernel: [ 2699.483494]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:22:00 Arbeits-PC kernel: [ 2705.486922] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:22:00 Arbeits-PC kernel: [ 2705.486929]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:22:08 Arbeits-PC kernel: [ 2713.491353] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:22:08 Arbeits-PC kernel: [ 2713.491464]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:22:12 Arbeits-PC kernel: [ 2717.128723] survey done event(12)
Sep  9 08:22:12 Arbeits-PC kernel: [ 2717.493596] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:22:12 Arbeits-PC kernel: [ 2717.493603]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:22:14 Arbeits-PC kernel: [ 2719.494690] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:22:14 Arbeits-PC kernel: [ 2719.494807]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:22:16 Arbeits-PC kernel: [ 2721.496007] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:22:16 Arbeits-PC kernel: [ 2721.496014]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:22:18 Arbeits-PC kernel: [ 2723.497107] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:22:18 Arbeits-PC kernel: [ 2723.497179]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:22:24 Arbeits-PC kernel: [ 2729.500469] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:22:24 Arbeits-PC kernel: [ 2729.500477]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:22:26 Arbeits-PC kernel: [ 2731.501598] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:22:26 Arbeits-PC kernel: [ 2731.501846]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:22:30 Arbeits-PC kernel: [ 2735.503824] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:22:30 Arbeits-PC kernel: [ 2735.503831]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:22:40 Arbeits-PC kernel: [ 2745.509580] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:22:40 Arbeits-PC kernel: [ 2745.509816]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:22:44 Arbeits-PC kernel: [ 2749.511762] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:22:44 Arbeits-PC kernel: [ 2749.511769]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:22:48 Arbeits-PC kernel: [ 2753.514025] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:22:48 Arbeits-PC kernel: [ 2753.514146]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:22:50 Arbeits-PC kernel: [ 2755.515157] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:22:50 Arbeits-PC kernel: [ 2755.515164]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:22:52 Arbeits-PC kernel: [ 2757.516275] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:22:52 Arbeits-PC kernel: [ 2757.516390]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:23:12 Arbeits-PC kernel: [ 2777.527693] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:23:12 Arbeits-PC kernel: [ 2777.527705]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:23:16 Arbeits-PC kernel: [ 2781.529959] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:23:16 Arbeits-PC kernel: [ 2781.530081]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:23:18 Arbeits-PC kernel: [ 2783.531106] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:23:18 Arbeits-PC kernel: [ 2783.531113]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:23:24 Arbeits-PC kernel: [ 2789.534448] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:23:24 Arbeits-PC kernel: [ 2789.534567]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:23:30 Arbeits-PC kernel: [ 2795.537805] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:23:30 Arbeits-PC kernel: [ 2795.537812]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:23:32 Arbeits-PC kernel: [ 2797.539077] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:23:32 Arbeits-PC kernel: [ 2797.539321]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:23:34 Arbeits-PC kernel: [ 2799.540204] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:23:34 Arbeits-PC kernel: [ 2799.540211]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:23:38 Arbeits-PC kernel: [ 2803.542410] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:23:38 Arbeits-PC kernel: [ 2803.542491]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:23:46 Arbeits-PC kernel: [ 2811.546905] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:23:46 Arbeits-PC kernel: [ 2811.546912]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:23:48 Arbeits-PC kernel: [ 2813.548000] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:23:48 Arbeits-PC kernel: [ 2813.548093]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:23:54 Arbeits-PC kernel: [ 2819.551466] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:23:54 Arbeits-PC kernel: [ 2819.551473]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:23:56 Arbeits-PC kernel: [ 2821.552617] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:23:56 Arbeits-PC kernel: [ 2821.552737]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:23:58 Arbeits-PC kernel: [ 2823.553737] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:23:58 Arbeits-PC kernel: [ 2823.553744]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:24:02 Arbeits-PC kernel: [ 2827.555987] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:24:02 Arbeits-PC kernel: [ 2827.556097]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:24:06 Arbeits-PC kernel: [ 2831.558617] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:24:06 Arbeits-PC kernel: [ 2831.558624]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:24:08 Arbeits-PC kernel: [ 2833.559464] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:24:08 Arbeits-PC kernel: [ 2833.559583]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:24:12 Arbeits-PC kernel: [ 2836.957286] survey done event(14)
Sep  9 08:24:16 Arbeits-PC kernel: [ 2841.563976] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:24:16 Arbeits-PC kernel: [ 2841.563983]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:24:18 Arbeits-PC kernel: [ 2843.565080] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:24:18 Arbeits-PC kernel: [ 2843.565336]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:24:20 Arbeits-PC kernel: [ 2845.566191] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:24:20 Arbeits-PC kernel: [ 2845.566198]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:24:24 Arbeits-PC kernel: [ 2849.568527] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:24:24 Arbeits-PC kernel: [ 2849.568637]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:24:30 Arbeits-PC kernel: [ 2855.571915] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:24:30 Arbeits-PC kernel: [ 2855.571922]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:24:42 Arbeits-PC kernel: [ 2867.578627] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:24:42 Arbeits-PC kernel: [ 2867.578727]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:24:46 Arbeits-PC kernel: [ 2871.581038] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:24:46 Arbeits-PC kernel: [ 2871.581046]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:24:48 Arbeits-PC kernel: [ 2873.582148] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:24:48 Arbeits-PC kernel: [ 2873.582391]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:24:50 Arbeits-PC kernel: [ 2875.583213] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:24:50 Arbeits-PC kernel: [ 2875.583221]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:24:56 Arbeits-PC kernel: [ 2881.586568] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:24:56 Arbeits-PC kernel: [ 2881.586673]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:25:00 Arbeits-PC kernel: [ 2885.588862] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:25:00 Arbeits-PC kernel: [ 2885.588869]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:25:08 Arbeits-PC kernel: [ 2893.593418] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:25:08 Arbeits-PC kernel: [ 2893.593536]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:25:12 Arbeits-PC kernel: [ 2897.595714] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:25:12 Arbeits-PC kernel: [ 2897.595721]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:25:42 Arbeits-PC kernel: [ 2927.612773] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:25:42 Arbeits-PC kernel: [ 2927.613009]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:25:44 Arbeits-PC kernel: [ 2929.613841] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:25:44 Arbeits-PC kernel: [ 2929.613847]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:25:48 Arbeits-PC kernel: [ 2933.616108] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:25:48 Arbeits-PC kernel: [ 2933.616204]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:25:50 Arbeits-PC kernel: [ 2935.617234] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:25:50 Arbeits-PC kernel: [ 2935.617240]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:25:54 Arbeits-PC kernel: [ 2939.619468] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:25:54 Arbeits-PC kernel: [ 2939.619589]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:26:00 Arbeits-PC kernel: [ 2945.622978] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:26:00 Arbeits-PC kernel: [ 2945.622985]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:26:10 Arbeits-PC kernel: [ 2955.430715] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:26:10 Arbeits-PC kernel: [ 2955.430969]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:26:12 Arbeits-PC kernel: [ 2956.797580] survey done event(17)
Sep  9 08:26:15 Arbeits-PC kernel: [ 2959.630804] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:26:15 Arbeits-PC kernel: [ 2959.630810]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:26:17 Arbeits-PC kernel: [ 2961.631928] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:26:17 Arbeits-PC kernel: [ 2961.632040]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:26:23 Arbeits-PC kernel: [ 2967.635368] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:26:23 Arbeits-PC kernel: [ 2967.635382]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:26:25 Arbeits-PC kernel: [ 2969.636528] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:26:25 Arbeits-PC kernel: [ 2969.636601]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:26:29 Arbeits-PC kernel: [ 2973.638732] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:26:29 Arbeits-PC kernel: [ 2973.638746]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:26:31 Arbeits-PC kernel: [ 2975.639879] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:26:31 Arbeits-PC kernel: [ 2975.639999]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:26:33 Arbeits-PC kernel: [ 2977.640999] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:26:33 Arbeits-PC kernel: [ 2977.641005]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:26:34 Arbeits-PC kernel: [ 2978.778086] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:26:34 Arbeits-PC kernel: [ 2978.778244]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:26:37 Arbeits-PC kernel: [ 2981.643246] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:26:37 Arbeits-PC kernel: [ 2981.643253]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:26:39 Arbeits-PC kernel: [ 2983.644458] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:26:39 Arbeits-PC kernel: [ 2983.644580]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:26:43 Arbeits-PC kernel: [ 2987.646729] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:26:43 Arbeits-PC kernel: [ 2987.646736]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:26:45 Arbeits-PC kernel: [ 2989.647855] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:26:45 Arbeits-PC kernel: [ 2989.647945]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:26:51 Arbeits-PC kernel: [ 2995.651211] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:26:51 Arbeits-PC kernel: [ 2995.651218]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:26:53 Arbeits-PC kernel: [ 2997.652341] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:26:53 Arbeits-PC kernel: [ 2997.652454]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:26:59 Arbeits-PC kernel: [ 3003.655830] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:26:59 Arbeits-PC kernel: [ 3003.655836]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:27:01 Arbeits-PC kernel: [ 3005.656935] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:27:01 Arbeits-PC kernel: [ 3005.657064]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:27:03 Arbeits-PC kernel: [ 3007.658067] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:27:03 Arbeits-PC kernel: [ 3007.658074]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:27:25 Arbeits-PC kernel: [ 3029.670512] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:27:25 Arbeits-PC kernel: [ 3029.670625]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:27:35 Arbeits-PC kernel: [ 3039.676255] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:27:35 Arbeits-PC kernel: [ 3039.676262]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:27:39 Arbeits-PC kernel: [ 3043.678441] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:27:39 Arbeits-PC kernel: [ 3043.678593]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:27:41 Arbeits-PC kernel: [ 3045.679612] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:27:41 Arbeits-PC kernel: [ 3045.679619]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:27:45 Arbeits-PC kernel: [ 3049.681838] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:27:45 Arbeits-PC kernel: [ 3049.681954]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:27:47 Arbeits-PC kernel: [ 3051.682921] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:27:47 Arbeits-PC kernel: [ 3051.682928]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:27:49 Arbeits-PC kernel: [ 3053.684048] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:27:49 Arbeits-PC kernel: [ 3053.684151]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:27:51 Arbeits-PC kernel: [ 3055.685342] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:27:51 Arbeits-PC kernel: [ 3055.685350]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:27:59 Arbeits-PC kernel: [ 3063.689798] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:27:59 Arbeits-PC kernel: [ 3063.689926]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:28:03 Arbeits-PC kernel: [ 3067.692045] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:28:03 Arbeits-PC kernel: [ 3067.692052]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:28:09 Arbeits-PC kernel: [ 3073.695408] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:28:09 Arbeits-PC kernel: [ 3073.695522]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:28:12 Arbeits-PC kernel: [ 3076.618073] survey done event(11)
Sep  9 08:28:13 Arbeits-PC kernel: [ 3077.697795] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:28:13 Arbeits-PC kernel: [ 3077.697801]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:28:17 Arbeits-PC kernel: [ 3081.700035] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:28:17 Arbeits-PC kernel: [ 3081.700277]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:28:21 Arbeits-PC kernel: [ 3085.702253] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:28:21 Arbeits-PC kernel: [ 3085.702261]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:28:29 Arbeits-PC kernel: [ 3093.706811] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:28:29 Arbeits-PC kernel: [ 3093.706915]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:28:31 Arbeits-PC kernel: [ 3095.707988] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:28:31 Arbeits-PC kernel: [ 3095.707995]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:28:37 Arbeits-PC kernel: [ 3101.711357] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:28:37 Arbeits-PC kernel: [ 3101.711576]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:28:41 Arbeits-PC kernel: [ 3105.713576] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:28:41 Arbeits-PC kernel: [ 3105.713584]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:28:49 Arbeits-PC kernel: [ 3113.718152] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:28:49 Arbeits-PC kernel: [ 3113.718269]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:28:51 Arbeits-PC kernel: [ 3115.719195] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:28:51 Arbeits-PC kernel: [ 3115.719202]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:28:59 Arbeits-PC kernel: [ 3123.723800] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:28:59 Arbeits-PC kernel: [ 3123.724052]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:29:01 Arbeits-PC kernel: [ 3125.724905] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:29:01 Arbeits-PC kernel: [ 3125.724913]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:29:11 Arbeits-PC kernel: [ 3135.730651] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:29:11 Arbeits-PC kernel: [ 3135.730899]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:29:15 Arbeits-PC kernel: [ 3139.732840] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:29:15 Arbeits-PC kernel: [ 3139.732847]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:29:37 Arbeits-PC kernel: [ 3161.745292] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:29:37 Arbeits-PC kernel: [ 3161.745412]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:29:41 Arbeits-PC kernel: [ 3165.747568] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:29:41 Arbeits-PC kernel: [ 3165.747575]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:29:43 Arbeits-PC kernel: [ 3167.748774] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:29:43 Arbeits-PC kernel: [ 3167.748881]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:29:45 Arbeits-PC kernel: [ 3169.749921] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:29:45 Arbeits-PC kernel: [ 3169.749928]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:29:49 Arbeits-PC kernel: [ 3173.752191] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:29:49 Arbeits-PC kernel: [ 3173.752409]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:29:51 Arbeits-PC kernel: [ 3175.753285] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:29:51 Arbeits-PC kernel: [ 3175.753292]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:29:59 Arbeits-PC kernel: [ 3183.757778] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:29:59 Arbeits-PC kernel: [ 3183.757890]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:30:03 Arbeits-PC kernel: [ 3187.760139] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:30:03 Arbeits-PC kernel: [ 3187.760146]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:30:10 Arbeits-PC kernel: [ 3195.087347] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:30:10 Arbeits-PC kernel: [ 3195.087559]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:30:12 Arbeits-PC kernel: [ 3196.454205] survey done event(12)
Sep  9 08:30:13 Arbeits-PC kernel: [ 3197.765742] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:30:13 Arbeits-PC kernel: [ 3197.765749]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:30:15 Arbeits-PC kernel: [ 3199.766863] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:30:15 Arbeits-PC kernel: [ 3199.766976]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:30:17 Arbeits-PC kernel: [ 3201.767976] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:30:17 Arbeits-PC kernel: [ 3201.767983]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:30:19 Arbeits-PC kernel: [ 3203.769095] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:30:19 Arbeits-PC kernel: [ 3203.769224]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:30:21 Arbeits-PC kernel: [ 3205.770223] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:30:21 Arbeits-PC kernel: [ 3205.770230]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:30:23 Arbeits-PC kernel: [ 3207.771487] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:30:23 Arbeits-PC kernel: [ 3207.771731]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:30:25 Arbeits-PC kernel: [ 3209.772604] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:30:25 Arbeits-PC kernel: [ 3209.772611]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:30:27 Arbeits-PC kernel: [ 3211.773695] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:30:27 Arbeits-PC kernel: [ 3211.773788]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:30:31 Arbeits-PC kernel: [ 3215.775945] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:30:31 Arbeits-PC kernel: [ 3215.775952]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:30:39 Arbeits-PC kernel: [ 3223.780518] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:30:39 Arbeits-PC kernel: [ 3223.780635]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:30:41 Arbeits-PC kernel: [ 3225.781636] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:30:41 Arbeits-PC kernel: [ 3225.781643]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:30:43 Arbeits-PC kernel: [ 3227.782730] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:30:43 Arbeits-PC kernel: [ 3227.782850]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:31:25 Arbeits-PC kernel: [ 3269.806593] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:31:25 Arbeits-PC kernel: [ 3269.806600]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:31:27 Arbeits-PC kernel: [ 3271.807685] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:31:27 Arbeits-PC kernel: [ 3271.807812]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:32:12 Arbeits-PC kernel: [ 3316.270660] survey done event(12)
Sep  9 08:33:17 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 192.168.1.1 port 67 (xid=0x45412da)
Sep  9 08:33:17 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 08:33:17 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 2707 seconds.
Sep  9 08:33:17 Arbeits-PC NetworkManager[1007]: <info> (wlan0):
DHCPv4 state changed bound -> renew
Sep  9 08:33:17 Arbeits-PC NetworkManager[1007]: <info>   address 192.168.1.103
Sep  9 08:33:17 Arbeits-PC NetworkManager[1007]: <info>   prefix 24
(255.255.255.0)
Sep  9 08:33:17 Arbeits-PC NetworkManager[1007]: <info>   gateway 192.168.1.1
Sep  9 08:33:17 Arbeits-PC NetworkManager[1007]: <info>   nameserver
'192.168.1.1'
Sep  9 08:33:17 Arbeits-PC dbus[910]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 08:33:17 Arbeits-PC dbus[910]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 08:33:33 Arbeits-PC kernel: [ 3397.879173] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:33:33 Arbeits-PC kernel: [ 3397.879181]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:33:35 Arbeits-PC kernel: [ 3399.880283] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:33:35 Arbeits-PC kernel: [ 3399.880527]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:33:37 Arbeits-PC kernel: [ 3401.881401] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:33:37 Arbeits-PC kernel: [ 3401.881407]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:33:39 Arbeits-PC kernel: [ 3403.882499] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:33:39 Arbeits-PC kernel: [ 3403.882617]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:34:03 Arbeits-PC kernel: [ 3427.896465] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:34:03 Arbeits-PC kernel: [ 3427.896472]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:34:07 Arbeits-PC kernel: [ 3431.898438] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:34:07 Arbeits-PC kernel: [ 3431.898554]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:34:09 Arbeits-PC kernel: [ 3433.899524] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:34:09 Arbeits-PC kernel: [ 3433.899532]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:34:10 Arbeits-PC kernel: [ 3434.742952] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:34:10 Arbeits-PC kernel: [ 3434.743038]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:34:12 Arbeits-PC kernel: [ 3436.110953] survey done event(13)
Sep  9 08:34:17 Arbeits-PC kernel: [ 3441.904008] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:34:17 Arbeits-PC kernel: [ 3441.904014]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:34:19 Arbeits-PC kernel: [ 3443.905153] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:34:19 Arbeits-PC kernel: [ 3443.905279]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:34:25 Arbeits-PC kernel: [ 3449.908647] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:34:25 Arbeits-PC kernel: [ 3449.908655]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:34:30 Arbeits-PC kernel: [ 3453.910851] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:34:30 Arbeits-PC kernel: [ 3453.910954]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:34:34 Arbeits-PC kernel: [ 3457.913147] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:34:34 Arbeits-PC kernel: [ 3457.913151]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:34:38 Arbeits-PC kernel: [ 3461.915371] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:34:38 Arbeits-PC kernel: [ 3461.915481]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:34:40 Arbeits-PC kernel: [ 3463.916490] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:34:40 Arbeits-PC kernel: [ 3463.916498]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:34:42 Arbeits-PC kernel: [ 3465.917571] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:34:42 Arbeits-PC kernel: [ 3465.917721]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:34:44 Arbeits-PC kernel: [ 3467.918859] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:34:44 Arbeits-PC kernel: [ 3467.918867]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:34:48 Arbeits-PC kernel: [ 3471.921032] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:34:48 Arbeits-PC kernel: [ 3471.921214]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:34:54 Arbeits-PC kernel: [ 3477.924448] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:34:54 Arbeits-PC kernel: [ 3477.924455]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:34:58 Arbeits-PC kernel: [ 3481.926694] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:34:58 Arbeits-PC kernel: [ 3481.926812]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:35:04 Arbeits-PC kernel: [ 3487.930201] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:35:04 Arbeits-PC kernel: [ 3487.930207]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:35:12 Arbeits-PC kernel: [ 3495.934656] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:35:12 Arbeits-PC kernel: [ 3495.934785]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:35:14 Arbeits-PC kernel: [ 3497.935781] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:35:14 Arbeits-PC kernel: [ 3497.935785]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:35:16 Arbeits-PC kernel: [ 3499.936857] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:35:16 Arbeits-PC kernel: [ 3499.936979]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:35:36 Arbeits-PC kernel: [ 3519.948237] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:35:36 Arbeits-PC kernel: [ 3519.948244]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:35:38 Arbeits-PC kernel: [ 3521.949493] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:35:38 Arbeits-PC kernel: [ 3521.949741]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:35:46 Arbeits-PC kernel: [ 3529.953972] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:35:46 Arbeits-PC kernel: [ 3529.953978]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:35:50 Arbeits-PC kernel: [ 3533.956180] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:35:50 Arbeits-PC kernel: [ 3533.956315]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:35:52 Arbeits-PC kernel: [ 3535.957316] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:35:52 Arbeits-PC kernel: [ 3535.957323]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:36:00 Arbeits-PC kernel: [ 3543.961928] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:36:00 Arbeits-PC kernel: [ 3543.962000]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:36:02 Arbeits-PC kernel: [ 3545.963053] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:36:02 Arbeits-PC kernel: [ 3545.963059]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:36:04 Arbeits-PC kernel: [ 3547.964183] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:36:04 Arbeits-PC kernel: [ 3547.964429]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:36:08 Arbeits-PC kernel: [ 3551.966414] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:36:08 Arbeits-PC kernel: [ 3551.966421]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:36:10 Arbeits-PC kernel: [ 3553.967515] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:36:10 Arbeits-PC kernel: [ 3553.967636]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:38:12 Arbeits-PC kernel: [ 3675.755847] survey done event(13)
Sep  9 08:39:32 Arbeits-PC kernel: [ 3756.082047] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:39:32 Arbeits-PC kernel: [ 3756.082054]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:39:34 Arbeits-PC kernel: [ 3758.083135] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:39:34 Arbeits-PC kernel: [ 3758.083254]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:39:36 Arbeits-PC kernel: [ 3760.084259] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:39:36 Arbeits-PC kernel: [ 3760.084266]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:39:40 Arbeits-PC kernel: [ 3764.086507] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:39:40 Arbeits-PC kernel: [ 3764.086608]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:39:46 Arbeits-PC kernel: [ 3770.090011] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:39:46 Arbeits-PC kernel: [ 3770.090017]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:39:50 Arbeits-PC kernel: [ 3774.092287] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:39:50 Arbeits-PC kernel: [ 3774.092524]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:40:22 Arbeits-PC kernel: [ 3806.110425] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:40:22 Arbeits-PC kernel: [ 3806.110432]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:40:24 Arbeits-PC kernel: [ 3808.111551] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:40:24 Arbeits-PC kernel: [ 3808.111666]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:41:04 Arbeits-PC kernel: [ 3848.134119] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:41:04 Arbeits-PC kernel: [ 3848.134125]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:41:06 Arbeits-PC kernel: [ 3850.135321] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:41:06 Arbeits-PC kernel: [ 3850.135442]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:41:12 Arbeits-PC kernel: [ 3856.138674] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:41:12 Arbeits-PC kernel: [ 3856.138682]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:41:14 Arbeits-PC kernel: [ 3858.139812] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:41:14 Arbeits-PC kernel: [ 3858.139902]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:41:18 Arbeits-PC kernel: [ 3862.142191] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:41:18 Arbeits-PC kernel: [ 3862.142196]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:41:20 Arbeits-PC kernel: [ 3864.143303] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:41:20 Arbeits-PC kernel: [ 3864.143372]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:41:32 Arbeits-PC kernel: [ 3876.150147] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:41:32 Arbeits-PC kernel: [ 3876.150155]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:41:34 Arbeits-PC kernel: [ 3878.151223] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:41:34 Arbeits-PC kernel: [ 3878.151340]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:41:54 Arbeits-PC kernel: [ 3898.162616] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:41:54 Arbeits-PC kernel: [ 3898.162623]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:41:56 Arbeits-PC kernel: [ 3900.163731] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:41:56 Arbeits-PC kernel: [ 3900.163977]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:42:12 Arbeits-PC kernel: [ 3915.416453] survey done event(12)
Sep  9 08:42:40 Arbeits-PC kernel: [ 3944.188606] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:42:40 Arbeits-PC kernel: [ 3944.188613]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:42:42 Arbeits-PC kernel: [ 3946.189694] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:42:42 Arbeits-PC kernel: [ 3946.189801]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:42:53 Arbeits-PC kernel: [ 3956.195448] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:42:53 Arbeits-PC kernel: [ 3956.195456]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:42:55 Arbeits-PC kernel: [ 3958.196574] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:42:55 Arbeits-PC kernel: [ 3958.196689]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:43:21 Arbeits-PC kernel: [ 3984.211267] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:43:21 Arbeits-PC kernel: [ 3984.211275]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:43:23 Arbeits-PC kernel: [ 3986.212528] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:43:23 Arbeits-PC kernel: [ 3986.212776]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:43:53 Arbeits-PC kernel: [ 4016.229436] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:43:53 Arbeits-PC kernel: [ 4016.229442]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:43:57 Arbeits-PC kernel: [ 4020.231697] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:43:57 Arbeits-PC kernel: [ 4020.231918]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:44:01 Arbeits-PC kernel: [ 4024.234065] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:44:01 Arbeits-PC kernel: [ 4024.234072]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:44:09 Arbeits-PC kernel: [ 4032.239043] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:44:09 Arbeits-PC kernel: [ 4032.239290]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:44:12 Arbeits-PC kernel: [ 4035.240789] survey done event(14)
Sep  9 08:44:25 Arbeits-PC kernel: [ 4048.247578] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:44:25 Arbeits-PC kernel: [ 4048.247584]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:44:27 Arbeits-PC kernel: [ 4050.248736] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:44:27 Arbeits-PC kernel: [ 4050.248848]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:44:31 Arbeits-PC kernel: [ 4054.250973] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:44:31 Arbeits-PC kernel: [ 4054.250979]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:44:35 Arbeits-PC kernel: [ 4058.253208] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:44:35 Arbeits-PC kernel: [ 4058.253328]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:44:37 Arbeits-PC kernel: [ 4060.254480] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:44:37 Arbeits-PC kernel: [ 4060.254487]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:44:43 Arbeits-PC kernel: [ 4066.257843] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:44:43 Arbeits-PC kernel: [ 4066.258086]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:44:51 Arbeits-PC kernel: [ 4074.262305] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:44:51 Arbeits-PC kernel: [ 4074.262312]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:44:53 Arbeits-PC kernel: [ 4076.263422] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:44:53 Arbeits-PC kernel: [ 4076.263553]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:44:55 Arbeits-PC kernel: [ 4078.264533] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:44:55 Arbeits-PC kernel: [ 4078.264540]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:44:59 Arbeits-PC kernel: [ 4082.266928] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:44:59 Arbeits-PC kernel: [ 4082.267172]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:45:01 Arbeits-PC kernel: [ 4084.268048] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:45:01 Arbeits-PC kernel: [ 4084.268055]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:45:03 Arbeits-PC kernel: [ 4086.269247] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:45:03 Arbeits-PC kernel: [ 4086.269393]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:45:23 Arbeits-PC kernel: [ 4106.280492] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:45:23 Arbeits-PC kernel: [ 4106.280499]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:45:26 Arbeits-PC kernel: [ 4108.985651] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:45:26 Arbeits-PC kernel: [ 4108.985833]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:45:31 Arbeits-PC kernel: [ 4114.284959] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:45:31 Arbeits-PC kernel: [ 4114.284965]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:45:37 Arbeits-PC kernel: [ 4120.288458] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:45:37 Arbeits-PC kernel: [ 4120.288708]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:45:41 Arbeits-PC kernel: [ 4124.290703] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:45:41 Arbeits-PC kernel: [ 4124.290709]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:45:45 Arbeits-PC kernel: [ 4128.292934] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:45:45 Arbeits-PC kernel: [ 4128.293191]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:45:47 Arbeits-PC kernel: [ 4130.294038] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:45:47 Arbeits-PC kernel: [ 4130.294045]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:45:49 Arbeits-PC kernel: [ 4132.295163] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:45:49 Arbeits-PC kernel: [ 4132.295282]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:45:51 Arbeits-PC kernel: [ 4134.296430] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:45:51 Arbeits-PC kernel: [ 4134.296436]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:45:53 Arbeits-PC kernel: [ 4136.297550] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:45:53 Arbeits-PC kernel: [ 4136.297796]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:45:55 Arbeits-PC kernel: [ 4138.298671] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:45:55 Arbeits-PC kernel: [ 4138.298678]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:45:57 Arbeits-PC kernel: [ 4140.299789] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:45:57 Arbeits-PC kernel: [ 4140.300034]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:46:01 Arbeits-PC kernel: [ 4144.302031] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:46:01 Arbeits-PC kernel: [ 4144.302037]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:46:03 Arbeits-PC kernel: [ 4146.303154] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:46:03 Arbeits-PC kernel: [ 4146.303397]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:46:05 Arbeits-PC kernel: [ 4148.304251] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:46:05 Arbeits-PC kernel: [ 4148.304257]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:46:10 Arbeits-PC kernel: [ 4153.713798] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:46:10 Arbeits-PC kernel: [ 4153.713923]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:46:12 Arbeits-PC kernel: [ 4155.081078] survey done event(16)
Sep  9 08:46:13 Arbeits-PC kernel: [ 4156.308865] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:46:13 Arbeits-PC kernel: [ 4156.308871]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:46:19 Arbeits-PC kernel: [ 4162.312237] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:46:19 Arbeits-PC kernel: [ 4162.312485]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:46:21 Arbeits-PC kernel: [ 4164.313338] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:46:21 Arbeits-PC kernel: [ 4164.313345]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:46:29 Arbeits-PC kernel: [ 4172.317910] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:46:29 Arbeits-PC kernel: [ 4172.318023]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:46:31 Arbeits-PC kernel: [ 4174.319085] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:46:31 Arbeits-PC kernel: [ 4174.319091]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:46:39 Arbeits-PC kernel: [ 4182.323546] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:46:39 Arbeits-PC kernel: [ 4182.323664]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:46:41 Arbeits-PC kernel: [ 4184.324657] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:46:41 Arbeits-PC kernel: [ 4184.324664]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:46:43 Arbeits-PC kernel: [ 4186.325789] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:46:43 Arbeits-PC kernel: [ 4186.325906]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:46:47 Arbeits-PC kernel: [ 4190.327996] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:46:47 Arbeits-PC kernel: [ 4190.328002]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:46:49 Arbeits-PC kernel: [ 4192.329293] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:46:49 Arbeits-PC kernel: [ 4192.329515]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:46:51 Arbeits-PC kernel: [ 4194.330410] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:46:51 Arbeits-PC kernel: [ 4194.330417]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:46:57 Arbeits-PC kernel: [ 4200.333736] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:46:57 Arbeits-PC kernel: [ 4200.333843]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:47:01 Arbeits-PC kernel: [ 4204.335992] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:47:01 Arbeits-PC kernel: [ 4204.335999]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:47:07 Arbeits-PC kernel: [ 4210.339474] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:47:07 Arbeits-PC kernel: [ 4210.339608]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:47:11 Arbeits-PC kernel: [ 4214.341738] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:47:11 Arbeits-PC kernel: [ 4214.341744]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:47:19 Arbeits-PC kernel: [ 4222.346196] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:47:19 Arbeits-PC kernel: [ 4222.346317]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:47:21 Arbeits-PC kernel: [ 4224.347320] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:47:21 Arbeits-PC kernel: [ 4224.347327]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:47:27 Arbeits-PC kernel: [ 4230.350808] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:47:27 Arbeits-PC kernel: [ 4230.350926]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:47:33 Arbeits-PC kernel: [ 4236.354191] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:47:33 Arbeits-PC kernel: [ 4236.354197]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:47:35 Arbeits-PC kernel: [ 4238.355288] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:47:35 Arbeits-PC kernel: [ 4238.355404]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:47:41 Arbeits-PC kernel: [ 4244.358655] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:47:41 Arbeits-PC kernel: [ 4244.358661]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:47:43 Arbeits-PC kernel: [ 4246.360165] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:47:43 Arbeits-PC kernel: [ 4246.360411]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:47:51 Arbeits-PC kernel: [ 4254.364397] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:47:51 Arbeits-PC kernel: [ 4254.364404]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:47:59 Arbeits-PC kernel: [ 4262.368859] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:47:59 Arbeits-PC kernel: [ 4262.368977]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:48:01 Arbeits-PC kernel: [ 4264.369982] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:48:01 Arbeits-PC kernel: [ 4264.369988]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:48:09 Arbeits-PC kernel: [ 4272.374604] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:48:09 Arbeits-PC kernel: [ 4272.374824]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:48:12 Arbeits-PC kernel: [ 4274.897661] survey done event(12)
Sep  9 08:48:27 Arbeits-PC kernel: [ 4290.384791] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:48:27 Arbeits-PC kernel: [ 4290.384796]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:48:29 Arbeits-PC kernel: [ 4292.385940] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:48:29 Arbeits-PC kernel: [ 4292.386165]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:48:31 Arbeits-PC kernel: [ 4294.387054] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:48:31 Arbeits-PC kernel: [ 4294.387061]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:48:35 Arbeits-PC kernel: [ 4298.389246] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:48:35 Arbeits-PC kernel: [ 4298.389396]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:48:37 Arbeits-PC kernel: [ 4300.390487] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:48:37 Arbeits-PC kernel: [ 4300.390494]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:48:39 Arbeits-PC kernel: [ 4302.391633] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:48:39 Arbeits-PC kernel: [ 4302.391761]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:48:41 Arbeits-PC kernel: [ 4304.392661] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:48:41 Arbeits-PC kernel: [ 4304.392668]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:48:45 Arbeits-PC kernel: [ 4308.394952] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:48:45 Arbeits-PC kernel: [ 4308.395068]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:48:49 Arbeits-PC kernel: [ 4312.397268] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:48:49 Arbeits-PC kernel: [ 4312.397275]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:48:51 Arbeits-PC kernel: [ 4314.398332] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:48:51 Arbeits-PC kernel: [ 4314.398481]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:48:55 Arbeits-PC kernel: [ 4318.400600] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:48:55 Arbeits-PC kernel: [ 4318.400607]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:48:57 Arbeits-PC kernel: [ 4320.401719] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:48:57 Arbeits-PC kernel: [ 4320.401848]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:49:03 Arbeits-PC kernel: [ 4326.405228] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:49:03 Arbeits-PC kernel: [ 4326.405235]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:49:09 Arbeits-PC kernel: [ 4332.408589] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:49:09 Arbeits-PC kernel: [ 4332.408814]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:49:11 Arbeits-PC kernel: [ 4334.409691] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:49:11 Arbeits-PC kernel: [ 4334.409698]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:49:15 Arbeits-PC kernel: [ 4338.411936] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:49:15 Arbeits-PC kernel: [ 4338.412048]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:49:17 Arbeits-PC kernel: [ 4340.413194] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:49:17 Arbeits-PC kernel: [ 4340.413201]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:49:19 Arbeits-PC kernel: [ 4342.414330] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:49:19 Arbeits-PC kernel: [ 4342.414564]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:49:21 Arbeits-PC kernel: [ 4344.415409] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:49:21 Arbeits-PC kernel: [ 4344.415415]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:49:29 Arbeits-PC kernel: [ 4352.419863] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:49:29 Arbeits-PC kernel: [ 4352.419981]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:49:31 Arbeits-PC kernel: [ 4354.421014] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:49:31 Arbeits-PC kernel: [ 4354.421021]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:49:39 Arbeits-PC kernel: [ 4362.425648] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:49:39 Arbeits-PC kernel: [ 4362.425886]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:49:41 Arbeits-PC kernel: [ 4364.426763] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:49:41 Arbeits-PC kernel: [ 4364.426770]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:49:49 Arbeits-PC kernel: [ 4372.431215] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:49:49 Arbeits-PC kernel: [ 4372.431313]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:49:51 Arbeits-PC kernel: [ 4374.432349] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:49:51 Arbeits-PC kernel: [ 4374.432356]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:49:59 Arbeits-PC kernel: [ 4382.436971] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:49:59 Arbeits-PC kernel: [ 4382.437220]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:50:01 Arbeits-PC kernel: [ 4384.438095] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:50:01 Arbeits-PC kernel: [ 4384.438101]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:50:03 Arbeits-PC kernel: [ 4386.439156] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:50:03 Arbeits-PC kernel: [ 4386.439267]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:50:05 Arbeits-PC kernel: [ 4388.440310] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:50:05 Arbeits-PC kernel: [ 4388.440317]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:50:09 Arbeits-PC kernel: [ 4392.442518] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:50:09 Arbeits-PC kernel: [ 4392.442678]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:50:12 Arbeits-PC kernel: [ 4394.729844] survey done event(12)
Sep  9 08:50:13 Arbeits-PC kernel: [ 4396.444936] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:50:13 Arbeits-PC kernel: [ 4396.444943]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:50:19 Arbeits-PC kernel: [ 4402.448301] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:50:19 Arbeits-PC kernel: [ 4402.448545]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:50:21 Arbeits-PC kernel: [ 4404.449416] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:50:21 Arbeits-PC kernel: [ 4404.449423]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:50:39 Arbeits-PC kernel: [ 4422.459602] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:50:39 Arbeits-PC kernel: [ 4422.459721]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:50:41 Arbeits-PC kernel: [ 4424.460735] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:50:41 Arbeits-PC kernel: [ 4424.460742]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:51:30 Arbeits-PC kernel: [ 4472.488010] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:51:30 Arbeits-PC kernel: [ 4472.488257]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:51:32 Arbeits-PC kernel: [ 4474.489129] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:51:32 Arbeits-PC kernel: [ 4474.489136]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:52:04 Arbeits-PC kernel: [ 4506.507157] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:52:04 Arbeits-PC kernel: [ 4506.507285]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:52:06 Arbeits-PC kernel: [ 4508.508243] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:52:06 Arbeits-PC kernel: [ 4508.508250]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:52:10 Arbeits-PC kernel: [ 4512.510596] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:52:10 Arbeits-PC kernel: [ 4512.510716]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:52:18 Arbeits-PC kernel: [ 4520.515093] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:52:18 Arbeits-PC kernel: [ 4520.515099]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:52:20 Arbeits-PC kernel: [ 4522.516192] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:52:20 Arbeits-PC kernel: [ 4522.516335]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:52:24 Arbeits-PC kernel: [ 4526.518584] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:52:24 Arbeits-PC kernel: [ 4526.518590]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:52:30 Arbeits-PC kernel: [ 4532.521993] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:52:30 Arbeits-PC kernel: [ 4532.522241]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:52:36 Arbeits-PC kernel: [ 4538.525334] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:52:36 Arbeits-PC kernel: [ 4538.525340]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:52:40 Arbeits-PC kernel: [ 4542.527585] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:52:40 Arbeits-PC kernel: [ 4542.527841]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:52:42 Arbeits-PC kernel: [ 4544.528821] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:52:42 Arbeits-PC kernel: [ 4544.528828]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:52:50 Arbeits-PC kernel: [ 4552.533320] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:52:50 Arbeits-PC kernel: [ 4552.533569]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:52:52 Arbeits-PC kernel: [ 4554.534414] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:52:52 Arbeits-PC kernel: [ 4554.534421]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:52:56 Arbeits-PC kernel: [ 4558.536655] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:52:56 Arbeits-PC kernel: [ 4558.536776]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:53:02 Arbeits-PC kernel: [ 4564.540149] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:53:02 Arbeits-PC kernel: [ 4564.540156]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:53:06 Arbeits-PC kernel: [ 4568.542353] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:53:06 Arbeits-PC kernel: [ 4568.542473]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:53:08 Arbeits-PC kernel: [ 4570.543529] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:53:08 Arbeits-PC kernel: [ 4570.543535]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:53:10 Arbeits-PC kernel: [ 4572.544629] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:53:10 Arbeits-PC kernel: [ 4572.544747]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:53:12 Arbeits-PC kernel: [ 4574.545747] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:53:12 Arbeits-PC kernel: [ 4574.545754]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:53:16 Arbeits-PC kernel: [ 4578.547984] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:53:16 Arbeits-PC kernel: [ 4578.548119]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:53:18 Arbeits-PC kernel: [ 4580.549253] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:53:18 Arbeits-PC kernel: [ 4580.549259]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:53:20 Arbeits-PC kernel: [ 4582.550377] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:53:20 Arbeits-PC kernel: [ 4582.550619]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:53:22 Arbeits-PC kernel: [ 4584.551445] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:53:22 Arbeits-PC kernel: [ 4584.551451]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:53:40 Arbeits-PC kernel: [ 4602.561566] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:53:40 Arbeits-PC kernel: [ 4602.561681]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:53:46 Arbeits-PC kernel: [ 4608.565066] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:53:46 Arbeits-PC kernel: [ 4608.565073]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:53:50 Arbeits-PC kernel: [ 4612.567285] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:53:50 Arbeits-PC kernel: [ 4612.567403]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:53:52 Arbeits-PC kernel: [ 4614.568398] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:53:52 Arbeits-PC kernel: [ 4614.568404]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:54:00 Arbeits-PC kernel: [ 4622.573006] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:54:00 Arbeits-PC kernel: [ 4622.573126]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:54:02 Arbeits-PC kernel: [ 4624.574149] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:54:02 Arbeits-PC kernel: [ 4624.574155]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:54:10 Arbeits-PC kernel: [ 4633.026589] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:54:10 Arbeits-PC kernel: [ 4633.026892]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:54:12 Arbeits-PC kernel: [ 4634.394578] survey done event(13)
Sep  9 08:54:14 Arbeits-PC kernel: [ 4636.580999] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:54:14 Arbeits-PC kernel: [ 4636.581005]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:54:16 Arbeits-PC kernel: [ 4638.582104] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:54:16 Arbeits-PC kernel: [ 4638.582216]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:54:18 Arbeits-PC kernel: [ 4640.583239] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:54:18 Arbeits-PC kernel: [ 4640.583246]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:54:20 Arbeits-PC kernel: [ 4642.584332] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:54:20 Arbeits-PC kernel: [ 4642.584453]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:54:22 Arbeits-PC kernel: [ 4644.585479] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:54:22 Arbeits-PC kernel: [ 4644.585485]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:54:26 Arbeits-PC kernel: [ 4648.587699] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:54:26 Arbeits-PC kernel: [ 4648.587819]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:54:28 Arbeits-PC kernel: [ 4650.588822] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:54:28 Arbeits-PC kernel: [ 4650.588830]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:54:30 Arbeits-PC kernel: [ 4652.589940] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:54:30 Arbeits-PC kernel: [ 4652.590059]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:54:32 Arbeits-PC kernel: [ 4654.591063] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:54:32 Arbeits-PC kernel: [ 4654.591070]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:54:44 Arbeits-PC kernel: [ 4666.597906] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:54:44 Arbeits-PC kernel: [ 4666.598033]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:54:46 Arbeits-PC kernel: [ 4668.599027] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:54:46 Arbeits-PC kernel: [ 4668.599034]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:55:00 Arbeits-PC kernel: [ 4682.606962] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:55:00 Arbeits-PC kernel: [ 4682.607092]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:55:02 Arbeits-PC kernel: [ 4684.608141] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:55:02 Arbeits-PC kernel: [ 4684.608147]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:55:10 Arbeits-PC kernel: [ 4692.612739] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:55:10 Arbeits-PC kernel: [ 4692.612987]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:55:16 Arbeits-PC kernel: [ 4698.616076] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:55:16 Arbeits-PC kernel: [ 4698.616082]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:55:28 Arbeits-PC kernel: [ 4710.622947] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:55:28 Arbeits-PC kernel: [ 4710.623197]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:55:30 Arbeits-PC kernel: [ 4712.624070] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:55:30 Arbeits-PC kernel: [ 4712.624076]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:55:52 Arbeits-PC kernel: [ 4734.636519] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:55:52 Arbeits-PC kernel: [ 4734.636764]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:55:58 Arbeits-PC kernel: [ 4740.639855] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:55:58 Arbeits-PC kernel: [ 4740.639859]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:56:00 Arbeits-PC kernel: [ 4742.640980] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:56:00 Arbeits-PC kernel: [ 4742.641096]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:56:06 Arbeits-PC kernel: [ 4748.644460] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:56:06 Arbeits-PC kernel: [ 4748.644466]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:56:08 Arbeits-PC kernel: [ 4750.645579] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:56:08 Arbeits-PC kernel: [ 4750.645700]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:56:12 Arbeits-PC kernel: [ 4754.211158] survey done event(15)
Sep  9 08:56:12 Arbeits-PC kernel: [ 4754.647789] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:56:12 Arbeits-PC kernel: [ 4754.647796]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:56:14 Arbeits-PC kernel: [ 4756.648965] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:56:14 Arbeits-PC kernel: [ 4756.649211]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:56:24 Arbeits-PC kernel: [ 4766.654665] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:56:24 Arbeits-PC kernel: [ 4766.654672]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:56:28 Arbeits-PC kernel: [ 4770.656904] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:56:28 Arbeits-PC kernel: [ 4770.657040]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:56:30 Arbeits-PC kernel: [ 4772.658055] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:56:30 Arbeits-PC kernel: [ 4772.658061]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:56:32 Arbeits-PC kernel: [ 4774.659119] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:56:32 Arbeits-PC kernel: [ 4774.659277]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:56:34 Arbeits-PC kernel: [ 4776.660298] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:56:34 Arbeits-PC kernel: [ 4776.660305]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:56:38 Arbeits-PC kernel: [ 4780.662514] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:56:38 Arbeits-PC kernel: [ 4780.662633]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:56:46 Arbeits-PC kernel: [ 4788.667182] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:56:46 Arbeits-PC kernel: [ 4788.667188]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:57:02 Arbeits-PC kernel: [ 4804.676174] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:57:02 Arbeits-PC kernel: [ 4804.676330]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:57:04 Arbeits-PC kernel: [ 4806.677348] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:57:04 Arbeits-PC kernel: [ 4806.677355]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:57:20 Arbeits-PC kernel: [ 4822.686434] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:57:20 Arbeits-PC kernel: [ 4822.686682]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:57:22 Arbeits-PC kernel: [ 4824.687556] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:57:22 Arbeits-PC kernel: [ 4824.687563]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:57:24 Arbeits-PC kernel: [ 4826.688677] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:57:24 Arbeits-PC kernel: [ 4826.688919]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:57:26 Arbeits-PC kernel: [ 4828.689786] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:57:26 Arbeits-PC kernel: [ 4828.689792]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:57:28 Arbeits-PC kernel: [ 4830.693462] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:57:28 Arbeits-PC kernel: [ 4830.693599]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:57:32 Arbeits-PC kernel: [ 4834.693136] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:57:32 Arbeits-PC kernel: [ 4834.693143]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:57:38 Arbeits-PC kernel: [ 4840.696495] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:57:38 Arbeits-PC kernel: [ 4840.696624]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:57:40 Arbeits-PC kernel: [ 4842.697764] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:57:40 Arbeits-PC kernel: [ 4842.697771]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:57:44 Arbeits-PC kernel: [ 4846.700002] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:57:44 Arbeits-PC kernel: [ 4846.700250]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:57:52 Arbeits-PC kernel: [ 4854.704464] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:57:52 Arbeits-PC kernel: [ 4854.704470]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:57:56 Arbeits-PC kernel: [ 4858.706856] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:57:56 Arbeits-PC kernel: [ 4858.707073]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:58:12 Arbeits-PC kernel: [ 4874.039722] survey done event(15)
Sep  9 08:58:48 Arbeits-PC kernel: [ 4910.736186] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:58:48 Arbeits-PC kernel: [ 4910.736193]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:58:52 Arbeits-PC kernel: [ 4914.738415] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:58:52 Arbeits-PC kernel: [ 4914.738574]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:59:02 Arbeits-PC kernel: [ 4924.744181] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:59:02 Arbeits-PC kernel: [ 4924.744187]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:59:06 Arbeits-PC kernel: [ 4928.746412] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:59:06 Arbeits-PC kernel: [ 4928.746511]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:59:10 Arbeits-PC kernel: [ 4932.748770] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:59:10 Arbeits-PC kernel: [ 4932.748777]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:59:12 Arbeits-PC kernel: [ 4934.749769] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:59:12 Arbeits-PC kernel: [ 4934.749892]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:59:14 Arbeits-PC kernel: [ 4936.751044] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:59:14 Arbeits-PC kernel: [ 4936.751051]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:59:16 Arbeits-PC kernel: [ 4938.752163] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:59:16 Arbeits-PC kernel: [ 4938.752409]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:59:20 Arbeits-PC kernel: [ 4942.754377] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:59:20 Arbeits-PC kernel: [ 4942.754384]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:59:28 Arbeits-PC kernel: [ 4950.758825] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:59:28 Arbeits-PC kernel: [ 4950.758964]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:59:35 Arbeits-PC kernel: [ 4956.762328] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:59:35 Arbeits-PC kernel: [ 4956.762335]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:59:39 Arbeits-PC kernel: [ 4960.764587] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:59:39 Arbeits-PC kernel: [ 4960.764687]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:59:41 Arbeits-PC kernel: [ 4962.765731] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:59:41 Arbeits-PC kernel: [ 4962.765738]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:59:43 Arbeits-PC kernel: [ 4964.766766] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:59:43 Arbeits-PC kernel: [ 4964.766909]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 08:59:49 Arbeits-PC kernel: [ 4970.770192] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 08:59:49 Arbeits-PC kernel: [ 4970.770198]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 08:59:51 Arbeits-PC kernel: [ 4972.771457] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 08:59:51 Arbeits-PC kernel: [ 4972.771703]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:00:12 Arbeits-PC kernel: [ 4993.871785] survey done event(13)
Sep  9 09:00:23 Arbeits-PC kernel: [ 5004.789455] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:00:23 Arbeits-PC kernel: [ 5004.789461]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:00:25 Arbeits-PC kernel: [ 5006.790609] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:00:25 Arbeits-PC kernel: [ 5006.790726]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:00:33 Arbeits-PC kernel: [ 5014.795416] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:00:33 Arbeits-PC kernel: [ 5014.795423]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:00:35 Arbeits-PC kernel: [ 5016.796357] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:00:35 Arbeits-PC kernel: [ 5016.796601]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:00:43 Arbeits-PC kernel: [ 5024.800814] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:00:43 Arbeits-PC kernel: [ 5024.800821]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:00:45 Arbeits-PC kernel: [ 5026.802074] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:00:45 Arbeits-PC kernel: [ 5026.802328]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:00:47 Arbeits-PC kernel: [ 5028.803207] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:00:47 Arbeits-PC kernel: [ 5028.803212]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:00:49 Arbeits-PC kernel: [ 5030.804302] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:00:49 Arbeits-PC kernel: [ 5030.804420]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:00:51 Arbeits-PC kernel: [ 5032.805400] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:00:51 Arbeits-PC kernel: [ 5032.805408]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:00:59 Arbeits-PC kernel: [ 5040.809915] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:00:59 Arbeits-PC kernel: [ 5040.810170]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:01:01 Arbeits-PC kernel: [ 5042.810992] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:01:01 Arbeits-PC kernel: [ 5042.811001]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:01:03 Arbeits-PC kernel: [ 5044.812140] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:01:03 Arbeits-PC kernel: [ 5044.812269]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:01:33 Arbeits-PC kernel: [ 5074.829202] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:01:33 Arbeits-PC kernel: [ 5074.829209]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:01:35 Arbeits-PC kernel: [ 5076.830322] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:01:35 Arbeits-PC kernel: [ 5076.830437]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:01:37 Arbeits-PC kernel: [ 5078.831450] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:01:37 Arbeits-PC kernel: [ 5078.831458]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:01:39 Arbeits-PC kernel: [ 5080.832554] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:01:39 Arbeits-PC kernel: [ 5080.832674]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:01:41 Arbeits-PC kernel: [ 5082.833676] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:01:41 Arbeits-PC kernel: [ 5082.833684]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:01:45 Arbeits-PC kernel: [ 5086.836051] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:01:45 Arbeits-PC kernel: [ 5086.836161]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:01:57 Arbeits-PC kernel: [ 5098.842747] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:01:57 Arbeits-PC kernel: [ 5098.842751]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:01:59 Arbeits-PC kernel: [ 5100.844055] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:01:59 Arbeits-PC kernel: [ 5100.844276]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:02:12 Arbeits-PC kernel: [ 5113.700093] survey done event(12)
Sep  9 09:02:17 Arbeits-PC kernel: [ 5118.854095] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:02:17 Arbeits-PC kernel: [ 5118.854103]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:02:19 Arbeits-PC kernel: [ 5120.855338] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:02:19 Arbeits-PC kernel: [ 5120.855428]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:02:23 Arbeits-PC kernel: [ 5124.857593] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:02:23 Arbeits-PC kernel: [ 5124.857600]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:02:29 Arbeits-PC kernel: [ 5130.860908] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:02:29 Arbeits-PC kernel: [ 5130.861027]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:02:33 Arbeits-PC kernel: [ 5134.863165] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:02:33 Arbeits-PC kernel: [ 5134.863169]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:02:35 Arbeits-PC kernel: [ 5136.864681] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:02:35 Arbeits-PC kernel: [ 5136.864754]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:02:39 Arbeits-PC kernel: [ 5140.866762] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:02:39 Arbeits-PC kernel: [ 5140.866765]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:02:41 Arbeits-PC kernel: [ 5142.867766] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:02:41 Arbeits-PC kernel: [ 5142.867862]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:02:45 Arbeits-PC kernel: [ 5146.869980] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:02:45 Arbeits-PC kernel: [ 5146.869983]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:02:47 Arbeits-PC kernel: [ 5148.871146] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:02:47 Arbeits-PC kernel: [ 5148.871263]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:02:49 Arbeits-PC kernel: [ 5150.872267] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:02:49 Arbeits-PC kernel: [ 5150.872275]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:02:51 Arbeits-PC kernel: [ 5152.873343] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:02:51 Arbeits-PC kernel: [ 5152.873467]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:02:57 Arbeits-PC kernel: [ 5158.876830] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:02:57 Arbeits-PC kernel: [ 5158.876834]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:02:59 Arbeits-PC kernel: [ 5160.877811] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:02:59 Arbeits-PC kernel: [ 5160.877931]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:03:15 Arbeits-PC kernel: [ 5176.887100] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:03:15 Arbeits-PC kernel: [ 5176.887104]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:03:19 Arbeits-PC kernel: [ 5180.889276] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:03:19 Arbeits-PC kernel: [ 5180.889383]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:03:27 Arbeits-PC kernel: [ 5188.893826] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:03:27 Arbeits-PC kernel: [ 5188.893833]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:03:29 Arbeits-PC kernel: [ 5190.894894] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:03:29 Arbeits-PC kernel: [ 5190.895040]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:03:33 Arbeits-PC kernel: [ 5194.897315] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:03:33 Arbeits-PC kernel: [ 5194.897322]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:03:35 Arbeits-PC kernel: [ 5196.898431] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:03:35 Arbeits-PC kernel: [ 5196.898674]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:03:37 Arbeits-PC kernel: [ 5198.899549] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:03:37 Arbeits-PC kernel: [ 5198.899556]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:03:39 Arbeits-PC kernel: [ 5200.900671] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:03:39 Arbeits-PC kernel: [ 5200.900859]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:03:49 Arbeits-PC kernel: [ 5210.906246] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:03:49 Arbeits-PC kernel: [ 5210.906253]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:03:51 Arbeits-PC kernel: [ 5212.907493] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:03:51 Arbeits-PC kernel: [ 5212.907590]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:03:53 Arbeits-PC kernel: [ 5214.908461] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:03:53 Arbeits-PC kernel: [ 5214.908468]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:03:55 Arbeits-PC kernel: [ 5216.909759] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:03:55 Arbeits-PC kernel: [ 5216.910007]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:04:03 Arbeits-PC kernel: [ 5224.914231] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:04:03 Arbeits-PC kernel: [ 5224.914238]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:04:05 Arbeits-PC kernel: [ 5226.915312] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:04:05 Arbeits-PC kernel: [ 5226.915419]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:04:12 Arbeits-PC kernel: [ 5233.524536] survey done event(11)
Sep  9 09:04:17 Arbeits-PC kernel: [ 5238.922181] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:04:17 Arbeits-PC kernel: [ 5238.922188]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:04:19 Arbeits-PC kernel: [ 5240.923345] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:04:19 Arbeits-PC kernel: [ 5240.923548]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:04:21 Arbeits-PC kernel: [ 5242.924427] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:04:21 Arbeits-PC kernel: [ 5242.924434]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:04:25 Arbeits-PC kernel: [ 5246.926695] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:04:25 Arbeits-PC kernel: [ 5246.926935]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:04:27 Arbeits-PC kernel: [ 5248.927757] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:04:27 Arbeits-PC kernel: [ 5248.927763]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:04:29 Arbeits-PC kernel: [ 5250.929030] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:04:29 Arbeits-PC kernel: [ 5250.929149]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:04:37 Arbeits-PC kernel: [ 5258.933537] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:04:37 Arbeits-PC kernel: [ 5258.933544]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:04:39 Arbeits-PC kernel: [ 5260.934656] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:04:39 Arbeits-PC kernel: [ 5260.934875]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:04:41 Arbeits-PC kernel: [ 5262.935755] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:04:41 Arbeits-PC kernel: [ 5262.935762]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:04:43 Arbeits-PC kernel: [ 5264.936880] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:04:43 Arbeits-PC kernel: [ 5264.936965]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:04:45 Arbeits-PC kernel: [ 5266.938102] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:04:45 Arbeits-PC kernel: [ 5266.938107]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:04:49 Arbeits-PC kernel: [ 5270.940380] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:04:49 Arbeits-PC kernel: [ 5270.940606]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:04:53 Arbeits-PC kernel: [ 5274.942607] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:04:53 Arbeits-PC kernel: [ 5274.942614]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:04:59 Arbeits-PC kernel: [ 5280.945957] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:04:59 Arbeits-PC kernel: [ 5280.946078]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:05:01 Arbeits-PC kernel: [ 5282.947099] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:05:01 Arbeits-PC kernel: [ 5282.947106]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:05:03 Arbeits-PC kernel: [ 5284.948210] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:05:03 Arbeits-PC kernel: [ 5284.948323]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:05:31 Arbeits-PC kernel: [ 5312.964157] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:05:31 Arbeits-PC kernel: [ 5312.964164]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:05:35 Arbeits-PC kernel: [ 5316.966378] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:05:35 Arbeits-PC kernel: [ 5316.966479]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:05:41 Arbeits-PC kernel: [ 5322.969704] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:05:41 Arbeits-PC kernel: [ 5322.969712]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:05:43 Arbeits-PC kernel: [ 5324.970957] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:05:43 Arbeits-PC kernel: [ 5324.971106]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:05:45 Arbeits-PC kernel: [ 5326.972102] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:05:45 Arbeits-PC kernel: [ 5326.972109]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:05:49 Arbeits-PC kernel: [ 5330.974360] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:05:49 Arbeits-PC kernel: [ 5330.974553]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:05:51 Arbeits-PC kernel: [ 5332.975434] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:05:51 Arbeits-PC kernel: [ 5332.975441]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:05:53 Arbeits-PC kernel: [ 5334.976584] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:05:53 Arbeits-PC kernel: [ 5334.976701]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:06:12 Arbeits-PC kernel: [ 5353.352848] survey done event(13)
Sep  9 09:06:15 Arbeits-PC kernel: [ 5356.989032] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:06:15 Arbeits-PC kernel: [ 5356.989040]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:06:17 Arbeits-PC kernel: [ 5358.990155] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:06:17 Arbeits-PC kernel: [ 5358.990274]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:06:31 Arbeits-PC kernel: [ 5372.998127] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:06:31 Arbeits-PC kernel: [ 5372.998134]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:06:33 Arbeits-PC kernel: [ 5374.999244] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:06:33 Arbeits-PC kernel: [ 5374.999334]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:06:41 Arbeits-PC kernel: [ 5383.003724] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:06:41 Arbeits-PC kernel: [ 5383.003732]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:06:42 Arbeits-PC kernel: [ 5383.580107] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:06:42 Arbeits-PC kernel: [ 5383.580269]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:06:49 Arbeits-PC kernel: [ 5391.008338] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:06:49 Arbeits-PC kernel: [ 5391.008346]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:06:51 Arbeits-PC kernel: [ 5393.009446] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:06:51 Arbeits-PC kernel: [ 5393.009575]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:06:53 Arbeits-PC kernel: [ 5395.010576] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:06:53 Arbeits-PC kernel: [ 5395.010583]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:06:57 Arbeits-PC kernel: [ 5399.012937] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:06:57 Arbeits-PC kernel: [ 5399.013012]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:07:03 Arbeits-PC kernel: [ 5405.016250] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:07:03 Arbeits-PC kernel: [ 5405.016257]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:07:05 Arbeits-PC kernel: [ 5407.017377] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:07:05 Arbeits-PC kernel: [ 5407.017509]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:07:25 Arbeits-PC kernel: [ 5427.028741] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:07:25 Arbeits-PC kernel: [ 5427.028749]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:07:27 Arbeits-PC kernel: [ 5429.029866] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:07:27 Arbeits-PC kernel: [ 5429.029983]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:07:33 Arbeits-PC kernel: [ 5435.033228] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:07:33 Arbeits-PC kernel: [ 5435.033235]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:07:35 Arbeits-PC kernel: [ 5437.034492] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:07:35 Arbeits-PC kernel: [ 5437.034735]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:07:45 Arbeits-PC kernel: [ 5447.040074] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:07:45 Arbeits-PC kernel: [ 5447.040081]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:07:47 Arbeits-PC kernel: [ 5449.041188] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:07:47 Arbeits-PC kernel: [ 5449.041293]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:07:49 Arbeits-PC kernel: [ 5451.042282] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:07:49 Arbeits-PC kernel: [ 5451.042294]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:07:56 Arbeits-PC kernel: [ 5457.045823] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:07:56 Arbeits-PC kernel: [ 5457.046065]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:08:02 Arbeits-PC kernel: [ 5463.049166] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:08:02 Arbeits-PC kernel: [ 5463.049173]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:08:04 Arbeits-PC kernel: [ 5465.050299] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:08:04 Arbeits-PC kernel: [ 5465.050540]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:08:06 Arbeits-PC kernel: [ 5467.051396] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:08:06 Arbeits-PC kernel: [ 5467.051402]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:08:08 Arbeits-PC kernel: [ 5469.052519] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:08:08 Arbeits-PC kernel: [ 5469.052638]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:08:12 Arbeits-PC kernel: [ 5473.181535] survey done event(e)
Sep  9 09:08:24 Arbeits-PC kernel: [ 5485.061609] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:08:24 Arbeits-PC kernel: [ 5485.061616]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:08:26 Arbeits-PC kernel: [ 5487.062729] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:08:26 Arbeits-PC kernel: [ 5487.062850]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:08:34 Arbeits-PC kernel: [ 5495.067184] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:08:34 Arbeits-PC kernel: [ 5495.067198]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:08:36 Arbeits-PC kernel: [ 5497.068432] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:08:36 Arbeits-PC kernel: [ 5497.068532]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:08:38 Arbeits-PC kernel: [ 5499.069574] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:08:38 Arbeits-PC kernel: [ 5499.069581]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:08:40 Arbeits-PC kernel: [ 5501.070695] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:08:40 Arbeits-PC kernel: [ 5501.070813]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:08:46 Arbeits-PC kernel: [ 5507.074043] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:08:46 Arbeits-PC kernel: [ 5507.074047]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:08:48 Arbeits-PC kernel: [ 5509.075127] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:08:48 Arbeits-PC kernel: [ 5509.075247]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:08:52 Arbeits-PC kernel: [ 5513.077560] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:08:52 Arbeits-PC kernel: [ 5513.077568]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:08:54 Arbeits-PC kernel: [ 5515.078637] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:08:54 Arbeits-PC kernel: [ 5515.078753]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:09:12 Arbeits-PC kernel: [ 5533.088889] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:09:12 Arbeits-PC kernel: [ 5533.088896]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:09:14 Arbeits-PC kernel: [ 5535.089946] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:09:14 Arbeits-PC kernel: [ 5535.090077]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:09:34 Arbeits-PC kernel: [ 5555.101287] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:09:34 Arbeits-PC kernel: [ 5555.101294]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:09:36 Arbeits-PC kernel: [ 5557.102459] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:09:36 Arbeits-PC kernel: [ 5557.102684]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:09:42 Arbeits-PC kernel: [ 5563.105805] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:09:42 Arbeits-PC kernel: [ 5563.105812]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:09:44 Arbeits-PC kernel: [ 5565.106915] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:09:44 Arbeits-PC kernel: [ 5565.107035]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:09:58 Arbeits-PC kernel: [ 5579.114853] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:09:58 Arbeits-PC kernel: [ 5579.114860]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:10:00 Arbeits-PC kernel: [ 5581.116018] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:10:00 Arbeits-PC kernel: [ 5581.116272]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:10:02 Arbeits-PC kernel: [ 5583.117089] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:10:02 Arbeits-PC kernel: [ 5583.117094]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:10:04 Arbeits-PC kernel: [ 5585.118393] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:10:04 Arbeits-PC kernel: [ 5585.118575]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:10:08 Arbeits-PC kernel: [ 5589.120635] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:10:08 Arbeits-PC kernel: [ 5589.120642]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:10:10 Arbeits-PC kernel: [ 5591.121712] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:10:10 Arbeits-PC kernel: [ 5591.121826]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:10:14 Arbeits-PC kernel: [ 5595.123996] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:10:14 Arbeits-PC kernel: [ 5595.124003]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:10:16 Arbeits-PC kernel: [ 5597.125102] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:10:16 Arbeits-PC kernel: [ 5597.125215]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:10:32 Arbeits-PC kernel: [ 5613.134183] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:10:32 Arbeits-PC kernel: [ 5613.134191]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:10:34 Arbeits-PC kernel: [ 5615.135304] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:10:34 Arbeits-PC kernel: [ 5615.135420]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:10:44 Arbeits-PC kernel: [ 5625.141003] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:10:44 Arbeits-PC kernel: [ 5625.141010]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:10:46 Arbeits-PC kernel: [ 5627.142176] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:10:46 Arbeits-PC kernel: [ 5627.142412]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:10:48 Arbeits-PC kernel: [ 5629.143287] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:10:48 Arbeits-PC kernel: [ 5629.143292]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:10:50 Arbeits-PC kernel: [ 5631.144375] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:10:50 Arbeits-PC kernel: [ 5631.144511]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:10:52 Arbeits-PC kernel: [ 5633.145506] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:10:52 Arbeits-PC kernel: [ 5633.145513]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:10:54 Arbeits-PC kernel: [ 5635.146632] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:10:54 Arbeits-PC kernel: [ 5635.146748]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:10:58 Arbeits-PC kernel: [ 5639.148880] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:10:58 Arbeits-PC kernel: [ 5639.148886]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:11:00 Arbeits-PC kernel: [ 5641.150114] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:11:00 Arbeits-PC kernel: [ 5641.150190]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:11:02 Arbeits-PC kernel: [ 5643.151244] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:11:02 Arbeits-PC kernel: [ 5643.151251]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:11:04 Arbeits-PC kernel: [ 5645.152325] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:11:04 Arbeits-PC kernel: [ 5645.152479]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:11:16 Arbeits-PC kernel: [ 5657.159172] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:11:16 Arbeits-PC kernel: [ 5657.159179]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:11:18 Arbeits-PC kernel: [ 5659.160193] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:11:18 Arbeits-PC kernel: [ 5659.160313]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:11:32 Arbeits-PC kernel: [ 5673.168136] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:11:32 Arbeits-PC kernel: [ 5673.168143]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:11:34 Arbeits-PC kernel: [ 5675.169303] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:11:34 Arbeits-PC kernel: [ 5675.169533]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:11:36 Arbeits-PC kernel: [ 5677.170374] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:11:36 Arbeits-PC kernel: [ 5677.170381]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:11:38 Arbeits-PC kernel: [ 5679.171498] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:11:38 Arbeits-PC kernel: [ 5679.171645]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:11:46 Arbeits-PC kernel: [ 5687.176107] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:11:46 Arbeits-PC kernel: [ 5687.176114]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:11:48 Arbeits-PC kernel: [ 5689.177262] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:11:48 Arbeits-PC kernel: [ 5689.177373]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:12:32 Arbeits-PC kernel: [ 5733.202164] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:12:32 Arbeits-PC kernel: [ 5733.202171]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:12:36 Arbeits-PC kernel: [ 5737.204491] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:12:36 Arbeits-PC kernel: [ 5737.204604]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:12:44 Arbeits-PC kernel: [ 5745.208996] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:12:44 Arbeits-PC kernel: [ 5745.209003]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:12:46 Arbeits-PC kernel: [ 5747.210115] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:12:46 Arbeits-PC kernel: [ 5747.210234]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:13:08 Arbeits-PC kernel: [ 5769.222564] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:13:08 Arbeits-PC kernel: [ 5769.222571]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:13:10 Arbeits-PC kernel: [ 5771.223682] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:13:10 Arbeits-PC kernel: [ 5771.223774]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:13:32 Arbeits-PC kernel: [ 5793.236254] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:13:32 Arbeits-PC kernel: [ 5793.236261]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:13:36 Arbeits-PC kernel: [ 5797.238532] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:13:36 Arbeits-PC kernel: [ 5797.238744]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:13:50 Arbeits-PC kernel: [ 5811.246464] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:13:50 Arbeits-PC kernel: [ 5811.246471]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:13:52 Arbeits-PC kernel: [ 5813.247610] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:13:52 Arbeits-PC kernel: [ 5813.247854]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:13:56 Arbeits-PC kernel: [ 5817.249847] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:13:56 Arbeits-PC kernel: [ 5817.249854]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:13:58 Arbeits-PC kernel: [ 5819.250895] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:13:58 Arbeits-PC kernel: [ 5819.251025]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:14:02 Arbeits-PC kernel: [ 5823.253184] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:14:02 Arbeits-PC kernel: [ 5823.253191]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:14:08 Arbeits-PC kernel: [ 5829.256560] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:14:08 Arbeits-PC kernel: [ 5829.256818]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:14:12 Arbeits-PC kernel: [ 5832.666489] survey done event(15)
Sep  9 09:14:16 Arbeits-PC kernel: [ 5837.261155] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:14:16 Arbeits-PC kernel: [ 5837.261161]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:14:18 Arbeits-PC kernel: [ 5839.262273] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:14:18 Arbeits-PC kernel: [ 5839.262378]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:14:36 Arbeits-PC kernel: [ 5857.272451] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:14:36 Arbeits-PC kernel: [ 5857.272457]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:14:40 Arbeits-PC kernel: [ 5861.274734] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:14:40 Arbeits-PC kernel: [ 5861.274988]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:14:42 Arbeits-PC kernel: [ 5863.275842] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:14:42 Arbeits-PC kernel: [ 5863.275848]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:14:52 Arbeits-PC kernel: [ 5873.281538] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:14:52 Arbeits-PC kernel: [ 5873.281649]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:14:56 Arbeits-PC kernel: [ 5877.283776] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:14:56 Arbeits-PC kernel: [ 5877.283783]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:14:58 Arbeits-PC kernel: [ 5879.284928] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:14:58 Arbeits-PC kernel: [ 5879.285045]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:15:06 Arbeits-PC kernel: [ 5887.289540] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:15:06 Arbeits-PC kernel: [ 5887.289547]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:15:08 Arbeits-PC kernel: [ 5889.290681] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:15:08 Arbeits-PC kernel: [ 5889.290859]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:15:12 Arbeits-PC kernel: [ 5893.292894] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:15:12 Arbeits-PC kernel: [ 5893.292901]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:15:16 Arbeits-PC kernel: [ 5897.295143] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:15:16 Arbeits-PC kernel: [ 5897.295256]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:15:20 Arbeits-PC kernel: [ 5901.297473] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:15:20 Arbeits-PC kernel: [ 5901.297480]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:15:22 Arbeits-PC kernel: [ 5903.298464] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:15:22 Arbeits-PC kernel: [ 5903.298620]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:15:24 Arbeits-PC kernel: [ 5905.299738] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:15:24 Arbeits-PC kernel: [ 5905.299745]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:15:28 Arbeits-PC kernel: [ 5909.301991] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:15:28 Arbeits-PC kernel: [ 5909.302063]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:15:36 Arbeits-PC kernel: [ 5917.306468] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:15:36 Arbeits-PC kernel: [ 5917.306475]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:15:38 Arbeits-PC kernel: [ 5919.307712] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:15:38 Arbeits-PC kernel: [ 5919.307790]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:15:40 Arbeits-PC kernel: [ 5921.308833] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:15:40 Arbeits-PC kernel: [ 5921.308842]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:15:48 Arbeits-PC kernel: [ 5929.313292] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:15:48 Arbeits-PC kernel: [ 5929.313392]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:16:00 Arbeits-PC kernel: [ 5941.320041] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:16:00 Arbeits-PC kernel: [ 5941.320045]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:16:02 Arbeits-PC kernel: [ 5943.321306] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:16:02 Arbeits-PC kernel: [ 5943.321519]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:16:06 Arbeits-PC kernel: [ 5947.323545] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:16:06 Arbeits-PC kernel: [ 5947.323552]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:16:10 Arbeits-PC kernel: [ 5951.141363] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:16:10 Arbeits-PC kernel: [ 5951.141494]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:16:12 Arbeits-PC kernel: [ 5952.506643] survey done event(15)
Sep  9 09:16:13 Arbeits-PC kernel: [ 5953.326906] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:16:13 Arbeits-PC kernel: [ 5953.326913]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:16:15 Arbeits-PC kernel: [ 5955.327999] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:16:15 Arbeits-PC kernel: [ 5955.328119]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:16:21 Arbeits-PC kernel: [ 5961.331504] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:16:21 Arbeits-PC kernel: [ 5961.331512]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:16:23 Arbeits-PC kernel: [ 5963.332601] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:16:23 Arbeits-PC kernel: [ 5963.332697]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:16:25 Arbeits-PC kernel: [ 5965.333731] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:16:25 Arbeits-PC kernel: [ 5965.333738]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:16:27 Arbeits-PC kernel: [ 5967.334853] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:16:27 Arbeits-PC kernel: [ 5967.334967]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:16:31 Arbeits-PC kernel: [ 5971.337091] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:16:31 Arbeits-PC kernel: [ 5971.337098]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:16:33 Arbeits-PC kernel: [ 5973.338206] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:16:33 Arbeits-PC kernel: [ 5973.338336]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:16:43 Arbeits-PC kernel: [ 5983.343934] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:16:43 Arbeits-PC kernel: [ 5983.343941]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:16:45 Arbeits-PC kernel: [ 5985.345077] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:16:45 Arbeits-PC kernel: [ 5985.345325]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:16:47 Arbeits-PC kernel: [ 5987.346175] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:16:47 Arbeits-PC kernel: [ 5987.346181]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:16:49 Arbeits-PC kernel: [ 5989.347264] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:16:49 Arbeits-PC kernel: [ 5989.347371]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:16:51 Arbeits-PC kernel: [ 5991.348385] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:16:51 Arbeits-PC kernel: [ 5991.348391]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:16:53 Arbeits-PC kernel: [ 5993.349542] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:16:53 Arbeits-PC kernel: [ 5993.349657]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:16:55 Arbeits-PC kernel: [ 5995.350625] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:16:55 Arbeits-PC kernel: [ 5995.350632]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:16:57 Arbeits-PC kernel: [ 5997.351874] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:16:57 Arbeits-PC kernel: [ 5997.352020]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:17:01 Arbeits-PC kernel: [ 6001.354170] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:17:01 Arbeits-PC kernel: [ 6001.354177]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:17:01 Arbeits-PC CRON[5403]: (root) CMD (   cd / &&
run-parts --report /etc/cron.hourly)
Sep  9 09:17:03 Arbeits-PC kernel: [ 6003.355231] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:17:03 Arbeits-PC kernel: [ 6003.355386]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:17:05 Arbeits-PC kernel: [ 6005.356377] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:17:05 Arbeits-PC kernel: [ 6005.356385]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:17:07 Arbeits-PC kernel: [ 6007.357709] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:17:07 Arbeits-PC kernel: [ 6007.357829]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:17:11 Arbeits-PC kernel: [ 6011.359721] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:17:11 Arbeits-PC kernel: [ 6011.359727]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:17:13 Arbeits-PC kernel: [ 6013.360984] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:17:13 Arbeits-PC kernel: [ 6013.361106]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:17:15 Arbeits-PC kernel: [ 6015.362131] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:17:15 Arbeits-PC kernel: [ 6015.362137]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:17:19 Arbeits-PC kernel: [ 6019.364319] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:17:19 Arbeits-PC kernel: [ 6019.364472]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:17:27 Arbeits-PC kernel: [ 6027.368833] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:17:27 Arbeits-PC kernel: [ 6027.368839]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:17:28 Arbeits-PC kernel: [ 6028.495142] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:17:28 Arbeits-PC kernel: [ 6028.495358]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:17:33 Arbeits-PC kernel: [ 6033.372341] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:17:33 Arbeits-PC kernel: [ 6033.372347]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:17:37 Arbeits-PC kernel: [ 6037.374518] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:17:37 Arbeits-PC kernel: [ 6037.374649]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:17:43 Arbeits-PC kernel: [ 6043.377918] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:17:43 Arbeits-PC kernel: [ 6043.377924]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:17:45 Arbeits-PC kernel: [ 6045.379034] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:17:45 Arbeits-PC kernel: [ 6045.379141]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:17:47 Arbeits-PC kernel: [ 6047.380159] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:17:47 Arbeits-PC kernel: [ 6047.380166]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:17:51 Arbeits-PC kernel: [ 6051.382710] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:17:51 Arbeits-PC kernel: [ 6051.382894]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:17:55 Arbeits-PC kernel: [ 6055.384739] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:17:55 Arbeits-PC kernel: [ 6055.384745]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:17:57 Arbeits-PC kernel: [ 6057.385852] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:17:57 Arbeits-PC kernel: [ 6057.386002]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:18:01 Arbeits-PC kernel: [ 6061.388127] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:18:01 Arbeits-PC kernel: [ 6061.388134]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:18:09 Arbeits-PC kernel: [ 6069.392755] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:18:09 Arbeits-PC kernel: [ 6069.393001]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:18:12 Arbeits-PC kernel: [ 6072.327217] survey done event(15)
Sep  9 09:18:13 Arbeits-PC kernel: [ 6073.394969] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:18:13 Arbeits-PC kernel: [ 6073.394976]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:18:19 Arbeits-PC kernel: [ 6079.398300] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:18:19 Arbeits-PC kernel: [ 6079.398419]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:18:21 Arbeits-PC kernel: [ 6081.399457] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:18:21 Arbeits-PC kernel: [ 6081.399464]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:18:23 Arbeits-PC kernel: [ 6083.400777] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:18:23 Arbeits-PC kernel: [ 6083.400899]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:18:24 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 192.168.1.1 port 67 (xid=0x45412da)
Sep  9 09:18:24 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 09:18:24 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 3515 seconds.
Sep  9 09:18:24 Arbeits-PC NetworkManager[1007]: <info> (wlan0):
DHCPv4 state changed renew -> renew
Sep  9 09:18:24 Arbeits-PC NetworkManager[1007]: <info>   address 192.168.1.103
Sep  9 09:18:24 Arbeits-PC NetworkManager[1007]: <info>   prefix 24
(255.255.255.0)
Sep  9 09:18:24 Arbeits-PC NetworkManager[1007]: <info>   gateway 192.168.1.1
Sep  9 09:18:24 Arbeits-PC NetworkManager[1007]: <info>   nameserver
'192.168.1.1'
Sep  9 09:18:24 Arbeits-PC dbus[910]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 09:18:24 Arbeits-PC dbus[910]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 09:18:27 Arbeits-PC kernel: [ 6087.402962] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:18:27 Arbeits-PC kernel: [ 6087.402969]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:18:35 Arbeits-PC kernel: [ 6095.407398] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:18:35 Arbeits-PC kernel: [ 6095.407537]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:18:45 Arbeits-PC kernel: [ 6105.413121] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:18:45 Arbeits-PC kernel: [ 6105.413128]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:18:47 Arbeits-PC kernel: [ 6107.414110] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:18:47 Arbeits-PC kernel: [ 6107.414262]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:18:49 Arbeits-PC kernel: [ 6109.415385] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:18:49 Arbeits-PC kernel: [ 6109.415392]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:18:53 Arbeits-PC kernel: [ 6113.417646] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:18:53 Arbeits-PC kernel: [ 6113.417894]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:18:55 Arbeits-PC kernel: [ 6115.418770] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:18:55 Arbeits-PC kernel: [ 6115.418777]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:18:59 Arbeits-PC kernel: [ 6119.420983] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:18:59 Arbeits-PC kernel: [ 6119.421123]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:19:01 Arbeits-PC kernel: [ 6121.422118] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:19:01 Arbeits-PC kernel: [ 6121.422126]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:19:05 Arbeits-PC kernel: [ 6125.424476] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:19:05 Arbeits-PC kernel: [ 6125.424595]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:19:07 Arbeits-PC kernel: [ 6127.425616] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:19:07 Arbeits-PC kernel: [ 6127.425623]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:19:09 Arbeits-PC kernel: [ 6129.426712] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:19:09 Arbeits-PC kernel: [ 6129.426837]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:19:13 Arbeits-PC kernel: [ 6133.428948] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:19:13 Arbeits-PC kernel: [ 6133.428955]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:19:15 Arbeits-PC kernel: [ 6135.430078] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:19:15 Arbeits-PC kernel: [ 6135.430197]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:19:21 Arbeits-PC kernel: [ 6141.433428] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:19:21 Arbeits-PC kernel: [ 6141.433435]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:19:23 Arbeits-PC kernel: [ 6143.434651] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:19:23 Arbeits-PC kernel: [ 6143.434758]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:19:25 Arbeits-PC kernel: [ 6145.435822] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:19:25 Arbeits-PC kernel: [ 6145.435829]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:19:27 Arbeits-PC kernel: [ 6147.436909] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:19:27 Arbeits-PC kernel: [ 6147.437018]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:19:31 Arbeits-PC kernel: [ 6151.439130] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:19:31 Arbeits-PC kernel: [ 6151.439137]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:19:33 Arbeits-PC kernel: [ 6153.440477] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:19:33 Arbeits-PC kernel: [ 6153.440615]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:19:37 Arbeits-PC kernel: [ 6157.442467] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:19:37 Arbeits-PC kernel: [ 6157.442473]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:19:39 Arbeits-PC kernel: [ 6159.443652] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:19:39 Arbeits-PC kernel: [ 6159.443765]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:19:45 Arbeits-PC kernel: [ 6165.447154] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:19:45 Arbeits-PC kernel: [ 6165.447161]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:19:49 Arbeits-PC kernel: [ 6169.449390] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:19:49 Arbeits-PC kernel: [ 6169.449591]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:19:51 Arbeits-PC kernel: [ 6171.450490] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:19:51 Arbeits-PC kernel: [ 6171.450498]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:20:01 Arbeits-PC kernel: [ 6181.456250] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:20:01 Arbeits-PC kernel: [ 6181.456487]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:20:03 Arbeits-PC kernel: [ 6183.457358] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:20:03 Arbeits-PC kernel: [ 6183.457362]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:20:05 Arbeits-PC kernel: [ 6185.458436] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:20:05 Arbeits-PC kernel: [ 6185.458593]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:20:07 Arbeits-PC kernel: [ 6187.459609] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:20:07 Arbeits-PC kernel: [ 6187.459616]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:20:09 Arbeits-PC kernel: [ 6189.460670] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:20:09 Arbeits-PC kernel: [ 6189.460825]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:20:12 Arbeits-PC kernel: [ 6192.155528] survey done event(12)
Sep  9 09:20:21 Arbeits-PC kernel: [ 6201.467548] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:20:21 Arbeits-PC kernel: [ 6201.467555]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:20:23 Arbeits-PC kernel: [ 6203.468669] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:20:23 Arbeits-PC kernel: [ 6203.468787]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:20:29 Arbeits-PC kernel: [ 6209.472030] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:20:29 Arbeits-PC kernel: [ 6209.472037]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:20:31 Arbeits-PC kernel: [ 6211.473162] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:20:31 Arbeits-PC kernel: [ 6211.473391]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:20:33 Arbeits-PC kernel: [ 6213.474274] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:20:33 Arbeits-PC kernel: [ 6213.474281]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:20:41 Arbeits-PC kernel: [ 6221.478846] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:20:41 Arbeits-PC kernel: [ 6221.478963]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:20:47 Arbeits-PC kernel: [ 6227.482239] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:20:47 Arbeits-PC kernel: [ 6227.482246]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:20:53 Arbeits-PC kernel: [ 6233.485577] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:20:53 Arbeits-PC kernel: [ 6233.485676]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:20:57 Arbeits-PC kernel: [ 6237.487963] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:20:57 Arbeits-PC kernel: [ 6237.487970]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:20:59 Arbeits-PC kernel: [ 6239.489042] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:20:59 Arbeits-PC kernel: [ 6239.489180]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:21:05 Arbeits-PC kernel: [ 6245.492445] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:21:05 Arbeits-PC kernel: [ 6245.492451]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:21:09 Arbeits-PC kernel: [ 6249.494639] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:21:09 Arbeits-PC kernel: [ 6249.494752]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:21:13 Arbeits-PC kernel: [ 6253.496891] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:21:13 Arbeits-PC kernel: [ 6253.496898]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:21:15 Arbeits-PC kernel: [ 6255.498052] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:21:15 Arbeits-PC kernel: [ 6255.498165]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:21:17 Arbeits-PC kernel: [ 6257.499265] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:21:17 Arbeits-PC kernel: [ 6257.499272]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:21:19 Arbeits-PC kernel: [ 6259.500431] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:21:19 Arbeits-PC kernel: [ 6259.500676]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:21:23 Arbeits-PC kernel: [ 6263.502675] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:21:23 Arbeits-PC kernel: [ 6263.502682]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:21:29 Arbeits-PC kernel: [ 6269.506012] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:21:29 Arbeits-PC kernel: [ 6269.506128]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:21:41 Arbeits-PC kernel: [ 6281.512833] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:21:41 Arbeits-PC kernel: [ 6281.512840]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:21:45 Arbeits-PC kernel: [ 6285.515107] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:21:45 Arbeits-PC kernel: [ 6285.515221]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:21:49 Arbeits-PC kernel: [ 6289.517348] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:21:49 Arbeits-PC kernel: [ 6289.517355]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:21:53 Arbeits-PC kernel: [ 6293.519730] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:21:53 Arbeits-PC kernel: [ 6293.519974]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:21:55 Arbeits-PC kernel: [ 6295.520846] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:21:55 Arbeits-PC kernel: [ 6295.520853]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:21:59 Arbeits-PC kernel: [ 6299.523036] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:21:59 Arbeits-PC kernel: [ 6299.523147]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:22:01 Arbeits-PC kernel: [ 6301.524134] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:22:01 Arbeits-PC kernel: [ 6301.524141]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:22:05 Arbeits-PC kernel: [ 6305.526429] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:22:05 Arbeits-PC kernel: [ 6305.526543]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:22:07 Arbeits-PC kernel: [ 6307.527552] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:22:07 Arbeits-PC kernel: [ 6307.527559]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:22:10 Arbeits-PC kernel: [ 6310.624692] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:22:10 Arbeits-PC kernel: [ 6310.624783]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:22:12 Arbeits-PC kernel: [ 6311.979847] survey done event(10)
Sep  9 09:22:13 Arbeits-PC kernel: [ 6313.531056] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:22:13 Arbeits-PC kernel: [ 6313.531063]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:22:15 Arbeits-PC kernel: [ 6315.532177] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:22:15 Arbeits-PC kernel: [ 6315.532418]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:22:27 Arbeits-PC kernel: [ 6327.538878] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:22:27 Arbeits-PC kernel: [ 6327.538884]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:22:29 Arbeits-PC kernel: [ 6329.540144] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:22:29 Arbeits-PC kernel: [ 6329.540324]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:22:41 Arbeits-PC kernel: [ 6341.546819] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:22:41 Arbeits-PC kernel: [ 6341.546824]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:22:43 Arbeits-PC kernel: [ 6343.547930] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:22:43 Arbeits-PC kernel: [ 6343.548041]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:22:45 Arbeits-PC kernel: [ 6345.549093] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:22:45 Arbeits-PC kernel: [ 6345.549100]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:22:47 Arbeits-PC kernel: [ 6347.550319] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:22:47 Arbeits-PC kernel: [ 6347.550400]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:22:51 Arbeits-PC kernel: [ 6351.552583] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:22:51 Arbeits-PC kernel: [ 6351.552590]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:22:57 Arbeits-PC kernel: [ 6357.555926] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:22:57 Arbeits-PC kernel: [ 6357.556032]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:23:15 Arbeits-PC kernel: [ 6375.566365] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:23:15 Arbeits-PC kernel: [ 6375.566370]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:23:17 Arbeits-PC kernel: [ 6377.567234] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:23:17 Arbeits-PC kernel: [ 6377.567351]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:23:41 Arbeits-PC kernel: [ 6401.581107] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:23:41 Arbeits-PC kernel: [ 6401.581111]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:23:43 Arbeits-PC kernel: [ 6403.582040] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:23:43 Arbeits-PC kernel: [ 6403.582194]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:23:45 Arbeits-PC kernel: [ 6405.583214] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:23:45 Arbeits-PC kernel: [ 6405.583221]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:23:47 Arbeits-PC kernel: [ 6407.584280] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:23:47 Arbeits-PC kernel: [ 6407.584428]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:24:05 Arbeits-PC kernel: [ 6425.594544] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:24:05 Arbeits-PC kernel: [ 6425.594551]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:24:10 Arbeits-PC kernel: [ 6430.455622] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:24:10 Arbeits-PC kernel: [ 6430.455740]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:24:12 Arbeits-PC kernel: [ 6431.820187] survey done event(11)
Sep  9 09:24:15 Arbeits-PC kernel: [ 6435.600125] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:24:15 Arbeits-PC kernel: [ 6435.600132]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:24:17 Arbeits-PC kernel: [ 6437.601239] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:24:17 Arbeits-PC kernel: [ 6437.601357]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:24:21 Arbeits-PC kernel: [ 6441.603580] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:24:21 Arbeits-PC kernel: [ 6441.603587]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:24:27 Arbeits-PC kernel: [ 6447.606921] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:24:27 Arbeits-PC kernel: [ 6447.607028]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:24:42 Arbeits-PC kernel: [ 6461.614829] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:24:42 Arbeits-PC kernel: [ 6461.614836]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:24:50 Arbeits-PC kernel: [ 6469.619441] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:24:50 Arbeits-PC kernel: [ 6469.619659]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:24:52 Arbeits-PC kernel: [ 6471.620533] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:24:52 Arbeits-PC kernel: [ 6471.620541]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:24:53 Arbeits-PC kernel: [ 6472.992709] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:24:53 Arbeits-PC kernel: [ 6472.992931]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:25:02 Arbeits-PC kernel: [ 6481.626241] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:25:02 Arbeits-PC kernel: [ 6481.626249]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:25:04 Arbeits-PC kernel: [ 6483.627192] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:25:04 Arbeits-PC kernel: [ 6483.627315]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:25:22 Arbeits-PC kernel: [ 6501.637565] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:25:22 Arbeits-PC kernel: [ 6501.637580]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:25:24 Arbeits-PC kernel: [ 6503.638681] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:25:24 Arbeits-PC kernel: [ 6503.638787]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:25:26 Arbeits-PC kernel: [ 6505.639854] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:25:26 Arbeits-PC kernel: [ 6505.639862]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:25:30 Arbeits-PC kernel: [ 6509.642024] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:25:30 Arbeits-PC kernel: [ 6509.642142]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:25:32 Arbeits-PC kernel: [ 6511.643196] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:25:32 Arbeits-PC kernel: [ 6511.643200]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:25:40 Arbeits-PC kernel: [ 6519.647765] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:25:40 Arbeits-PC kernel: [ 6519.647885]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:25:44 Arbeits-PC kernel: [ 6523.650008] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:25:44 Arbeits-PC kernel: [ 6523.650015]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:25:50 Arbeits-PC kernel: [ 6529.653341] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:25:50 Arbeits-PC kernel: [ 6529.653479]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:25:56 Arbeits-PC kernel: [ 6535.656827] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:25:56 Arbeits-PC kernel: [ 6535.656832]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:26:00 Arbeits-PC kernel: [ 6539.659106] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:26:00 Arbeits-PC kernel: [ 6539.659227]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:26:02 Arbeits-PC kernel: [ 6541.660224] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:26:02 Arbeits-PC kernel: [ 6541.660229]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:26:04 Arbeits-PC kernel: [ 6543.661394] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:26:04 Arbeits-PC kernel: [ 6543.661581]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:26:12 Arbeits-PC kernel: [ 6551.640321] survey done event(14)
Sep  9 09:26:12 Arbeits-PC kernel: [ 6551.665829] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:26:12 Arbeits-PC kernel: [ 6551.665834]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:26:26 Arbeits-PC kernel: [ 6565.673777] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:26:26 Arbeits-PC kernel: [ 6565.673996]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:26:32 Arbeits-PC kernel: [ 6571.677281] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:26:32 Arbeits-PC kernel: [ 6571.677289]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:26:34 Arbeits-PC kernel: [ 6573.678394] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:26:34 Arbeits-PC kernel: [ 6573.678505]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:26:36 Arbeits-PC kernel: [ 6575.679509] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:26:36 Arbeits-PC kernel: [ 6575.679516]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:26:38 Arbeits-PC kernel: [ 6577.680655] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:26:38 Arbeits-PC kernel: [ 6577.680776]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:26:40 Arbeits-PC kernel: [ 6579.681752] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:26:40 Arbeits-PC kernel: [ 6579.681756]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:26:48 Arbeits-PC kernel: [ 6587.686232] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:26:48 Arbeits-PC kernel: [ 6587.686351]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:26:52 Arbeits-PC kernel: [ 6591.688632] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:26:52 Arbeits-PC kernel: [ 6591.688639]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:26:56 Arbeits-PC kernel: [ 6595.691071] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:26:56 Arbeits-PC kernel: [ 6595.691197]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:26:58 Arbeits-PC kernel: [ 6597.691960] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:26:58 Arbeits-PC kernel: [ 6597.691964]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:27:00 Arbeits-PC kernel: [ 6599.693069] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:27:00 Arbeits-PC kernel: [ 6599.693294]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:27:02 Arbeits-PC kernel: [ 6601.694198] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:27:02 Arbeits-PC kernel: [ 6601.694205]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:27:04 Arbeits-PC kernel: [ 6603.695358] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:27:04 Arbeits-PC kernel: [ 6603.695429]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:27:06 Arbeits-PC kernel: [ 6605.696594] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:27:06 Arbeits-PC kernel: [ 6605.696599]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:27:10 Arbeits-PC kernel: [ 6609.698788] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:27:10 Arbeits-PC kernel: [ 6609.698897]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:27:12 Arbeits-PC kernel: [ 6611.699960] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:27:12 Arbeits-PC kernel: [ 6611.699967]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:27:20 Arbeits-PC kernel: [ 6619.704405] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:27:20 Arbeits-PC kernel: [ 6619.704508]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:27:23 Arbeits-PC dbus[910]: [system] Activating service
name='org.freedesktop.hostname1' (using servicehelper)
Sep  9 09:27:23 Arbeits-PC dbus[910]: [system] Successfully activated
service 'org.freedesktop.hostname1'
Sep  9 09:27:24 Arbeits-PC kernel: [ 6623.706621] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:27:24 Arbeits-PC kernel: [ 6623.706628]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:27:28 Arbeits-PC kernel: [ 6627.708995] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:27:28 Arbeits-PC kernel: [ 6627.709104]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:27:32 Arbeits-PC kernel: [ 6631.711294] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:27:32 Arbeits-PC kernel: [ 6631.711301]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:27:34 Arbeits-PC kernel: [ 6633.712428] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:27:34 Arbeits-PC kernel: [ 6633.712675]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:27:46 Arbeits-PC kernel: [ 6645.719122] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:27:46 Arbeits-PC kernel: [ 6645.719130]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:27:48 Arbeits-PC kernel: [ 6647.720399] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:27:48 Arbeits-PC kernel: [ 6647.720614]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:27:58 Arbeits-PC kernel: [ 6657.725942] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:27:58 Arbeits-PC kernel: [ 6657.725948]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:28:00 Arbeits-PC kernel: [ 6659.727095] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:28:00 Arbeits-PC kernel: [ 6659.727214]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:28:02 Arbeits-PC kernel: [ 6661.728217] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:28:02 Arbeits-PC kernel: [ 6661.728224]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:28:04 Arbeits-PC kernel: [ 6663.729483] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:28:04 Arbeits-PC kernel: [ 6663.729731]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:28:06 Arbeits-PC kernel: [ 6665.730575] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:28:06 Arbeits-PC kernel: [ 6665.730581]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:28:08 Arbeits-PC kernel: [ 6667.731720] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:28:08 Arbeits-PC kernel: [ 6667.731927]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:28:12 Arbeits-PC kernel: [ 6671.734156] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:28:12 Arbeits-PC kernel: [ 6671.734162]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:28:20 Arbeits-PC kernel: [ 6679.738415] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:28:20 Arbeits-PC kernel: [ 6679.738539]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:28:26 Arbeits-PC kernel: [ 6685.741930] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:28:26 Arbeits-PC kernel: [ 6685.741936]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:28:30 Arbeits-PC kernel: [ 6689.744167] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:28:30 Arbeits-PC kernel: [ 6689.744419]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:28:32 Arbeits-PC kernel: [ 6691.745263] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:28:32 Arbeits-PC kernel: [ 6691.745269]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:28:36 Arbeits-PC kernel: [ 6695.747510] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:28:36 Arbeits-PC kernel: [ 6695.747629]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:28:42 Arbeits-PC kernel: [ 6701.751017] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:28:42 Arbeits-PC kernel: [ 6701.751024]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:28:50 Arbeits-PC kernel: [ 6709.755449] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:28:50 Arbeits-PC kernel: [ 6709.755607]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:28:54 Arbeits-PC kernel: [ 6713.757718] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:28:54 Arbeits-PC kernel: [ 6713.757724]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:28:56 Arbeits-PC kernel: [ 6715.758837] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:28:56 Arbeits-PC kernel: [ 6715.758965]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:28:58 Arbeits-PC kernel: [ 6717.759969] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:28:58 Arbeits-PC kernel: [ 6717.759975]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:29:00 Arbeits-PC kernel: [ 6719.761221] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:29:00 Arbeits-PC kernel: [ 6719.761446]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:29:02 Arbeits-PC kernel: [ 6721.762351] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:29:02 Arbeits-PC kernel: [ 6721.762358]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:29:08 Arbeits-PC kernel: [ 6727.765653] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:29:08 Arbeits-PC kernel: [ 6727.765775]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:29:12 Arbeits-PC kernel: [ 6731.767952] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:29:12 Arbeits-PC kernel: [ 6731.767959]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:29:16 Arbeits-PC kernel: [ 6735.770178] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:29:16 Arbeits-PC kernel: [ 6735.770300]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:29:24 Arbeits-PC kernel: [ 6743.774771] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:29:24 Arbeits-PC kernel: [ 6743.774777]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:29:28 Arbeits-PC kernel: [ 6747.776997] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:29:28 Arbeits-PC kernel: [ 6747.777092]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:29:32 Arbeits-PC kernel: [ 6751.779228] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:29:32 Arbeits-PC kernel: [ 6751.779235]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:29:40 Arbeits-PC kernel: [ 6759.783854] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:29:40 Arbeits-PC kernel: [ 6759.783986]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:29:42 Arbeits-PC kernel: [ 6761.784986] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:29:42 Arbeits-PC kernel: [ 6761.784993]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:29:46 Arbeits-PC kernel: [ 6765.787218] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:29:46 Arbeits-PC kernel: [ 6765.787336]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:29:48 Arbeits-PC kernel: [ 6767.788320] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:29:48 Arbeits-PC kernel: [ 6767.788326]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:29:50 Arbeits-PC kernel: [ 6769.789456] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:29:50 Arbeits-PC kernel: [ 6769.789576]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:29:52 Arbeits-PC kernel: [ 6771.790548] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:29:52 Arbeits-PC kernel: [ 6771.790554]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:29:56 Arbeits-PC kernel: [ 6775.792968] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:29:56 Arbeits-PC kernel: [ 6775.793217]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:29:58 Arbeits-PC kernel: [ 6777.794090] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:29:58 Arbeits-PC kernel: [ 6777.794097]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:30:00 Arbeits-PC kernel: [ 6779.795209] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:30:00 Arbeits-PC kernel: [ 6779.795456]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:30:02 Arbeits-PC kernel: [ 6781.796331] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:30:02 Arbeits-PC kernel: [ 6781.796338]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:30:04 Arbeits-PC kernel: [ 6783.797445] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:30:04 Arbeits-PC kernel: [ 6783.797696]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:30:06 Arbeits-PC kernel: [ 6785.798572] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:30:06 Arbeits-PC kernel: [ 6785.798579]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:30:10 Arbeits-PC kernel: [ 6789.800788] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:30:10 Arbeits-PC kernel: [ 6789.800914]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:30:12 Arbeits-PC kernel: [ 6791.293221] survey done event(10)
Sep  9 09:30:12 Arbeits-PC kernel: [ 6791.801915] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:30:12 Arbeits-PC kernel: [ 6791.801922]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:30:16 Arbeits-PC kernel: [ 6795.804540] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:30:16 Arbeits-PC kernel: [ 6795.804766]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:30:18 Arbeits-PC kernel: [ 6797.805415] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:30:18 Arbeits-PC kernel: [ 6797.805422]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:30:20 Arbeits-PC kernel: [ 6799.806536] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:30:20 Arbeits-PC kernel: [ 6799.806783]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:30:22 Arbeits-PC kernel: [ 6801.807607] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:30:22 Arbeits-PC kernel: [ 6801.807613]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:30:30 Arbeits-PC kernel: [ 6809.812123] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:30:30 Arbeits-PC kernel: [ 6809.812236]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:30:34 Arbeits-PC kernel: [ 6813.814477] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:30:34 Arbeits-PC kernel: [ 6813.814484]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:30:44 Arbeits-PC kernel: [ 6823.820084] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:30:44 Arbeits-PC kernel: [ 6823.820167]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:30:50 Arbeits-PC kernel: [ 6829.823436] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:30:50 Arbeits-PC kernel: [ 6829.823442]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:30:56 Arbeits-PC kernel: [ 6835.826932] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:30:56 Arbeits-PC kernel: [ 6835.827050]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:30:58 Arbeits-PC kernel: [ 6837.828016] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:30:58 Arbeits-PC kernel: [ 6837.828023]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:31:04 Arbeits-PC kernel: [ 6843.831410] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:31:04 Arbeits-PC kernel: [ 6843.831528]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:31:06 Arbeits-PC kernel: [ 6845.832515] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:31:06 Arbeits-PC kernel: [ 6845.832522]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:31:14 Arbeits-PC kernel: [ 6853.837157] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:31:14 Arbeits-PC kernel: [ 6853.837387]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:31:24 Arbeits-PC kernel: [ 6863.842739] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:31:24 Arbeits-PC kernel: [ 6863.842745]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:31:28 Arbeits-PC kernel: [ 6867.844985] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:31:28 Arbeits-PC kernel: [ 6867.845059]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:31:36 Arbeits-PC kernel: [ 6875.849587] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:31:36 Arbeits-PC kernel: [ 6875.849592]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:31:40 Arbeits-PC kernel: [ 6879.851816] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:31:40 Arbeits-PC kernel: [ 6879.851924]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:31:42 Arbeits-PC kernel: [ 6881.852951] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:31:42 Arbeits-PC kernel: [ 6881.852958]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:31:48 Arbeits-PC kernel: [ 6887.856429] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:31:48 Arbeits-PC kernel: [ 6887.856549]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:31:52 Arbeits-PC kernel: [ 6891.858642] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:31:52 Arbeits-PC kernel: [ 6891.858648]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:32:04 Arbeits-PC kernel: [ 6903.865642] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:32:04 Arbeits-PC kernel: [ 6903.865769]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:32:12 Arbeits-PC kernel: [ 6911.121784] survey done event(15)
Sep  9 09:32:12 Arbeits-PC kernel: [ 6911.870027] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:32:12 Arbeits-PC kernel: [ 6911.870035]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:32:14 Arbeits-PC kernel: [ 6913.871145] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:32:14 Arbeits-PC kernel: [ 6913.871363]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:32:16 Arbeits-PC kernel: [ 6915.872228] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:32:16 Arbeits-PC kernel: [ 6915.872235]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:32:18 Arbeits-PC kernel: [ 6917.873362] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:32:18 Arbeits-PC kernel: [ 6917.873489]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:32:24 Arbeits-PC kernel: [ 6923.876723] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:32:24 Arbeits-PC kernel: [ 6923.876730]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:32:26 Arbeits-PC kernel: [ 6925.877989] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:32:26 Arbeits-PC kernel: [ 6925.878236]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:32:28 Arbeits-PC kernel: [ 6927.879047] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:32:28 Arbeits-PC kernel: [ 6927.879053]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:32:30 Arbeits-PC kernel: [ 6929.880232] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:32:30 Arbeits-PC kernel: [ 6929.880477]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:32:32 Arbeits-PC kernel: [ 6931.881298] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:32:32 Arbeits-PC kernel: [ 6931.881304]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:32:34 Arbeits-PC kernel: [ 6933.882446] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:32:34 Arbeits-PC kernel: [ 6933.882565]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:32:36 Arbeits-PC kernel: [ 6935.883544] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:32:36 Arbeits-PC kernel: [ 6935.883551]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:32:40 Arbeits-PC kernel: [ 6939.885811] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:32:40 Arbeits-PC kernel: [ 6939.885930]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:32:42 Arbeits-PC kernel: [ 6941.887047] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:32:42 Arbeits-PC kernel: [ 6941.887051]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:32:50 Arbeits-PC kernel: [ 6949.891557] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:32:50 Arbeits-PC kernel: [ 6949.891805]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:32:55 Arbeits-PC kernel: [ 6953.893777] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:32:55 Arbeits-PC kernel: [ 6953.893784]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:33:05 Arbeits-PC kernel: [ 6963.899526] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:33:05 Arbeits-PC kernel: [ 6963.899773]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:33:07 Arbeits-PC kernel: [ 6965.900646] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:33:07 Arbeits-PC kernel: [ 6965.900653]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:33:09 Arbeits-PC kernel: [ 6967.901748] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:33:09 Arbeits-PC kernel: [ 6967.901862]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:33:13 Arbeits-PC kernel: [ 6971.903951] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:33:13 Arbeits-PC kernel: [ 6971.903958]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:33:19 Arbeits-PC kernel: [ 6977.907352] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:33:19 Arbeits-PC kernel: [ 6977.907466]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:33:23 Arbeits-PC kernel: [ 6981.909733] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:33:23 Arbeits-PC kernel: [ 6981.909739]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:33:33 Arbeits-PC kernel: [ 6991.915248] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:33:33 Arbeits-PC kernel: [ 6991.915371]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:33:41 Arbeits-PC kernel: [ 6999.919887] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:33:41 Arbeits-PC kernel: [ 6999.919894]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:33:43 Arbeits-PC kernel: [ 7001.921034] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:33:43 Arbeits-PC kernel: [ 7001.921156]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:33:47 Arbeits-PC kernel: [ 7005.923300] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:33:47 Arbeits-PC kernel: [ 7005.923307]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:33:49 Arbeits-PC kernel: [ 7007.924384] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:33:49 Arbeits-PC kernel: [ 7007.924496]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:33:53 Arbeits-PC kernel: [ 7011.926627] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:33:53 Arbeits-PC kernel: [ 7011.926634]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:33:59 Arbeits-PC kernel: [ 7017.930148] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:33:59 Arbeits-PC kernel: [ 7017.930373]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:34:01 Arbeits-PC kernel: [ 7019.931271] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:34:01 Arbeits-PC kernel: [ 7019.931278]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:34:05 Arbeits-PC kernel: [ 7023.933484] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:34:05 Arbeits-PC kernel: [ 7023.933604]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:34:07 Arbeits-PC kernel: [ 7025.934632] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:34:07 Arbeits-PC kernel: [ 7025.934639]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:34:10 Arbeits-PC kernel: [ 7029.595747] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:34:10 Arbeits-PC kernel: [ 7029.596071]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:34:12 Arbeits-PC kernel: [ 7030.961955] survey done event(13)
Sep  9 09:34:13 Arbeits-PC kernel: [ 7031.937954] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:34:13 Arbeits-PC kernel: [ 7031.937961]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:34:19 Arbeits-PC kernel: [ 7037.941448] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:34:19 Arbeits-PC kernel: [ 7037.941580]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:34:25 Arbeits-PC kernel: [ 7043.944813] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:34:25 Arbeits-PC kernel: [ 7043.944819]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:34:29 Arbeits-PC kernel: [ 7047.947058] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:34:29 Arbeits-PC kernel: [ 7047.947176]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:34:33 Arbeits-PC kernel: [ 7051.949305] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:34:33 Arbeits-PC kernel: [ 7051.949311]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:34:49 Arbeits-PC kernel: [ 7067.958383] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:34:49 Arbeits-PC kernel: [ 7067.958509]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:34:51 Arbeits-PC kernel: [ 7069.959509] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:34:51 Arbeits-PC kernel: [ 7069.959515]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:34:59 Arbeits-PC kernel: [ 7077.964109] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:34:59 Arbeits-PC kernel: [ 7077.964227]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:35:17 Arbeits-PC kernel: [ 7095.974319] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:35:17 Arbeits-PC kernel: [ 7095.974324]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:35:19 Arbeits-PC kernel: [ 7097.975457] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:35:19 Arbeits-PC kernel: [ 7097.975703]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:35:37 Arbeits-PC kernel: [ 7115.985668] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:35:37 Arbeits-PC kernel: [ 7115.985675]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:35:41 Arbeits-PC kernel: [ 7119.987896] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:35:41 Arbeits-PC kernel: [ 7119.987965]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:35:43 Arbeits-PC kernel: [ 7121.989003] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:35:43 Arbeits-PC kernel: [ 7121.989009]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:35:49 Arbeits-PC kernel: [ 7127.992514] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:35:49 Arbeits-PC kernel: [ 7127.992760]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:35:53 Arbeits-PC kernel: [ 7131.994751] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:35:53 Arbeits-PC kernel: [ 7131.994755]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:35:57 Arbeits-PC kernel: [ 7135.996994] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:35:57 Arbeits-PC kernel: [ 7135.997239]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:36:01 Arbeits-PC kernel: [ 7139.999214] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:36:01 Arbeits-PC kernel: [ 7139.999221]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:36:05 Arbeits-PC kernel: [ 7144.001457] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:36:05 Arbeits-PC kernel: [ 7144.001574]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:36:07 Arbeits-PC kernel: [ 7146.002579] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:36:07 Arbeits-PC kernel: [ 7146.002586]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:36:10 Arbeits-PC kernel: [ 7149.425430] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:36:10 Arbeits-PC kernel: [ 7149.425649]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:36:12 Arbeits-PC kernel: [ 7150.790516] survey done event(14)
Sep  9 09:36:15 Arbeits-PC kernel: [ 7154.007203] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:36:15 Arbeits-PC kernel: [ 7154.007210]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:36:19 Arbeits-PC kernel: [ 7158.009443] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:36:19 Arbeits-PC kernel: [ 7158.009692]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:36:21 Arbeits-PC kernel: [ 7160.010516] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:36:21 Arbeits-PC kernel: [ 7160.010522]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:36:33 Arbeits-PC kernel: [ 7172.017391] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:36:33 Arbeits-PC kernel: [ 7172.017509]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:36:37 Arbeits-PC kernel: [ 7176.019651] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:36:37 Arbeits-PC kernel: [ 7176.019658]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:36:43 Arbeits-PC kernel: [ 7182.022991] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:36:43 Arbeits-PC kernel: [ 7182.023111]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:36:45 Arbeits-PC kernel: [ 7184.024259] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:36:45 Arbeits-PC kernel: [ 7184.024266]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:36:51 Arbeits-PC kernel: [ 7190.027619] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:36:51 Arbeits-PC kernel: [ 7190.027865]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:36:53 Arbeits-PC kernel: [ 7192.028743] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:36:53 Arbeits-PC kernel: [ 7192.028749]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:36:59 Arbeits-PC kernel: [ 7198.032073] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:36:59 Arbeits-PC kernel: [ 7198.032194]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:37:01 Arbeits-PC kernel: [ 7200.033200] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:37:01 Arbeits-PC kernel: [ 7200.033207]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:37:03 Arbeits-PC kernel: [ 7202.034287] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:37:03 Arbeits-PC kernel: [ 7202.034396]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:37:05 Arbeits-PC kernel: [ 7204.035584] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:37:05 Arbeits-PC kernel: [ 7204.035590]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:37:19 Arbeits-PC kernel: [ 7218.043408] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:37:19 Arbeits-PC kernel: [ 7218.043526]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:37:21 Arbeits-PC kernel: [ 7220.044530] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:37:21 Arbeits-PC kernel: [ 7220.044537]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:37:27 Arbeits-PC kernel: [ 7226.048021] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:37:27 Arbeits-PC kernel: [ 7226.048091]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:37:37 Arbeits-PC kernel: [ 7236.053616] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:37:37 Arbeits-PC kernel: [ 7236.053622]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:37:39 Arbeits-PC kernel: [ 7238.054742] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:37:39 Arbeits-PC kernel: [ 7238.054855]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:37:45 Arbeits-PC kernel: [ 7244.058214] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:37:45 Arbeits-PC kernel: [ 7244.058221]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:37:51 Arbeits-PC kernel: [ 7250.061581] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:37:51 Arbeits-PC kernel: [ 7250.061708]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:37:53 Arbeits-PC kernel: [ 7252.062703] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:37:53 Arbeits-PC kernel: [ 7252.062709]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:37:57 Arbeits-PC kernel: [ 7256.064945] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:37:57 Arbeits-PC kernel: [ 7256.065066]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:37:59 Arbeits-PC kernel: [ 7258.066183] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:37:59 Arbeits-PC kernel: [ 7258.066189]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:38:05 Arbeits-PC kernel: [ 7264.069570] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:38:05 Arbeits-PC kernel: [ 7264.069817]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:38:12 Arbeits-PC kernel: [ 7270.606721] survey done event(15)
Sep  9 09:38:13 Arbeits-PC kernel: [ 7272.074024] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:38:13 Arbeits-PC kernel: [ 7272.074031]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:38:19 Arbeits-PC kernel: [ 7278.077482] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:38:19 Arbeits-PC kernel: [ 7278.077590]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:38:21 Arbeits-PC kernel: [ 7280.078658] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:38:21 Arbeits-PC kernel: [ 7280.078665]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:38:23 Arbeits-PC kernel: [ 7282.079715] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:38:23 Arbeits-PC kernel: [ 7282.079831]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:38:27 Arbeits-PC kernel: [ 7286.081992] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:38:27 Arbeits-PC kernel: [ 7286.081999]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:38:35 Arbeits-PC kernel: [ 7294.086481] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:38:35 Arbeits-PC kernel: [ 7294.086597]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:38:53 Arbeits-PC kernel: [ 7312.096681] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:38:53 Arbeits-PC kernel: [ 7312.096689]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:38:55 Arbeits-PC kernel: [ 7314.097783] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:38:55 Arbeits-PC kernel: [ 7314.097901]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:39:07 Arbeits-PC kernel: [ 7326.104679] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:39:07 Arbeits-PC kernel: [ 7326.104687]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:39:09 Arbeits-PC kernel: [ 7328.105740] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:39:09 Arbeits-PC kernel: [ 7328.105858]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:39:15 Arbeits-PC kernel: [ 7334.109137] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:39:15 Arbeits-PC kernel: [ 7334.109144]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:39:19 Arbeits-PC kernel: [ 7338.111454] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:39:19 Arbeits-PC kernel: [ 7338.111575]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:39:23 Arbeits-PC kernel: [ 7342.113768] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:39:23 Arbeits-PC kernel: [ 7342.113775]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:39:27 Arbeits-PC kernel: [ 7346.115920] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:39:27 Arbeits-PC kernel: [ 7346.116047]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:39:35 Arbeits-PC kernel: [ 7354.120608] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:39:35 Arbeits-PC kernel: [ 7354.120615]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:39:39 Arbeits-PC kernel: [ 7358.122766] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:39:39 Arbeits-PC kernel: [ 7358.122884]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:39:43 Arbeits-PC kernel: [ 7362.125036] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:39:43 Arbeits-PC kernel: [ 7362.125043]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:39:48 Arbeits-PC kernel: [ 7367.202847] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:39:48 Arbeits-PC kernel: [ 7367.203011]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:39:53 Arbeits-PC kernel: [ 7372.130816] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:39:53 Arbeits-PC kernel: [ 7372.130823]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:39:59 Arbeits-PC kernel: [ 7378.134524] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:39:59 Arbeits-PC kernel: [ 7378.134645]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:40:01 Arbeits-PC kernel: [ 7380.135275] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:40:01 Arbeits-PC kernel: [ 7380.135282]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:40:05 Arbeits-PC kernel: [ 7384.137515] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:40:05 Arbeits-PC kernel: [ 7384.137643]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:40:12 Arbeits-PC kernel: [ 7390.435283] survey done event(14)
Sep  9 09:40:17 Arbeits-PC kernel: [ 7396.144385] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:40:17 Arbeits-PC kernel: [ 7396.144392]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:40:19 Arbeits-PC kernel: [ 7398.145479] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:40:19 Arbeits-PC kernel: [ 7398.145615]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:40:27 Arbeits-PC kernel: [ 7406.149960] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:40:27 Arbeits-PC kernel: [ 7406.149967]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:40:29 Arbeits-PC kernel: [ 7408.151302] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:40:29 Arbeits-PC kernel: [ 7408.151412]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:40:33 Arbeits-PC kernel: [ 7412.153471] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:40:33 Arbeits-PC kernel: [ 7412.153478]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:40:35 Arbeits-PC kernel: [ 7414.154593] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:40:35 Arbeits-PC kernel: [ 7414.154838]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:40:37 Arbeits-PC kernel: [ 7416.155661] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:40:37 Arbeits-PC kernel: [ 7416.155668]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:40:39 Arbeits-PC kernel: [ 7418.156781] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:40:39 Arbeits-PC kernel: [ 7418.156886]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:40:41 Arbeits-PC kernel: [ 7420.157932] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:40:41 Arbeits-PC kernel: [ 7420.157938]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:40:45 Arbeits-PC kernel: [ 7424.160141] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:40:45 Arbeits-PC kernel: [ 7424.160248]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:40:47 Arbeits-PC kernel: [ 7426.161413] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:40:47 Arbeits-PC kernel: [ 7426.161419]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:40:49 Arbeits-PC kernel: [ 7428.162532] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:40:49 Arbeits-PC kernel: [ 7428.162653]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:40:51 Arbeits-PC kernel: [ 7430.163652] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:40:51 Arbeits-PC kernel: [ 7430.163659]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:40:57 Arbeits-PC kernel: [ 7436.167014] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:40:57 Arbeits-PC kernel: [ 7436.167135]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:41:01 Arbeits-PC kernel: [ 7440.169259] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:41:01 Arbeits-PC kernel: [ 7440.169266]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:41:09 Arbeits-PC kernel: [ 7448.173887] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:41:09 Arbeits-PC kernel: [ 7448.174135]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:41:11 Arbeits-PC kernel: [ 7450.174973] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:41:11 Arbeits-PC kernel: [ 7450.174979]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:41:20 Arbeits-PC kernel: [ 7458.179463] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:41:20 Arbeits-PC kernel: [ 7458.179582]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:41:22 Arbeits-PC kernel: [ 7460.180583] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:41:22 Arbeits-PC kernel: [ 7460.180586]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:41:30 Arbeits-PC kernel: [ 7468.185161] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:41:30 Arbeits-PC kernel: [ 7468.185286]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:41:32 Arbeits-PC kernel: [ 7470.186280] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:41:32 Arbeits-PC kernel: [ 7470.186287]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:41:36 Arbeits-PC kernel: [ 7474.188554] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:41:36 Arbeits-PC kernel: [ 7474.188674]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:41:42 Arbeits-PC kernel: [ 7480.191916] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:41:42 Arbeits-PC kernel: [ 7480.191923]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:41:44 Arbeits-PC kernel: [ 7482.193268] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:41:44 Arbeits-PC kernel: [ 7482.193363]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:41:54 Arbeits-PC kernel: [ 7492.198764] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:41:54 Arbeits-PC kernel: [ 7492.198771]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:41:56 Arbeits-PC kernel: [ 7494.199885] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:41:56 Arbeits-PC kernel: [ 7494.200002]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:42:00 Arbeits-PC kernel: [ 7498.202264] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:42:00 Arbeits-PC kernel: [ 7498.202268]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:42:10 Arbeits-PC kernel: [ 7508.207843] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:42:10 Arbeits-PC kernel: [ 7508.207965]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:42:12 Arbeits-PC kernel: [ 7510.263472] survey done event(16)
Sep  9 09:42:22 Arbeits-PC kernel: [ 7520.214719] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:42:22 Arbeits-PC kernel: [ 7520.214726]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:42:26 Arbeits-PC kernel: [ 7524.216959] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:42:26 Arbeits-PC kernel: [ 7524.217205]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:42:28 Arbeits-PC kernel: [ 7526.218080] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:42:28 Arbeits-PC kernel: [ 7526.218087]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:42:30 Arbeits-PC kernel: [ 7528.219203] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:42:30 Arbeits-PC kernel: [ 7528.219442]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:42:36 Arbeits-PC kernel: [ 7534.222517] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:42:36 Arbeits-PC kernel: [ 7534.222522]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:42:38 Arbeits-PC kernel: [ 7536.223626] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:42:38 Arbeits-PC kernel: [ 7536.223777]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:42:42 Arbeits-PC kernel: [ 7540.226046] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:42:42 Arbeits-PC kernel: [ 7540.226052]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:42:46 Arbeits-PC kernel: [ 7544.228242] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:42:46 Arbeits-PC kernel: [ 7544.228343]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:42:48 Arbeits-PC kernel: [ 7546.229385] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:42:48 Arbeits-PC kernel: [ 7546.229392]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:42:50 Arbeits-PC kernel: [ 7548.230523] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:42:50 Arbeits-PC kernel: [ 7548.230774]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:42:52 Arbeits-PC kernel: [ 7550.231592] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:42:52 Arbeits-PC kernel: [ 7550.231599]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:42:56 Arbeits-PC kernel: [ 7554.233874] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:42:56 Arbeits-PC kernel: [ 7554.233986]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:42:58 Arbeits-PC kernel: [ 7556.235133] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:42:58 Arbeits-PC kernel: [ 7556.235140]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:43:00 Arbeits-PC kernel: [ 7558.236253] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:43:00 Arbeits-PC kernel: [ 7558.236497]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:43:02 Arbeits-PC kernel: [ 7560.237374] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:43:02 Arbeits-PC kernel: [ 7560.237380]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:43:10 Arbeits-PC kernel: [ 7568.241801] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:43:10 Arbeits-PC kernel: [ 7568.241909]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:43:12 Arbeits-PC kernel: [ 7570.242953] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:43:12 Arbeits-PC kernel: [ 7570.242959]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:43:14 Arbeits-PC kernel: [ 7572.244075] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:43:14 Arbeits-PC kernel: [ 7572.244193]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:43:18 Arbeits-PC kernel: [ 7576.246458] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:43:18 Arbeits-PC kernel: [ 7576.246464]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:43:28 Arbeits-PC kernel: [ 7586.252040] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:43:28 Arbeits-PC kernel: [ 7586.252160]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:43:32 Arbeits-PC kernel: [ 7590.254281] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:43:32 Arbeits-PC kernel: [ 7590.254287]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:43:38 Arbeits-PC kernel: [ 7596.257735] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:43:38 Arbeits-PC kernel: [ 7596.257842]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:43:52 Arbeits-PC kernel: [ 7610.265556] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:43:52 Arbeits-PC kernel: [ 7610.265561]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:44:00 Arbeits-PC kernel: [ 7618.270237] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:44:00 Arbeits-PC kernel: [ 7618.270483]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:44:02 Arbeits-PC kernel: [ 7620.271354] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:44:02 Arbeits-PC kernel: [ 7620.271361]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:44:10 Arbeits-PC kernel: [ 7628.275826] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:44:10 Arbeits-PC kernel: [ 7628.275939]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:44:12 Arbeits-PC kernel: [ 7630.092033] survey done event(13)
Sep  9 09:44:12 Arbeits-PC kernel: [ 7630.277084] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:44:12 Arbeits-PC kernel: [ 7630.277091]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:44:14 Arbeits-PC kernel: [ 7632.278204] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:44:14 Arbeits-PC kernel: [ 7632.278453]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:44:16 Arbeits-PC kernel: [ 7634.279320] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:44:16 Arbeits-PC kernel: [ 7634.279326]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:44:20 Arbeits-PC kernel: [ 7638.282064] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:44:20 Arbeits-PC kernel: [ 7638.282284]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:44:40 Arbeits-PC kernel: [ 7658.292896] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:44:40 Arbeits-PC kernel: [ 7658.292902]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:44:42 Arbeits-PC kernel: [ 7660.293999] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:44:42 Arbeits-PC kernel: [ 7660.294112]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:44:46 Arbeits-PC kernel: [ 7664.296477] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:44:46 Arbeits-PC kernel: [ 7664.296485]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:45:00 Arbeits-PC kernel: [ 7678.304166] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:45:00 Arbeits-PC kernel: [ 7678.304267]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:45:02 Arbeits-PC kernel: [ 7680.305321] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:45:02 Arbeits-PC kernel: [ 7680.305327]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:45:06 Arbeits-PC kernel: [ 7684.307567] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:45:06 Arbeits-PC kernel: [ 7684.307681]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:45:42 Arbeits-PC kernel: [ 7720.327984] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:45:42 Arbeits-PC kernel: [ 7720.327990]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:45:44 Arbeits-PC kernel: [ 7722.329098] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:45:44 Arbeits-PC kernel: [ 7722.329213]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:45:48 Arbeits-PC kernel: [ 7726.331322] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:45:48 Arbeits-PC kernel: [ 7726.331327]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:46:00 Arbeits-PC kernel: [ 7738.338159] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:46:00 Arbeits-PC kernel: [ 7738.338252]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:46:02 Arbeits-PC kernel: [ 7740.339283] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:46:02 Arbeits-PC kernel: [ 7740.339288]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:46:04 Arbeits-PC kernel: [ 7742.340358] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:46:04 Arbeits-PC kernel: [ 7742.340480]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:46:08 Arbeits-PC kernel: [ 7746.342775] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:46:08 Arbeits-PC kernel: [ 7746.342780]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:46:10 Arbeits-PC kernel: [ 7748.565879] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:46:10 Arbeits-PC kernel: [ 7748.566043]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:46:12 Arbeits-PC kernel: [ 7749.932200] survey done event(14)
Sep  9 09:46:12 Arbeits-PC kernel: [ 7750.345053] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:46:12 Arbeits-PC kernel: [ 7750.345059]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:46:20 Arbeits-PC kernel: [ 7758.349480] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:46:20 Arbeits-PC kernel: [ 7758.349628]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:46:22 Arbeits-PC kernel: [ 7760.350624] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:46:22 Arbeits-PC kernel: [ 7760.350631]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:47:01 Arbeits-PC kernel: imklog 5.8.11, log source =
/proc/kmsg started.
Sep  9 09:47:01 Arbeits-PC rsyslogd: [origin software="rsyslogd"
swVersion="5.8.11" x-pid="639" x-info="http://www.rsyslog.com"] start
Sep  9 09:47:01 Arbeits-PC rsyslogd: rsyslogd's groupid changed to 103
Sep  9 09:47:01 Arbeits-PC rsyslogd: rsyslogd's userid changed to 101
Sep  9 09:47:01 Arbeits-PC rsyslogd-2039: Could not open output pipe
'/dev/xconsole' [try http://www.rsyslog.com/e/2039 ]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Initializing cgroup
subsys cpuset
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Initializing cgroup subsys cpu
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Linux version
3.8.0-30-generic (buildd@roseapple) (gcc version 4.7.3 (Ubuntu/Linaro
4.7.3-1ubuntu1) ) #44-Ubuntu SMP Thu Aug 22 20:52:24 UTC 2013 (Ubuntu
3.8.0-30.44-generic 3.8.13.6)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Command line:
BOOT_IMAGE=/boot/vmlinuz-3.8.0-30-generic
root=UUID=b44f3d14-b5d6-4775-a304-5d29e8fcd2db ro nomodeset
acpi_osi=Linux quiet splash vt.handoff=7
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] KERNEL supported cpus:
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   Intel GenuineIntel
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   AMD AuthenticAMD
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   Centaur CentaurHauls
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] e820: BIOS-provided
physical RAM map:
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x0000000000000000-0x000000000009efff] usable
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x000000000009f000-0x000000000009ffff] reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x0000000000100000-0x00000000deb8efff] usable
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000deb8f000-0x00000000df13efff] reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df13f000-0x00000000df383fff] ACPI NVS
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df384000-0x00000000df391fff] ACPI data
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df392000-0x00000000df3befff] ACPI NVS
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df3bf000-0x00000000df3c3fff] ACPI data
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df3c4000-0x00000000df406fff] ACPI NVS
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df407000-0x00000000df7fffff] usable
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000f8000000-0x00000000fbffffff] reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fec00000-0x00000000fec00fff] reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fed00000-0x00000000fed03fff] reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fed1c000-0x00000000fed1ffff] reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fee00000-0x00000000fee00fff] reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000ff000000-0x00000000ffffffff] reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x0000000100000000-0x000000021effffff] usable
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] NX (Execute Disable)
protection: active
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: EFI v2.31 by
American Megatrends
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi:
ACPI=0xdf384000  ACPI 2.0=0xdf384000  SMBIOS=0xdec27e98  MPS=0xfc980
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem00: type=3,
attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem01: type=7,
attr=0xf, range=[0x0000000000008000-0x0000000000048000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem02: type=4,
attr=0xf, range=[0x0000000000048000-0x0000000000059000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem03: type=7,
attr=0xf, range=[0x0000000000059000-0x000000000005f000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem04: type=4,
attr=0xf, range=[0x000000000005f000-0x0000000000060000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem05: type=3,
attr=0xf, range=[0x0000000000060000-0x000000000009f000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem06: type=6,
attr=0x800000000000000f, range=[0x000000000009f000-0x00000000000a0000)
(0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem07: type=7,
attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem08: type=2,
attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem09: type=4,
attr=0xf, range=[0x0000000001100000-0x0000000001984000) (8MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem10: type=3,
attr=0xf, range=[0x0000000001984000-0x0000000001986000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem11: type=4,
attr=0xf, range=[0x0000000001986000-0x0000000001988000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem12: type=3,
attr=0xf, range=[0x0000000001988000-0x000000000198c000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem13: type=4,
attr=0xf, range=[0x000000000198c000-0x0000000001991000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem14: type=3,
attr=0xf, range=[0x0000000001991000-0x000000000199e000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem15: type=4,
attr=0xf, range=[0x000000000199e000-0x0000000001da4000) (4MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem16: type=3,
attr=0xf, range=[0x0000000001da4000-0x0000000001da5000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem17: type=4,
attr=0xf, range=[0x0000000001da5000-0x0000000001da9000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem18: type=3,
attr=0xf, range=[0x0000000001da9000-0x0000000001daa000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem19: type=4,
attr=0xf, range=[0x0000000001daa000-0x0000000001daf000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem20: type=3,
attr=0xf, range=[0x0000000001daf000-0x0000000001db0000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem21: type=4,
attr=0xf, range=[0x0000000001db0000-0x0000000001db1000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem22: type=3,
attr=0xf, range=[0x0000000001db1000-0x0000000001db2000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem23: type=4,
attr=0xf, range=[0x0000000001db2000-0x0000000001dbf000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem24: type=3,
attr=0xf, range=[0x0000000001dbf000-0x0000000001dc0000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem25: type=4,
attr=0xf, range=[0x0000000001dc0000-0x0000000001dc1000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem26: type=3,
attr=0xf, range=[0x0000000001dc1000-0x0000000001dc7000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem27: type=4,
attr=0xf, range=[0x0000000001dc7000-0x0000000001dc9000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem28: type=3,
attr=0xf, range=[0x0000000001dc9000-0x0000000001dca000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem29: type=4,
attr=0xf, range=[0x0000000001dca000-0x0000000001dcf000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem30: type=3,
attr=0xf, range=[0x0000000001dcf000-0x0000000001dd1000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem31: type=4,
attr=0xf, range=[0x0000000001dd1000-0x0000000001dd7000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem32: type=3,
attr=0xf, range=[0x0000000001dd7000-0x0000000001dda000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem33: type=4,
attr=0xf, range=[0x0000000001dda000-0x0000000001ddc000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem34: type=3,
attr=0xf, range=[0x0000000001ddc000-0x0000000001dde000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem35: type=4,
attr=0xf, range=[0x0000000001dde000-0x0000000001ded000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem36: type=3,
attr=0xf, range=[0x0000000001ded000-0x0000000001def000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem37: type=4,
attr=0xf, range=[0x0000000001def000-0x0000000001df0000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem38: type=3,
attr=0xf, range=[0x0000000001df0000-0x0000000001df1000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem39: type=4,
attr=0xf, range=[0x0000000001df1000-0x0000000001df2000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem40: type=3,
attr=0xf, range=[0x0000000001df2000-0x0000000001df3000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem41: type=4,
attr=0xf, range=[0x0000000001df3000-0x0000000001df7000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem42: type=3,
attr=0xf, range=[0x0000000001df7000-0x0000000001df9000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem43: type=4,
attr=0xf, range=[0x0000000001df9000-0x0000000001dfd000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem44: type=3,
attr=0xf, range=[0x0000000001dfd000-0x0000000001dff000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem45: type=4,
attr=0xf, range=[0x0000000001dff000-0x0000000001e07000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem46: type=3,
attr=0xf, range=[0x0000000001e07000-0x0000000001e0b000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem47: type=4,
attr=0xf, range=[0x0000000001e0b000-0x0000000001e0d000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem48: type=3,
attr=0xf, range=[0x0000000001e0d000-0x0000000001e0f000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem49: type=4,
attr=0xf, range=[0x0000000001e0f000-0x0000000001e11000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem50: type=3,
attr=0xf, range=[0x0000000001e11000-0x0000000001e13000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem51: type=4,
attr=0xf, range=[0x0000000001e13000-0x0000000001e23000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem52: type=3,
attr=0xf, range=[0x0000000001e23000-0x0000000001e27000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem53: type=4,
attr=0xf, range=[0x0000000001e27000-0x0000000001e2d000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem54: type=3,
attr=0xf, range=[0x0000000001e2d000-0x0000000001e2e000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem55: type=4,
attr=0xf, range=[0x0000000001e2e000-0x0000000001e4d000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem56: type=3,
attr=0xf, range=[0x0000000001e4d000-0x0000000001e4e000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem57: type=4,
attr=0xf, range=[0x0000000001e4e000-0x0000000001e59000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem58: type=3,
attr=0xf, range=[0x0000000001e59000-0x0000000001e5d000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem59: type=4,
attr=0xf, range=[0x0000000001e5d000-0x0000000001e76000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem60: type=3,
attr=0xf, range=[0x0000000001e76000-0x0000000001e80000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem61: type=4,
attr=0xf, range=[0x0000000001e80000-0x0000000001e8f000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem62: type=3,
attr=0xf, range=[0x0000000001e8f000-0x0000000001e93000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem63: type=4,
attr=0xf, range=[0x0000000001e93000-0x0000000001e96000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem64: type=3,
attr=0xf, range=[0x0000000001e96000-0x0000000001e97000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem65: type=4,
attr=0xf, range=[0x0000000001e97000-0x00000000022ae000) (4MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem66: type=3,
attr=0xf, range=[0x00000000022ae000-0x00000000022b8000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem67: type=4,
attr=0xf, range=[0x00000000022b8000-0x00000000022c7000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem68: type=3,
attr=0xf, range=[0x00000000022c7000-0x00000000022cd000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem69: type=4,
attr=0xf, range=[0x00000000022cd000-0x00000000022d1000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem70: type=3,
attr=0xf, range=[0x00000000022d1000-0x00000000022d2000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem71: type=4,
attr=0xf, range=[0x00000000022d2000-0x00000000022d3000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem72: type=3,
attr=0xf, range=[0x00000000022d3000-0x00000000022d5000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem73: type=4,
attr=0xf, range=[0x00000000022d5000-0x00000000022d6000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem74: type=3,
attr=0xf, range=[0x00000000022d6000-0x00000000022d7000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem75: type=4,
attr=0xf, range=[0x00000000022d7000-0x00000000022de000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem76: type=3,
attr=0xf, range=[0x00000000022de000-0x00000000022df000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem77: type=4,
attr=0xf, range=[0x00000000022df000-0x00000000022fc000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem78: type=3,
attr=0xf, range=[0x00000000022fc000-0x0000000002309000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem79: type=4,
attr=0xf, range=[0x0000000002309000-0x0000000002317000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem80: type=3,
attr=0xf, range=[0x0000000002317000-0x000000000231c000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem81: type=4,
attr=0xf, range=[0x000000000231c000-0x0000000002320000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem82: type=3,
attr=0xf, range=[0x0000000002320000-0x0000000002324000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem83: type=4,
attr=0xf, range=[0x0000000002324000-0x000000000232a000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem84: type=3,
attr=0xf, range=[0x000000000232a000-0x000000000232d000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem85: type=4,
attr=0xf, range=[0x000000000232d000-0x0000000002344000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem86: type=3,
attr=0xf, range=[0x0000000002344000-0x0000000002348000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem87: type=4,
attr=0xf, range=[0x0000000002348000-0x000000000234b000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem88: type=3,
attr=0xf, range=[0x000000000234b000-0x0000000002351000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem89: type=4,
attr=0xf, range=[0x0000000002351000-0x0000000002362000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem90: type=3,
attr=0xf, range=[0x0000000002362000-0x0000000002363000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem91: type=4,
attr=0xf, range=[0x0000000002363000-0x0000000002367000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem92: type=3,
attr=0xf, range=[0x0000000002367000-0x0000000002374000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem93: type=4,
attr=0xf, range=[0x0000000002374000-0x000000000237b000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem94: type=3,
attr=0xf, range=[0x000000000237b000-0x000000000237e000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem95: type=4,
attr=0xf, range=[0x000000000237e000-0x0000000002386000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem96: type=3,
attr=0xf, range=[0x0000000002386000-0x0000000002389000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem97: type=4,
attr=0xf, range=[0x0000000002389000-0x0000000002391000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem98: type=3,
attr=0xf, range=[0x0000000002391000-0x0000000002395000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem99: type=4,
attr=0xf, range=[0x0000000002395000-0x000000000239e000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem100: type=3,
attr=0xf, range=[0x000000000239e000-0x00000000023a0000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem101: type=4,
attr=0xf, range=[0x00000000023a0000-0x00000000023a2000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem102: type=3,
attr=0xf, range=[0x00000000023a2000-0x00000000023aa000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem103: type=4,
attr=0xf, range=[0x00000000023aa000-0x00000000023b0000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem104: type=3,
attr=0xf, range=[0x00000000023b0000-0x00000000023c8000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem105: type=4,
attr=0xf, range=[0x00000000023c8000-0x00000000023cb000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem106: type=3,
attr=0xf, range=[0x00000000023cb000-0x00000000023ce000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem107: type=4,
attr=0xf, range=[0x00000000023ce000-0x00000000023d1000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem108: type=3,
attr=0xf, range=[0x00000000023d1000-0x00000000023d5000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem109: type=4,
attr=0xf, range=[0x00000000023d5000-0x00000000023d6000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem110: type=3,
attr=0xf, range=[0x00000000023d6000-0x00000000023da000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem111: type=4,
attr=0xf, range=[0x00000000023da000-0x00000000023dd000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem112: type=3,
attr=0xf, range=[0x00000000023dd000-0x00000000023df000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem113: type=4,
attr=0xf, range=[0x00000000023df000-0x00000000023e0000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem114: type=3,
attr=0xf, range=[0x00000000023e0000-0x00000000023e3000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem115: type=4,
attr=0xf, range=[0x00000000023e3000-0x00000000023ed000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem116: type=3,
attr=0xf, range=[0x00000000023ed000-0x00000000023f0000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem117: type=4,
attr=0xf, range=[0x00000000023f0000-0x00000000023fd000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem118: type=3,
attr=0xf, range=[0x00000000023fd000-0x00000000023ff000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem119: type=4,
attr=0xf, range=[0x00000000023ff000-0x0000000002403000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem120: type=3,
attr=0xf, range=[0x0000000002403000-0x0000000002409000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem121: type=4,
attr=0xf, range=[0x0000000002409000-0x0000000002410000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem122: type=3,
attr=0xf, range=[0x0000000002410000-0x0000000002417000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem123: type=4,
attr=0xf, range=[0x0000000002417000-0x0000000002445000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem124: type=3,
attr=0xf, range=[0x0000000002445000-0x000000000244c000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem125: type=4,
attr=0xf, range=[0x000000000244c000-0x0000000002465000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem126: type=3,
attr=0xf, range=[0x0000000002465000-0x0000000002471000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem127: type=4,
attr=0xf, range=[0x0000000002471000-0x0000000002479000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem128: type=3,
attr=0xf, range=[0x0000000002479000-0x000000000247d000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem129: type=4,
attr=0xf, range=[0x000000000247d000-0x0000000002480000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem130: type=3,
attr=0xf, range=[0x0000000002480000-0x00000000024bf000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem131: type=4,
attr=0xf, range=[0x00000000024bf000-0x00000000024e6000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem132: type=3,
attr=0xf, range=[0x00000000024e6000-0x000000000250b000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem133: type=4,
attr=0xf, range=[0x000000000250b000-0x0000000002534000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem134: type=3,
attr=0xf, range=[0x0000000002534000-0x000000000253c000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem135: type=4,
attr=0xf, range=[0x000000000253c000-0x000000000253e000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem136: type=3,
attr=0xf, range=[0x000000000253e000-0x0000000002540000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem137: type=4,
attr=0xf, range=[0x0000000002540000-0x0000000002554000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem138: type=3,
attr=0xf, range=[0x0000000002554000-0x0000000002555000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem139: type=4,
attr=0xf, range=[0x0000000002555000-0x0000000002556000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem140: type=3,
attr=0xf, range=[0x0000000002556000-0x000000000255b000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem141: type=4,
attr=0xf, range=[0x000000000255b000-0x000000000255e000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem142: type=3,
attr=0xf, range=[0x000000000255e000-0x000000000256d000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem143: type=4,
attr=0xf, range=[0x000000000256d000-0x0000000002572000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem144: type=3,
attr=0xf, range=[0x0000000002572000-0x0000000002574000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem145: type=4,
attr=0xf, range=[0x0000000002574000-0x0000000002575000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem146: type=3,
attr=0xf, range=[0x0000000002575000-0x0000000002576000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem147: type=4,
attr=0xf, range=[0x0000000002576000-0x000000000258e000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem148: type=3,
attr=0xf, range=[0x000000000258e000-0x0000000002590000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem149: type=4,
attr=0xf, range=[0x0000000002590000-0x0000000002598000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem150: type=3,
attr=0xf, range=[0x0000000002598000-0x00000000025a1000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem151: type=4,
attr=0xf, range=[0x00000000025a1000-0x00000000025c3000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem152: type=3,
attr=0xf, range=[0x00000000025c3000-0x00000000025d7000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem153: type=4,
attr=0xf, range=[0x00000000025d7000-0x00000000025db000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem154: type=3,
attr=0xf, range=[0x00000000025db000-0x00000000025dd000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem155: type=4,
attr=0xf, range=[0x00000000025dd000-0x00000000025e7000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem156: type=3,
attr=0xf, range=[0x00000000025e7000-0x00000000025ec000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem157: type=4,
attr=0xf, range=[0x00000000025ec000-0x00000000025ee000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem158: type=3,
attr=0xf, range=[0x00000000025ee000-0x00000000025f0000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem159: type=4,
attr=0xf, range=[0x00000000025f0000-0x00000000025f3000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem160: type=3,
attr=0xf, range=[0x00000000025f3000-0x00000000025f6000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem161: type=4,
attr=0xf, range=[0x00000000025f6000-0x00000000025fc000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem162: type=3,
attr=0xf, range=[0x00000000025fc000-0x00000000025ff000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem163: type=4,
attr=0xf, range=[0x00000000025ff000-0x00000000026b4000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem164: type=3,
attr=0xf, range=[0x00000000026b4000-0x0000000002ac2000) (4MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem165: type=4,
attr=0xf, range=[0x0000000002ac2000-0x000000000c361000) (152MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem166: type=3,
attr=0xf, range=[0x000000000c361000-0x000000000c367000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem167: type=4,
attr=0xf, range=[0x000000000c367000-0x000000000c371000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem168: type=3,
attr=0xf, range=[0x000000000c371000-0x000000000c373000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem169: type=4,
attr=0xf, range=[0x000000000c373000-0x000000000c4e4000) (1MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem170: type=3,
attr=0xf, range=[0x000000000c4e4000-0x000000000c503000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem171: type=4,
attr=0xf, range=[0x000000000c503000-0x000000000c5d7000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem172: type=7,
attr=0xf, range=[0x000000000c5d7000-0x000000000c5db000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem173: type=4,
attr=0xf, range=[0x000000000c5db000-0x000000000c5f3000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem174: type=7,
attr=0xf, range=[0x000000000c5f3000-0x000000000c605000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem175: type=1,
attr=0xf, range=[0x000000000c605000-0x000000000c623000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem176: type=2,
attr=0xf, range=[0x000000000c623000-0x000000000d967000) (19MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem177: type=7,
attr=0xf, range=[0x000000000d967000-0x000000000e000000) (6MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem178: type=2,
attr=0xf, range=[0x000000000e000000-0x000000000f344000) (19MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem179: type=7,
attr=0xf, range=[0x000000000f344000-0x00000000360fc000) (621MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem180: type=2,
attr=0xf, range=[0x00000000360fc000-0x0000000037076000) (15MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem181: type=7,
attr=0xf, range=[0x0000000037076000-0x00000000a9e70000) (1837MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem182: type=2,
attr=0xf, range=[0x00000000a9e70000-0x00000000deb8f000) (845MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem183: type=5,
attr=0x800000000000000f, range=[0x00000000deb8f000-0x00000000debd4000)
(0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem184: type=6,
attr=0x800000000000000f, range=[0x00000000debd4000-0x00000000dec04000)
(0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem185: type=5,
attr=0x800000000000000f, range=[0x00000000dec04000-0x00000000dec15000)
(0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem186: type=6,
attr=0x800000000000000f, range=[0x00000000dec15000-0x00000000dec25000)
(0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem187: type=6,
attr=0x800000000000000f, range=[0x00000000dec25000-0x00000000dec26000)
(0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem188: type=6,
attr=0x800000000000000f, range=[0x00000000dec26000-0x00000000dec27000)
(0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem189: type=6,
attr=0x800000000000000f, range=[0x00000000dec27000-0x00000000dec3f000)
(0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem190: type=0,
attr=0xf, range=[0x00000000dec3f000-0x00000000dee70000) (2MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem191: type=0,
attr=0xf, range=[0x00000000dee70000-0x00000000df13f000) (2MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem192:
type=10, attr=0xf, range=[0x00000000df13f000-0x00000000df300000) (1MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem193:
type=10, attr=0xf, range=[0x00000000df300000-0x00000000df384000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem194: type=9,
attr=0xf, range=[0x00000000df384000-0x00000000df392000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem195:
type=10, attr=0xf, range=[0x00000000df392000-0x00000000df3a3000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem196:
type=10, attr=0xf, range=[0x00000000df3a3000-0x00000000df3b0000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem197:
type=10, attr=0xf, range=[0x00000000df3b0000-0x00000000df3bf000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem198: type=9,
attr=0xf, range=[0x00000000df3bf000-0x00000000df3c3000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem199: type=9,
attr=0xf, range=[0x00000000df3c3000-0x00000000df3c4000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem200:
type=10, attr=0xf, range=[0x00000000df3c4000-0x00000000df407000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem201: type=4,
attr=0xf, range=[0x00000000df407000-0x00000000df54d000) (1MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem202: type=3,
attr=0xf, range=[0x00000000df54d000-0x00000000df7db000) (2MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem203: type=4,
attr=0xf, range=[0x00000000df7db000-0x00000000df7e3000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem204: type=3,
attr=0xf, range=[0x00000000df7e3000-0x00000000df7ed000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem205: type=4,
attr=0xf, range=[0x00000000df7ed000-0x00000000df800000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem206: type=7,
attr=0xf, range=[0x0000000100000000-0x000000021f000000) (4592MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem207:
type=11, attr=0x8000000000000001,
range=[0x00000000f8000000-0x00000000fc000000) (64MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem208:
type=11, attr=0x8000000000000001,
range=[0x00000000fec00000-0x00000000fec01000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem209:
type=11, attr=0x8000000000000001,
range=[0x00000000fed00000-0x00000000fed04000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem210:
type=11, attr=0x8000000000000001,
range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem211:
type=11, attr=0x8000000000000001,
range=[0x00000000fee00000-0x00000000fee01000) (0MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] efi: mem212:
type=11, attr=0x8000000000000001,
range=[0x00000000ff000000-0x0000000100000000) (16MB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] SMBIOS 2.6 present.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] DMI: System
manufacturer System Product Name/Maximus IV GENE-Z, BIOS 3603
11/09/2012
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] e820: update [mem
0x00000000-0x0000ffff] usable ==> reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] e820: remove [mem
0x000a0000-0x000fffff] usable
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] No AGP bridge found
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] e820: last_pfn =
0x21f000 max_arch_pfn = 0x400000000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] MTRR default type: uncachable
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] MTRR fixed ranges enabled:
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   00000-9FFFF write-back
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   A0000-BFFFF uncachable
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   C0000-D3FFF write-protect
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   D4000-DFFFF uncachable
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   E0000-E7FFF write-through
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   E8000-FFFFF write-protect
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] MTRR variable ranges enabled:
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   0 base 000000000
mask E00000000 write-back
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   1 base 200000000
mask FF0000000 write-back
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   2 base 210000000
mask FF8000000 write-back
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   3 base 218000000
mask FFC000000 write-back
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   4 base 21C000000
mask FFE000000 write-back
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   5 base 21E000000
mask FFF000000 write-back
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   6 base 0E0000000
mask FE0000000 uncachable
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   7 disabled
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   8 disabled
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   9 disabled
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] x86 PAT enabled: cpu
0, old 0x7040600070406, new 0x7010600070106
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] original variable MTRRs
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 0, base: 0GB,
range: 8GB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 1, base: 8GB,
range: 256MB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 2, base: 8448MB,
range: 128MB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 3, base: 8576MB,
range: 64MB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 4, base: 8640MB,
range: 32MB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 5, base: 8672MB,
range: 16MB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 6, base: 3584MB,
range: 512MB, type UC
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] total RAM covered: 8176M
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Found optimal
setting for mtrr clean up
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]  gran_size: 64K
chunk_size: 32M num_reg: 6   lose cover RAM: 0G
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] New variable MTRRs
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 0, base: 0GB,
range: 2GB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 1, base: 2GB,
range: 1GB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 2, base: 3GB,
range: 512MB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 3, base: 4GB,
range: 4GB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 4, base: 8GB,
range: 512MB, type WB
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] reg 5, base: 8688MB,
range: 16MB, type UC
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] e820: update [mem
0xe0000000-0xffffffff] usable ==> reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] e820: last_pfn =
0xdf800 max_arch_pfn = 0x400000000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] found SMP MP-table
at [mem 0x000fccf0-0x000fccff] mapped at [ffff8800000fccf0]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] initial memory
mapped: [mem 0x00000000-0x1fffffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Base memory
trampoline at [ffff880000097000] 97000 size 24576
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0x00000000-0xdf7fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]  [mem
0x00000000-0xdf7fffff] page 2M
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] kernel direct
mapping tables up to 0xdf7fffff @ [mem 0x1fffb000-0x1fffffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0x100000000-0x21effffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]  [mem
0x100000000-0x21effffff] page 2M
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] kernel direct
mapping tables up to 0x21effffff @ [mem 0xdeb89000-0xdeb8efff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] RAMDISK: [mem
0x360fc000-0x37075fff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: RSDP
00000000df384000 00024 (v02 ALASKA)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: XSDT
00000000df384070 0005C (v01 ALASKA    A M I 01072009 AMI  00010013)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: FACP
00000000df38fc70 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: DSDT
00000000df384168 0BB02 (v02 ALASKA    A M I 00000015 INTL 20051117)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: FACS
00000000df3bdf80 00040
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: APIC
00000000df38fd68 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: MCFG
00000000df38fde0 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: HPET
00000000df38fe20 00038 (v01 ALASKA    A M I 01072009 AMI. 00000005)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: SSDT
00000000df38fe58 0036D (v01 SataRe SataTabl 00001000 INTL 20091112)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: SSDT
00000000df3901c8 00926 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: SSDT
00000000df390af0 00A92 (v01  PmRef    CpuPm 00003000 INTL 20051117)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] No NUMA configuration found
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Faking a node at
[mem 0x0000000000000000-0x000000021effffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Initmem setup node 0
[mem 0x00000000-0x21effffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   NODE_DATA [mem
0x21effb000-0x21effffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]
[ffffea0000000000-ffffea00087fffff] PMD ->
[ffff880216600000-ffff88021e5fffff] on node 0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Zone ranges:
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   DMA      [mem
0x00010000-0x00ffffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   DMA32    [mem
0x01000000-0xffffffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   Normal   [mem
0x100000000-0x21effffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Movable zone start
for each node
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Early memory node ranges
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0x00010000-0x0009efff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0x00100000-0xdeb8efff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0xdf407000-0xdf7fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0x100000000-0x21effffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] On node 0 totalpages: 2088727
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   DMA zone: 64 pages
used for memmap
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   DMA zone: 29 pages reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   DMA zone: 3890
pages, LIFO batch:0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   DMA32 zone: 14207
pages used for memmap
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   DMA32 zone: 894985
pages, LIFO batch:31
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   Normal zone: 18368
pages used for memmap
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000]   Normal zone:
1157184 pages, LIFO batch:31
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x00] enabled)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x02] lapic_id[0x02] enabled)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x03] lapic_id[0x04] enabled)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x04] lapic_id[0x06] enabled)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0xff] high edge lint[0x1])
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: IOAPIC
(id[0x02] address[0xfec00000] gsi_base[0])
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] IOAPIC[0]: apic_id
2, version 32, address 0xfec00000, GSI 0-23
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 0 global_irq 2 dfl dfl)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 9 global_irq 9 high level)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: IRQ0 used by override.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: IRQ2 used by override.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: IRQ9 used by override.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Using ACPI (MADT)
for SMP configuration information
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] ACPI: HPET id:
0x8086a701 base: 0xfed00000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] smpboot: Allowing 4
CPUs, 0 hotplug CPUs
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] nr_irqs_gsi: 40
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 000000000009f000 - 00000000000a0000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000000a0000 - 0000000000100000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000deb8f000 - 00000000df13f000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df13f000 - 00000000df384000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df384000 - 00000000df392000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df392000 - 00000000df3bf000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df3bf000 - 00000000df3c4000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df3c4000 - 00000000df407000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df800000 - 00000000f8000000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000f8000000 - 00000000fc000000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fc000000 - 00000000fec00000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fec00000 - 00000000fec01000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fec01000 - 00000000fed00000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fed00000 - 00000000fed04000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fed04000 - 00000000fed1c000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fed1c000 - 00000000fed20000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fed20000 - 00000000fee00000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fee00000 - 00000000fee01000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fee01000 - 00000000ff000000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000ff000000 - 0000000100000000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] e820: [mem
0xdf800000-0xf7ffffff] available for PCI devices
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Booting
paravirtualized kernel on bare hardware
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] setup_percpu:
NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PERCPU: Embedded 28
pages/cpu @ffff88021ec00000 s85056 r8192 d21440 u524288
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] pcpu-alloc: s85056
r8192 d21440 u524288 alloc=1*2097152
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Built 1 zonelists in
Zone order, mobility grouping on.  Total pages: 2056059
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Policy zone: Normal
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-3.8.0-30-generic
root=UUID=b44f3d14-b5d6-4775-a304-5d29e8fcd2db ro nomodeset
acpi_osi=Linux quiet splash vt.handoff=7
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] PID hash table
entries: 4096 (order: 3, 32768 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] __ex_table already
sorted, skipping sort
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] xsave: enabled
xstate_bv 0x7, cntxt size 0x340
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Checking aperture...
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] No AGP bridge found
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Calgary: detecting
Calgary via BIOS EBDA area
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Calgary: Unable to
locate Rio Grande table in EBDA - bailing!
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Memory:
7936200k/8896512k available (7014k kernel code, 541604k absent,
418708k reserved, 6229k data, 996k init)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] SLUB: Genslabs=15,
HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Hierarchical RCU
implementation.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] RCU dyntick-idle
grace-period acceleration is enabled.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] RCU restricting CPUs
from NR_CPUS=256 to nr_cpu_ids=4.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] NR_IRQS:16640 nr_irqs:712 16
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Extended CMOS year: 2000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] Console: colour
dummy device 80x25
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] console [tty0] enabled
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] allocated 33554432
bytes of page_cgroup
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] please try
'cgroup_disable=memory' option if you don't want memory cgroups
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] hpet clockevent registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000000] tsc: Fast TSC
calibration using PIT
Sep  9 09:47:01 Arbeits-PC kernel: [    0.004000] tsc: Detected
2809.174 MHz processor
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000001] Calibrating delay
loop (skipped), value calculated using timer frequency.. 5618.34
BogoMIPS (lpj=11236696)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.000004] pid_max: default:
32768 minimum: 301
Sep  9 09:47:01 Arbeits-PC kernel: [    0.010729] Security Framework initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    0.010736] AppArmor: AppArmor initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    0.010737] Yama: becoming mindful.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.011168] Dentry cache hash
table entries: 1048576 (order: 11, 8388608 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.012546] Inode-cache hash
table entries: 524288 (order: 10, 4194304 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013142] Mount-cache hash
table entries: 256
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013267] Initializing cgroup
subsys cpuacct
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013268] Initializing cgroup
subsys memory
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013273] Initializing cgroup
subsys devices
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013274] Initializing cgroup
subsys freezer
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013275] Initializing cgroup
subsys blkio
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013276] Initializing cgroup
subsys perf_event
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013278] Initializing cgroup
subsys hugetlb
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013298] CPU: Physical Processor ID: 0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013299] CPU: Processor Core ID: 0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013303] ENERGY_PERF_BIAS:
Set to 'normal', was 'performance'
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013303] ENERGY_PERF_BIAS:
View and update with x86_energy_perf_policy(8)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013305] mce: CPU supports 9 MCE banks
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013316] CPU0: Thermal
monitoring enabled (TM1)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013322] process: using mwait
in idle threads
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013324] Last level iTLB
entries: 4KB 512, 2MB 0, 4MB 0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013324] Last level dTLB
entries: 4KB 512, 2MB 32, 4MB 32
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013324] tlb_flushall_shift: 5
Sep  9 09:47:01 Arbeits-PC kernel: [    0.013443] Freeing SMP
alternatives: 24k freed
Sep  9 09:47:01 Arbeits-PC kernel: [    0.015577] ACPI: Core revision 20121018
Sep  9 09:47:01 Arbeits-PC kernel: [    0.241402] ftrace: allocating
26715 entries in 105 pages
Sep  9 09:47:01 Arbeits-PC kernel: [    0.253143] ..TIMER: vector=0x30
apic1=0 pin1=2 apic2=-1 pin2=-1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.292771] smpboot: CPU0:
Intel(R) Core(TM) i5-2300 CPU @ 2.80GHz (fam: 06, model: 2a, stepping:
07)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.292778] TSC deadline timer enabled
Sep  9 09:47:01 Arbeits-PC kernel: [    0.292781] Performance Events:
PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.292786] ... version:                3
Sep  9 09:47:01 Arbeits-PC kernel: [    0.292787] ... bit width:              48
Sep  9 09:47:01 Arbeits-PC kernel: [    0.292788] ... generic registers:      8
Sep  9 09:47:01 Arbeits-PC kernel: [    0.292789] ... value mask:
       0000ffffffffffff
Sep  9 09:47:01 Arbeits-PC kernel: [    0.292790] ... max period:
       000000007fffffff
Sep  9 09:47:01 Arbeits-PC kernel: [    0.292791] ... fixed-purpose events:   3
Sep  9 09:47:01 Arbeits-PC kernel: [    0.292792] ... event mask:
       00000007000000ff
Sep  9 09:47:01 Arbeits-PC kernel: [    0.306630] NMI watchdog:
enabled on all CPUs, permanently consumes one hw-PMU counter.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.293562] smpboot: Booting
Node   0, Processors  #1 #2 #3 OK
Sep  9 09:47:01 Arbeits-PC kernel: [    0.333007] Brought up 4 CPUs
Sep  9 09:47:01 Arbeits-PC kernel: [    0.333010] smpboot: Total of 4
processors activated (22473.39 BogoMIPS)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.335921] devtmpfs: initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    0.336736] EVM: security.selinux
Sep  9 09:47:01 Arbeits-PC kernel: [    0.336737] EVM: security.SMACK64
Sep  9 09:47:01 Arbeits-PC kernel: [    0.336738] EVM: security.capability
Sep  9 09:47:01 Arbeits-PC kernel: [    0.336776] PM: Registering ACPI
NVS region [mem 0xdf13f000-0xdf383fff] (2379776 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.336803] PM: Registering ACPI
NVS region [mem 0xdf392000-0xdf3befff] (184320 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.336807] PM: Registering ACPI
NVS region [mem 0xdf3c4000-0xdf406fff] (274432 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.337411] regulator-dummy: no parameters
Sep  9 09:47:01 Arbeits-PC kernel: [    0.337446] NET: Registered
protocol family 16
Sep  9 09:47:01 Arbeits-PC kernel: [    0.337568] ACPI FADT declares
the system doesn't support PCIe ASPM, so disable it
Sep  9 09:47:01 Arbeits-PC kernel: [    0.337570] ACPI: bus type pci registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.337609] PCI: MMCONFIG for
domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base
0xf8000000)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.337611] PCI: MMCONFIG at
[mem 0xf8000000-0xfbffffff] reserved in E820
Sep  9 09:47:01 Arbeits-PC kernel: [    0.342661] PCI: Using
configuration type 1 for base access
Sep  9 09:47:01 Arbeits-PC kernel: [    0.343335] bio: create slab <bio-0> at 0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.343394] ACPI: Added
_OSI(Module Device)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.343395] ACPI: Added
_OSI(Processor Device)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.343396] ACPI: Added _OSI(3.0
_SCP Extensions)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.343398] ACPI: Added
_OSI(Processor Aggregator Device)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.343399] ACPI: Added _OSI(Linux)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.344729] ACPI: EC: Look up EC in DSDT
Sep  9 09:47:01 Arbeits-PC kernel: [    0.346020] ACPI: Executed 1
blocks of module-level executable AML code
Sep  9 09:47:01 Arbeits-PC kernel: [    0.348608] ACPI: SSDT
00000000df0ec018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.348945] ACPI: Dynamic OEM Table Load:
Sep  9 09:47:01 Arbeits-PC kernel: [    0.348947] ACPI: SSDT
(null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.349166] ACPI: SSDT
00000000df0eda98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.349525] ACPI: Dynamic OEM Table Load:
Sep  9 09:47:01 Arbeits-PC kernel: [    0.349527] ACPI: SSDT
(null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.349644] ACPI: SSDT
00000000df0eec18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.349980] ACPI: Dynamic OEM Table Load:
Sep  9 09:47:01 Arbeits-PC kernel: [    0.349982] ACPI: SSDT
(null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.350444] ACPI: Interpreter enabled
Sep  9 09:47:01 Arbeits-PC kernel: [    0.350448] ACPI: (supports S0
S1 S3 S4 S5)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.350464] ACPI: Using IOAPIC
for interrupt routing
Sep  9 09:47:01 Arbeits-PC kernel: [    0.354351] ACPI: Power Resource
[FN00] (off)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.354404] ACPI: Power Resource
[FN01] (off)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.354456] ACPI: Power Resource
[FN02] (off)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.354507] ACPI: Power Resource
[FN03] (off)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.354558] ACPI: Power Resource
[FN04] (off)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.354798] ACPI: EC: GPE =
0x18, I/O: command/status = 0x66, data = 0x62
Sep  9 09:47:01 Arbeits-PC kernel: [    0.354925] ACPI: No dock devices found.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.354928] PCI: Using host
bridge windows from ACPI; if necessary, use "pci=nocrs" and report a
bug
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355118] ACPI: PCI Root
Bridge [PCI0] (domain 0000 [bus 00-3e])
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355120] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0._PRT]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355243] \_SB_.PCI0:_OSC invalid UUID
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355244] _OSC request data:1 8 0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355611] PCI host bridge to bus 0000:00
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355614] pci_bus 0000:00:
root bus resource [bus 00-3e]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355616] pci_bus 0000:00:
root bus resource [io  0x0000-0x0cf7]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355617] pci_bus 0000:00:
root bus resource [io  0x0d00-0xffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355619] pci_bus 0000:00:
root bus resource [mem 0x000a0000-0x000bffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355620] pci_bus 0000:00:
root bus resource [mem 0x000d4000-0x000d7fff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355622] pci_bus 0000:00:
root bus resource [mem 0x000d8000-0x000dbfff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355623] pci_bus 0000:00:
root bus resource [mem 0x000dc000-0x000dffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355624] pci_bus 0000:00:
root bus resource [mem 0xe0000000-0xfeafffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355632] pci 0000:00:00.0:
[8086:0100] type 00 class 0x060000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355663] pci 0000:00:01.0:
[8086:0101] type 01 class 0x060400
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355690] pci 0000:00:01.0:
PME# supported from D0 D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355732] pci 0000:00:16.0:
[8086:1c3a] type 00 class 0x078000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355756] pci 0000:00:16.0:
reg 10: [mem 0xf742c000-0xf742c00f 64bit]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355830] pci 0000:00:16.0:
PME# supported from D0 D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355859] pci 0000:00:19.0:
[8086:1503] type 00 class 0x020000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355876] pci 0000:00:19.0:
reg 10: [mem 0xf7400000-0xf741ffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355885] pci 0000:00:19.0:
reg 14: [mem 0xf7429000-0xf7429fff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355893] pci 0000:00:19.0:
reg 18: [io  0xf040-0xf05f]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355953] pci 0000:00:19.0:
PME# supported from D0 D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355978] pci 0000:00:1a.0:
[8086:1c2d] type 00 class 0x0c0320
Sep  9 09:47:01 Arbeits-PC kernel: [    0.355999] pci 0000:00:1a.0:
reg 10: [mem 0xf7428000-0xf74283ff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356086] pci 0000:00:1a.0:
PME# supported from D0 D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356111] pci 0000:00:1b.0:
[8086:1c20] type 00 class 0x040300
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356125] pci 0000:00:1b.0:
reg 10: [mem 0xf7420000-0xf7423fff 64bit]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356189] pci 0000:00:1b.0:
PME# supported from D0 D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356214] pci 0000:00:1c.0:
[8086:1c10] type 01 class 0x060400
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356339] pci 0000:00:1c.0:
PME# supported from D0 D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356374] pci 0000:00:1c.4:
[8086:1c18] type 01 class 0x060400
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356448] pci 0000:00:1c.4:
PME# supported from D0 D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356472] pci 0000:00:1c.5:
[8086:1c1a] type 01 class 0x060400
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356546] pci 0000:00:1c.5:
PME# supported from D0 D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356568] pci 0000:00:1c.6:
[8086:1c1c] type 01 class 0x060400
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356643] pci 0000:00:1c.6:
PME# supported from D0 D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356672] pci 0000:00:1d.0:
[8086:1c26] type 00 class 0x0c0320
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356692] pci 0000:00:1d.0:
reg 10: [mem 0xf7427000-0xf74273ff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356778] pci 0000:00:1d.0:
PME# supported from D0 D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356803] pci 0000:00:1f.0:
[8086:1c44] type 00 class 0x060100
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356924] pci 0000:00:1f.2:
[8086:1c02] type 00 class 0x010601
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356941] pci 0000:00:1f.2:
reg 10: [io  0xf090-0xf097]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356949] pci 0000:00:1f.2:
reg 14: [io  0xf080-0xf083]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356956] pci 0000:00:1f.2:
reg 18: [io  0xf070-0xf077]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356964] pci 0000:00:1f.2:
reg 1c: [io  0xf060-0xf063]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356971] pci 0000:00:1f.2:
reg 20: [io  0xf020-0xf03f]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.356983] pci 0000:00:1f.2:
reg 24: [mem 0xf7426000-0xf74267ff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357025] pci 0000:00:1f.2:
PME# supported from D3hot
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357043] pci 0000:00:1f.3:
[8086:1c22] type 00 class 0x0c0500
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357058] pci 0000:00:1f.3:
reg 10: [mem 0xf7425000-0xf74250ff 64bit]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357078] pci 0000:00:1f.3:
reg 20: [io  0x0580-0x059f]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357130] pci 0000:01:00.0:
[10de:11c0] type 00 class 0x030000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357139] pci 0000:01:00.0:
reg 10: [mem 0xf6000000-0xf6ffffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357149] pci 0000:01:00.0:
reg 14: [mem 0xe8000000-0xefffffff 64bit pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357159] pci 0000:01:00.0:
reg 1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357166] pci 0000:01:00.0:
reg 24: [io  0xe000-0xe07f]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357173] pci 0000:01:00.0:
reg 30: [mem 0xf7000000-0xf707ffff pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357228] pci 0000:01:00.1:
[10de:0e0b] type 00 class 0x040300
Sep  9 09:47:01 Arbeits-PC kernel: [    0.357237] pci 0000:01:00.1:
reg 10: [mem 0xf7080000-0xf7083fff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.364993] pci 0000:00:01.0:
PCI bridge to [bus 01]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.364995] pci 0000:00:01.0:
bridge window [io  0xe000-0xefff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.364997] pci 0000:00:01.0:
bridge window [mem 0xf6000000-0xf70fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.365000] pci 0000:00:01.0:
bridge window [mem 0xe8000000-0xf1ffffff 64bit pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.365070] pci 0000:00:1c.0:
PCI bridge to [bus 02]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.365153] pci 0000:03:00.0:
[1b21:1042] type 00 class 0x0c0330
Sep  9 09:47:01 Arbeits-PC kernel: [    0.365182] pci 0000:03:00.0:
reg 10: [mem 0xf7300000-0xf7307fff 64bit]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.365327] pci 0000:03:00.0:
PME# supported from D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.372988] pci 0000:00:1c.4:
PCI bridge to [bus 03]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.372994] pci 0000:00:1c.4:
bridge window [mem 0xf7300000-0xf73fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.373068] pci 0000:04:00.0:
[1b21:1042] type 00 class 0x0c0330
Sep  9 09:47:01 Arbeits-PC kernel: [    0.373096] pci 0000:04:00.0:
reg 10: [mem 0xf7200000-0xf7207fff 64bit]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.373242] pci 0000:04:00.0:
PME# supported from D3hot D3cold
Sep  9 09:47:01 Arbeits-PC kernel: [    0.380980] pci 0000:00:1c.5:
PCI bridge to [bus 04]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.380985] pci 0000:00:1c.5:
bridge window [mem 0xf7200000-0xf72fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.381052] pci 0000:05:00.0:
[197b:2362] type 00 class 0x010185
Sep  9 09:47:01 Arbeits-PC kernel: [    0.381087] pci 0000:05:00.0:
reg 10: [io  0xd040-0xd047]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.381102] pci 0000:05:00.0:
reg 14: [io  0xd030-0xd033]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.381118] pci 0000:05:00.0:
reg 18: [io  0xd020-0xd027]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.381134] pci 0000:05:00.0:
reg 1c: [io  0xd010-0xd013]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.381150] pci 0000:05:00.0:
reg 20: [io  0xd000-0xd00f]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.381165] pci 0000:05:00.0:
reg 24: [mem 0xf7110000-0xf71101ff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.381182] pci 0000:05:00.0:
reg 30: [mem 0x00000000-0x0000ffff pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.381243] pci 0000:05:00.0:
PME# supported from D3hot
Sep  9 09:47:01 Arbeits-PC kernel: [    0.388970] pci 0000:00:1c.6:
PCI bridge to [bus 05]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.388973] pci 0000:00:1c.6:
bridge window [io  0xd000-0xdfff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.388977] pci 0000:00:1c.6:
bridge window [mem 0xf7100000-0xf71fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389023] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.RP01._PRT]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389056] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.RP05._PRT]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389080] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.RP06._PRT]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389105] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.RP07._PRT]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389135] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.PEG0._PRT]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389217] \_SB_.PCI0:_OSC invalid UUID
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389218] _OSC request data:1 1f 0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389221]  pci0000:00: ACPI
_OSC support notification failed, disabling PCIe ASPM
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389222]  pci0000:00: Unable
to request _OSC control (_OSC support mask: 0x08)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389852] ACPI: PCI Interrupt
Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389889] ACPI: PCI Interrupt
Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389922] ACPI: PCI Interrupt
Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389955] ACPI: PCI Interrupt
Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.389988] ACPI: PCI Interrupt
Link [LNKE] (IRQs 3 *4 5 6 10 11 12 14 15)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390022] ACPI: PCI Interrupt
Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390055] ACPI: PCI Interrupt
Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390088] ACPI: PCI Interrupt
Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390158] vgaarb: device
added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390159] vgaarb: loaded
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390160] vgaarb: bridge
control possible 0000:01:00.0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390276] SCSI subsystem initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390278] ACPI: bus type scsi registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390300] libata version 3.00 loaded.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390314] ACPI: bus type usb registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390326] usbcore: registered
new interface driver usbfs
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390331] usbcore: registered
new interface driver hub
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390343] usbcore: registered
new device driver usb
Sep  9 09:47:01 Arbeits-PC kernel: [    0.390397] PCI: Using ACPI for
IRQ routing
Sep  9 09:47:01 Arbeits-PC kernel: [    0.391837] PCI:
pci_cache_line_size set to 64 bytes
Sep  9 09:47:01 Arbeits-PC kernel: [    0.391896] e820: reserve RAM
buffer [mem 0x0009f000-0x0009ffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.391897] e820: reserve RAM
buffer [mem 0xdeb8f000-0xdfffffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.391899] e820: reserve RAM
buffer [mem 0xdf800000-0xdfffffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.391900] e820: reserve RAM
buffer [mem 0x21f000000-0x21fffffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.391956] NetLabel: Initializing
Sep  9 09:47:01 Arbeits-PC kernel: [    0.391958] NetLabel:  domain
hash size = 128
Sep  9 09:47:01 Arbeits-PC kernel: [    0.391958] NetLabel:  protocols
= UNLABELED CIPSOv4
Sep  9 09:47:01 Arbeits-PC kernel: [    0.391966] NetLabel:  unlabeled
traffic allowed by default
Sep  9 09:47:01 Arbeits-PC kernel: [    0.392008] hpet0: at MMIO
0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.392013] hpet0: 8
comparators, 64-bit 14.318180 MHz counter
Sep  9 09:47:01 Arbeits-PC kernel: [    0.394021] Switching to clocksource hpet
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397753] AppArmor: AppArmor
Filesystem Enabled
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397770] pnp: PnP ACPI init
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397780] ACPI: bus type pnp registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397842] system 00:00: [mem
0xfed40000-0xfed44fff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397845] system 00:00: Plug
and Play ACPI device, IDs PNP0c01 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397854] pnp 00:01: [dma 4]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397865] pnp 00:01: Plug and
Play ACPI device, IDs PNP0200 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397878] pnp 00:02: Plug and
Play ACPI device, IDs INT0800 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397948] pnp 00:03: Plug and
Play ACPI device, IDs PNP0103 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397980] system 00:04: [io
0x0680-0x069f] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397982] system 00:04: [io
0x0200-0x020f] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397984] system 00:04: [io
0xffff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397985] system 00:04: [io
0xffff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397987] system 00:04: [io
0x0400-0x0453] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397988] system 00:04: [io
0x0458-0x047f] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397990] system 00:04: [io
0x0500-0x057f] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397991] system 00:04: [io
0x164e-0x164f] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.397993] system 00:04: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398014] pnp 00:05: Plug and
Play ACPI device, IDs PNP0b00 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398058] system 00:06: [io
0x0454-0x0457] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398061] system 00:06: Plug
and Play ACPI device, IDs INT3f0d PNP0c02 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398122] system 00:07: [io
0x0290-0x029f] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398124] system 00:07: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398159] system 00:08: [io
0x04d0-0x04d1] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398162] system 00:08: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398179] pnp 00:09: Plug and
Play ACPI device, IDs PNP0c04 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398393] system 00:0a: [mem
0xfed1c000-0xfed1ffff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398395] system 00:0a: [mem
0xfed10000-0xfed17fff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398397] system 00:0a: [mem
0xfed18000-0xfed18fff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398398] system 00:0a: [mem
0xfed19000-0xfed19fff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398400] system 00:0a: [mem
0xf8000000-0xfbffffff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398402] system 00:0a: [mem
0xfed20000-0xfed3ffff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398403] system 00:0a: [mem
0xfed90000-0xfed93fff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398405] system 00:0a: [mem
0xfed45000-0xfed8ffff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398406] system 00:0a: [mem
0xff000000-0xffffffff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398408] system 00:0a: [mem
0xfee00000-0xfeefffff] could not be reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398410] system 00:0a: [mem
0xe0000000-0xe0000fff] has been reserved
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398412] system 00:0a: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398510] pnp: PnP ACPI: found
11 devices
Sep  9 09:47:01 Arbeits-PC kernel: [    0.398511] ACPI: ACPI bus type
pnp unregistered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404254] pci 0000:00:1c.0:
bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404257] pci 0000:00:1c.0:
bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02]
add_size 200000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404259] pci 0000:00:1c.0:
bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404284] pci 0000:00:1c.0:
res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404286] pci 0000:00:1c.0:
res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size
add_size 200000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404288] pci 0000:00:1c.0:
res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404291] pci 0000:00:1c.0:
BAR 14: assigned [mem 0xe0100000-0xe02fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404294] pci 0000:00:1c.0:
BAR 15: assigned [mem 0xe0300000-0xe04fffff 64bit pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404296] pci 0000:00:1c.6:
BAR 15: assigned [mem 0xe0500000-0xe05fffff pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404298] pci 0000:00:1c.0:
BAR 13: assigned [io  0x2000-0x2fff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404301] pci 0000:00:01.0:
PCI bridge to [bus 01]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404303] pci 0000:00:01.0:
bridge window [io  0xe000-0xefff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404305] pci 0000:00:01.0:
bridge window [mem 0xf6000000-0xf70fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404307] pci 0000:00:01.0:
bridge window [mem 0xe8000000-0xf1ffffff 64bit pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404310] pci 0000:00:1c.0:
PCI bridge to [bus 02]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404314] pci 0000:00:1c.0:
bridge window [io  0x2000-0x2fff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404320] pci 0000:00:1c.0:
bridge window [mem 0xe0100000-0xe02fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404325] pci 0000:00:1c.0:
bridge window [mem 0xe0300000-0xe04fffff 64bit pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404333] pci 0000:00:1c.4:
PCI bridge to [bus 03]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404338] pci 0000:00:1c.4:
bridge window [mem 0xf7300000-0xf73fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404346] pci 0000:00:1c.5:
PCI bridge to [bus 04]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404351] pci 0000:00:1c.5:
bridge window [mem 0xf7200000-0xf72fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404359] pci 0000:05:00.0:
BAR 6: assigned [mem 0xe0500000-0xe050ffff pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404361] pci 0000:00:1c.6:
PCI bridge to [bus 05]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404364] pci 0000:00:1c.6:
bridge window [io  0xd000-0xdfff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404369] pci 0000:00:1c.6:
bridge window [mem 0xf7100000-0xf71fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404372] pci 0000:00:1c.6:
bridge window [mem 0xe0500000-0xe05fffff pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404406] pci_bus 0000:00:
resource 4 [io  0x0000-0x0cf7]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404407] pci_bus 0000:00:
resource 5 [io  0x0d00-0xffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404409] pci_bus 0000:00:
resource 6 [mem 0x000a0000-0x000bffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404410] pci_bus 0000:00:
resource 7 [mem 0x000d4000-0x000d7fff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404412] pci_bus 0000:00:
resource 8 [mem 0x000d8000-0x000dbfff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404413] pci_bus 0000:00:
resource 9 [mem 0x000dc000-0x000dffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404415] pci_bus 0000:00:
resource 10 [mem 0xe0000000-0xfeafffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404416] pci_bus 0000:01:
resource 0 [io  0xe000-0xefff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404418] pci_bus 0000:01:
resource 1 [mem 0xf6000000-0xf70fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404419] pci_bus 0000:01:
resource 2 [mem 0xe8000000-0xf1ffffff 64bit pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404421] pci_bus 0000:02:
resource 0 [io  0x2000-0x2fff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404422] pci_bus 0000:02:
resource 1 [mem 0xe0100000-0xe02fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404424] pci_bus 0000:02:
resource 2 [mem 0xe0300000-0xe04fffff 64bit pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404425] pci_bus 0000:03:
resource 1 [mem 0xf7300000-0xf73fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404427] pci_bus 0000:04:
resource 1 [mem 0xf7200000-0xf72fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404428] pci_bus 0000:05:
resource 0 [io  0xd000-0xdfff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404430] pci_bus 0000:05:
resource 1 [mem 0xf7100000-0xf71fffff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404431] pci_bus 0000:05:
resource 2 [mem 0xe0500000-0xe05fffff pref]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404456] NET: Registered
protocol family 2
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404590] TCP established hash
table entries: 65536 (order: 8, 1048576 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404757] TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404868] TCP: Hash tables
configured (established 65536 bind 65536)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404884] TCP: reno registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404893] UDP hash table
entries: 4096 (order: 5, 131072 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404917] UDP-Lite hash table
entries: 4096 (order: 5, 131072 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.404965] NET: Registered
protocol family 1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.446002] pci 0000:01:00.0:
Boot video device
Sep  9 09:47:01 Arbeits-PC kernel: [    0.446090] PCI: CLS 64 bytes, default 64
Sep  9 09:47:01 Arbeits-PC kernel: [    0.446118] Trying to unpack
rootfs image as initramfs...
Sep  9 09:47:01 Arbeits-PC kernel: [    0.660562] Freeing initrd
memory: 15848k freed
Sep  9 09:47:01 Arbeits-PC kernel: [    0.662208] PCI-DMA: Using
software bounce buffering for IO (SWIOTLB)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.662212] software IO TLB [mem
0xdab89000-0xdeb89000] (64MB) mapped at
[ffff8800dab89000-ffff8800deb88fff]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.662537] Initialise module verification
Sep  9 09:47:01 Arbeits-PC kernel: [    0.662568] audit: initializing
netlink socket (disabled)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.662581] type=2000
audit(1378712820.448:1): initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    0.684943] HugeTLB registered 2
MB page size, pre-allocated 0 pages
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686006] VFS: Disk quotas dquot_6.5.2
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686034] Dquot-cache hash
table entries: 512 (order 0, 4096 bytes)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686344] fuse init (API version 7.20)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686393] msgmni has been set to 15901
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686698] Key type asymmetric registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686700] Asymmetric key
parser 'x509' registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686720] Block layer SCSI
generic (bsg) driver version 0.4 loaded (major 252)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686738] io scheduler noop registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686740] io scheduler
deadline registered (default)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686743] io scheduler cfq registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.686821] pcieport
0000:00:01.0: irq 40 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.687025] pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Sep  9 09:47:01 Arbeits-PC kernel: [    0.687034] pciehp: PCI Express
Hot Plug Controller Driver version: 0.4
Sep  9 09:47:01 Arbeits-PC kernel: [    0.687073] efifb: probing for efifb
Sep  9 09:47:01 Arbeits-PC kernel: [    0.687262] efifb: framebuffer
at 0xf1000000, mapped to 0xffffc9000a000000, using 1920k, total 1920k
Sep  9 09:47:01 Arbeits-PC kernel: [    0.687263] efifb: mode is
800x600x32, linelength=3200, pages=1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.687264] efifb: scrolling: redraw
Sep  9 09:47:01 Arbeits-PC kernel: [    0.687265] efifb: Truecolor:
size=8:8:8:8, shift=24:16:8:0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.688175] Console: switching
to colour frame buffer device 100x37
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689030] fb0: EFI VGA frame
buffer device
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689034] intel_idle: MWAIT
substates: 0x1120
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689035] intel_idle: v0.4 model 0x2A
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689036] intel_idle:
lapic_timer_reliable_states 0xffffffff
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689097] input: Power Button
as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689102] ACPI: Power Button [PWRB]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689126] input: Power Button
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689128] ACPI: Power Button [PWRF]
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689179] ACPI: Fan [FAN0] (off)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689198] ACPI: Fan [FAN1] (off)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689214] ACPI: Fan [FAN2] (off)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689232] ACPI: Fan [FAN3] (off)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689248] ACPI: Fan [FAN4] (off)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.689289] ACPI: Requesting acpi_cpufreq
Sep  9 09:47:01 Arbeits-PC kernel: [    0.692301] thermal LNXTHERM:00:
registered as thermal_zone0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.692303] ACPI: Thermal Zone
[TZ00] (28 C)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.692461] thermal LNXTHERM:01:
registered as thermal_zone1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.692462] ACPI: Thermal Zone
[TZ01] (30 C)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.692492] GHES: HEST is not enabled!
Sep  9 09:47:01 Arbeits-PC kernel: [    0.692536] Serial: 8250/16550
driver, 32 ports, IRQ sharing enabled
Sep  9 09:47:01 Arbeits-PC kernel: [    0.693356] Linux agpgart interface v0.103
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694216] brd: module loaded
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694612] loop: module loaded
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694820] libphy: Fixed MDIO Bus: probed
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694859] tun: Universal
TUN/TAP device driver, 1.6
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694860] tun: (C) 1999-2004
Max Krasnyansky <maxk@qualcomm.com>
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694881] PPP generic driver
version 2.4.2
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694906] ehci_hcd: USB 2.0
'Enhanced' Host Controller (EHCI) Driver
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694907] ehci-pci: EHCI PCI
platform driver
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694935] ehci-pci
0000:00:1a.0: setting latency timer to 64
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694938] ehci-pci
0000:00:1a.0: EHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694942] ehci-pci
0000:00:1a.0: new USB bus registered, assigned bus number 1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.694954] ehci-pci
0000:00:1a.0: debug port 2
Sep  9 09:47:01 Arbeits-PC kernel: [    0.698840] ehci-pci
0000:00:1a.0: cache line size of 64 is not supported
Sep  9 09:47:01 Arbeits-PC kernel: [    0.698855] ehci-pci
0000:00:1a.0: irq 16, io mem 0xf7428000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709604] ehci-pci
0000:00:1a.0: USB 2.0 started, EHCI 1.00
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709618] usb usb1: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709619] usb usb1: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709621] usb usb1: Product:
EHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709622] usb usb1:
Manufacturer: Linux 3.8.0-30-generic ehci_hcd
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709624] usb usb1:
SerialNumber: 0000:00:1a.0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709690] hub 1-0:1.0: USB hub found
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709693] hub 1-0:1.0: 2 ports detected
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709781] ehci-pci
0000:00:1d.0: setting latency timer to 64
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709784] ehci-pci
0000:00:1d.0: EHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709787] ehci-pci
0000:00:1d.0: new USB bus registered, assigned bus number 2
Sep  9 09:47:01 Arbeits-PC kernel: [    0.709798] ehci-pci
0000:00:1d.0: debug port 2
Sep  9 09:47:01 Arbeits-PC kernel: [    0.713679] ehci-pci
0000:00:1d.0: cache line size of 64 is not supported
Sep  9 09:47:01 Arbeits-PC kernel: [    0.713691] ehci-pci
0000:00:1d.0: irq 23, io mem 0xf7427000
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725579] ehci-pci
0000:00:1d.0: USB 2.0 started, EHCI 1.00
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725588] usb usb2: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725590] usb usb2: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725591] usb usb2: Product:
EHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725592] usb usb2:
Manufacturer: Linux 3.8.0-30-generic ehci_hcd
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725594] usb usb2:
SerialNumber: 0000:00:1d.0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725649] hub 2-0:1.0: USB hub found
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725652] hub 2-0:1.0: 2 ports detected
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725718] ehci-platform: EHCI
generic platform driver
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725723] ohci_hcd: USB 1.1
'Open' Host Controller (OHCI) Driver
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725731] uhci_hcd: USB
Universal Host Controller Interface driver
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725762] xhci_hcd
0000:03:00.0: xHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.725765] xhci_hcd
0000:03:00.0: new USB bus registered, assigned bus number 3
Sep  9 09:47:01 Arbeits-PC kernel: [    0.786856] xhci_hcd
0000:03:00.0: irq 41 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.786861] xhci_hcd
0000:03:00.0: irq 42 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.786865] xhci_hcd
0000:03:00.0: irq 43 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.786868] xhci_hcd
0000:03:00.0: irq 44 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.786872] xhci_hcd
0000:03:00.0: irq 45 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.786959] usb usb3: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 09:47:01 Arbeits-PC kernel: [    0.786960] usb usb3: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.786962] usb usb3: Product:
xHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.786963] usb usb3:
Manufacturer: Linux 3.8.0-30-generic xhci_hcd
Sep  9 09:47:01 Arbeits-PC kernel: [    0.786964] usb usb3:
SerialNumber: 0000:03:00.0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787010] xHCI
xhci_add_endpoint called for root hub
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787011] xHCI
xhci_check_bandwidth called for root hub
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787025] hub 3-0:1.0: USB hub found
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787031] hub 3-0:1.0: 2 ports detected
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787072] xhci_hcd
0000:03:00.0: xHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787075] xhci_hcd
0000:03:00.0: new USB bus registered, assigned bus number 4
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787108] usb usb4: New USB
device found, idVendor=1d6b, idProduct=0003
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787110] usb usb4: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787111] usb usb4: Product:
xHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787112] usb usb4:
Manufacturer: Linux 3.8.0-30-generic xhci_hcd
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787114] usb usb4:
SerialNumber: 0000:03:00.0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787150] xHCI
xhci_add_endpoint called for root hub
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787152] xHCI
xhci_check_bandwidth called for root hub
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787163] hub 4-0:1.0: USB hub found
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787169] hub 4-0:1.0: 2 ports detected
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787264] xhci_hcd
0000:04:00.0: xHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.787269] xhci_hcd
0000:04:00.0: new USB bus registered, assigned bus number 5
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848360] xhci_hcd
0000:04:00.0: irq 46 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848365] xhci_hcd
0000:04:00.0: irq 47 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848369] xhci_hcd
0000:04:00.0: irq 48 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848373] xhci_hcd
0000:04:00.0: irq 49 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848377] xhci_hcd
0000:04:00.0: irq 50 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848465] usb usb5: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848466] usb usb5: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848468] usb usb5: Product:
xHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848469] usb usb5:
Manufacturer: Linux 3.8.0-30-generic xhci_hcd
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848471] usb usb5:
SerialNumber: 0000:04:00.0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848516] xHCI
xhci_add_endpoint called for root hub
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848517] xHCI
xhci_check_bandwidth called for root hub
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848531] hub 5-0:1.0: USB hub found
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848537] hub 5-0:1.0: 2 ports detected
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848582] xhci_hcd
0000:04:00.0: xHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848585] xhci_hcd
0000:04:00.0: new USB bus registered, assigned bus number 6
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848614] usb usb6: New USB
device found, idVendor=1d6b, idProduct=0003
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848615] usb usb6: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848617] usb usb6: Product:
xHCI Host Controller
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848618] usb usb6:
Manufacturer: Linux 3.8.0-30-generic xhci_hcd
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848619] usb usb6:
SerialNumber: 0000:04:00.0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848656] xHCI
xhci_add_endpoint called for root hub
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848658] xHCI
xhci_check_bandwidth called for root hub
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848670] hub 6-0:1.0: USB hub found
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848676] hub 6-0:1.0: 2 ports detected
Sep  9 09:47:01 Arbeits-PC kernel: [    0.848775] i8042: PNP: No PS/2
controller found. Probing ports directly.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851227] serio: i8042 KBD
port at 0x60,0x64 irq 1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851232] serio: i8042 AUX
port at 0x60,0x64 irq 12
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851311] mousedev: PS/2 mouse
device common for all mice
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851403] rtc_cmos 00:05: RTC
can wake from S4
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851506] rtc_cmos 00:05: rtc
core: registered rtc_cmos as rtc0
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851532] rtc0: alarms up to
one month, y3k, 242 bytes nvram, hpet irqs
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851587] device-mapper:
uevent: version 1.0.3
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851625] device-mapper:
ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851667] cpuidle: using governor ladder
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851721] cpuidle: using governor menu
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851724] ledtrig-cpu:
registered to indicate activity on CPUs
Sep  9 09:47:01 Arbeits-PC kernel: [    0.851726] EFI Variables
Facility v0.08 2004-May-17
Sep  9 09:47:01 Arbeits-PC kernel: [    0.901135] ashmem: initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    0.901278] TCP: cubic registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.901353] NET: Registered
protocol family 10
Sep  9 09:47:01 Arbeits-PC kernel: [    0.901466] NET: Registered
protocol family 17
Sep  9 09:47:01 Arbeits-PC kernel: [    0.901473] Key type
dns_resolver registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.901801] Loading module
verification certificates
Sep  9 09:47:01 Arbeits-PC kernel: [    0.902548] MODSIGN: Loaded cert
'Magrathea: Glacier signing key:
3a8155c013f798de7084673b6e86215ebed17697'
Sep  9 09:47:01 Arbeits-PC kernel: [    0.902556] registered taskstats version 1
Sep  9 09:47:01 Arbeits-PC kernel: [    0.904587] Key type trusted registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.906216] Key type encrypted registered
Sep  9 09:47:01 Arbeits-PC kernel: [    0.908184] rtc_cmos 00:05:
setting system clock to 2013-09-09 07:47:00 UTC (1378712820)
Sep  9 09:47:01 Arbeits-PC kernel: [    0.908728] BIOS EDD facility
v0.16 2004-Jun-25, 0 devices found
Sep  9 09:47:01 Arbeits-PC kernel: [    0.908730] EDD information not available.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.909859] Freeing unused
kernel memory: 996k freed
Sep  9 09:47:01 Arbeits-PC kernel: [    0.909946] Write protecting the
kernel read-only data: 12288k
Sep  9 09:47:01 Arbeits-PC kernel: [    0.912249] Freeing unused
kernel memory: 1168k freed
Sep  9 09:47:01 Arbeits-PC kernel: [    0.914349] Freeing unused
kernel memory: 1076k freed
Sep  9 09:47:01 Arbeits-PC kernel: [    0.934678] Disabling lock
debugging due to kernel taint
Sep  9 09:47:01 Arbeits-PC kernel: [    0.935079] e1000e: Intel(R)
PRO/1000 Network Driver - 2.1.4-k
Sep  9 09:47:01 Arbeits-PC kernel: [    0.935081] e1000e: Copyright(c)
1999 - 2012 Intel Corporation.
Sep  9 09:47:01 Arbeits-PC kernel: [    0.935111] e1000e 0000:00:19.0:
setting latency timer to 64
Sep  9 09:47:01 Arbeits-PC kernel: [    0.935165] e1000e 0000:00:19.0:
Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
Sep  9 09:47:01 Arbeits-PC kernel: [    0.935195] e1000e 0000:00:19.0:
irq 51 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    1.021169] usb 1-1: new
high-speed USB device number 2 using ehci-pci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.153266] usb 1-1: New USB
device found, idVendor=8087, idProduct=0024
Sep  9 09:47:01 Arbeits-PC kernel: [    1.153268] usb 1-1: New USB
device strings: Mfr=0, Product=0, SerialNumber=0
Sep  9 09:47:01 Arbeits-PC kernel: [    1.153535] hub 1-1:1.0: USB hub found
Sep  9 09:47:01 Arbeits-PC kernel: [    1.153636] hub 1-1:1.0: 6 ports detected
Sep  9 09:47:01 Arbeits-PC kernel: [    1.195128] e1000e 0000:00:19.0
eth0: (PCI Express:2.5GT/s:Width x1) 54:04:a6:2a:65:f6
Sep  9 09:47:01 Arbeits-PC kernel: [    1.195131] e1000e 0000:00:19.0
eth0: Intel(R) PRO/1000 Network Connection
Sep  9 09:47:01 Arbeits-PC kernel: [    1.195178] e1000e 0000:00:19.0
eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
Sep  9 09:47:01 Arbeits-PC kernel: [    1.195213] ahci 0000:00:1f.2: version 3.0
Sep  9 09:47:01 Arbeits-PC kernel: [    1.195283] ahci 0000:00:1f.2:
irq 52 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    1.208924] ahci 0000:00:1f.2:
AHCI 0001.0300 32 slots 6 ports 6 Gbps 0xb impl SATA mode
Sep  9 09:47:01 Arbeits-PC kernel: [    1.208927] ahci 0000:00:1f.2:
flags: 64bit ncq led clo pio slum part ems apst
Sep  9 09:47:01 Arbeits-PC kernel: [    1.208932] ahci 0000:00:1f.2:
setting latency timer to 64
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225180] scsi0 : ahci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225306] scsi1 : ahci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225428] scsi2 : ahci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225530] scsi3 : ahci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225629] scsi4 : ahci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225730] scsi5 : ahci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225788] ata1: SATA max
UDMA/133 abar m2048@0xf7426000 port 0xf7426100 irq 52
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225791] ata2: SATA max
UDMA/133 abar m2048@0xf7426000 port 0xf7426180 irq 52
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225792] ata3: DUMMY
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225794] ata4: SATA max
UDMA/133 abar m2048@0xf7426000 port 0xf7426280 irq 52
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225795] ata5: DUMMY
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225795] ata6: DUMMY
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225913] ahci 0000:05:00.0:
AHCI 0001.0100 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
Sep  9 09:47:01 Arbeits-PC kernel: [    1.225916] ahci 0000:05:00.0:
flags: 64bit ncq pm led clo pmp pio slum part
Sep  9 09:47:01 Arbeits-PC kernel: [    1.226129] scsi6 : ahci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.226202] scsi7 : ahci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.226233] ata7: SATA max
UDMA/133 abar m512@0xf7110000 port 0xf7110100 irq 18
Sep  9 09:47:01 Arbeits-PC kernel: [    1.226237] ata8: SATA max
UDMA/133 abar m512@0xf7110000 port 0xf7110180 irq 18
Sep  9 09:47:01 Arbeits-PC kernel: [    1.264817] usb 2-1: new
high-speed USB device number 2 using ehci-pci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.397064] usb 2-1: New USB
device found, idVendor=8087, idProduct=0024
Sep  9 09:47:01 Arbeits-PC kernel: [    1.397067] usb 2-1: New USB
device strings: Mfr=0, Product=0, SerialNumber=0
Sep  9 09:47:01 Arbeits-PC kernel: [    1.397308] hub 2-1:1.0: USB hub found
Sep  9 09:47:01 Arbeits-PC kernel: [    1.397411] hub 2-1:1.0: 8 ports detected
Sep  9 09:47:01 Arbeits-PC kernel: [    1.544447] ata8: SATA link down
(SStatus 0 SControl 300)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.544449] ata1: SATA link up
6.0 Gbps (SStatus 133 SControl 300)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.544494] ata4: SATA link up
1.5 Gbps (SStatus 113 SControl 300)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.544500] ata7: SATA link down
(SStatus 0 SControl 300)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.547558] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.547562] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT3._GTF] (Node
ffff8802130b2438), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.547570] ata4.00: ATAPI:
HL-DT-ST DVDRAM GH22LS50, TL02, max UDMA/100
Sep  9 09:47:01 Arbeits-PC kernel: [    1.551336] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.551340] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT3._GTF] (Node
ffff8802130b2438), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.551348] ata4.00: configured
for UDMA/100
Sep  9 09:47:01 Arbeits-PC kernel: [    1.552411] ata2: SATA link up
3.0 Gbps (SStatus 123 SControl 300)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.553160] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.553165] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node
ffff8802130b2348), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.553337] ata2.00: HPA
detected: current 1250261615, native 1250263728
Sep  9 09:47:01 Arbeits-PC kernel: [    1.553461] ata2.00: ATA-8: WDC
WD6400AAKS-07A7B0, 01.03B01, max UDMA/133
Sep  9 09:47:01 Arbeits-PC kernel: [    1.553463] ata2.00: 1250261615
sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Sep  9 09:47:01 Arbeits-PC kernel: [    1.554353] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.554357] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node
ffff8802130b2348), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.554652] ata2.00: configured
for UDMA/133
Sep  9 09:47:01 Arbeits-PC kernel: [    1.555516] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.555520] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node
ffff8802130b22d0), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.556353] ata1.00: ATA-8:
SanDisk SDSSDX120GG25, R112, max UDMA/133
Sep  9 09:47:01 Arbeits-PC kernel: [    1.556355] ata1.00: 234441648
sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Sep  9 09:47:01 Arbeits-PC kernel: [    1.564392] usb 3-1: new
high-speed USB device number 2 using xhci_hcd
Sep  9 09:47:01 Arbeits-PC kernel: [    1.565501] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.565506] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node
ffff8802130b22d0), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566285] ata1.00: configured
for UDMA/133
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566435] scsi 0:0:0:0:
Direct-Access     ATA      SanDisk SDSSDX12 R112 PQ: 0 ANSI: 5
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566545] sd 0:0:0:0: [sda]
234441648 512-byte logical blocks: (120 GB/111 GiB)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566570] sd 0:0:0:0: Attached
scsi generic sg0 type 0
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566591] sd 0:0:0:0: [sda]
Write Protect is off
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566593] sd 0:0:0:0: [sda]
Mode Sense: 00 3a 00 00
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566605] sd 0:0:0:0: [sda]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566758] scsi 1:0:0:0:
Direct-Access     ATA      WDC WD6400AAKS-0 01.0 PQ: 0 ANSI: 5
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566872] sd 1:0:0:0: Attached
scsi generic sg1 type 0
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566874] sd 1:0:0:0: [sdb]
1250261615 512-byte logical blocks: (640 GB/596 GiB)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566938] sd 1:0:0:0: [sdb]
Write Protect is off
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566941] sd 1:0:0:0: [sdb]
Mode Sense: 00 3a 00 00
Sep  9 09:47:01 Arbeits-PC kernel: [    1.566991] sd 1:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep  9 09:47:01 Arbeits-PC kernel: [    1.567452]  sda: sda1 sda2 sda3
Sep  9 09:47:01 Arbeits-PC kernel: [    1.567643] sd 0:0:0:0: [sda]
Attached SCSI disk
Sep  9 09:47:01 Arbeits-PC kernel: [    1.570319] scsi 3:0:0:0: CD-ROM
           HL-DT-ST DVDRAM GH22LS50  TL02 PQ: 0 ANSI: 5
Sep  9 09:47:01 Arbeits-PC kernel: [    1.578741] sr0: scsi3-mmc
drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Sep  9 09:47:01 Arbeits-PC kernel: [    1.578743] cdrom: Uniform
CD-ROM driver Revision: 3.20
Sep  9 09:47:01 Arbeits-PC kernel: [    1.578840] sr 3:0:0:0: Attached
scsi CD-ROM sr0
Sep  9 09:47:01 Arbeits-PC kernel: [    1.578887] sr 3:0:0:0: Attached
scsi generic sg2 type 5
Sep  9 09:47:01 Arbeits-PC kernel: [    1.581334] usb 3-1: New USB
device found, idVendor=1058, idProduct=1021
Sep  9 09:47:01 Arbeits-PC kernel: [    1.581336] usb 3-1: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Sep  9 09:47:01 Arbeits-PC kernel: [    1.581338] usb 3-1: Product: Ext HDD 1021
Sep  9 09:47:01 Arbeits-PC kernel: [    1.581339] usb 3-1:
Manufacturer: Western Digital
Sep  9 09:47:01 Arbeits-PC kernel: [    1.581340] usb 3-1:
SerialNumber: 574D43315430333633353930
Sep  9 09:47:01 Arbeits-PC kernel: [    1.583543] Initializing USB
Mass Storage driver...
Sep  9 09:47:01 Arbeits-PC kernel: [    1.583633] scsi8 : usb-storage 3-1:1.0
Sep  9 09:47:01 Arbeits-PC kernel: [    1.583669] usbcore: registered
new interface driver usb-storage
Sep  9 09:47:01 Arbeits-PC kernel: [    1.583670] USB Mass Storage
support registered.
Sep  9 09:47:01 Arbeits-PC kernel: [    1.624169] EXT4-fs (sda2):
mounted filesystem with ordered data mode. Opts: (null)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.638174]  sdb: sdb1
Sep  9 09:47:01 Arbeits-PC kernel: [    1.638550] sd 1:0:0:0: [sdb]
Attached SCSI disk
Sep  9 09:47:01 Arbeits-PC kernel: [    1.660248] tsc: Refined TSC
clocksource calibration: 2809.165 MHz
Sep  9 09:47:01 Arbeits-PC kernel: [    1.660252] Switching to clocksource tsc
Sep  9 09:47:01 Arbeits-PC kernel: [    1.748107] usb 3-2: new
high-speed USB device number 3 using xhci_hcd
Sep  9 09:47:01 Arbeits-PC kernel: [    1.765020] usb 3-2: New USB
device found, idVendor=1058, idProduct=1001
Sep  9 09:47:01 Arbeits-PC kernel: [    1.765023] usb 3-2: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Sep  9 09:47:01 Arbeits-PC kernel: [    1.765025] usb 3-2: Product:
External HDD
Sep  9 09:47:01 Arbeits-PC kernel: [    1.765026] usb 3-2:
Manufacturer: Western Digital
Sep  9 09:47:01 Arbeits-PC kernel: [    1.765027] usb 3-2:
SerialNumber: 574341553433313736393333
Sep  9 09:47:01 Arbeits-PC kernel: [    1.765808] scsi9 : usb-storage 3-2:1.0
Sep  9 09:47:01 Arbeits-PC kernel: [    1.836264] usb 1-1.3: new
high-speed USB device number 3 using ehci-pci
Sep  9 09:47:01 Arbeits-PC kernel: [    1.861997] Adding 8354812k swap
on /dev/sda3.  Priority:-1 extents:1 across:8354812k SS
Sep  9 09:47:01 Arbeits-PC kernel: [    1.867221] IPv6:
ADDRCONF(NETDEV_UP): eth0: link is not ready
Sep  9 09:47:01 Arbeits-PC kernel: [    1.869807] EXT4-fs (sda2):
re-mounted. Opts: errors=remount-ro
Sep  9 09:47:01 Arbeits-PC kernel: [    1.897215] lp: driver loaded
but no devices found
Sep  9 09:47:01 Arbeits-PC kernel: [    1.923361] mei 0000:00:16.0:
setting latency timer to 64
Sep  9 09:47:01 Arbeits-PC kernel: [    1.923411] mei 0000:00:16.0:
irq 53 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930763] ACPI Warning:
0x0000000000000428-0x000000000000042f SystemIO conflicts with Region
\PMIO 1 (20121018/utaddress-251)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930768] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930771] ACPI Warning:
0x0000000000000540-0x000000000000054f SystemIO conflicts with Region
\GPIO 1 (20121018/utaddress-251)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930774] ACPI Warning:
0x0000000000000540-0x000000000000054f SystemIO conflicts with Region
\_SB_.PCI0.LPCB.GPBX 2 (20121018/utaddress-251)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930776] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930777] ACPI Warning:
0x0000000000000530-0x000000000000053f SystemIO conflicts with Region
\GPIO 1 (20121018/utaddress-251)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930779] ACPI Warning:
0x0000000000000530-0x000000000000053f SystemIO conflicts with Region
\_SB_.PCI0.LPCB.GPBX 2 (20121018/utaddress-251)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930781] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930782] ACPI Warning:
0x0000000000000500-0x000000000000052f SystemIO conflicts with Region
\GPIO 1 (20121018/utaddress-251)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930784] ACPI Warning:
0x0000000000000500-0x000000000000052f SystemIO conflicts with Region
\_SB_.PCI0.LPCB.GPBX 2 (20121018/utaddress-251)
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930786] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 09:47:01 Arbeits-PC kernel: [    1.930786] lpc_ich: Resource
conflict(s) found affecting gpio_ich
Sep  9 09:47:01 Arbeits-PC kernel: [    1.932867] usb 1-1.3: New USB
device found, idVendor=0bda, idProduct=8178
Sep  9 09:47:01 Arbeits-PC kernel: [    1.932870] usb 1-1.3: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Sep  9 09:47:01 Arbeits-PC kernel: [    1.932872] usb 1-1.3: Product: USB WLAN
Sep  9 09:47:01 Arbeits-PC kernel: [    1.932873] usb 1-1.3:
Manufacturer: 802.11n
Sep  9 09:47:01 Arbeits-PC kernel: [    1.932874] usb 1-1.3:
SerialNumber: 00e04c000001
Sep  9 09:47:01 Arbeits-PC kernel: [    1.943899] [drm] Initialized
drm 1.1.0 20060810
Sep  9 09:47:01 Arbeits-PC mtp-probe: checking bus 3, device 2:
"/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/usb3/3-1"
Sep  9 09:47:01 Arbeits-PC kernel: [    1.964996] wmi: Mapper loaded
Sep  9 09:47:01 Arbeits-PC mtp-probe: bus: 3, device: 2 was not an MTP device
Sep  9 09:47:01 Arbeits-PC mtp-probe: checking bus 3, device 3:
"/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/usb3/3-2"
Sep  9 09:47:01 Arbeits-PC mtp-probe: bus: 3, device: 3 was not an MTP device
Sep  9 09:47:01 Arbeits-PC bluetoothd[711]: Bluetooth daemon 4.101
Sep  9 09:47:01 Arbeits-PC bluetoothd[711]: Starting SDP server
Sep  9 09:47:01 Arbeits-PC kernel: [    1.988959] type=1400
audit(1378712821.578:2): apparmor="STATUS" operation="profile_load"
name="/sbin/dhclient" pid=708 comm="apparmor_parser"
Sep  9 09:47:01 Arbeits-PC kernel: [    1.989228] type=1400
audit(1378712821.578:3): apparmor="STATUS" operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=708
comm="apparmor_parser"
Sep  9 09:47:01 Arbeits-PC kernel: [    1.989376] type=1400
audit(1378712821.578:4): apparmor="STATUS" operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" pid=708
comm="apparmor_parser"
Sep  9 09:47:01 Arbeits-PC kernel: [    1.991140] Bluetooth: Core ver 2.16
Sep  9 09:47:01 Arbeits-PC kernel: [    1.991152] NET: Registered
protocol family 31
Sep  9 09:47:01 Arbeits-PC kernel: [    1.991153] Bluetooth: HCI
device and connection manager initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    1.991159] Bluetooth: HCI
socket layer initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    1.991160] Bluetooth: L2CAP
socket layer initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    1.991163] Bluetooth: SCO
socket layer initialized
Sep  9 09:47:01 Arbeits-PC bluetoothd[711]: DIS cannot start: GATT is disabled
Sep  9 09:47:01 Arbeits-PC bluetoothd[711]: Failed to init deviceinfo plugin
Sep  9 09:47:01 Arbeits-PC bluetoothd[711]: Failed to init proximity plugin
Sep  9 09:47:01 Arbeits-PC bluetoothd[711]: Failed to init time plugin
Sep  9 09:47:01 Arbeits-PC bluetoothd[711]: Failed to init alert plugin
Sep  9 09:47:01 Arbeits-PC bluetoothd[711]: Failed to init thermometer plugin
Sep  9 09:47:01 Arbeits-PC avahi-daemon[749]: Found user 'avahi' (UID
111) and group 'avahi' (GID 118).
Sep  9 09:47:01 Arbeits-PC avahi-daemon[749]: Successfully dropped
root privileges.
Sep  9 09:47:01 Arbeits-PC avahi-daemon[749]: avahi-daemon 0.6.31 starting up.
Sep  9 09:47:01 Arbeits-PC bluetoothd[711]: Failed to init gatt_example plugin
Sep  9 09:47:01 Arbeits-PC bluetoothd[711]: Bluetooth Management
interface initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    1.997413] Bluetooth: BNEP
(Ethernet Emulation) ver 1.3
Sep  9 09:47:01 Arbeits-PC kernel: [    1.997416] Bluetooth: BNEP
filters: protocol multicast
Sep  9 09:47:01 Arbeits-PC kernel: [    1.997422] Bluetooth: BNEP
socket layer initialized
Sep  9 09:47:01 Arbeits-PC avahi-daemon[749]: Successfully called chroot().
Sep  9 09:47:01 Arbeits-PC avahi-daemon[749]: Successfully dropped
remaining capabilities.
Sep  9 09:47:01 Arbeits-PC avahi-daemon[749]: Loading service file
/services/udisks.service.
Sep  9 09:47:01 Arbeits-PC avahi-daemon[749]: Network interface
enumeration completed.
Sep  9 09:47:01 Arbeits-PC avahi-daemon[749]: Registering HINFO record
with values 'X86_64'/'LINUX'.
Sep  9 09:47:01 Arbeits-PC avahi-daemon[749]: Server startup complete.
Host name is Arbeits-PC.local. Local service cookie is 2079062776.
Sep  9 09:47:01 Arbeits-PC avahi-daemon[749]: Service "Arbeits-PC"
(/services/udisks.service) successfully established.
Sep  9 09:47:01 Arbeits-PC kernel: [    2.000090] Bluetooth: RFCOMM
TTY layer initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    2.000098] Bluetooth: RFCOMM
socket layer initialized
Sep  9 09:47:01 Arbeits-PC kernel: [    2.000099] Bluetooth: RFCOMM ver 1.11
Sep  9 09:47:01 Arbeits-PC kernel: [    2.003894] usb 2-1.3: new
full-speed USB device number 3 using ehci-pci
Sep  9 09:47:01 Arbeits-PC kernel: [    2.010634] ppdev: user-space
parallel port driver
Sep  9 09:47:01 Arbeits-PC kernel: [    2.023117] type=1400
audit(1378712821.610:5): apparmor="STATUS" operation="profile_load"
name="/usr/lib/cups/backend/cups-pdf" pid=778 comm="apparmor_parser"
Sep  9 09:47:01 Arbeits-PC kernel: [    2.023424] type=1400
audit(1378712821.610:6): apparmor="STATUS" operation="profile_load"
name="/usr/sbin/cupsd" pid=778 comm="apparmor_parser"
Sep  9 09:47:01 Arbeits-PC kernel: [    2.031570] nvidia: module
license 'NVIDIA' taints kernel.
Sep  9 09:47:01 Arbeits-PC kernel: [    2.037639] vgaarb: device
changed decodes:
PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
Sep  9 09:47:01 Arbeits-PC kernel: [    2.037767] [drm] Initialized
nvidia-drm 0.0.0 20130102 for 0000:01:00.0 on minor 0
Sep  9 09:47:01 Arbeits-PC kernel: [    2.037772] NVRM: loading NVIDIA
UNIX x86_64 Kernel Module  325.15  Wed Jul 31 18:50:56 PDT 2013
Sep  9 09:47:01 Arbeits-PC kernel: [    2.045848] microcode: CPU0
sig=0x206a7, pf=0x2, revision=0x28
Sep  9 09:47:01 Arbeits-PC kernel: [    2.054697] snd_hda_intel
0000:00:1b.0: enabling device (0000 -> 0002)
Sep  9 09:47:01 Arbeits-PC kernel: [    2.054749] snd_hda_intel
0000:00:1b.0: irq 54 for MSI/MSI-X
Sep  9 09:47:01 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.ColorManager' (using servicehelper)
Sep  9 09:47:01 Arbeits-PC failsafe: Failsafe of 120 seconds reached.
Sep  9 09:47:01 Arbeits-PC colord: Using config file /etc/colord.conf
Sep  9 09:47:01 Arbeits-PC colord: Using mapping database file
/var/lib/colord/mapping.db
Sep  9 09:47:01 Arbeits-PC colord: Using device database file
/var/lib/colord/storage.db
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094427] input: HDA Intel PCH
Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input2
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094469] input: HDA Intel PCH
Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input3
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094500] input: HDA Intel PCH
Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094530] input: HDA Intel PCH
Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094561] input: HDA Intel PCH
Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094593] input: HDA Intel PCH
Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094622] input: HDA Intel PCH
Line Out Surround as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094650] input: HDA Intel PCH
Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094775] snd_hda_intel
0000:01:00.1: enabling device (0000 -> 0002)
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094780] hda_intel: Disabling MSI
Sep  9 09:47:01 Arbeits-PC kernel: [    2.094785] hda-intel
0000:01:00.1: Handle VGA-switcheroo audio client
Sep  9 09:47:01 Arbeits-PC mtp-probe: checking bus 1, device 3:
"/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3"
Sep  9 09:47:01 Arbeits-PC colord: loaded plugin libcd_plugin_scanner.so
Sep  9 09:47:01 Arbeits-PC mtp-probe: bus: 1, device: 3 was not an MTP device
Sep  9 09:47:01 Arbeits-PC colord: plugin
/usr/lib/colord-plugins/libcd_plugin_sane.so not loaded: plugin
refused to load
Sep  9 09:47:01 Arbeits-PC colord: loaded plugin libcd_plugin_camera.so
Sep  9 09:47:01 Arbeits-PC colord: Daemon ready for requests
Sep  9 09:47:01 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.ColorManager'
Sep  9 09:47:01 Arbeits-PC kernel: [    2.105308] asus_wmi: ASUS WMI
generic driver loaded
Sep  9 09:47:01 Arbeits-PC kernel: [    2.107040] asus_wmi:
Initialization: 0x0asus_wmi: BIOS WMI version: 0.9
Sep  9 09:47:01 Arbeits-PC kernel: [    2.107082] asus_wmi: SFUN
value: 0x0<6>[    2.107120] usb 2-1.3: New USB device found,
idVendor=045e, idProduct=0768
Sep  9 09:47:01 Arbeits-PC kernel: [    2.107123] usb 2-1.3: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Sep  9 09:47:01 Arbeits-PC kernel: [    2.107125] usb 2-1.3: Product:
Microsoft® SiderWinderTM X4 Keyboard
Sep  9 09:47:01 Arbeits-PC kernel: [    2.107126] usb 2-1.3:
Manufacturer: Microsoft
Sep  9 09:47:01 Arbeits-PC kernel: [    2.107268] input: Eee PC WMI
hotkeys as /devices/platform/eeepc-wmi/input/input10
Sep  9 09:47:01 Arbeits-PC kernel: [    2.111193] asus_wmi: Disabling
ACPI video driver
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113855] rtw driver
version=v3.4.4_4749.20121105
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113858] Build at: Sep  5 2013 16:14:35
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113882] register
rtw_netdev_ops to netdev_ops
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113883] CHIP TYPE: RTL8188C_8192C
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113885]
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113885] usb_endpoint_descriptor(0):
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113886] bLength=7
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113886] bDescriptorType=5
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113887] bEndpointAddress=81
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113888] wMaxPacketSize=200
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113889] bInterval=0
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113889] RT_usb_endpoint_is_bulk_in = 1
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113890]
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113890] usb_endpoint_descriptor(1):
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113891] bLength=7
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113892] bDescriptorType=5
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113892] bEndpointAddress=2
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113893] wMaxPacketSize=200
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113894] bInterval=0
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113894]
RT_usb_endpoint_is_bulk_out = 2
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113895]
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113895] usb_endpoint_descriptor(2):
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113896] bLength=7
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113897] bDescriptorType=5
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113897] bEndpointAddress=3
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113898] wMaxPacketSize=200
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113898] bInterval=0
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113899]
RT_usb_endpoint_is_bulk_out = 3
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113900]
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113900] usb_endpoint_descriptor(3):
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113901] bLength=7
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113902] bDescriptorType=5
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113902] bEndpointAddress=84
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113903] wMaxPacketSize=40
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113903] bInterval=1
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113904]
RT_usb_endpoint_is_int_in = 4, Interval = 1
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113905] nr_endpoint=4,
in_num=2, out_num=2
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113905]
Sep  9 09:47:01 Arbeits-PC kernel: [    2.113906] USB_SPEED_HIGH
Sep  9 09:47:01 Arbeits-PC kernel: [    2.114230] Chip Version ID:
VERSION_NORMAL_TSMC_CHIP_92C.
Sep  9 09:47:01 Arbeits-PC kernel: [    2.114232] RF_Type is 2!!
Sep  9 09:47:01 Arbeits-PC kernel: [    2.114779] EEPROM type is E-FUSE
Sep  9 09:47:01 Arbeits-PC kernel: [    2.114781] ====> ReadAdapterInfo8192C
Sep  9 09:47:01 Arbeits-PC mtp-probe: checking bus 2, device 3:
"/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3"
Sep  9 09:47:01 Arbeits-PC mtp-probe: bus: 2, device: 3 was not an MTP device
Sep  9 09:47:01 Arbeits-PC kernel: [    2.116002] Boot from EFUSE, Autoload OK !
Sep  9 09:47:01 Arbeits-PC kernel: [    2.117491] microcode: CPU1
sig=0x206a7, pf=0x2, revision=0x28
Sep  9 09:47:01 Arbeits-PC kernel: [    2.118996] microcode: CPU2
sig=0x206a7, pf=0x2, revision=0x28
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-709099b11b3ec2828a314682a3c09f75
Sep  9 09:47:01 Arbeits-PC kernel: [    2.128437] microcode: CPU3
sig=0x206a7, pf=0x2, revision=0x28
Sep  9 09:47:01 Arbeits-PC kernel: [    2.129472] microcode: Microcode
Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-22f24c14dfa0237c65ce91cbdc840c69
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-d3ee37ff47fcdf614fb5cb62fb3e16a7
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-7da394e6f8f9718fc7b52b32566dac05
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-e7ecfce2d984c9f0c90f4ef1cdc9ac7e
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  ModemManager
(version 0.6.0.0) starting...
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-798efa4314bbd0274499de21fdf4ee5e
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-f844a65e79050c828a5f8381a0798e49
Sep  9 09:47:01 Arbeits-PC kernel: [    2.150160] usbcore: registered
new interface driver usbhid
Sep  9 09:47:01 Arbeits-PC kernel: [    2.150163] usbhid: USB HID core driver
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-f1d6e4a79454dcf348e740f8258ebc8b
Sep  9 09:47:01 Arbeits-PC kernel: [    2.154399] input: Microsoft
Microsoft® SiderWinderTM X4 Keyboard as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input11
Sep  9 09:47:01 Arbeits-PC kernel: [    2.154575] hid-generic
0003:045E:0768.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsoft
Microsoft® SiderWinderTM X4 Keyboard] on usb-0000:00:1d.0-1.3/input0
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-5e1ebb54becd93f823c07c22bc1938e0
Sep  9 09:47:01 Arbeits-PC kernel: [    2.157726] input: Microsoft
Microsoft® SiderWinderTM X4 Keyboard as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/input/input12
Sep  9 09:47:01 Arbeits-PC kernel: [    2.158507] hid-generic
0003:045E:0768.0002: input,hidraw1: USB HID v1.11 Keyboard [Microsoft
Microsoft® SiderWinderTM X4 Keyboard] on usb-0000:00:1d.0-1.3/input1
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-e9984ac92492c61ae319f57aa7cbb102
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Linktop'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Nokia'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin
'Ericsson MBM'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'X22X'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'ZTE'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'AnyData'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Samsung'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Gobi'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Longcheer'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Huawei'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'MotoC'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin
'Option High-Speed'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Novatel'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Wavecom'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Sierra'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Option'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'SimTech'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Iridium'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Cinterion'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Loaded plugin 'Generic'
Sep  9 09:47:01 Arbeits-PC modem-manager[944]: <info>  Successfully
loaded 20 plugins
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-578e8c43d0440cff3239ced4417c691a
Sep  9 09:47:01 Arbeits-PC kernel: [    2.180744] usb 2-1.4: new
low-speed USB device number 4 using ehci-pci
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> NetworkManager
(version 0.9.8.0) is starting...
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> Read config
file /etc/NetworkManager/NetworkManager.conf
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> WEXT support is enabled
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-6590422afc1260c68d531b8de865eda1
Sep  9 09:47:01 Arbeits-PC kernel: [    2.185779] type=1400
audit(1378712821.774:7): apparmor="STATUS" operation="profile_load"
name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=1015
comm="apparmor_parser"
Sep  9 09:47:01 Arbeits-PC kernel: [    2.185987] type=1400
audit(1378712821.774:8): apparmor="STATUS" operation="profile_load"
name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper//chromium_browser"
pid=1015 comm="apparmor_parser"
Sep  9 09:47:01 Arbeits-PC kernel: [    2.187082] type=1400
audit(1378712821.774:9): apparmor="STATUS" operation="profile_load"
name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-freerdp/freerdp-session-wrapper"
pid=1016 comm="apparmor_parser"
Sep  9 09:47:01 Arbeits-PC kernel: [    2.187330] type=1400
audit(1378712821.774:10): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient" pid=1018
comm="apparmor_parser"
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> VPN: loaded
org.freedesktop.NetworkManager.pptp
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> DNS: loaded
plugin dnsmasq
Sep  9 09:47:01 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.PolicyKit1' (using servicehelper)
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-8032ad23c1912c7ffae56745d279fde7
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-f5cf9cb1331928471dbcd67d7229aff5
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-9cc8e51f95b2209f235c230393230ead
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-429bb399c0de0c6fe69826993b46c219
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-8ab229960e966f047a0fb62c4cb1f390
Sep  9 09:47:01 Arbeits-PC polkitd[1028]: started daemon version 0.105
using authority implementation `local' version `0.105'
Sep  9 09:47:01 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.PolicyKit1'
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-adb5ebe2a14b98599a170cd3ab54fe76
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown: init!
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown:
update_system_hostname
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    SCPluginIfupdown:
management mode: unmanaged
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown:
devices added (path: /sys/devices/pci0000:00/0000:00:19.0/net/eth0,
iface: eth0)
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown:
device added (path: /sys/devices/pci0000:00/0000:00:19.0/net/eth0,
iface: eth0): no ifupdown configuration found.
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown:
devices added (path: /sys/devices/virtual/net/lo, iface: lo)
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown:
device added (path: /sys/devices/virtual/net/lo, iface: lo): no
ifupdown configuration found.
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown:
end _init.
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> Loaded plugin
ifupdown: (C) 2008 Canonical Ltd.  To report bugs please use the
NetworkManager mailing list.
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> Loaded plugin
keyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the
NetworkManager mailing list.
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    Ifupdown: get
unmanaged devices count: 0
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown:
(16408752) ... get_connections.
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown:
(16408752) ... get_connections (managed=false): return empty list.
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    keyfile: parsing Festung ...
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-29f7c3bb18648f967e9cc450f5b0821e
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-dff20c58ed34af3a30bc97b2b2a1b6c5
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    keyfile:     read
connection 'Festung'
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    keyfile: parsing WG-WLAN ...
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-ae0f19a77ff01ea1932ef5fd9609ef9d
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-0ef971da00dac3a46e0c86550c54d5ad
Sep  9 09:47:01 Arbeits-PC colord: Profile added:
icc-0bd9f292ce7882699e93ff844071783d
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    keyfile:     read
connection 'WG-WLAN'
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    keyfile: parsing
WG-WLAN 1 ...
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    keyfile:     read
connection 'WG-WLAN 1'
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]:    Ifupdown: get
unmanaged devices count: 0
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> modem-manager
is now available
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> monitoring
kernel firmware directory '/lib/firmware'.
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> WiFi hardware
radio set enabled
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> WiFi enabled
by radio killswitch; enabled by state file
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> WWAN enabled
by radio killswitch; enabled by state file
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> WiMAX enabled
by radio killswitch; enabled by state file
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> Networking is
enabled by state file
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <warn> failed to
allocate link cache: (-10) Operation not supported
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> (eth0): carrier is OFF
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> (eth0): new
Ethernet device (driver: 'e1000e' ifindex: 2)
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> (eth0):
exported as /org/freedesktop/NetworkManager/Devices/0
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> (eth0): device
state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Sep  9 09:47:01 Arbeits-PC NetworkManager[1019]: <info> (eth0):
bringing up device.
Sep  9 09:47:01 Arbeits-PC colord: Profile added: EPSON-WF-2510-Series-Gray..
Sep  9 09:47:01 Arbeits-PC colord: Profile added: EPSON-WF-2510-Series-RGB..
Sep  9 09:47:01 Arbeits-PC colord: Device added: cups-EPSON-WF-2510-Series
Sep  9 09:47:01 Arbeits-PC anacron[1124]: Anacron 2.3 started on 2013-09-09
Sep  9 09:47:01 Arbeits-PC cron[1085]: (CRON) INFO (pidfile fd = 3)
Sep  9 09:47:01 Arbeits-PC acpid: starting up with proc fs
Sep  9 09:47:01 Arbeits-PC cron[1127]: (CRON) STARTUP (fork ok)
Sep  9 09:47:01 Arbeits-PC anacron[1124]: Normal exit (0 jobs run)
Sep  9 09:47:01 Arbeits-PC cron[1127]: (CRON) INFO (Running @reboot jobs)
Sep  9 09:47:01 Arbeits-PC kernel: [    2.276877] usb 2-1.4: New USB
device found, idVendor=046d, idProduct=c051
Sep  9 09:47:01 Arbeits-PC kernel: [    2.276880] usb 2-1.4: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Sep  9 09:47:01 Arbeits-PC kernel: [    2.276882] usb 2-1.4: Product:
USB-PS/2 Optical Mouse
Sep  9 09:47:01 Arbeits-PC kernel: [    2.276883] usb 2-1.4:
Manufacturer: Logitech
Sep  9 09:47:01 Arbeits-PC acpid: 33 rules loaded
Sep  9 09:47:01 Arbeits-PC acpid: waiting for events: event logging is off
Sep  9 09:47:01 Arbeits-PC mtp-probe: checking bus 2, device 4:
"/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
Sep  9 09:47:01 Arbeits-PC mtp-probe: bus: 2, device: 4 was not an MTP device
Sep  9 09:47:01 Arbeits-PC kernel: [    2.280631] input: Logitech
USB-PS/2 Optical Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input13
Sep  9 09:47:01 Arbeits-PC kernel: [    2.280743] hid-generic
0003:046D:C051.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech
USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.4/input0
Sep  9 09:47:01 Arbeits-PC nvidia-persistenced: Started (1156)
Sep  9 09:47:01 Arbeits-PC nvidia-persistenced: Failed to query NVIDIA
devices. Please ensure that the NVIDIA device files (/dev/nvidia*)
exist, and that user 999 has read and write permissions for those
files.
Sep  9 09:47:01 Arbeits-PC nvidia-persistenced: The daemon no longer
has permission to remove its runtime data directory
/var/run/nvidia-persistenced
Sep  9 09:47:01 Arbeits-PC nvidia-persistenced: Shutdown (1156)
Sep  9 09:47:01 Arbeits-PC ntpdate[1192]: Can't find host
ntp.ubuntu.com: System error (-11)
Sep  9 09:47:01 Arbeits-PC ntpdate[1192]: no servers can be used, exiting
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316066] EEPROMVID = 0x0bda
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316069] EEPROMPID = 0x8178
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316070] EEPROMCustomerID : 0x00
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316070] EEPROMSubCustomerID: 0x00
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316071] RT_CustomerID: 0x00
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316073] _ReadMACAddress MAC
Address from EFUSE = f8:1a:67:19:16:94
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316074] EEPROMRegulatory = 0x0
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316075] _ReadBoardType(0)
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316076] BT Coexistance = disable
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316077] RT_ChannelPlan: 0x02
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316078]
_ReadPSSetting...bHWPwrPindetect(0)-bHWPowerdown(0)
,bSupportRemoteWakeup(0)
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316079] ### PS params=>
power_mgnt(1),usbss_enable(0) ###
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316079] ### AntDivCfg(0)
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316080]
readAdapterInfo_8192CU(): REPLACEMENT = 1
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316081] <====
ReadAdapterInfo8192C in 204 ms
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316178] rtw_macaddr_cfg MAC
Address  = f8:1a:67:19:16:94
Sep  9 09:47:01 Arbeits-PC kernel: [    2.316180] MAC Address from
pnetdev->dev_addr= f8:1a:67:19:16:94
Sep  9 09:47:01 Arbeits-PC anacron[1226]: Anacron 2.3 started on 2013-09-09
Sep  9 09:47:01 Arbeits-PC anacron[1226]: Normal exit (0 jobs run)
Sep  9 09:47:01 Arbeits-PC acpid: client connected from 1209[0:0]
Sep  9 09:47:01 Arbeits-PC acpid: 1 client rule loaded
Sep  9 09:47:01 Arbeits-PC kernel: [    2.392799] e1000e 0000:00:19.0:
irq 51 for MSI/MSI-X
Sep  9 09:47:02 Arbeits-PC kernel: [    2.420715] nvidia 0000:01:00.0:
irq 55 for MSI/MSI-X
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (eth0):
preparing device.
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (eth0):
deactivating device (reason 'managed') [2]
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> Added default
wired connection 'Kabelnetzwerkverbindung 1' for
/sys/devices/pci0000:00/0000:00:19.0/net/eth0
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <warn>
/sys/devices/virtual/net/lo: couldn't determine device driver;
ignoring...
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <warn>
/sys/devices/virtual/net/lo: couldn't determine device driver;
ignoring...
Sep  9 09:47:02 Arbeits-PC kernel: [    2.495139] e1000e 0000:00:19.0:
irq 51 for MSI/MSI-X
Sep  9 09:47:02 Arbeits-PC kernel: [    2.495259] IPv6:
ADDRCONF(NETDEV_UP): eth0: link is not ready
Sep  9 09:47:02 Arbeits-PC kernel: [    2.495556] IPv6:
ADDRCONF(NETDEV_UP): eth0: link is not ready
Sep  9 09:47:02 Arbeits-PC kernel: [    2.496673] bDriverStopped:1,
bSurpriseRemoved:0, bup:0, hw_init_completed:0
Sep  9 09:47:02 Arbeits-PC kernel: [    2.496692] usbcore: registered
new interface driver rtl8192cu
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown:
devices added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0)
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]:    SCPlugin-Ifupdown:
device added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0): no ifupdown configuration found.
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <warn> failed to
allocate link cache: (-10) Operation not supported
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
driver supports SSID scans (scan_capa 0x3F).
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0): using
WEXT for WiFi device control
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <error>
[1378712822.106157] [nm-device-wifi.c:2841]
update_permanent_hw_address(): (wlan0): unable to read permanent MAC
address (error 0)
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0): new
802.11 WiFi device (driver: 'rtl8192cu' ifindex: 3)
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
exported as /org/freedesktop/NetworkManager/Devices/1
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
device state change: unmanaged -> unavailable (reason 'managed') [10
20 2]
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
bringing up device.
Sep  9 09:47:02 Arbeits-PC kernel: [    2.511938] bDriverStopped=1
Sep  9 09:47:02 Arbeits-PC kernel: [    2.512461] +871x_drv - drv_open, bup=0
Sep  9 09:47:02 Arbeits-PC kernel: [    2.516660]  ===>
FirmwareDownload91C() fw:Rtl819XFwImageArray_TSMC
Sep  9 09:47:02 Arbeits-PC kernel: [    2.516661] FirmwareDownload92C
accquire FW from embedded image
Sep  9 09:47:02 Arbeits-PC kernel: [    2.516663] fw_ver=v80,
fw_subver=0, sig=0x88c0
Sep  9 09:47:02 Arbeits-PC kernel: [    2.543883] fw download ok!
Sep  9 09:47:02 Arbeits-PC kernel: [    2.543885] Set RF Chip ID to
RF_6052 and RF type to 2.
Sep  9 09:47:02 Arbeits-PC kernel: [    2.562989] input: HDA NVidia
HDMI/DP,pcm=9 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
Sep  9 09:47:02 Arbeits-PC kernel: [    2.563045] input: HDA NVidia
HDMI/DP,pcm=8 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
Sep  9 09:47:02 Arbeits-PC kernel: [    2.563117] input: HDA NVidia
HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
Sep  9 09:47:02 Arbeits-PC kernel: [    2.563167] input: HDA NVidia
HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
Sep  9 09:47:02 Arbeits-PC kernel: [    2.580852] scsi 8:0:0:0:
Direct-Access     WD       Ext HDD 1021     2021 PQ: 0 ANSI: 4
Sep  9 09:47:02 Arbeits-PC kernel: [    2.581126] sd 8:0:0:0: Attached
scsi generic sg3 type 0
Sep  9 09:47:02 Arbeits-PC kernel: [    2.581539] sd 8:0:0:0: [sdc]
732566016 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Sep  9 09:47:02 Arbeits-PC kernel: [    2.583066] sd 8:0:0:0: [sdc]
Write Protect is off
Sep  9 09:47:02 Arbeits-PC kernel: [    2.583069] sd 8:0:0:0: [sdc]
Mode Sense: 17 00 10 08
Sep  9 09:47:02 Arbeits-PC kernel: [    2.584551] sd 8:0:0:0: [sdc] No
Caching mode page present
Sep  9 09:47:02 Arbeits-PC kernel: [    2.584555] sd 8:0:0:0: [sdc]
Assuming drive cache: write through
Sep  9 09:47:02 Arbeits-PC kernel: [    2.585072] sd 8:0:0:0: [sdc]
732566016 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Sep  9 09:47:02 Arbeits-PC kernel: [    2.588031] sd 8:0:0:0: [sdc] No
Caching mode page present
Sep  9 09:47:02 Arbeits-PC kernel: [    2.588034] sd 8:0:0:0: [sdc]
Assuming drive cache: write through
Sep  9 09:47:02 Arbeits-PC kernel: [    2.588334]  sdc: sdc1
Sep  9 09:47:02 Arbeits-PC kernel: [    2.588974] sd 8:0:0:0: [sdc]
732566016 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Sep  9 09:47:02 Arbeits-PC kernel: [    2.593784] sd 8:0:0:0: [sdc] No
Caching mode page present
Sep  9 09:47:02 Arbeits-PC kernel: [    2.593788] sd 8:0:0:0: [sdc]
Assuming drive cache: write through
Sep  9 09:47:02 Arbeits-PC kernel: [    2.593790] sd 8:0:0:0: [sdc]
Attached SCSI disk
Sep  9 09:47:02 Arbeits-PC kernel: [    2.816179] scsi 9:0:0:0:
Direct-Access     WD       10EAVS External  1.05 PQ: 0 ANSI: 4
Sep  9 09:47:02 Arbeits-PC kernel: [    2.816605] sd 9:0:0:0: Attached
scsi generic sg4 type 0
Sep  9 09:47:02 Arbeits-PC kernel: [    2.816791] sd 9:0:0:0: [sdd]
1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Sep  9 09:47:02 Arbeits-PC kernel: [    2.817378] sd 9:0:0:0: [sdd]
Write Protect is off
Sep  9 09:47:02 Arbeits-PC kernel: [    2.817382] sd 9:0:0:0: [sdd]
Mode Sense: 21 00 00 00
Sep  9 09:47:02 Arbeits-PC kernel: [    2.817996] sd 9:0:0:0: [sdd] No
Caching mode page present
Sep  9 09:47:02 Arbeits-PC kernel: [    2.817999] sd 9:0:0:0: [sdd]
Assuming drive cache: write through
Sep  9 09:47:02 Arbeits-PC kernel: [    2.819595] sd 9:0:0:0: [sdd] No
Caching mode page present
Sep  9 09:47:02 Arbeits-PC kernel: [    2.819597] sd 9:0:0:0: [sdd]
Assuming drive cache: write through
Sep  9 09:47:02 Arbeits-PC kernel: [    2.825692]  sdd: sdd1
Sep  9 09:47:02 Arbeits-PC kernel: [    2.827886] sd 9:0:0:0: [sdd] No
Caching mode page present
Sep  9 09:47:02 Arbeits-PC kernel: [    2.827888] sd 9:0:0:0: [sdd]
Assuming drive cache: write through
Sep  9 09:47:02 Arbeits-PC kernel: [    2.827890] sd 9:0:0:0: [sdd]
Attached SCSI disk
Sep  9 09:47:02 Arbeits-PC kernel: [    2.959388] IQK:Start!!!
Sep  9 09:47:02 Arbeits-PC kernel: [    2.971121] Path A IQK Success!!
Sep  9 09:47:02 Arbeits-PC kernel: [    2.975863] Path B IQK Success!!
Sep  9 09:47:02 Arbeits-PC kernel: [    2.984352] Path A IQK Success!!
Sep  9 09:47:02 Arbeits-PC kernel: [    2.989095] Path B IQK Success!!
Sep  9 09:47:02 Arbeits-PC kernel: [    3.001701] Path A IQK Success!!
Sep  9 09:47:02 Arbeits-PC kernel: [    3.006444] Path B IQK Success!!
Sep  9 09:47:02 Arbeits-PC kernel: [    3.011190] IQK: final_candidate is 1
Sep  9 09:47:02 Arbeits-PC kernel: [    3.011194] IQK: RegE94=fe
RegE9C=0 RegEA4=fa RegEAC=0 RegEB4=103 RegEBC=8 RegEC4=f6 RegECC=4
Sep  9 09:47:02 Arbeits-PC kernel: [    3.011194]  Path A IQ
Calibration Success !
Sep  9 09:47:02 Arbeits-PC kernel: [    3.013311] Path B IQ
Calibration Success !
Sep  9 09:47:02 Arbeits-PC kernel: [    3.066196] NVRM: Your system is
not currently configured to drive a VGA console
Sep  9 09:47:02 Arbeits-PC kernel: [    3.066198] NVRM: on the primary
VGA device. The NVIDIA Linux graphics driver
Sep  9 09:47:02 Arbeits-PC kernel: [    3.066200] NVRM: requires the
use of a text-mode VGA console. Use of other console
Sep  9 09:47:02 Arbeits-PC kernel: [    3.066201] NVRM: drivers
including, but not limited to, vesafb, may result in
Sep  9 09:47:02 Arbeits-PC kernel: [    3.066208] NVRM: corruption and
stability problems, and is not supported.
Sep  9 09:47:02 Arbeits-PC acpid: client connected from 1209[0:0]
Sep  9 09:47:02 Arbeits-PC acpid: 1 client rule loaded
Sep  9 09:47:02 Arbeits-PC kernel: [    3.126024]
pdmpriv->TxPowerTrackControl = 1
Sep  9 09:47:02 Arbeits-PC kernel: [    3.130891] MAC Address from
REG_MACID = f8:1a:67:19:16:94
Sep  9 09:47:02 Arbeits-PC kernel: [    3.130894] rtl8192cu_hal_init in 620ms
Sep  9 09:47:02 Arbeits-PC kernel: [    3.130895] MAC Address =
f8:1a:67:19:16:94
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
preparing device.
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
deactivating device (reason 'managed') [2]
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
taking down device.
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
bringing up device.
Sep  9 09:47:02 Arbeits-PC dbus[651]: [system] Activating service
name='fi.w1.wpa_supplicant1' (using servicehelper)
Sep  9 09:47:02 Arbeits-PC kernel: [    3.135652] -871x_drv - drv_open, bup=1
Sep  9 09:47:02 Arbeits-PC kernel: [    3.135676] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 09:47:02 Arbeits-PC kernel: [    3.135873] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 09:47:02 Arbeits-PC kernel: [    3.135965] (2)871x_drv -
drv_close, bup=1, hw_init_completed=1
Sep  9 09:47:02 Arbeits-PC kernel: [    3.136132] -871x_drv - drv_close, bup=1
Sep  9 09:47:02 Arbeits-PC kernel: [    3.136218] set_mode = IW_MODE_INFRA
Sep  9 09:47:02 Arbeits-PC kernel: [    3.136288] +871x_drv - drv_open, bup=1
Sep  9 09:47:02 Arbeits-PC kernel: [    3.136291] -871x_drv - drv_open, bup=1
Sep  9 09:47:02 Arbeits-PC kernel: [    3.136300] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 09:47:02 Arbeits-PC dbus[651]: [system] Successfully activated
service 'fi.w1.wpa_supplicant1'
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> wpa_supplicant started
Sep  9 09:47:02 Arbeits-PC wpa_supplicant[1404]: nl80211: 'nl80211'
generic netlink not found
Sep  9 09:47:02 Arbeits-PC wpa_supplicant[1404]: Failed to initialize
driver 'nl80211'
Sep  9 09:47:02 Arbeits-PC kernel: [    3.145168] [rtw_wx_set_pmkid]
IW_PMKSA_FLUSH!
Sep  9 09:47:02 Arbeits-PC kernel: [    3.145172] set_mode = IW_MODE_INFRA
Sep  9 09:47:02 Arbeits-PC kernel: [    3.145208] =>rtw_wx_set_essid

Sep  9 09:47:02 Arbeits-PC kernel: [    3.145211] Set SSID under
fw_state=0x00000008
Sep  9 09:47:02 Arbeits-PC kernel: [    3.145212] <=rtw_wx_set_essid, ret -1
Sep  9 09:47:02 Arbeits-PC kernel: [    3.166189] [rtw_wx_set_pmkid]
IW_PMKSA_FLUSH!
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0)
supports 1 scan SSIDs
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <warn> Trying to
remove a non-existant call id.
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
supplicant interface state: starting -> ready
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
device state change: unavailable -> disconnected (reason
'supplicant-available') [20 30 42]
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
supplicant interface state: ready -> inactive
Sep  9 09:47:02 Arbeits-PC NetworkManager[1019]: <info> (wlan0)
supports 1 scan SSIDs
Sep  9 09:47:02 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.Accounts' (using servicehelper)
Sep  9 09:47:02 Arbeits-PC accounts-daemon[1415]: started daemon version 0.6.29
Sep  9 09:47:02 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.Accounts'
Sep  9 09:47:02 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.ConsoleKit' (using servicehelper)
Sep  9 09:47:02 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.ConsoleKit'
Sep  9 09:47:03 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.UPower' (using servicehelper)
Sep  9 09:47:03 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.UPower'
Sep  9 09:47:03 Arbeits-PC anacron[1628]: Anacron 2.3 started on 2013-09-09
Sep  9 09:47:03 Arbeits-PC anacron[1628]: Normal exit (0 jobs run)
Sep  9 09:47:03 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.systemd1' (using servicehelper)
Sep  9 09:47:03 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.systemd1'
Sep  9 09:47:03 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.RealtimeKit1' (using servicehelper)
Sep  9 09:47:03 Arbeits-PC colord: Device added: xrandr-Samsung
Electric Company-SMS27A550H-808465713
Sep  9 09:47:03 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.RealtimeKit1'
Sep  9 09:47:03 Arbeits-PC rtkit-daemon[1761]: Successfully called chroot.
Sep  9 09:47:03 Arbeits-PC rtkit-daemon[1761]: Successfully dropped privileges.
Sep  9 09:47:03 Arbeits-PC rtkit-daemon[1761]: Successfully limited resources.
Sep  9 09:47:03 Arbeits-PC rtkit-daemon[1761]: Running.
Sep  9 09:47:03 Arbeits-PC rtkit-daemon[1761]: Watchdog thread running.
Sep  9 09:47:03 Arbeits-PC rtkit-daemon[1761]: Canary thread running.
Sep  9 09:47:03 Arbeits-PC rtkit-daemon[1761]: Successfully made
thread 1754 of process 1754 (n/a) owned by '110' high priority at nice
level -11.
Sep  9 09:47:03 Arbeits-PC rtkit-daemon[1761]: Supervising 1 threads
of 1 processes of 1 users.
Sep  9 09:47:03 Arbeits-PC colord: Profile added:
icc-43452068d98938efc2ed29a6d513fbc0
Sep  9 09:47:03 Arbeits-PC rtkit-daemon[1761]: Successfully made
thread 1792 of process 1754 (n/a) owned by '110' RT at priority 5.
Sep  9 09:47:03 Arbeits-PC rtkit-daemon[1761]: Supervising 2 threads
of 1 processes of 1 users.
Sep  9 09:47:03 Arbeits-PC kernel: [    4.183021] hda-intel: IRQ
timing workaround is activated for card #1. Suggest a bigger
bdl_pos_adj.
Sep  9 09:47:04 Arbeits-PC kernel: [    4.481701] survey done event(17)
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info>
Auto-activating connection 'WG-WLAN'.
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) starting connection 'WG-WLAN'
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
device state change: disconnected -> prepare (reason 'none') [30 40 0]
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0/wireless): connection 'WG-WLAN' has security, and secrets
exist.  No new secrets needed.
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Config: added
'ssid' value 'WG-WLAN'
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Config: added
'scan_ssid' value '1'
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Config: added
'auth_alg' value 'OPEN'
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Config: added
'psk' value '<omitted>'
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> Config: set
interface ap_scan to 1
Sep  9 09:47:04 Arbeits-PC kernel: [    4.514177] IW_SCAN_THIS_ESSID,
ssid=WG-WLAN, len=7
Sep  9 09:47:04 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
supplicant interface state: inactive -> scanning
Sep  9 09:47:05 Arbeits-PC wpa_supplicant[1404]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 09:47:05 Arbeits-PC wpa_supplicant[1404]: wlan0: Association
request to the driver failed
Sep  9 09:47:05 Arbeits-PC kernel: [    5.823771] survey done event(1d)
Sep  9 09:47:05 Arbeits-PC kernel: [    5.823992] wpa_set_auth_algs,
AUTH_ALG_OPEN_SYSTEM
Sep  9 09:47:05 Arbeits-PC kernel: [    5.823996] set_mode = IW_MODE_INFRA
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824002]
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824002]  wpa_ie(length:22):
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824004] 0x30 0x14 0x01 0x00
0x00 0x0f 0xac 0x04
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824005] 0x01 0x00 0x00 0x0f
0xac 0x04 0x01 0x00
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824007] 0x00 0x0f 0xac 0x02
0x00 0x00 0x00 0x00
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824013] =>rtw_wx_set_essid
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824014] ssid=WG-WLAN, len=7
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824016] Set SSID under
fw_state=0x00000008
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824018]
[by_bssid:0][assoc_ssid:WG-WLAN][to_roaming:0] new candidate:
WG-WLAN(a0:f3:c1:05:80:ec) rssi:-66
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824020]
rtw_select_and_join_from_scanned_queue: candidate:
WG-WLAN(a0:f3:c1:05:80:ec)
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824023]
rtw_restructure_ht_ie IEEE80211_HT_CAP_MAX_AMSDU is set
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824024] link to Artheros AP
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824025] <=rtw_wx_set_essid, ret 0
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824028] Set BSSID under
fw_state=0x00000088
Sep  9 09:47:05 Arbeits-PC kernel: [    5.824911] set ch/bw before connected
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
supplicant interface state: scanning -> associating
Sep  9 09:47:05 Arbeits-PC kernel: [    5.871873] link to Artheros AP
Sep  9 09:47:05 Arbeits-PC kernel: [    5.871876] issue_deauth to
a0:f3:c1:05:80:ec
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876258] OnAuthClient
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876262] network.SupportedRates[0]=82
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876264] network.SupportedRates[1]=84
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876264] network.SupportedRates[2]=8B
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876265] network.SupportedRates[3]=96
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876266] network.SupportedRates[4]=0C
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876267] network.SupportedRates[5]=12
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876267] network.SupportedRates[6]=18
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876268] network.SupportedRates[7]=24
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876269] network.SupportedRates[8]=30
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876270] network.SupportedRates[9]=48
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876271] network.SupportedRates[10]=60
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876271] network.SupportedRates[11]=6C
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876272] bssrate_len = 12
Sep  9 09:47:05 Arbeits-PC kernel: [    5.876274] declare supporting RX STBC
Sep  9 09:47:05 Arbeits-PC wpa_supplicant[1404]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 09:47:05 Arbeits-PC kernel: [    5.880484] OnAssocRsp
Sep  9 09:47:05 Arbeits-PC kernel: [    5.880488] report_join_res(2)
Sep  9 09:47:05 Arbeits-PC kernel: [    5.880490] rtw_joinbss_update_network
Sep  9 09:47:05 Arbeits-PC kernel: [    5.880491] +rtw_update_ht_cap()
Sep  9 09:47:05 Arbeits-PC kernel: [    5.880494] rtw_joinbss_update_stainfo
Sep  9 09:47:05 Arbeits-PC kernel: [    5.880518] IPv6:
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sep  9 09:47:05 Arbeits-PC kernel: [    5.880525] HW_VAR_BASIC_RATE:
BrateCfg(0x15d)
Sep  9 09:47:05 Arbeits-PC kernel: [    5.881311] WMM(0): 0, a42b
Sep  9 09:47:05 Arbeits-PC kernel: [    5.881435] WMM(1): 0, a44f
Sep  9 09:47:05 Arbeits-PC kernel: [    5.881559] WMM(2): 0, 5e4322
Sep  9 09:47:05 Arbeits-PC kernel: [    5.881684] WMM(3): 0, 2f3222
Sep  9 09:47:05 Arbeits-PC kernel: [    5.881686] HTOnAssocRsp
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 09:47:05 Arbeits-PC kernel: [    5.888076] update raid entry,
mask=0xfffffff, arg=0xa0
Sep  9 09:47:05 Arbeits-PC kernel: [    5.889549]
rtl8192c_set_FwJoinBssReport_cmd mstatus(1)
Sep  9 09:47:05 Arbeits-PC kernel: [    5.890423] SetFwRsvdPagePkt
Sep  9 09:47:05 Arbeits-PC kernel: [    5.890431] Set RSVD page location to Fw.
Sep  9 09:47:05 Arbeits-PC kernel: [    5.891545]
=>mlmeext_joinbss_event_callback
Sep  9 09:47:05 Arbeits-PC wpa_supplicant[1404]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 09:47:05 Arbeits-PC wpa_supplicant[1404]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(auth) [id=0 id_str=]
Sep  9 09:47:05 Arbeits-PC kernel: [    5.901042]
Sep  9 09:47:05 Arbeits-PC kernel: [    5.901042]  ~~~~stastakey:unicastkey
Sep  9 09:47:05 Arbeits-PC kernel: [    5.901074]
Sep  9 09:47:05 Arbeits-PC kernel: [    5.901074]  ~~~~stastakey:groupkey
Sep  9 09:47:05 Arbeits-PC kernel: [    5.901076] ==> rtw_set_key
algorithm(4),keyid(1),key_mask(2)
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'WG-WLAN'.
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
device state change: config -> ip-config (reason 'none') [50 70 0]
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> dhclient
started with pid 1797
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Beginning IP6 addrconf.
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Sep  9 09:47:05 Arbeits-PC dhclient: Internet Systems Consortium DHCP
Client 4.2.4
Sep  9 09:47:05 Arbeits-PC dhclient: Copyright 2004-2012 Internet
Systems Consortium.
Sep  9 09:47:05 Arbeits-PC dhclient: All rights reserved.
Sep  9 09:47:05 Arbeits-PC dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Sep  9 09:47:05 Arbeits-PC dhclient:
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
DHCPv4 state changed nbi -> preinit
Sep  9 09:47:05 Arbeits-PC dhclient: Listening on LPF/wlan0/f8:1a:67:19:16:94
Sep  9 09:47:05 Arbeits-PC dhclient: Sending on   LPF/wlan0/f8:1a:67:19:16:94
Sep  9 09:47:05 Arbeits-PC dhclient: Sending on   Socket/fallback
Sep  9 09:47:05 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 255.255.255.255 port 67 (xid=0x2c4356d1)
Sep  9 09:47:05 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 09:47:05 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 3340 seconds.
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
DHCPv4 state changed preinit -> reboot
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info>   address 192.168.1.103
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info>   prefix 24
(255.255.255.0)
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info>   gateway 192.168.1.1
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info>   nameserver
'192.168.1.1'
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Sep  9 09:47:05 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Sep  9 09:47:05 Arbeits-PC avahi-daemon[749]: Joining mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 09:47:05 Arbeits-PC avahi-daemon[749]: New relevant interface
wlan0.IPv4 for mDNS.
Sep  9 09:47:05 Arbeits-PC avahi-daemon[749]: Registering new address
record for 192.168.1.103 on wlan0.IPv4.
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
device state change: ip-config -> secondaries (reason 'none') [70 90
0]
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <info> (wlan0):
device state change: secondaries -> activated (reason 'none') [90 100
0]
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <info> Policy set
'WG-WLAN' (wlan0) as default for IPv4 routing and DNS.
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <info> DNS: starting dnsmasq...
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <warn> dnsmasq not
available on the bus, can't update servers.
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <error>
[1378712826.556713] [nm-dns-dnsmasq.c:402] update(): dnsmasq owner not
found on bus: Could not get owner of name
'org.freedesktop.NetworkManager.dnsmasq': no such name
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <warn> DNS: plugin
dnsmasq update failed
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 09:47:06 Arbeits-PC dnsmasq[1802]: Gestartet, Version 2.65
Cache deaktiviert
Sep  9 09:47:06 Arbeits-PC dnsmasq[1802]: Übersetzungsoptionen: IPv6
GNU-getopt DBus i18n IDN DHCP DHCPv6 no-Lua TFTP conntrack
Sep  9 09:47:06 Arbeits-PC dnsmasq[1802]: DBus-Unterstützung
eingeschaltet: mit Systembus verbunden
Sep  9 09:47:06 Arbeits-PC dnsmasq[1802]: Warnung: keine vorgelagerten
(Upstream) Server konfiguriert
Sep  9 09:47:06 Arbeits-PC kernel: [    6.996590] OnAction_back
Sep  9 09:47:06 Arbeits-PC kernel: [    6.996593] OnAction_back, action=0
Sep  9 09:47:06 Arbeits-PC kernel: [    6.996594] issue_action_BA,
category=3, action=1, status=0
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) successful, device activated.
Sep  9 09:47:06 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <warn> dnsmasq
appeared on DBus: :1.37
Sep  9 09:47:06 Arbeits-PC NetworkManager[1019]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 09:47:06 Arbeits-PC dnsmasq[1802]: vorgelagerte Server von DBus gesetzt
Sep  9 09:47:06 Arbeits-PC dnsmasq[1802]: Benutze Namensserver 192.168.1.1#53
Sep  9 09:47:06 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 09:47:07 Arbeits-PC rtkit-daemon[1761]: Successfully made
thread 1951 of process 1754 (n/a) owned by '110' RT at priority 5.
Sep  9 09:47:07 Arbeits-PC rtkit-daemon[1761]: Supervising 3 threads
of 1 processes of 1 users.
Sep  9 09:47:07 Arbeits-PC rtkit-daemon[1761]: Successfully made
thread 1952 of process 1754 (n/a) owned by '110' RT at priority 5.
Sep  9 09:47:07 Arbeits-PC rtkit-daemon[1761]: Supervising 4 threads
of 1 processes of 1 users.
Sep  9 09:47:07 Arbeits-PC rtkit-daemon[1761]: Successfully made
thread 1954 of process 1954 (n/a) owned by '110' high priority at nice
level -11.
Sep  9 09:47:07 Arbeits-PC rtkit-daemon[1761]: Supervising 5 threads
of 2 processes of 1 users.
Sep  9 09:47:07 Arbeits-PC pulseaudio[1954]: [pulseaudio] pid.c:
Daemon already running.
Sep  9 09:47:07 Arbeits-PC avahi-daemon[749]: Joining mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 09:47:07 Arbeits-PC avahi-daemon[749]: New relevant interface
wlan0.IPv6 for mDNS.
Sep  9 09:47:07 Arbeits-PC avahi-daemon[749]: Registering new address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.*.
Sep  9 09:47:13 Arbeits-PC ntpdate[1930]: adjust time server
91.189.94.4 offset 0.450319 sec
Sep  9 09:47:18 Arbeits-PC kernel: [   19.141050] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:47:18 Arbeits-PC kernel: [   19.141053]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:47:25 Arbeits-PC NetworkManager[1019]: <info> (wlan0): IP6
addrconf timed out or failed.
Sep  9 09:47:25 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Sep  9 09:47:25 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Sep  9 09:47:25 Arbeits-PC NetworkManager[1019]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Sep  9 09:47:25 Arbeits-PC kernel: [   26.172537] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:47:25 Arbeits-PC kernel: [   26.172631]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:47:27 Arbeits-PC kernel: [   27.535405] survey done event(11)
Sep  9 09:47:28 Arbeits-PC kernel: [   29.141645] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:47:28 Arbeits-PC kernel: [   29.141648]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:47:30 Arbeits-PC colord: device removed: xrandr-Samsung
Electric Company-SMS27A550H-808465713
Sep  9 09:47:30 Arbeits-PC colord: Profile removed:
icc-43452068d98938efc2ed29a6d513fbc0
Sep  9 09:47:30 Arbeits-PC rtkit-daemon[1761]: Successfully made
thread 2090 of process 2090 (n/a) owned by '1000' high priority at
nice level -11.
Sep  9 09:47:30 Arbeits-PC rtkit-daemon[1761]: Supervising 1 threads
of 1 processes of 1 users.
Sep  9 09:47:30 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.systemd1' (using servicehelper)
Sep  9 09:47:30 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.systemd1'
Sep  9 09:47:30 Arbeits-PC colord: Device added: xrandr-Samsung
Electric Company-SMS27A550H-808465713
Sep  9 09:47:30 Arbeits-PC rtkit-daemon[1761]: Successfully made
thread 2119 of process 2090 (n/a) owned by '1000' RT at priority 5.
Sep  9 09:47:30 Arbeits-PC rtkit-daemon[1761]: Supervising 2 threads
of 1 processes of 1 users.
Sep  9 09:47:34 Arbeits-PC rtkit-daemon[1761]: Successfully made
thread 2120 of process 2090 (n/a) owned by '1000' RT at priority 5.
Sep  9 09:47:34 Arbeits-PC rtkit-daemon[1761]: Supervising 3 threads
of 1 processes of 1 users.
Sep  9 09:47:34 Arbeits-PC rtkit-daemon[1761]: Successfully made
thread 2121 of process 2090 (n/a) owned by '1000' RT at priority 5.
Sep  9 09:47:34 Arbeits-PC rtkit-daemon[1761]: Supervising 4 threads
of 1 processes of 1 users.
Sep  9 09:47:34 Arbeits-PC rtkit-daemon[1761]: Successfully made
thread 2123 of process 2123 (n/a) owned by '1000' high priority at
nice level -11.
Sep  9 09:47:34 Arbeits-PC rtkit-daemon[1761]: Supervising 5 threads
of 2 processes of 1 users.
Sep  9 09:47:34 Arbeits-PC pulseaudio[2123]: [pulseaudio] pid.c:
Daemon already running.
Sep  9 09:47:34 Arbeits-PC colord: Profile added:
icc-d78f3944822b856ad4092fc58ca09547
Sep  9 09:47:34 Arbeits-PC colord: Profile added:
icc-51d0587849c3109e19cf97296ee1f39f
Sep  9 09:47:35 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.UDisks2' (using servicehelper)
Sep  9 09:47:35 Arbeits-PC udisksd[2163]: udisks daemon version 2.1.0 starting
Sep  9 09:47:35 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.UDisks2'
Sep  9 09:47:35 Arbeits-PC udisksd[2163]: Acquired the name
org.freedesktop.UDisks2 on the system message bus
Sep  9 09:47:35 Arbeits-PC udisksd[2163]: Cleaning up mount point
/media/vincent/Elements (device 8:49 is not mounted)
Sep  9 09:47:35 Arbeits-PC udisksd[2163]: Cleaning up mount point
/media/vincent/Elements1 (device 8:33 is not mounted)
Sep  9 09:47:35 Arbeits-PC udisksd[2163]: Cleaning up mount point
/media/vincent/c08c4653-e319-4cce-8862-07874a4d20e7 (device 8:17 is
not mounted)
Sep  9 09:47:37 Arbeits-PC ntfs-3g[2336]: Version 2013.1.13 external FUSE 29
Sep  9 09:47:37 Arbeits-PC ntfs-3g[2336]: Mounted /dev/sdd1
(Read-Write, label "Elements", NTFS 3.1)
Sep  9 09:47:37 Arbeits-PC ntfs-3g[2336]: Cmdline options:
rw,nosuid,nodev,uhelper=udisks2,uid=1000,gid=1000,dmask=0077,fmask=0177
Sep  9 09:47:37 Arbeits-PC ntfs-3g[2336]: Mount options:
rw,nosuid,nodev,uhelper=udisks2,allow_other,nonempty,relatime,default_permissions,fsname=/dev/sdd1,blkdev,blksize=4096
Sep  9 09:47:37 Arbeits-PC ntfs-3g[2336]: Global ownership and
permissions enforced, configuration type 7
Sep  9 09:47:37 Arbeits-PC udisksd[2163]: Mounted /dev/sdd1 at
/media/vincent/Elements on behalf of uid 1000
Sep  9 09:47:37 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.hostname1' (using servicehelper)
Sep  9 09:47:37 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.hostname1'
Sep  9 09:47:38 Arbeits-PC ntfs-3g[2452]: Version 2013.1.13 external FUSE 29
Sep  9 09:47:38 Arbeits-PC ntfs-3g[2452]: Mounted /dev/sdc1
(Read-Write, label "Elements", NTFS 3.1)
Sep  9 09:47:38 Arbeits-PC ntfs-3g[2452]: Cmdline options:
rw,nosuid,nodev,uhelper=udisks2,uid=1000,gid=1000,dmask=0077,fmask=0177
Sep  9 09:47:38 Arbeits-PC ntfs-3g[2452]: Mount options:
rw,nosuid,nodev,uhelper=udisks2,allow_other,nonempty,relatime,default_permissions,fsname=/dev/sdc1,blkdev,blksize=4096
Sep  9 09:47:38 Arbeits-PC ntfs-3g[2452]: Global ownership and
permissions enforced, configuration type 7
Sep  9 09:47:38 Arbeits-PC udisksd[2163]: Mounted /dev/sdc1 at
/media/vincent/Elements1 on behalf of uid 1000
Sep  9 09:47:40 Arbeits-PC kernel: [   41.142465] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:47:40 Arbeits-PC kernel: [   41.142586]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:47:42 Arbeits-PC kernel: [   43.142613] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:47:42 Arbeits-PC kernel: [   43.142618]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:47:46 Arbeits-PC kernel: [   47.142836] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:47:46 Arbeits-PC kernel: [   47.142972]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:47:46 Arbeits-PC kernel: [   47.175463] rtw_issue_addbareq_cmd, p=0
Sep  9 09:47:46 Arbeits-PC kernel: [   47.175491] issue_action_BA,
category=3, action=0, status=0
Sep  9 09:47:46 Arbeits-PC kernel: [   47.175494] BA_starting_seqctrl
= 207 for TID=0
Sep  9 09:47:46 Arbeits-PC kernel: [   47.179768] OnAction_back
Sep  9 09:47:46 Arbeits-PC kernel: [   47.179771] OnAction_back, action=1
Sep  9 09:47:46 Arbeits-PC kernel: [   47.179772] agg_enable for TID=0
Sep  9 09:48:00 Arbeits-PC kernel: [   60.782228] rtw_issue_addbareq_cmd, p=6
Sep  9 09:48:00 Arbeits-PC kernel: [   60.782242] issue_action_BA,
category=3, action=0, status=6
Sep  9 09:48:00 Arbeits-PC kernel: [   60.782244] BA_starting_seqctrl
= 5 for TID=6
Sep  9 09:48:00 Arbeits-PC kernel: [   60.786563] OnAction_back
Sep  9 09:48:00 Arbeits-PC kernel: [   60.786566] OnAction_back, action=1
Sep  9 09:48:00 Arbeits-PC kernel: [   60.786567] agg_enable for TID=6
Sep  9 09:48:10 Arbeits-PC dbus[651]: [system] Activating service
name='com.ubuntu.SoftwareProperties' (using servicehelper)
Sep  9 09:48:10 Arbeits-PC dbus[651]: [system] Successfully activated
service 'com.ubuntu.SoftwareProperties'
Sep  9 09:48:14 Arbeits-PC kernel: [   75.144783] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:48:14 Arbeits-PC kernel: [   75.144788]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:48:16 Arbeits-PC kernel: [   77.144936] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:48:16 Arbeits-PC kernel: [   77.145049]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:48:17 Arbeits-PC pulseaudio[3260]: [pulseaudio]
server-lookup.c: Unable to contact D-Bus:
org.freedesktop.DBus.Error.NotSupported: Unable to autolaunch a
dbus-daemon without a $DISPLAY for X11
Sep  9 09:48:17 Arbeits-PC pulseaudio[3260]: [pulseaudio] main.c:
Unable to contact D-Bus: org.freedesktop.DBus.Error.NotSupported:
Unable to autolaunch a dbus-daemon without a $DISPLAY for X11
Sep  9 09:48:20 Arbeits-PC kernel: [   81.145162] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:48:20 Arbeits-PC kernel: [   81.145169]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:48:22 Arbeits-PC kernel: [   83.145271] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:48:22 Arbeits-PC kernel: [   83.145394]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:48:24 Arbeits-PC kernel: [   85.145409] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:48:24 Arbeits-PC kernel: [   85.145416]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:48:26 Arbeits-PC kernel: [   87.145683] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:48:26 Arbeits-PC kernel: [   87.145786]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:48:35 Arbeits-PC pulseaudio[2090]: [alsa-sink] alsa-sink.c:
ALSA weckte uns auf, um neue Daten auf das Gerät zu schreiben, doch es
gab nichts zum Schreiben!
Sep  9 09:48:35 Arbeits-PC pulseaudio[2090]: [alsa-sink] alsa-sink.c:
Dies ist höchstwahrscheinlich ein Fehler im ALSA-Treiber
'snd_hda_intel'. Bitte melden Sie diesen Fehler den ALSA-Entwicklern.
Sep  9 09:48:35 Arbeits-PC pulseaudio[2090]: [alsa-sink] alsa-sink.c:
Wir wurden durch das POLLOUT-Set geweckt, allerdings lieferte ein
anschliessender snd_pcm_avail() den Wert 0 oder einen anderen Wert <
min_avail.
Sep  9 09:48:50 Arbeits-PC kernel: [  111.147274] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:48:50 Arbeits-PC kernel: [  111.147279]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:48:52 Arbeits-PC kernel: [  113.147389] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:48:52 Arbeits-PC kernel: [  113.147491]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:48:54 Arbeits-PC kernel: [  115.147514] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:48:54 Arbeits-PC kernel: [  115.147521]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:48:56 Arbeits-PC kernel: [  117.147608] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:48:56 Arbeits-PC kernel: [  117.147728]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:48:58 Arbeits-PC kernel: [  119.147706] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:48:58 Arbeits-PC kernel: [  119.147713]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:49:02 Arbeits-PC kernel: [  123.148236] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:49:02 Arbeits-PC kernel: [  123.148348]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:49:04 Arbeits-PC kernel: [  125.148246] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:49:04 Arbeits-PC kernel: [  125.148253]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:49:06 Arbeits-PC kernel: [  127.148368] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:49:06 Arbeits-PC kernel: [  127.148471]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:49:08 Arbeits-PC kernel: [  129.148450] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:49:08 Arbeits-PC kernel: [  129.148454]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:49:11 Arbeits-PC kernel: [  131.968197] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:49:11 Arbeits-PC kernel: [  131.968404]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:49:13 Arbeits-PC kernel: [  133.334911] survey done event(12)
Sep  9 09:49:29 Arbeits-PC kernel: [  149.149836] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:49:29 Arbeits-PC kernel: [  149.149844]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:49:31 Arbeits-PC kernel: [  151.149929] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:49:31 Arbeits-PC kernel: [  151.150047]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:49:33 Arbeits-PC kernel: [  153.150047] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:49:33 Arbeits-PC kernel: [  153.150055]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:49:47 Arbeits-PC kernel: [  167.151025] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:49:47 Arbeits-PC kernel: [  167.151147]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:49:49 Arbeits-PC kernel: [  169.151147] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:49:49 Arbeits-PC kernel: [  169.151154]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:49:55 Arbeits-PC kernel: [  175.151519] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:49:55 Arbeits-PC kernel: [  175.151640]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:50:03 Arbeits-PC kernel: [  183.152098] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:50:03 Arbeits-PC kernel: [  183.152105]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:50:05 Arbeits-PC kernel: [  185.152230] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:50:05 Arbeits-PC kernel: [  185.152342]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:50:15 Arbeits-PC kernel: [  195.152859] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:50:15 Arbeits-PC kernel: [  195.152866]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:50:17 Arbeits-PC kernel: [  197.152983] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:50:17 Arbeits-PC kernel: [  197.153103]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:50:19 Arbeits-PC kernel: [  199.153107] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:50:19 Arbeits-PC kernel: [  199.153114]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:50:34 Arbeits-PC kernel: [  214.809770] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:50:34 Arbeits-PC kernel: [  214.809937]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:50:36 Arbeits-PC kernel: [  216.170829] survey done event(13)
Sep  9 09:50:41 Arbeits-PC kernel: [  221.154714] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:50:41 Arbeits-PC kernel: [  221.154721]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:50:41 Arbeits-PC kernel: [  221.918896] EXT4-fs (sdb1):
mounted filesystem with ordered data mode. Opts: (null)
Sep  9 09:50:41 Arbeits-PC udisksd[2163]: Mounted /dev/sdb1 at
/media/vincent/c08c4653-e319-4cce-8862-07874a4d20e7 on behalf of uid
1000
Sep  9 09:50:45 Arbeits-PC kernel: [  225.154935] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:50:45 Arbeits-PC kernel: [  225.155058]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:51:15 Arbeits-PC kernel: [  255.156850] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:51:15 Arbeits-PC kernel: [  255.156855]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:51:17 Arbeits-PC kernel: [  257.156986] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:51:17 Arbeits-PC kernel: [  257.157106]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:51:21 Arbeits-PC kernel: [  261.157354] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:51:21 Arbeits-PC kernel: [  261.157359]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:51:25 Arbeits-PC kernel: [  265.157641] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:51:25 Arbeits-PC kernel: [  265.157743]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:51:27 Arbeits-PC kernel: [  267.157737] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:51:27 Arbeits-PC kernel: [  267.157744]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:51:31 Arbeits-PC kernel: [  271.157963] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:51:31 Arbeits-PC kernel: [  271.158070]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:51:33 Arbeits-PC kernel: [  273.158110] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:51:33 Arbeits-PC kernel: [  273.158117]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:51:35 Arbeits-PC kernel: [  275.158231] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:51:35 Arbeits-PC kernel: [  275.158333]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:51:59 Arbeits-PC kernel: [  299.159935] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:51:59 Arbeits-PC kernel: [  299.159942]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:52:03 Arbeits-PC kernel: [  303.160178] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:52:03 Arbeits-PC kernel: [  303.160299]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:52:05 Arbeits-PC kernel: [  305.160273] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:52:05 Arbeits-PC kernel: [  305.160279]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:52:07 Arbeits-PC kernel: [  307.160393] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:52:07 Arbeits-PC kernel: [  307.160512]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:52:09 Arbeits-PC kernel: [  309.160517] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:52:09 Arbeits-PC kernel: [  309.160524]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:52:17 Arbeits-PC kernel: [  317.161181] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:52:17 Arbeits-PC kernel: [  317.161276]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:52:19 Arbeits-PC kernel: [  318.964280] survey done event(12)
Sep  9 09:52:23 Arbeits-PC kernel: [  323.161528] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:52:23 Arbeits-PC kernel: [  323.161535]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:52:27 Arbeits-PC kernel: [  327.161738] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:52:27 Arbeits-PC kernel: [  327.161852]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:52:29 Arbeits-PC kernel: [  329.161890] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:52:29 Arbeits-PC kernel: [  329.161897]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:52:31 Arbeits-PC kernel: [  331.161992] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:52:31 Arbeits-PC kernel: [  331.162128]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:52:39 Arbeits-PC kernel: [  339.162619] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:52:39 Arbeits-PC kernel: [  339.162626]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:52:41 Arbeits-PC kernel: [  341.162721] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:52:41 Arbeits-PC kernel: [  341.162831]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:52:45 Arbeits-PC kernel: [  345.162966] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:52:45 Arbeits-PC kernel: [  345.162974]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:52:47 Arbeits-PC kernel: [  347.163076] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:52:47 Arbeits-PC kernel: [  347.163194]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:52:51 Arbeits-PC kernel: [  351.163501] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:52:51 Arbeits-PC kernel: [  351.163507]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:52:57 Arbeits-PC kernel: [  357.164069] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:52:57 Arbeits-PC kernel: [  357.164190]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:53:19 Arbeits-PC kernel: [  379.165278] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:53:19 Arbeits-PC kernel: [  379.165285]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:53:27 Arbeits-PC kernel: [  387.165777] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:53:27 Arbeits-PC kernel: [  387.165897]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:53:29 Arbeits-PC kernel: [  389.165915] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:53:29 Arbeits-PC kernel: [  389.165923]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:53:43 Arbeits-PC kernel: [  403.166886] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:53:43 Arbeits-PC kernel: [  403.167003]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:53:51 Arbeits-PC kernel: [  411.167492] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:53:51 Arbeits-PC kernel: [  411.167506]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:53:57 Arbeits-PC kernel: [  417.167857] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:53:57 Arbeits-PC kernel: [  417.167976]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:53:59 Arbeits-PC kernel: [  419.167968] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:53:59 Arbeits-PC kernel: [  419.167973]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:54:07 Arbeits-PC kernel: [  427.168462] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:54:07 Arbeits-PC kernel: [  427.168582]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:54:09 Arbeits-PC kernel: [  429.168710] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:54:09 Arbeits-PC kernel: [  429.168714]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:54:11 Arbeits-PC kernel: [  431.168830] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:54:11 Arbeits-PC kernel: [  431.168940]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:54:13 Arbeits-PC kernel: [  433.168934] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:54:13 Arbeits-PC kernel: [  433.168939]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:54:17 Arbeits-PC kernel: [  437.169196] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:54:17 Arbeits-PC kernel: [  437.169315]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:54:19 Arbeits-PC kernel: [  438.732800] survey done event(12)
Sep  9 09:54:19 Arbeits-PC kernel: [  439.169315] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:54:19 Arbeits-PC kernel: [  439.169320]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:54:29 Arbeits-PC kernel: [  449.170065] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:54:29 Arbeits-PC kernel: [  449.170191]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:54:33 Arbeits-PC kernel: [  453.170562] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:54:33 Arbeits-PC kernel: [  453.170568]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:54:35 Arbeits-PC kernel: [  455.170452] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:54:35 Arbeits-PC kernel: [  455.170556]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:54:59 Arbeits-PC kernel: [  479.171991] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:54:59 Arbeits-PC kernel: [  479.171998]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:55:05 Arbeits-PC kernel: [  485.172530] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:55:05 Arbeits-PC kernel: [  485.172635]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:55:15 Arbeits-PC kernel: [  495.173120] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:55:15 Arbeits-PC kernel: [  495.173126]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:55:17 Arbeits-PC kernel: [  497.173210] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:55:17 Arbeits-PC kernel: [  497.173368]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:55:21 Arbeits-PC kernel: [  501.173633] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:55:21 Arbeits-PC kernel: [  501.173639]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:55:25 Arbeits-PC kernel: [  505.173873] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:55:25 Arbeits-PC kernel: [  505.173978]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:55:51 Arbeits-PC kernel: [  531.175588] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:55:51 Arbeits-PC kernel: [  531.175595]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:55:53 Arbeits-PC kernel: [  533.175685] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:55:53 Arbeits-PC kernel: [  533.175804]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:55:59 Arbeits-PC kernel: [  539.176024] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:55:59 Arbeits-PC kernel: [  539.176029]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:56:05 Arbeits-PC kernel: [  545.176501] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:56:05 Arbeits-PC kernel: [  545.176684]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:56:13 Arbeits-PC kernel: [  553.177021] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:56:13 Arbeits-PC kernel: [  553.177028]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:56:15 Arbeits-PC kernel: [  555.177291] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:56:15 Arbeits-PC kernel: [  555.177394]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:56:19 Arbeits-PC kernel: [  558.501326] survey done event(14)
Sep  9 09:56:21 Arbeits-PC kernel: [  561.177642] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:56:21 Arbeits-PC kernel: [  561.177649]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:56:35 Arbeits-PC kernel: [  575.178496] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:56:35 Arbeits-PC kernel: [  575.178611]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:57:15 Arbeits-PC kernel: [  615.181293] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:57:15 Arbeits-PC kernel: [  615.181301]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:57:17 Arbeits-PC kernel: [  617.181440] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:57:17 Arbeits-PC kernel: [  617.181545]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:57:21 Arbeits-PC kernel: [  621.181687] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:57:21 Arbeits-PC kernel: [  621.181694]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:57:27 Arbeits-PC kernel: [  627.182028] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:57:27 Arbeits-PC kernel: [  627.182151]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:57:31 Arbeits-PC kernel: [  631.182278] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:57:31 Arbeits-PC kernel: [  631.182284]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:57:38 Arbeits-PC kernel: [  637.182784] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:57:38 Arbeits-PC kernel: [  637.182887]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:57:40 Arbeits-PC kernel: [  639.182904] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:57:40 Arbeits-PC kernel: [  639.182911]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:57:42 Arbeits-PC kernel: [  641.183024] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:57:42 Arbeits-PC kernel: [  641.183127]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:57:50 Arbeits-PC kernel: [  649.183487] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:57:50 Arbeits-PC kernel: [  649.183494]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:57:52 Arbeits-PC kernel: [  651.183610] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:57:52 Arbeits-PC kernel: [  651.183712]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:57:56 Arbeits-PC kernel: [  655.183873] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:57:56 Arbeits-PC kernel: [  655.183880]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:57:58 Arbeits-PC kernel: [  657.184097] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:57:58 Arbeits-PC kernel: [  657.184226]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:58:02 Arbeits-PC kernel: [  661.184315] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:58:02 Arbeits-PC kernel: [  661.184322]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:58:08 Arbeits-PC kernel: [  667.184714] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:58:08 Arbeits-PC kernel: [  667.184835]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:58:19 Arbeits-PC kernel: [  678.269973] survey done event(12)
Sep  9 09:58:22 Arbeits-PC kernel: [  681.185690] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:58:22 Arbeits-PC kernel: [  681.185696]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:58:28 Arbeits-PC kernel: [  687.186061] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:58:28 Arbeits-PC kernel: [  687.186177]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:58:32 Arbeits-PC kernel: [  691.186444] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:58:32 Arbeits-PC kernel: [  691.186451]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:58:38 Arbeits-PC kernel: [  697.186808] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:58:38 Arbeits-PC kernel: [  697.186896]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:58:40 Arbeits-PC kernel: [  699.186934] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:58:40 Arbeits-PC kernel: [  699.186941]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:58:42 Arbeits-PC kernel: [  701.187030] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:58:42 Arbeits-PC kernel: [  701.187149]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:58:44 Arbeits-PC kernel: [  703.187155] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:58:44 Arbeits-PC kernel: [  703.187162]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:58:48 Arbeits-PC kernel: [  707.187544] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:58:48 Arbeits-PC kernel: [  707.187646]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:58:54 Arbeits-PC kernel: [  713.187909] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:58:54 Arbeits-PC kernel: [  713.187915]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:58:58 Arbeits-PC kernel: [  717.188524] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:58:58 Arbeits-PC kernel: [  717.188628]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:59:00 Arbeits-PC kernel: [  719.188247] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:59:00 Arbeits-PC kernel: [  719.188254]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:59:08 Arbeits-PC kernel: [  727.188741] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:59:08 Arbeits-PC kernel: [  727.188862]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:59:10 Arbeits-PC kernel: [  729.188871] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:59:10 Arbeits-PC kernel: [  729.188877]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:59:12 Arbeits-PC kernel: [  731.189130] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:59:12 Arbeits-PC kernel: [  731.189235]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:59:20 Arbeits-PC kernel: [  739.189611] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:59:20 Arbeits-PC kernel: [  739.189618]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:59:22 Arbeits-PC kernel: [  741.189697] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:59:22 Arbeits-PC kernel: [  741.189867]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:59:26 Arbeits-PC kernel: [  745.190107] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:59:26 Arbeits-PC kernel: [  745.190114]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:59:28 Arbeits-PC kernel: [  747.190202] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:59:28 Arbeits-PC kernel: [  747.190323]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 09:59:50 Arbeits-PC kernel: [  769.191665] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 09:59:50 Arbeits-PC kernel: [  769.191671]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 09:59:58 Arbeits-PC kernel: [  777.192160] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 09:59:58 Arbeits-PC kernel: [  777.192281]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:00:04 Arbeits-PC kernel: [  783.192670] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:00:04 Arbeits-PC kernel: [  783.192677]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:00:08 Arbeits-PC kernel: [  787.192913] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:00:08 Arbeits-PC kernel: [  787.193016]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:00:10 Arbeits-PC kernel: [  789.193015] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:00:10 Arbeits-PC kernel: [  789.193021]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:00:14 Arbeits-PC kernel: [  793.193258] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:00:14 Arbeits-PC kernel: [  793.193381]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:00:19 Arbeits-PC kernel: [  798.038498] survey done event(15)
Sep  9 10:00:22 Arbeits-PC kernel: [  801.193744] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:00:22 Arbeits-PC kernel: [  801.193751]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:00:24 Arbeits-PC kernel: [  803.194013] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:00:24 Arbeits-PC kernel: [  803.194117]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:00:26 Arbeits-PC kernel: [  805.194115] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:00:26 Arbeits-PC kernel: [  805.194121]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:00:28 Arbeits-PC kernel: [  807.194204] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:00:28 Arbeits-PC kernel: [  807.194322]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:00:32 Arbeits-PC kernel: [  811.194500] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:00:32 Arbeits-PC kernel: [  811.194507]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:00:34 Arbeits-PC kernel: [  813.194601] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:00:34 Arbeits-PC kernel: [  813.194685]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:00:46 Arbeits-PC kernel: [  825.195423] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:00:46 Arbeits-PC kernel: [  825.195430]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:00:48 Arbeits-PC kernel: [  827.195597] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:00:48 Arbeits-PC kernel: [  827.195704]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:00:54 Arbeits-PC kernel: [  833.195944] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:00:54 Arbeits-PC kernel: [  833.195951]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:00:56 Arbeits-PC kernel: [  835.196061] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:00:56 Arbeits-PC kernel: [  835.196180]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:01:04 Arbeits-PC kernel: [  843.196699] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:01:04 Arbeits-PC kernel: [  843.196705]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:01:08 Arbeits-PC kernel: [  847.196940] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:01:08 Arbeits-PC kernel: [  847.197022]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:01:10 Arbeits-PC kernel: [  849.197071] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:01:10 Arbeits-PC kernel: [  849.197078]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:01:20 Arbeits-PC kernel: [  859.197615] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:01:20 Arbeits-PC kernel: [  859.197733]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:01:22 Arbeits-PC kernel: [  861.197921] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:01:22 Arbeits-PC kernel: [  861.197928]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:01:26 Arbeits-PC kernel: [  865.198130] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:01:26 Arbeits-PC kernel: [  865.198249]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:01:28 Arbeits-PC kernel: [  867.198281] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:01:28 Arbeits-PC kernel: [  867.198288]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:01:46 Arbeits-PC kernel: [  885.199505] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:01:46 Arbeits-PC kernel: [  885.199611]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:01:48 Arbeits-PC kernel: [  887.199599] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:01:48 Arbeits-PC kernel: [  887.199606]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:02:17 Arbeits-PC kernel: [  916.454752] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:02:17 Arbeits-PC kernel: [  916.454846]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:02:19 Arbeits-PC kernel: [  917.819005] survey done event(15)
Sep  9 10:02:20 Arbeits-PC kernel: [  919.201804] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:02:20 Arbeits-PC kernel: [  919.201811]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:02:22 Arbeits-PC kernel: [  921.201944] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:02:22 Arbeits-PC kernel: [  921.202045]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:02:24 Arbeits-PC kernel: [  923.202040] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:02:24 Arbeits-PC kernel: [  923.202046]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:02:28 Arbeits-PC kernel: [  927.202256] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:02:28 Arbeits-PC kernel: [  927.202372]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:02:30 Arbeits-PC kernel: [  929.202413] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:02:30 Arbeits-PC kernel: [  929.202420]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:02:38 Arbeits-PC kernel: [  937.203000] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:02:38 Arbeits-PC kernel: [  937.203107]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:02:40 Arbeits-PC kernel: [  939.203150] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:02:40 Arbeits-PC kernel: [  939.203157]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:02:48 Arbeits-PC kernel: [  947.203632] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:02:48 Arbeits-PC kernel: [  947.203752]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:02:50 Arbeits-PC kernel: [  949.203754] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:02:50 Arbeits-PC kernel: [  949.203761]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:02:56 Arbeits-PC kernel: [  955.204264] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:02:56 Arbeits-PC kernel: [  955.204367]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:02:58 Arbeits-PC kernel: [  957.204387] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:02:58 Arbeits-PC kernel: [  957.204393]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:03:08 Arbeits-PC kernel: [  967.204971] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:03:08 Arbeits-PC kernel: [  967.205095]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:03:12 Arbeits-PC kernel: [  971.205347] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:03:12 Arbeits-PC kernel: [  971.205354]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:03:14 Arbeits-PC kernel: [  973.205486] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:03:14 Arbeits-PC kernel: [  973.205590]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:03:16 Arbeits-PC kernel: [  975.205584] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:03:16 Arbeits-PC kernel: [  975.205591]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:03:18 Arbeits-PC kernel: [  977.205729] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:03:18 Arbeits-PC kernel: [  977.205832]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:03:20 Arbeits-PC kernel: [  979.205796] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:03:20 Arbeits-PC kernel: [  979.205802]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:03:24 Arbeits-PC kernel: [  983.206071] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:03:24 Arbeits-PC kernel: [  983.206194]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:03:26 Arbeits-PC kernel: [  985.206196] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:03:26 Arbeits-PC kernel: [  985.206202]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:03:30 Arbeits-PC kernel: [  989.206430] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:03:30 Arbeits-PC kernel: [  989.206558]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:03:32 Arbeits-PC kernel: [  991.206706] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:03:32 Arbeits-PC kernel: [  991.206712]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:03:44 Arbeits-PC kernel: [ 1003.207415] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:03:44 Arbeits-PC kernel: [ 1003.207537]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:03:46 Arbeits-PC kernel: [ 1005.207537] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:03:46 Arbeits-PC kernel: [ 1005.207545]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:03:48 Arbeits-PC kernel: [ 1007.207659] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:03:48 Arbeits-PC kernel: [ 1007.207780]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:03:52 Arbeits-PC kernel: [ 1011.207994] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:03:52 Arbeits-PC kernel: [ 1011.208000]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:03:58 Arbeits-PC kernel: [ 1017.208414] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:03:58 Arbeits-PC kernel: [ 1017.208520]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:04:00 Arbeits-PC kernel: [ 1019.208513] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:04:00 Arbeits-PC kernel: [ 1019.208519]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:04:08 Arbeits-PC kernel: [ 1027.209010] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:04:08 Arbeits-PC kernel: [ 1027.209122]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:04:12 Arbeits-PC kernel: [ 1031.209387] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:04:12 Arbeits-PC kernel: [ 1031.209393]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:04:17 Arbeits-PC kernel: [ 1036.222025] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:04:17 Arbeits-PC kernel: [ 1036.222122]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:04:19 Arbeits-PC kernel: [ 1037.583659] survey done event(12)
Sep  9 10:04:20 Arbeits-PC kernel: [ 1039.210500] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:04:20 Arbeits-PC kernel: [ 1039.210506]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:04:26 Arbeits-PC kernel: [ 1045.213843] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:04:26 Arbeits-PC kernel: [ 1045.213964]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:04:30 Arbeits-PC kernel: [ 1049.216078] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:04:30 Arbeits-PC kernel: [ 1049.216085]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:04:38 Arbeits-PC kernel: [ 1057.220711] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:04:38 Arbeits-PC kernel: [ 1057.220819]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:04:42 Arbeits-PC kernel: [ 1061.222929] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:04:42 Arbeits-PC kernel: [ 1061.222935]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:04:44 Arbeits-PC kernel: [ 1063.224044] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:04:44 Arbeits-PC kernel: [ 1063.224164]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:04:46 Arbeits-PC kernel: [ 1065.225153] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:04:46 Arbeits-PC kernel: [ 1065.225160]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:04:48 Arbeits-PC kernel: [ 1067.226292] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:04:48 Arbeits-PC kernel: [ 1067.226411]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:04:50 Arbeits-PC kernel: [ 1069.227407] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:04:50 Arbeits-PC kernel: [ 1069.227414]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:04:59 Arbeits-PC dbus[651]: [system] Activating service
name='org.freedesktop.hostname1' (using servicehelper)
Sep  9 10:04:59 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.freedesktop.hostname1'
Sep  9 10:05:16 Arbeits-PC kernel: [ 1095.242189] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:05:16 Arbeits-PC kernel: [ 1095.242339]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:05:18 Arbeits-PC kernel: [ 1097.243365] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:05:18 Arbeits-PC kernel: [ 1097.243372]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:05:20 Arbeits-PC kernel: [ 1099.244464] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:05:20 Arbeits-PC kernel: [ 1099.244584]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:05:22 Arbeits-PC kernel: [ 1101.245589] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:05:22 Arbeits-PC kernel: [ 1101.245596]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:05:28 Arbeits-PC kernel: [ 1107.249060] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:05:28 Arbeits-PC kernel: [ 1107.249193]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:05:30 Arbeits-PC kernel: [ 1109.250184] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:05:30 Arbeits-PC kernel: [ 1109.250191]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:05:38 Arbeits-PC kernel: [ 1117.254640] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:05:38 Arbeits-PC kernel: [ 1117.254793]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:05:40 Arbeits-PC kernel: [ 1119.255794] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:05:40 Arbeits-PC kernel: [ 1119.255801]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:05:48 Arbeits-PC kernel: [ 1127.260391] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:05:48 Arbeits-PC kernel: [ 1127.260494]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:05:54 Arbeits-PC kernel: [ 1133.263760] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:05:54 Arbeits-PC kernel: [ 1133.263767]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:05:59 Arbeits-PC kernel: [ 1137.265998] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:05:59 Arbeits-PC kernel: [ 1137.266122]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:06:01 Arbeits-PC kernel: [ 1139.267238] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:06:01 Arbeits-PC kernel: [ 1139.267244]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:06:03 Arbeits-PC kernel: [ 1141.268386] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:06:03 Arbeits-PC kernel: [ 1141.268494]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:06:05 Arbeits-PC kernel: [ 1143.269463] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:06:05 Arbeits-PC kernel: [ 1143.269468]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:06:09 Arbeits-PC kernel: [ 1147.271726] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:06:09 Arbeits-PC kernel: [ 1147.271847]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:06:11 Arbeits-PC kernel: [ 1149.272848] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:06:11 Arbeits-PC kernel: [ 1149.272854]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:06:17 Arbeits-PC kernel: [ 1156.049289] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:06:17 Arbeits-PC kernel: [ 1156.049462]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:06:19 Arbeits-PC kernel: [ 1157.415841] survey done event(d)
Sep  9 10:06:21 Arbeits-PC kernel: [ 1159.278594] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:06:21 Arbeits-PC kernel: [ 1159.278601]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:06:31 Arbeits-PC kernel: [ 1169.284153] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:06:31 Arbeits-PC kernel: [ 1169.284270]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:06:33 Arbeits-PC kernel: [ 1171.285440] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:06:33 Arbeits-PC kernel: [ 1171.285446]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:06:39 Arbeits-PC dbus[651]: [system] Activating service
name='org.debian.apt' (using servicehelper)
Sep  9 10:06:39 Arbeits-PC AptDaemon: INFO: Initializing daemon
Sep  9 10:06:39 Arbeits-PC dbus[651]: [system] Successfully activated
service 'org.debian.apt'
Sep  9 10:06:40 Arbeits-PC AptDaemon.PackageKit: INFO: Initializing
PackageKit compat layer
Sep  9 10:06:41 Arbeits-PC kernel: [ 1179.289883] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:06:41 Arbeits-PC kernel: [ 1179.290000]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:06:42 Arbeits-PC AptDaemon: INFO: CommitPackages() was
called: dbus.Array([dbus.String('rtl8192cu-tjp-dkms')],
signature=dbus.Signature('s')), dbus.Array([dbus.String('')],
signature=dbus.Signature('s')), dbus.Array([dbus.String('')],
signature=dbus.Signature('s')), dbus.Array([dbus.String('')],
signature=dbus.Signature('s')), dbus.Array([dbus.String('')],
signature=dbus.Signature('s')), dbus.Array([dbus.String('')],
signature=dbus.Signature('s'))
Sep  9 10:06:43 Arbeits-PC AptDaemon.Trans: INFO: Simulate was called
Sep  9 10:06:43 Arbeits-PC AptDaemon.Worker: INFO: Simulating trans:
/org/debian/apt/transaction/5e2475ca7a1f4184ade15d5f57e3eb39
Sep  9 10:06:43 Arbeits-PC AptDaemon.Worker: INFO: Committing
packages: dbus.Array([dbus.String('rtl8192cu-tjp-dkms')],
signature=dbus.Signature('s')), dbus.Array([],
signature=dbus.Signature('s')), dbus.Array([],
signature=dbus.Signature('s')), dbus.Array([],
signature=dbus.Signature('s')), dbus.Array([],
signature=dbus.Signature('s')), dbus.Array([],
signature=dbus.Signature('s'))
Sep  9 10:06:51 Arbeits-PC kernel: [ 1189.295648] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:06:51 Arbeits-PC kernel: [ 1189.295654]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:06:59 Arbeits-PC kernel: [ 1197.300108] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:06:59 Arbeits-PC kernel: [ 1197.300229]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:07:01 Arbeits-PC kernel: [ 1199.301230] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:07:01 Arbeits-PC kernel: [ 1199.301236]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:07:29 Arbeits-PC kernel: [ 1227.317158] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:07:29 Arbeits-PC kernel: [ 1227.317265]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:07:31 Arbeits-PC kernel: [ 1229.318247] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:07:31 Arbeits-PC kernel: [ 1229.318253]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:07:33 Arbeits-PC kernel: [ 1231.319382] rtw_set_ps_mode():
Busy Traffic , Leave 802.11 power save..
Sep  9 10:07:33 Arbeits-PC kernel: [ 1231.319504]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Sep  9 10:07:35 Arbeits-PC kernel: [ 1233.320531] rtw_set_ps_mode():
Enter 802.11 power save mode...
Sep  9 10:07:35 Arbeits-PC kernel: [ 1233.320537]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Sep  9 10:08:11 Arbeits-PC kernel: imklog 5.8.11, log source =
/proc/kmsg started.
Sep  9 10:08:11 Arbeits-PC rsyslogd: [origin software="rsyslogd"
swVersion="5.8.11" x-pid="996" x-info="http://www.rsyslog.com"] start
Sep  9 10:08:11 Arbeits-PC rsyslogd: rsyslogd's groupid changed to 103
Sep  9 10:08:11 Arbeits-PC rsyslogd: rsyslogd's userid changed to 101
Sep  9 10:08:11 Arbeits-PC rsyslogd-2039: Could not open output pipe
'/dev/xconsole' [try http://www.rsyslog.com/e/2039 ]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Initializing cgroup
subsys cpuset
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Initializing cgroup subsys cpu
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Linux version
3.8.0-30-generic (buildd@roseapple) (gcc version 4.7.3 (Ubuntu/Linaro
4.7.3-1ubuntu1) ) #44-Ubuntu SMP Thu Aug 22 20:52:24 UTC 2013 (Ubuntu
3.8.0-30.44-generic 3.8.13.6)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Command line:
BOOT_IMAGE=/boot/vmlinuz-3.8.0-30-generic
root=UUID=b44f3d14-b5d6-4775-a304-5d29e8fcd2db ro nomodeset
acpi_osi=Linux quiet splash vt.handoff=7
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] KERNEL supported cpus:
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   Intel GenuineIntel
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   AMD AuthenticAMD
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   Centaur CentaurHauls
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] e820: BIOS-provided
physical RAM map:
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x0000000000000000-0x000000000009efff] usable
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x000000000009f000-0x000000000009ffff] reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x0000000000100000-0x00000000deb8efff] usable
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000deb8f000-0x00000000df13efff] reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df13f000-0x00000000df383fff] ACPI NVS
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df384000-0x00000000df391fff] ACPI data
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df392000-0x00000000df3befff] ACPI NVS
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df3bf000-0x00000000df3c3fff] ACPI data
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df3c4000-0x00000000df406fff] ACPI NVS
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df407000-0x00000000df7fffff] usable
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000f8000000-0x00000000fbffffff] reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fec00000-0x00000000fec00fff] reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fed00000-0x00000000fed03fff] reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fed1c000-0x00000000fed1ffff] reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fee00000-0x00000000fee00fff] reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000ff000000-0x00000000ffffffff] reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x0000000100000000-0x000000021effffff] usable
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] NX (Execute Disable)
protection: active
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: EFI v2.31 by
American Megatrends
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi:
ACPI=0xdf384000  ACPI 2.0=0xdf384000  SMBIOS=0xdec27e98  MPS=0xfc980
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem00: type=3,
attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem01: type=7,
attr=0xf, range=[0x0000000000008000-0x0000000000048000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem02: type=4,
attr=0xf, range=[0x0000000000048000-0x0000000000059000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem03: type=7,
attr=0xf, range=[0x0000000000059000-0x000000000005f000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem04: type=4,
attr=0xf, range=[0x000000000005f000-0x0000000000060000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem05: type=3,
attr=0xf, range=[0x0000000000060000-0x000000000009f000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem06: type=6,
attr=0x800000000000000f, range=[0x000000000009f000-0x00000000000a0000)
(0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem07: type=7,
attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem08: type=2,
attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem09: type=4,
attr=0xf, range=[0x0000000001100000-0x0000000001984000) (8MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem10: type=3,
attr=0xf, range=[0x0000000001984000-0x0000000001986000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem11: type=4,
attr=0xf, range=[0x0000000001986000-0x0000000001988000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem12: type=3,
attr=0xf, range=[0x0000000001988000-0x000000000198c000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem13: type=4,
attr=0xf, range=[0x000000000198c000-0x0000000001991000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem14: type=3,
attr=0xf, range=[0x0000000001991000-0x000000000199e000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem15: type=4,
attr=0xf, range=[0x000000000199e000-0x0000000001da4000) (4MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem16: type=3,
attr=0xf, range=[0x0000000001da4000-0x0000000001da5000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem17: type=4,
attr=0xf, range=[0x0000000001da5000-0x0000000001da9000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem18: type=3,
attr=0xf, range=[0x0000000001da9000-0x0000000001daa000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem19: type=4,
attr=0xf, range=[0x0000000001daa000-0x0000000001daf000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem20: type=3,
attr=0xf, range=[0x0000000001daf000-0x0000000001db0000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem21: type=4,
attr=0xf, range=[0x0000000001db0000-0x0000000001db1000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem22: type=3,
attr=0xf, range=[0x0000000001db1000-0x0000000001db2000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem23: type=4,
attr=0xf, range=[0x0000000001db2000-0x0000000001dbf000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem24: type=3,
attr=0xf, range=[0x0000000001dbf000-0x0000000001dc0000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem25: type=4,
attr=0xf, range=[0x0000000001dc0000-0x0000000001dc1000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem26: type=3,
attr=0xf, range=[0x0000000001dc1000-0x0000000001dc7000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem27: type=4,
attr=0xf, range=[0x0000000001dc7000-0x0000000001dc9000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem28: type=3,
attr=0xf, range=[0x0000000001dc9000-0x0000000001dca000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem29: type=4,
attr=0xf, range=[0x0000000001dca000-0x0000000001dcf000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem30: type=3,
attr=0xf, range=[0x0000000001dcf000-0x0000000001dd1000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem31: type=4,
attr=0xf, range=[0x0000000001dd1000-0x0000000001dd7000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem32: type=3,
attr=0xf, range=[0x0000000001dd7000-0x0000000001dda000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem33: type=4,
attr=0xf, range=[0x0000000001dda000-0x0000000001ddc000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem34: type=3,
attr=0xf, range=[0x0000000001ddc000-0x0000000001dde000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem35: type=4,
attr=0xf, range=[0x0000000001dde000-0x0000000001ded000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem36: type=3,
attr=0xf, range=[0x0000000001ded000-0x0000000001def000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem37: type=4,
attr=0xf, range=[0x0000000001def000-0x0000000001df0000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem38: type=3,
attr=0xf, range=[0x0000000001df0000-0x0000000001df1000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem39: type=4,
attr=0xf, range=[0x0000000001df1000-0x0000000001df2000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem40: type=3,
attr=0xf, range=[0x0000000001df2000-0x0000000001df3000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem41: type=4,
attr=0xf, range=[0x0000000001df3000-0x0000000001df7000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem42: type=3,
attr=0xf, range=[0x0000000001df7000-0x0000000001df9000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem43: type=4,
attr=0xf, range=[0x0000000001df9000-0x0000000001dfd000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem44: type=3,
attr=0xf, range=[0x0000000001dfd000-0x0000000001dff000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem45: type=4,
attr=0xf, range=[0x0000000001dff000-0x0000000001e07000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem46: type=3,
attr=0xf, range=[0x0000000001e07000-0x0000000001e0b000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem47: type=4,
attr=0xf, range=[0x0000000001e0b000-0x0000000001e0d000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem48: type=3,
attr=0xf, range=[0x0000000001e0d000-0x0000000001e0f000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem49: type=4,
attr=0xf, range=[0x0000000001e0f000-0x0000000001e11000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem50: type=3,
attr=0xf, range=[0x0000000001e11000-0x0000000001e13000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem51: type=4,
attr=0xf, range=[0x0000000001e13000-0x0000000001e23000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem52: type=3,
attr=0xf, range=[0x0000000001e23000-0x0000000001e27000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem53: type=4,
attr=0xf, range=[0x0000000001e27000-0x0000000001e2d000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem54: type=3,
attr=0xf, range=[0x0000000001e2d000-0x0000000001e2e000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem55: type=4,
attr=0xf, range=[0x0000000001e2e000-0x0000000001e4d000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem56: type=3,
attr=0xf, range=[0x0000000001e4d000-0x0000000001e4e000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem57: type=4,
attr=0xf, range=[0x0000000001e4e000-0x0000000001e59000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem58: type=3,
attr=0xf, range=[0x0000000001e59000-0x0000000001e5d000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem59: type=4,
attr=0xf, range=[0x0000000001e5d000-0x0000000001e76000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem60: type=3,
attr=0xf, range=[0x0000000001e76000-0x0000000001e80000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem61: type=4,
attr=0xf, range=[0x0000000001e80000-0x0000000001e8f000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem62: type=3,
attr=0xf, range=[0x0000000001e8f000-0x0000000001e93000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem63: type=4,
attr=0xf, range=[0x0000000001e93000-0x0000000001e96000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem64: type=3,
attr=0xf, range=[0x0000000001e96000-0x0000000001e97000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem65: type=4,
attr=0xf, range=[0x0000000001e97000-0x00000000022ae000) (4MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem66: type=3,
attr=0xf, range=[0x00000000022ae000-0x00000000022b8000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem67: type=4,
attr=0xf, range=[0x00000000022b8000-0x00000000022c7000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem68: type=3,
attr=0xf, range=[0x00000000022c7000-0x00000000022cd000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem69: type=4,
attr=0xf, range=[0x00000000022cd000-0x00000000022d1000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem70: type=3,
attr=0xf, range=[0x00000000022d1000-0x00000000022d2000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem71: type=4,
attr=0xf, range=[0x00000000022d2000-0x00000000022d3000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem72: type=3,
attr=0xf, range=[0x00000000022d3000-0x00000000022d5000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem73: type=4,
attr=0xf, range=[0x00000000022d5000-0x00000000022d6000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem74: type=3,
attr=0xf, range=[0x00000000022d6000-0x00000000022d7000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem75: type=4,
attr=0xf, range=[0x00000000022d7000-0x00000000022de000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem76: type=3,
attr=0xf, range=[0x00000000022de000-0x00000000022df000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem77: type=4,
attr=0xf, range=[0x00000000022df000-0x00000000022fc000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem78: type=3,
attr=0xf, range=[0x00000000022fc000-0x0000000002309000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem79: type=4,
attr=0xf, range=[0x0000000002309000-0x0000000002317000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem80: type=3,
attr=0xf, range=[0x0000000002317000-0x000000000231c000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem81: type=4,
attr=0xf, range=[0x000000000231c000-0x0000000002320000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem82: type=3,
attr=0xf, range=[0x0000000002320000-0x0000000002324000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem83: type=4,
attr=0xf, range=[0x0000000002324000-0x000000000232a000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem84: type=3,
attr=0xf, range=[0x000000000232a000-0x000000000232d000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem85: type=4,
attr=0xf, range=[0x000000000232d000-0x0000000002344000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem86: type=3,
attr=0xf, range=[0x0000000002344000-0x0000000002348000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem87: type=4,
attr=0xf, range=[0x0000000002348000-0x000000000234b000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem88: type=3,
attr=0xf, range=[0x000000000234b000-0x0000000002351000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem89: type=4,
attr=0xf, range=[0x0000000002351000-0x0000000002362000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem90: type=3,
attr=0xf, range=[0x0000000002362000-0x0000000002363000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem91: type=4,
attr=0xf, range=[0x0000000002363000-0x0000000002367000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem92: type=3,
attr=0xf, range=[0x0000000002367000-0x0000000002374000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem93: type=4,
attr=0xf, range=[0x0000000002374000-0x000000000237b000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem94: type=3,
attr=0xf, range=[0x000000000237b000-0x000000000237e000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem95: type=4,
attr=0xf, range=[0x000000000237e000-0x0000000002386000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem96: type=3,
attr=0xf, range=[0x0000000002386000-0x0000000002389000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem97: type=4,
attr=0xf, range=[0x0000000002389000-0x0000000002391000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem98: type=3,
attr=0xf, range=[0x0000000002391000-0x0000000002395000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem99: type=4,
attr=0xf, range=[0x0000000002395000-0x000000000239e000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem100: type=3,
attr=0xf, range=[0x000000000239e000-0x00000000023a0000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem101: type=4,
attr=0xf, range=[0x00000000023a0000-0x00000000023a2000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem102: type=3,
attr=0xf, range=[0x00000000023a2000-0x00000000023aa000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem103: type=4,
attr=0xf, range=[0x00000000023aa000-0x00000000023b0000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem104: type=3,
attr=0xf, range=[0x00000000023b0000-0x00000000023c8000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem105: type=4,
attr=0xf, range=[0x00000000023c8000-0x00000000023cb000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem106: type=3,
attr=0xf, range=[0x00000000023cb000-0x00000000023ce000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem107: type=4,
attr=0xf, range=[0x00000000023ce000-0x00000000023d1000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem108: type=3,
attr=0xf, range=[0x00000000023d1000-0x00000000023d5000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem109: type=4,
attr=0xf, range=[0x00000000023d5000-0x00000000023d6000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem110: type=3,
attr=0xf, range=[0x00000000023d6000-0x00000000023da000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem111: type=4,
attr=0xf, range=[0x00000000023da000-0x00000000023dd000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem112: type=3,
attr=0xf, range=[0x00000000023dd000-0x00000000023df000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem113: type=4,
attr=0xf, range=[0x00000000023df000-0x00000000023e0000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem114: type=3,
attr=0xf, range=[0x00000000023e0000-0x00000000023e3000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem115: type=4,
attr=0xf, range=[0x00000000023e3000-0x00000000023ed000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem116: type=3,
attr=0xf, range=[0x00000000023ed000-0x00000000023f0000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem117: type=4,
attr=0xf, range=[0x00000000023f0000-0x00000000023fd000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem118: type=3,
attr=0xf, range=[0x00000000023fd000-0x00000000023ff000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem119: type=4,
attr=0xf, range=[0x00000000023ff000-0x0000000002403000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem120: type=3,
attr=0xf, range=[0x0000000002403000-0x0000000002409000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem121: type=4,
attr=0xf, range=[0x0000000002409000-0x0000000002410000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem122: type=3,
attr=0xf, range=[0x0000000002410000-0x0000000002417000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem123: type=4,
attr=0xf, range=[0x0000000002417000-0x0000000002445000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem124: type=3,
attr=0xf, range=[0x0000000002445000-0x000000000244c000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem125: type=4,
attr=0xf, range=[0x000000000244c000-0x0000000002465000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem126: type=3,
attr=0xf, range=[0x0000000002465000-0x0000000002471000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem127: type=4,
attr=0xf, range=[0x0000000002471000-0x0000000002479000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem128: type=3,
attr=0xf, range=[0x0000000002479000-0x000000000247d000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem129: type=4,
attr=0xf, range=[0x000000000247d000-0x0000000002480000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem130: type=3,
attr=0xf, range=[0x0000000002480000-0x00000000024bf000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem131: type=4,
attr=0xf, range=[0x00000000024bf000-0x00000000024e6000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem132: type=3,
attr=0xf, range=[0x00000000024e6000-0x000000000250b000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem133: type=4,
attr=0xf, range=[0x000000000250b000-0x0000000002534000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem134: type=3,
attr=0xf, range=[0x0000000002534000-0x000000000253c000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem135: type=4,
attr=0xf, range=[0x000000000253c000-0x000000000253e000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem136: type=3,
attr=0xf, range=[0x000000000253e000-0x0000000002540000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem137: type=4,
attr=0xf, range=[0x0000000002540000-0x0000000002554000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem138: type=3,
attr=0xf, range=[0x0000000002554000-0x0000000002555000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem139: type=4,
attr=0xf, range=[0x0000000002555000-0x0000000002556000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem140: type=3,
attr=0xf, range=[0x0000000002556000-0x000000000255b000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem141: type=4,
attr=0xf, range=[0x000000000255b000-0x000000000255e000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem142: type=3,
attr=0xf, range=[0x000000000255e000-0x000000000256d000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem143: type=4,
attr=0xf, range=[0x000000000256d000-0x0000000002572000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem144: type=3,
attr=0xf, range=[0x0000000002572000-0x0000000002574000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem145: type=4,
attr=0xf, range=[0x0000000002574000-0x0000000002575000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem146: type=3,
attr=0xf, range=[0x0000000002575000-0x0000000002576000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem147: type=4,
attr=0xf, range=[0x0000000002576000-0x000000000258e000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem148: type=3,
attr=0xf, range=[0x000000000258e000-0x0000000002590000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem149: type=4,
attr=0xf, range=[0x0000000002590000-0x0000000002598000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem150: type=3,
attr=0xf, range=[0x0000000002598000-0x00000000025a1000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem151: type=4,
attr=0xf, range=[0x00000000025a1000-0x00000000025c3000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem152: type=3,
attr=0xf, range=[0x00000000025c3000-0x00000000025d7000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem153: type=4,
attr=0xf, range=[0x00000000025d7000-0x00000000025db000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem154: type=3,
attr=0xf, range=[0x00000000025db000-0x00000000025dd000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem155: type=4,
attr=0xf, range=[0x00000000025dd000-0x00000000025e7000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem156: type=3,
attr=0xf, range=[0x00000000025e7000-0x00000000025ec000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem157: type=4,
attr=0xf, range=[0x00000000025ec000-0x00000000025ee000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem158: type=3,
attr=0xf, range=[0x00000000025ee000-0x00000000025f0000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem159: type=4,
attr=0xf, range=[0x00000000025f0000-0x00000000025f3000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem160: type=3,
attr=0xf, range=[0x00000000025f3000-0x00000000025f6000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem161: type=4,
attr=0xf, range=[0x00000000025f6000-0x00000000025fc000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem162: type=3,
attr=0xf, range=[0x00000000025fc000-0x00000000025ff000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem163: type=4,
attr=0xf, range=[0x00000000025ff000-0x00000000026b4000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem164: type=3,
attr=0xf, range=[0x00000000026b4000-0x0000000002ac2000) (4MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem165: type=4,
attr=0xf, range=[0x0000000002ac2000-0x000000000c361000) (152MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem166: type=3,
attr=0xf, range=[0x000000000c361000-0x000000000c367000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem167: type=4,
attr=0xf, range=[0x000000000c367000-0x000000000c371000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem168: type=3,
attr=0xf, range=[0x000000000c371000-0x000000000c373000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem169: type=4,
attr=0xf, range=[0x000000000c373000-0x000000000c4e4000) (1MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem170: type=3,
attr=0xf, range=[0x000000000c4e4000-0x000000000c503000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem171: type=4,
attr=0xf, range=[0x000000000c503000-0x000000000c5d7000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem172: type=7,
attr=0xf, range=[0x000000000c5d7000-0x000000000c5db000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem173: type=4,
attr=0xf, range=[0x000000000c5db000-0x000000000c5f3000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem174: type=7,
attr=0xf, range=[0x000000000c5f3000-0x000000000c605000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem175: type=1,
attr=0xf, range=[0x000000000c605000-0x000000000c623000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem176: type=2,
attr=0xf, range=[0x000000000c623000-0x000000000d967000) (19MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem177: type=7,
attr=0xf, range=[0x000000000d967000-0x000000000e000000) (6MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem178: type=2,
attr=0xf, range=[0x000000000e000000-0x000000000f344000) (19MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem179: type=7,
attr=0xf, range=[0x000000000f344000-0x00000000360fe000) (621MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem180: type=2,
attr=0xf, range=[0x00000000360fe000-0x0000000037077000) (15MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem181: type=7,
attr=0xf, range=[0x0000000037077000-0x00000000a9e70000) (1837MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem182: type=2,
attr=0xf, range=[0x00000000a9e70000-0x00000000deb8f000) (845MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem183: type=5,
attr=0x800000000000000f, range=[0x00000000deb8f000-0x00000000debd4000)
(0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem184: type=6,
attr=0x800000000000000f, range=[0x00000000debd4000-0x00000000dec04000)
(0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem185: type=5,
attr=0x800000000000000f, range=[0x00000000dec04000-0x00000000dec15000)
(0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem186: type=6,
attr=0x800000000000000f, range=[0x00000000dec15000-0x00000000dec25000)
(0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem187: type=6,
attr=0x800000000000000f, range=[0x00000000dec25000-0x00000000dec26000)
(0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem188: type=6,
attr=0x800000000000000f, range=[0x00000000dec26000-0x00000000dec27000)
(0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem189: type=6,
attr=0x800000000000000f, range=[0x00000000dec27000-0x00000000dec3f000)
(0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem190: type=0,
attr=0xf, range=[0x00000000dec3f000-0x00000000dee70000) (2MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem191: type=0,
attr=0xf, range=[0x00000000dee70000-0x00000000df13f000) (2MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem192:
type=10, attr=0xf, range=[0x00000000df13f000-0x00000000df300000) (1MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem193:
type=10, attr=0xf, range=[0x00000000df300000-0x00000000df384000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem194: type=9,
attr=0xf, range=[0x00000000df384000-0x00000000df392000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem195:
type=10, attr=0xf, range=[0x00000000df392000-0x00000000df3a3000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem196:
type=10, attr=0xf, range=[0x00000000df3a3000-0x00000000df3b0000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem197:
type=10, attr=0xf, range=[0x00000000df3b0000-0x00000000df3bf000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem198: type=9,
attr=0xf, range=[0x00000000df3bf000-0x00000000df3c3000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem199: type=9,
attr=0xf, range=[0x00000000df3c3000-0x00000000df3c4000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem200:
type=10, attr=0xf, range=[0x00000000df3c4000-0x00000000df407000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem201: type=4,
attr=0xf, range=[0x00000000df407000-0x00000000df54d000) (1MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem202: type=3,
attr=0xf, range=[0x00000000df54d000-0x00000000df7db000) (2MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem203: type=4,
attr=0xf, range=[0x00000000df7db000-0x00000000df7e3000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem204: type=3,
attr=0xf, range=[0x00000000df7e3000-0x00000000df7ed000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem205: type=4,
attr=0xf, range=[0x00000000df7ed000-0x00000000df800000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem206: type=7,
attr=0xf, range=[0x0000000100000000-0x000000021f000000) (4592MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem207:
type=11, attr=0x8000000000000001,
range=[0x00000000f8000000-0x00000000fc000000) (64MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem208:
type=11, attr=0x8000000000000001,
range=[0x00000000fec00000-0x00000000fec01000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem209:
type=11, attr=0x8000000000000001,
range=[0x00000000fed00000-0x00000000fed04000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem210:
type=11, attr=0x8000000000000001,
range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem211:
type=11, attr=0x8000000000000001,
range=[0x00000000fee00000-0x00000000fee01000) (0MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] efi: mem212:
type=11, attr=0x8000000000000001,
range=[0x00000000ff000000-0x0000000100000000) (16MB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] SMBIOS 2.6 present.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] DMI: System
manufacturer System Product Name/Maximus IV GENE-Z, BIOS 3603
11/09/2012
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] e820: update [mem
0x00000000-0x0000ffff] usable ==> reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] e820: remove [mem
0x000a0000-0x000fffff] usable
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] No AGP bridge found
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] e820: last_pfn =
0x21f000 max_arch_pfn = 0x400000000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] MTRR default type: uncachable
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] MTRR fixed ranges enabled:
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   00000-9FFFF write-back
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   A0000-BFFFF uncachable
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   C0000-D3FFF write-protect
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   D4000-DFFFF uncachable
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   E0000-E7FFF write-through
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   E8000-FFFFF write-protect
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] MTRR variable ranges enabled:
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   0 base 000000000
mask E00000000 write-back
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   1 base 200000000
mask FF0000000 write-back
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   2 base 210000000
mask FF8000000 write-back
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   3 base 218000000
mask FFC000000 write-back
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   4 base 21C000000
mask FFE000000 write-back
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   5 base 21E000000
mask FFF000000 write-back
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   6 base 0E0000000
mask FE0000000 uncachable
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   7 disabled
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   8 disabled
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   9 disabled
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] x86 PAT enabled: cpu
0, old 0x7040600070406, new 0x7010600070106
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] original variable MTRRs
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 0, base: 0GB,
range: 8GB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 1, base: 8GB,
range: 256MB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 2, base: 8448MB,
range: 128MB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 3, base: 8576MB,
range: 64MB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 4, base: 8640MB,
range: 32MB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 5, base: 8672MB,
range: 16MB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 6, base: 3584MB,
range: 512MB, type UC
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] total RAM covered: 8176M
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Found optimal
setting for mtrr clean up
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]  gran_size: 64K
chunk_size: 32M num_reg: 6   lose cover RAM: 0G
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] New variable MTRRs
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 0, base: 0GB,
range: 2GB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 1, base: 2GB,
range: 1GB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 2, base: 3GB,
range: 512MB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 3, base: 4GB,
range: 4GB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 4, base: 8GB,
range: 512MB, type WB
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] reg 5, base: 8688MB,
range: 16MB, type UC
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] e820: update [mem
0xe0000000-0xffffffff] usable ==> reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] e820: last_pfn =
0xdf800 max_arch_pfn = 0x400000000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] found SMP MP-table
at [mem 0x000fccf0-0x000fccff] mapped at [ffff8800000fccf0]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] initial memory
mapped: [mem 0x00000000-0x1fffffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Base memory
trampoline at [ffff880000097000] 97000 size 24576
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0x00000000-0xdf7fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]  [mem
0x00000000-0xdf7fffff] page 2M
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] kernel direct
mapping tables up to 0xdf7fffff @ [mem 0x1fffb000-0x1fffffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0x100000000-0x21effffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]  [mem
0x100000000-0x21effffff] page 2M
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] kernel direct
mapping tables up to 0x21effffff @ [mem 0xdeb89000-0xdeb8efff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] RAMDISK: [mem
0x360fe000-0x37076fff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: RSDP
00000000df384000 00024 (v02 ALASKA)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: XSDT
00000000df384070 0005C (v01 ALASKA    A M I 01072009 AMI  00010013)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: FACP
00000000df38fc70 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: DSDT
00000000df384168 0BB02 (v02 ALASKA    A M I 00000015 INTL 20051117)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: FACS
00000000df3bdf80 00040
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: APIC
00000000df38fd68 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: MCFG
00000000df38fde0 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: HPET
00000000df38fe20 00038 (v01 ALASKA    A M I 01072009 AMI. 00000005)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: SSDT
00000000df38fe58 0036D (v01 SataRe SataTabl 00001000 INTL 20091112)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: SSDT
00000000df3901c8 00926 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: SSDT
00000000df390af0 00A92 (v01  PmRef    CpuPm 00003000 INTL 20051117)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] No NUMA configuration found
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Faking a node at
[mem 0x0000000000000000-0x000000021effffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Initmem setup node 0
[mem 0x00000000-0x21effffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   NODE_DATA [mem
0x21effb000-0x21effffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]
[ffffea0000000000-ffffea00087fffff] PMD ->
[ffff880216600000-ffff88021e5fffff] on node 0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Zone ranges:
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   DMA      [mem
0x00010000-0x00ffffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   DMA32    [mem
0x01000000-0xffffffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   Normal   [mem
0x100000000-0x21effffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Movable zone start
for each node
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Early memory node ranges
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0x00010000-0x0009efff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0x00100000-0xdeb8efff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0xdf407000-0xdf7fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0x100000000-0x21effffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] On node 0 totalpages: 2088727
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   DMA zone: 64 pages
used for memmap
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   DMA zone: 29 pages reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   DMA zone: 3890
pages, LIFO batch:0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   DMA32 zone: 14207
pages used for memmap
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   DMA32 zone: 894985
pages, LIFO batch:31
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   Normal zone: 18368
pages used for memmap
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000]   Normal zone:
1157184 pages, LIFO batch:31
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x00] enabled)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x02] lapic_id[0x02] enabled)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x03] lapic_id[0x04] enabled)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x04] lapic_id[0x06] enabled)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0xff] high edge lint[0x1])
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: IOAPIC
(id[0x02] address[0xfec00000] gsi_base[0])
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] IOAPIC[0]: apic_id
2, version 32, address 0xfec00000, GSI 0-23
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 0 global_irq 2 dfl dfl)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 9 global_irq 9 high level)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: IRQ0 used by override.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: IRQ2 used by override.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: IRQ9 used by override.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Using ACPI (MADT)
for SMP configuration information
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] ACPI: HPET id:
0x8086a701 base: 0xfed00000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] smpboot: Allowing 4
CPUs, 0 hotplug CPUs
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] nr_irqs_gsi: 40
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 000000000009f000 - 00000000000a0000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000000a0000 - 0000000000100000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000deb8f000 - 00000000df13f000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df13f000 - 00000000df384000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df384000 - 00000000df392000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df392000 - 00000000df3bf000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df3bf000 - 00000000df3c4000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df3c4000 - 00000000df407000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000df800000 - 00000000f8000000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000f8000000 - 00000000fc000000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fc000000 - 00000000fec00000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fec00000 - 00000000fec01000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fec01000 - 00000000fed00000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fed00000 - 00000000fed04000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fed04000 - 00000000fed1c000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fed1c000 - 00000000fed20000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fed20000 - 00000000fee00000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fee00000 - 00000000fee01000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000fee01000 - 00000000ff000000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: 00000000ff000000 - 0000000100000000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] e820: [mem
0xdf800000-0xf7ffffff] available for PCI devices
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Booting
paravirtualized kernel on bare hardware
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] setup_percpu:
NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PERCPU: Embedded 28
pages/cpu @ffff88021ec00000 s85056 r8192 d21440 u524288
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] pcpu-alloc: s85056
r8192 d21440 u524288 alloc=1*2097152
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Built 1 zonelists in
Zone order, mobility grouping on.  Total pages: 2056059
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Policy zone: Normal
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-3.8.0-30-generic
root=UUID=b44f3d14-b5d6-4775-a304-5d29e8fcd2db ro nomodeset
acpi_osi=Linux quiet splash vt.handoff=7
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] PID hash table
entries: 4096 (order: 3, 32768 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] __ex_table already
sorted, skipping sort
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] xsave: enabled
xstate_bv 0x7, cntxt size 0x340
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Checking aperture...
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] No AGP bridge found
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Calgary: detecting
Calgary via BIOS EBDA area
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Calgary: Unable to
locate Rio Grande table in EBDA - bailing!
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Memory:
7936204k/8896512k available (7014k kernel code, 541604k absent,
418704k reserved, 6229k data, 996k init)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] SLUB: Genslabs=15,
HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Hierarchical RCU
implementation.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] RCU dyntick-idle
grace-period acceleration is enabled.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] RCU restricting CPUs
from NR_CPUS=256 to nr_cpu_ids=4.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] NR_IRQS:16640 nr_irqs:712 16
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Extended CMOS year: 2000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] Console: colour
dummy device 80x25
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] console [tty0] enabled
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] allocated 33554432
bytes of page_cgroup
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] please try
'cgroup_disable=memory' option if you don't want memory cgroups
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] hpet clockevent registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000000] tsc: Fast TSC
calibration using PIT
Sep  9 10:08:11 Arbeits-PC kernel: [    0.004000] tsc: Detected
2809.340 MHz processor
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000001] Calibrating delay
loop (skipped), value calculated using timer frequency.. 5618.68
BogoMIPS (lpj=11237360)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.000004] pid_max: default:
32768 minimum: 301
Sep  9 10:08:11 Arbeits-PC kernel: [    0.010853] Security Framework initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    0.010860] AppArmor: AppArmor initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    0.010860] Yama: becoming mindful.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.011292] Dentry cache hash
table entries: 1048576 (order: 11, 8388608 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.012669] Inode-cache hash
table entries: 524288 (order: 10, 4194304 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013265] Mount-cache hash
table entries: 256
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013389] Initializing cgroup
subsys cpuacct
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013390] Initializing cgroup
subsys memory
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013395] Initializing cgroup
subsys devices
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013396] Initializing cgroup
subsys freezer
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013397] Initializing cgroup
subsys blkio
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013398] Initializing cgroup
subsys perf_event
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013400] Initializing cgroup
subsys hugetlb
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013419] CPU: Physical Processor ID: 0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013420] CPU: Processor Core ID: 0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013424] ENERGY_PERF_BIAS:
Set to 'normal', was 'performance'
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013424] ENERGY_PERF_BIAS:
View and update with x86_energy_perf_policy(8)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013426] mce: CPU supports 9 MCE banks
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013438] CPU0: Thermal
monitoring enabled (TM1)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013443] process: using mwait
in idle threads
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013446] Last level iTLB
entries: 4KB 512, 2MB 0, 4MB 0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013446] Last level dTLB
entries: 4KB 512, 2MB 32, 4MB 32
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013446] tlb_flushall_shift: 5
Sep  9 10:08:11 Arbeits-PC kernel: [    0.013564] Freeing SMP
alternatives: 24k freed
Sep  9 10:08:11 Arbeits-PC kernel: [    0.015694] ACPI: Core revision 20121018
Sep  9 10:08:11 Arbeits-PC kernel: [    0.240971] ftrace: allocating
26715 entries in 105 pages
Sep  9 10:08:11 Arbeits-PC kernel: [    0.252717] ..TIMER: vector=0x30
apic1=0 pin1=2 apic2=-1 pin2=-1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.292350] smpboot: CPU0:
Intel(R) Core(TM) i5-2300 CPU @ 2.80GHz (fam: 06, model: 2a, stepping:
07)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.292357] TSC deadline timer enabled
Sep  9 10:08:11 Arbeits-PC kernel: [    0.292361] Performance Events:
PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.292366] ... version:                3
Sep  9 10:08:11 Arbeits-PC kernel: [    0.292367] ... bit width:              48
Sep  9 10:08:11 Arbeits-PC kernel: [    0.292368] ... generic registers:      8
Sep  9 10:08:11 Arbeits-PC kernel: [    0.292369] ... value mask:
       0000ffffffffffff
Sep  9 10:08:11 Arbeits-PC kernel: [    0.292370] ... max period:
       000000007fffffff
Sep  9 10:08:11 Arbeits-PC kernel: [    0.292371] ... fixed-purpose events:   3
Sep  9 10:08:11 Arbeits-PC kernel: [    0.292372] ... event mask:
       00000007000000ff
Sep  9 10:08:11 Arbeits-PC kernel: [    0.306309] NMI watchdog:
enabled on all CPUs, permanently consumes one hw-PMU counter.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.293140] smpboot: Booting
Node   0, Processors  #1 #2 #3 OK
Sep  9 10:08:11 Arbeits-PC kernel: [    0.332687] Brought up 4 CPUs
Sep  9 10:08:11 Arbeits-PC kernel: [    0.332690] smpboot: Total of 4
processors activated (22474.72 BogoMIPS)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.335602] devtmpfs: initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    0.336418] EVM: security.selinux
Sep  9 10:08:11 Arbeits-PC kernel: [    0.336420] EVM: security.SMACK64
Sep  9 10:08:11 Arbeits-PC kernel: [    0.336421] EVM: security.capability
Sep  9 10:08:11 Arbeits-PC kernel: [    0.336458] PM: Registering ACPI
NVS region [mem 0xdf13f000-0xdf383fff] (2379776 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.336486] PM: Registering ACPI
NVS region [mem 0xdf392000-0xdf3befff] (184320 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.336489] PM: Registering ACPI
NVS region [mem 0xdf3c4000-0xdf406fff] (274432 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.337095] regulator-dummy: no parameters
Sep  9 10:08:11 Arbeits-PC kernel: [    0.337131] NET: Registered
protocol family 16
Sep  9 10:08:11 Arbeits-PC kernel: [    0.337252] ACPI FADT declares
the system doesn't support PCIe ASPM, so disable it
Sep  9 10:08:11 Arbeits-PC kernel: [    0.337254] ACPI: bus type pci registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.337292] PCI: MMCONFIG for
domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base
0xf8000000)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.337294] PCI: MMCONFIG at
[mem 0xf8000000-0xfbffffff] reserved in E820
Sep  9 10:08:11 Arbeits-PC kernel: [    0.342345] PCI: Using
configuration type 1 for base access
Sep  9 10:08:11 Arbeits-PC kernel: [    0.343019] bio: create slab <bio-0> at 0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.343077] ACPI: Added
_OSI(Module Device)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.343079] ACPI: Added
_OSI(Processor Device)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.343080] ACPI: Added _OSI(3.0
_SCP Extensions)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.343081] ACPI: Added
_OSI(Processor Aggregator Device)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.343082] ACPI: Added _OSI(Linux)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.344415] ACPI: EC: Look up EC in DSDT
Sep  9 10:08:11 Arbeits-PC kernel: [    0.345706] ACPI: Executed 1
blocks of module-level executable AML code
Sep  9 10:08:11 Arbeits-PC kernel: [    0.348297] ACPI: SSDT
00000000df0ec018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.348634] ACPI: Dynamic OEM Table Load:
Sep  9 10:08:11 Arbeits-PC kernel: [    0.348636] ACPI: SSDT
(null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.348854] ACPI: SSDT
00000000df0eda98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.349214] ACPI: Dynamic OEM Table Load:
Sep  9 10:08:11 Arbeits-PC kernel: [    0.349215] ACPI: SSDT
(null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.349332] ACPI: SSDT
00000000df0eec18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.349668] ACPI: Dynamic OEM Table Load:
Sep  9 10:08:11 Arbeits-PC kernel: [    0.349670] ACPI: SSDT
(null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.350133] ACPI: Interpreter enabled
Sep  9 10:08:11 Arbeits-PC kernel: [    0.350137] ACPI: (supports S0
S1 S3 S4 S5)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.350153] ACPI: Using IOAPIC
for interrupt routing
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354045] ACPI: Power Resource
[FN00] (off)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354098] ACPI: Power Resource
[FN01] (off)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354150] ACPI: Power Resource
[FN02] (off)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354201] ACPI: Power Resource
[FN03] (off)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354252] ACPI: Power Resource
[FN04] (off)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354493] ACPI: EC: GPE =
0x18, I/O: command/status = 0x66, data = 0x62
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354620] ACPI: No dock devices found.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354623] PCI: Using host
bridge windows from ACPI; if necessary, use "pci=nocrs" and report a
bug
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354814] ACPI: PCI Root
Bridge [PCI0] (domain 0000 [bus 00-3e])
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354816] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0._PRT]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354939] \_SB_.PCI0:_OSC invalid UUID
Sep  9 10:08:11 Arbeits-PC kernel: [    0.354940] _OSC request data:1 8 0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355307] PCI host bridge to bus 0000:00
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355309] pci_bus 0000:00:
root bus resource [bus 00-3e]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355311] pci_bus 0000:00:
root bus resource [io  0x0000-0x0cf7]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355313] pci_bus 0000:00:
root bus resource [io  0x0d00-0xffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355314] pci_bus 0000:00:
root bus resource [mem 0x000a0000-0x000bffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355316] pci_bus 0000:00:
root bus resource [mem 0x000d4000-0x000d7fff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355317] pci_bus 0000:00:
root bus resource [mem 0x000d8000-0x000dbfff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355318] pci_bus 0000:00:
root bus resource [mem 0x000dc000-0x000dffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355320] pci_bus 0000:00:
root bus resource [mem 0xe0000000-0xfeafffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355327] pci 0000:00:00.0:
[8086:0100] type 00 class 0x060000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355358] pci 0000:00:01.0:
[8086:0101] type 01 class 0x060400
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355385] pci 0000:00:01.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355427] pci 0000:00:16.0:
[8086:1c3a] type 00 class 0x078000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355451] pci 0000:00:16.0:
reg 10: [mem 0xf742c000-0xf742c00f 64bit]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355526] pci 0000:00:16.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355555] pci 0000:00:19.0:
[8086:1503] type 00 class 0x020000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355572] pci 0000:00:19.0:
reg 10: [mem 0xf7400000-0xf741ffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355580] pci 0000:00:19.0:
reg 14: [mem 0xf7429000-0xf7429fff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355588] pci 0000:00:19.0:
reg 18: [io  0xf040-0xf05f]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355649] pci 0000:00:19.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355674] pci 0000:00:1a.0:
[8086:1c2d] type 00 class 0x0c0320
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355694] pci 0000:00:1a.0:
reg 10: [mem 0xf7428000-0xf74283ff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355781] pci 0000:00:1a.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355806] pci 0000:00:1b.0:
[8086:1c20] type 00 class 0x040300
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355820] pci 0000:00:1b.0:
reg 10: [mem 0xf7420000-0xf7423fff 64bit]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355884] pci 0000:00:1b.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.355910] pci 0000:00:1c.0:
[8086:1c10] type 01 class 0x060400
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356038] pci 0000:00:1c.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356074] pci 0000:00:1c.4:
[8086:1c18] type 01 class 0x060400
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356149] pci 0000:00:1c.4:
PME# supported from D0 D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356173] pci 0000:00:1c.5:
[8086:1c1a] type 01 class 0x060400
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356247] pci 0000:00:1c.5:
PME# supported from D0 D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356272] pci 0000:00:1c.6:
[8086:1c1c] type 01 class 0x060400
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356346] pci 0000:00:1c.6:
PME# supported from D0 D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356374] pci 0000:00:1d.0:
[8086:1c26] type 00 class 0x0c0320
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356394] pci 0000:00:1d.0:
reg 10: [mem 0xf7427000-0xf74273ff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356481] pci 0000:00:1d.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356506] pci 0000:00:1f.0:
[8086:1c44] type 00 class 0x060100
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356627] pci 0000:00:1f.2:
[8086:1c02] type 00 class 0x010601
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356644] pci 0000:00:1f.2:
reg 10: [io  0xf090-0xf097]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356652] pci 0000:00:1f.2:
reg 14: [io  0xf080-0xf083]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356663] pci 0000:00:1f.2:
reg 18: [io  0xf070-0xf077]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356671] pci 0000:00:1f.2:
reg 1c: [io  0xf060-0xf063]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356679] pci 0000:00:1f.2:
reg 20: [io  0xf020-0xf03f]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356686] pci 0000:00:1f.2:
reg 24: [mem 0xf7426000-0xf74267ff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356730] pci 0000:00:1f.2:
PME# supported from D3hot
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356747] pci 0000:00:1f.3:
[8086:1c22] type 00 class 0x0c0500
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356761] pci 0000:00:1f.3:
reg 10: [mem 0xf7425000-0xf74250ff 64bit]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356781] pci 0000:00:1f.3:
reg 20: [io  0x0580-0x059f]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356834] pci 0000:01:00.0:
[10de:11c0] type 00 class 0x030000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356843] pci 0000:01:00.0:
reg 10: [mem 0xf6000000-0xf6ffffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356853] pci 0000:01:00.0:
reg 14: [mem 0xe8000000-0xefffffff 64bit pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356863] pci 0000:01:00.0:
reg 1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356870] pci 0000:01:00.0:
reg 24: [io  0xe000-0xe07f]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356876] pci 0000:01:00.0:
reg 30: [mem 0xf7000000-0xf707ffff pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356931] pci 0000:01:00.1:
[10de:0e0b] type 00 class 0x040300
Sep  9 10:08:11 Arbeits-PC kernel: [    0.356941] pci 0000:01:00.1:
reg 10: [mem 0xf7080000-0xf7083fff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.364674] pci 0000:00:01.0:
PCI bridge to [bus 01]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.364677] pci 0000:00:01.0:
bridge window [io  0xe000-0xefff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.364679] pci 0000:00:01.0:
bridge window [mem 0xf6000000-0xf70fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.364682] pci 0000:00:01.0:
bridge window [mem 0xe8000000-0xf1ffffff 64bit pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.364752] pci 0000:00:1c.0:
PCI bridge to [bus 02]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.364834] pci 0000:03:00.0:
[1b21:1042] type 00 class 0x0c0330
Sep  9 10:08:11 Arbeits-PC kernel: [    0.364862] pci 0000:03:00.0:
reg 10: [mem 0xf7300000-0xf7307fff 64bit]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.365008] pci 0000:03:00.0:
PME# supported from D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.372670] pci 0000:00:1c.4:
PCI bridge to [bus 03]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.372676] pci 0000:00:1c.4:
bridge window [mem 0xf7300000-0xf73fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.372750] pci 0000:04:00.0:
[1b21:1042] type 00 class 0x0c0330
Sep  9 10:08:11 Arbeits-PC kernel: [    0.372778] pci 0000:04:00.0:
reg 10: [mem 0xf7200000-0xf7207fff 64bit]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.372925] pci 0000:04:00.0:
PME# supported from D3hot D3cold
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380662] pci 0000:00:1c.5:
PCI bridge to [bus 04]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380668] pci 0000:00:1c.5:
bridge window [mem 0xf7200000-0xf72fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380735] pci 0000:05:00.0:
[197b:2362] type 00 class 0x010185
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380769] pci 0000:05:00.0:
reg 10: [io  0xd040-0xd047]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380785] pci 0000:05:00.0:
reg 14: [io  0xd030-0xd033]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380801] pci 0000:05:00.0:
reg 18: [io  0xd020-0xd027]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380817] pci 0000:05:00.0:
reg 1c: [io  0xd010-0xd013]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380833] pci 0000:05:00.0:
reg 20: [io  0xd000-0xd00f]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380849] pci 0000:05:00.0:
reg 24: [mem 0xf7110000-0xf71101ff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380865] pci 0000:05:00.0:
reg 30: [mem 0x00000000-0x0000ffff pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.380926] pci 0000:05:00.0:
PME# supported from D3hot
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388653] pci 0000:00:1c.6:
PCI bridge to [bus 05]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388657] pci 0000:00:1c.6:
bridge window [io  0xd000-0xdfff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388661] pci 0000:00:1c.6:
bridge window [mem 0xf7100000-0xf71fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388707] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.RP01._PRT]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388740] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.RP05._PRT]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388765] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.RP06._PRT]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388789] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.RP07._PRT]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388820] ACPI: PCI Interrupt
Routing Table [\_SB_.PCI0.PEG0._PRT]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388901] \_SB_.PCI0:_OSC invalid UUID
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388902] _OSC request data:1 1f 0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388905]  pci0000:00: ACPI
_OSC support notification failed, disabling PCIe ASPM
Sep  9 10:08:11 Arbeits-PC kernel: [    0.388906]  pci0000:00: Unable
to request _OSC control (_OSC support mask: 0x08)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389539] ACPI: PCI Interrupt
Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389576] ACPI: PCI Interrupt
Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389609] ACPI: PCI Interrupt
Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389642] ACPI: PCI Interrupt
Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389675] ACPI: PCI Interrupt
Link [LNKE] (IRQs 3 *4 5 6 10 11 12 14 15)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389709] ACPI: PCI Interrupt
Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389742] ACPI: PCI Interrupt
Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389775] ACPI: PCI Interrupt
Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389845] vgaarb: device
added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389847] vgaarb: loaded
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389848] vgaarb: bridge
control possible 0000:01:00.0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389964] SCSI subsystem initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389965] ACPI: bus type scsi registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.389987] libata version 3.00 loaded.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.390001] ACPI: bus type usb registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.390013] usbcore: registered
new interface driver usbfs
Sep  9 10:08:11 Arbeits-PC kernel: [    0.390018] usbcore: registered
new interface driver hub
Sep  9 10:08:11 Arbeits-PC kernel: [    0.390030] usbcore: registered
new device driver usb
Sep  9 10:08:11 Arbeits-PC kernel: [    0.390084] PCI: Using ACPI for
IRQ routing
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391525] PCI:
pci_cache_line_size set to 64 bytes
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391583] e820: reserve RAM
buffer [mem 0x0009f000-0x0009ffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391585] e820: reserve RAM
buffer [mem 0xdeb8f000-0xdfffffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391586] e820: reserve RAM
buffer [mem 0xdf800000-0xdfffffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391587] e820: reserve RAM
buffer [mem 0x21f000000-0x21fffffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391644] NetLabel: Initializing
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391645] NetLabel:  domain
hash size = 128
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391646] NetLabel:  protocols
= UNLABELED CIPSOv4
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391654] NetLabel:  unlabeled
traffic allowed by default
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391696] hpet0: at MMIO
0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.391700] hpet0: 8
comparators, 64-bit 14.318180 MHz counter
Sep  9 10:08:11 Arbeits-PC kernel: [    0.393710] Switching to clocksource hpet
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397437] AppArmor: AppArmor
Filesystem Enabled
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397454] pnp: PnP ACPI init
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397464] ACPI: bus type pnp registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397526] system 00:00: [mem
0xfed40000-0xfed44fff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397529] system 00:00: Plug
and Play ACPI device, IDs PNP0c01 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397538] pnp 00:01: [dma 4]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397549] pnp 00:01: Plug and
Play ACPI device, IDs PNP0200 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397562] pnp 00:02: Plug and
Play ACPI device, IDs INT0800 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397633] pnp 00:03: Plug and
Play ACPI device, IDs PNP0103 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397664] system 00:04: [io
0x0680-0x069f] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397666] system 00:04: [io
0x0200-0x020f] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397668] system 00:04: [io
0xffff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397670] system 00:04: [io
0xffff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397671] system 00:04: [io
0x0400-0x0453] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397673] system 00:04: [io
0x0458-0x047f] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397674] system 00:04: [io
0x0500-0x057f] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397676] system 00:04: [io
0x164e-0x164f] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397678] system 00:04: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397699] pnp 00:05: Plug and
Play ACPI device, IDs PNP0b00 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397743] system 00:06: [io
0x0454-0x0457] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397745] system 00:06: Plug
and Play ACPI device, IDs INT3f0d PNP0c02 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397806] system 00:07: [io
0x0290-0x029f] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397808] system 00:07: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397844] system 00:08: [io
0x04d0-0x04d1] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397846] system 00:08: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.397864] pnp 00:09: Plug and
Play ACPI device, IDs PNP0c04 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398078] system 00:0a: [mem
0xfed1c000-0xfed1ffff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398080] system 00:0a: [mem
0xfed10000-0xfed17fff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398081] system 00:0a: [mem
0xfed18000-0xfed18fff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398083] system 00:0a: [mem
0xfed19000-0xfed19fff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398084] system 00:0a: [mem
0xf8000000-0xfbffffff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398086] system 00:0a: [mem
0xfed20000-0xfed3ffff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398088] system 00:0a: [mem
0xfed90000-0xfed93fff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398089] system 00:0a: [mem
0xfed45000-0xfed8ffff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398091] system 00:0a: [mem
0xff000000-0xffffffff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398093] system 00:0a: [mem
0xfee00000-0xfeefffff] could not be reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398094] system 00:0a: [mem
0xe0000000-0xe0000fff] has been reserved
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398096] system 00:0a: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398194] pnp: PnP ACPI: found
11 devices
Sep  9 10:08:11 Arbeits-PC kernel: [    0.398195] ACPI: ACPI bus type
pnp unregistered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403940] pci 0000:00:1c.0:
bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403943] pci 0000:00:1c.0:
bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02]
add_size 200000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403945] pci 0000:00:1c.0:
bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403970] pci 0000:00:1c.0:
res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403971] pci 0000:00:1c.0:
res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size
add_size 200000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403973] pci 0000:00:1c.0:
res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403977] pci 0000:00:1c.0:
BAR 14: assigned [mem 0xe0100000-0xe02fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403979] pci 0000:00:1c.0:
BAR 15: assigned [mem 0xe0300000-0xe04fffff 64bit pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403982] pci 0000:00:1c.6:
BAR 15: assigned [mem 0xe0500000-0xe05fffff pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403984] pci 0000:00:1c.0:
BAR 13: assigned [io  0x2000-0x2fff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403986] pci 0000:00:01.0:
PCI bridge to [bus 01]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403988] pci 0000:00:01.0:
bridge window [io  0xe000-0xefff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403991] pci 0000:00:01.0:
bridge window [mem 0xf6000000-0xf70fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403993] pci 0000:00:01.0:
bridge window [mem 0xe8000000-0xf1ffffff 64bit pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403996] pci 0000:00:1c.0:
PCI bridge to [bus 02]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.403999] pci 0000:00:1c.0:
bridge window [io  0x2000-0x2fff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404006] pci 0000:00:1c.0:
bridge window [mem 0xe0100000-0xe02fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404011] pci 0000:00:1c.0:
bridge window [mem 0xe0300000-0xe04fffff 64bit pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404019] pci 0000:00:1c.4:
PCI bridge to [bus 03]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404024] pci 0000:00:1c.4:
bridge window [mem 0xf7300000-0xf73fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404032] pci 0000:00:1c.5:
PCI bridge to [bus 04]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404036] pci 0000:00:1c.5:
bridge window [mem 0xf7200000-0xf72fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404045] pci 0000:05:00.0:
BAR 6: assigned [mem 0xe0500000-0xe050ffff pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404046] pci 0000:00:1c.6:
PCI bridge to [bus 05]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404049] pci 0000:00:1c.6:
bridge window [io  0xd000-0xdfff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404054] pci 0000:00:1c.6:
bridge window [mem 0xf7100000-0xf71fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404058] pci 0000:00:1c.6:
bridge window [mem 0xe0500000-0xe05fffff pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404092] pci_bus 0000:00:
resource 4 [io  0x0000-0x0cf7]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404093] pci_bus 0000:00:
resource 5 [io  0x0d00-0xffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404095] pci_bus 0000:00:
resource 6 [mem 0x000a0000-0x000bffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404096] pci_bus 0000:00:
resource 7 [mem 0x000d4000-0x000d7fff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404098] pci_bus 0000:00:
resource 8 [mem 0x000d8000-0x000dbfff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404099] pci_bus 0000:00:
resource 9 [mem 0x000dc000-0x000dffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404101] pci_bus 0000:00:
resource 10 [mem 0xe0000000-0xfeafffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404102] pci_bus 0000:01:
resource 0 [io  0xe000-0xefff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404104] pci_bus 0000:01:
resource 1 [mem 0xf6000000-0xf70fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404105] pci_bus 0000:01:
resource 2 [mem 0xe8000000-0xf1ffffff 64bit pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404107] pci_bus 0000:02:
resource 0 [io  0x2000-0x2fff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404108] pci_bus 0000:02:
resource 1 [mem 0xe0100000-0xe02fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404110] pci_bus 0000:02:
resource 2 [mem 0xe0300000-0xe04fffff 64bit pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404111] pci_bus 0000:03:
resource 1 [mem 0xf7300000-0xf73fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404113] pci_bus 0000:04:
resource 1 [mem 0xf7200000-0xf72fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404114] pci_bus 0000:05:
resource 0 [io  0xd000-0xdfff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404116] pci_bus 0000:05:
resource 1 [mem 0xf7100000-0xf71fffff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404117] pci_bus 0000:05:
resource 2 [mem 0xe0500000-0xe05fffff pref]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404143] NET: Registered
protocol family 2
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404277] TCP established hash
table entries: 65536 (order: 8, 1048576 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404444] TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404556] TCP: Hash tables
configured (established 65536 bind 65536)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404572] TCP: reno registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404582] UDP hash table
entries: 4096 (order: 5, 131072 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404607] UDP-Lite hash table
entries: 4096 (order: 5, 131072 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.404654] NET: Registered
protocol family 1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.441696] pci 0000:01:00.0:
Boot video device
Sep  9 10:08:11 Arbeits-PC kernel: [    0.441784] PCI: CLS 64 bytes, default 64
Sep  9 10:08:11 Arbeits-PC kernel: [    0.441812] Trying to unpack
rootfs image as initramfs...
Sep  9 10:08:11 Arbeits-PC kernel: [    0.656237] Freeing initrd
memory: 15844k freed
Sep  9 10:08:11 Arbeits-PC kernel: [    0.657901] PCI-DMA: Using
software bounce buffering for IO (SWIOTLB)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.657905] software IO TLB [mem
0xdab89000-0xdeb89000] (64MB) mapped at
[ffff8800dab89000-ffff8800deb88fff]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.658239] Initialise module verification
Sep  9 10:08:11 Arbeits-PC kernel: [    0.658269] audit: initializing
netlink socket (disabled)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.658277] type=2000
audit(1378714088.444:1): initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    0.680542] HugeTLB registered 2
MB page size, pre-allocated 0 pages
Sep  9 10:08:11 Arbeits-PC kernel: [    0.681605] VFS: Disk quotas dquot_6.5.2
Sep  9 10:08:11 Arbeits-PC kernel: [    0.681632] Dquot-cache hash
table entries: 512 (order 0, 4096 bytes)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.681944] fuse init (API version 7.20)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.681992] msgmni has been set to 15901
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682304] Key type asymmetric registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682306] Asymmetric key
parser 'x509' registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682337] Block layer SCSI
generic (bsg) driver version 0.4 loaded (major 252)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682355] io scheduler noop registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682357] io scheduler
deadline registered (default)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682360] io scheduler cfq registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682440] pcieport
0000:00:01.0: irq 40 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682645] pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682654] pciehp: PCI Express
Hot Plug Controller Driver version: 0.4
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682694] efifb: probing for efifb
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682884] efifb: framebuffer
at 0xf1000000, mapped to 0xffffc9000a000000, using 1920k, total 1920k
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682885] efifb: mode is
800x600x32, linelength=3200, pages=1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682886] efifb: scrolling: redraw
Sep  9 10:08:11 Arbeits-PC kernel: [    0.682887] efifb: Truecolor:
size=8:8:8:8, shift=24:16:8:0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.683800] Console: switching
to colour frame buffer device 100x37
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684654] fb0: EFI VGA frame
buffer device
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684658] intel_idle: MWAIT
substates: 0x1120
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684659] intel_idle: v0.4 model 0x2A
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684660] intel_idle:
lapic_timer_reliable_states 0xffffffff
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684720] input: Power Button
as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684724] ACPI: Power Button [PWRB]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684747] input: Power Button
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684749] ACPI: Power Button [PWRF]
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684802] ACPI: Fan [FAN0] (off)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684819] ACPI: Fan [FAN1] (off)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684837] ACPI: Fan [FAN2] (off)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684852] ACPI: Fan [FAN3] (off)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684869] ACPI: Fan [FAN4] (off)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.684910] ACPI: Requesting acpi_cpufreq
Sep  9 10:08:11 Arbeits-PC kernel: [    0.687920] thermal LNXTHERM:00:
registered as thermal_zone0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.687923] ACPI: Thermal Zone
[TZ00] (28 C)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.688084] thermal LNXTHERM:01:
registered as thermal_zone1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.688085] ACPI: Thermal Zone
[TZ01] (30 C)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.688114] GHES: HEST is not enabled!
Sep  9 10:08:11 Arbeits-PC kernel: [    0.688166] Serial: 8250/16550
driver, 32 ports, IRQ sharing enabled
Sep  9 10:08:11 Arbeits-PC kernel: [    0.688982] Linux agpgart interface v0.103
Sep  9 10:08:11 Arbeits-PC kernel: [    0.689913] brd: module loaded
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690340] loop: module loaded
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690549] libphy: Fixed MDIO Bus: probed
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690587] tun: Universal
TUN/TAP device driver, 1.6
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690588] tun: (C) 1999-2004
Max Krasnyansky <maxk@qualcomm.com>
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690617] PPP generic driver
version 2.4.2
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690648] ehci_hcd: USB 2.0
'Enhanced' Host Controller (EHCI) Driver
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690649] ehci-pci: EHCI PCI
platform driver
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690678] ehci-pci
0000:00:1a.0: setting latency timer to 64
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690682] ehci-pci
0000:00:1a.0: EHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690687] ehci-pci
0000:00:1a.0: new USB bus registered, assigned bus number 1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.690699] ehci-pci
0000:00:1a.0: debug port 2
Sep  9 10:08:11 Arbeits-PC kernel: [    0.694587] ehci-pci
0000:00:1a.0: cache line size of 64 is not supported
Sep  9 10:08:11 Arbeits-PC kernel: [    0.694601] ehci-pci
0000:00:1a.0: irq 16, io mem 0xf7428000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705297] ehci-pci
0000:00:1a.0: USB 2.0 started, EHCI 1.00
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705311] usb usb1: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705313] usb usb1: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705314] usb usb1: Product:
EHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705316] usb usb1:
Manufacturer: Linux 3.8.0-30-generic ehci_hcd
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705317] usb usb1:
SerialNumber: 0000:00:1a.0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705384] hub 1-0:1.0: USB hub found
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705387] hub 1-0:1.0: 2 ports detected
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705471] ehci-pci
0000:00:1d.0: setting latency timer to 64
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705474] ehci-pci
0000:00:1d.0: EHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705478] ehci-pci
0000:00:1d.0: new USB bus registered, assigned bus number 2
Sep  9 10:08:11 Arbeits-PC kernel: [    0.705488] ehci-pci
0000:00:1d.0: debug port 2
Sep  9 10:08:11 Arbeits-PC kernel: [    0.709365] ehci-pci
0000:00:1d.0: cache line size of 64 is not supported
Sep  9 10:08:11 Arbeits-PC kernel: [    0.709378] ehci-pci
0000:00:1d.0: irq 23, io mem 0xf7427000
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721275] ehci-pci
0000:00:1d.0: USB 2.0 started, EHCI 1.00
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721284] usb usb2: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721285] usb usb2: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721287] usb usb2: Product:
EHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721288] usb usb2:
Manufacturer: Linux 3.8.0-30-generic ehci_hcd
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721289] usb usb2:
SerialNumber: 0000:00:1d.0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721347] hub 2-0:1.0: USB hub found
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721352] hub 2-0:1.0: 2 ports detected
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721419] ehci-platform: EHCI
generic platform driver
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721424] ohci_hcd: USB 1.1
'Open' Host Controller (OHCI) Driver
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721433] uhci_hcd: USB
Universal Host Controller Interface driver
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721465] xhci_hcd
0000:03:00.0: xHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.721468] xhci_hcd
0000:03:00.0: new USB bus registered, assigned bus number 3
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782558] xhci_hcd
0000:03:00.0: irq 41 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782562] xhci_hcd
0000:03:00.0: irq 42 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782566] xhci_hcd
0000:03:00.0: irq 43 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782570] xhci_hcd
0000:03:00.0: irq 44 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782574] xhci_hcd
0000:03:00.0: irq 45 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782659] usb usb3: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782661] usb usb3: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782662] usb usb3: Product:
xHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782664] usb usb3:
Manufacturer: Linux 3.8.0-30-generic xhci_hcd
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782665] usb usb3:
SerialNumber: 0000:03:00.0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782706] xHCI
xhci_add_endpoint called for root hub
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782708] xHCI
xhci_check_bandwidth called for root hub
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782720] hub 3-0:1.0: USB hub found
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782726] hub 3-0:1.0: 2 ports detected
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782769] xhci_hcd
0000:03:00.0: xHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782771] xhci_hcd
0000:03:00.0: new USB bus registered, assigned bus number 4
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782804] usb usb4: New USB
device found, idVendor=1d6b, idProduct=0003
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782805] usb usb4: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782806] usb usb4: Product:
xHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782808] usb usb4:
Manufacturer: Linux 3.8.0-30-generic xhci_hcd
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782809] usb usb4:
SerialNumber: 0000:03:00.0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782845] xHCI
xhci_add_endpoint called for root hub
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782846] xHCI
xhci_check_bandwidth called for root hub
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782859] hub 4-0:1.0: USB hub found
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782865] hub 4-0:1.0: 2 ports detected
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782957] xhci_hcd
0000:04:00.0: xHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.782962] xhci_hcd
0000:04:00.0: new USB bus registered, assigned bus number 5
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844052] xhci_hcd
0000:04:00.0: irq 46 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844056] xhci_hcd
0000:04:00.0: irq 47 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844060] xhci_hcd
0000:04:00.0: irq 48 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844064] xhci_hcd
0000:04:00.0: irq 49 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844067] xhci_hcd
0000:04:00.0: irq 50 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844155] usb usb5: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844157] usb usb5: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844158] usb usb5: Product:
xHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844159] usb usb5:
Manufacturer: Linux 3.8.0-30-generic xhci_hcd
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844161] usb usb5:
SerialNumber: 0000:04:00.0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844204] xHCI
xhci_add_endpoint called for root hub
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844205] xHCI
xhci_check_bandwidth called for root hub
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844220] hub 5-0:1.0: USB hub found
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844226] hub 5-0:1.0: 2 ports detected
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844270] xhci_hcd
0000:04:00.0: xHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844273] xhci_hcd
0000:04:00.0: new USB bus registered, assigned bus number 6
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844301] usb usb6: New USB
device found, idVendor=1d6b, idProduct=0003
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844303] usb usb6: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844304] usb usb6: Product:
xHCI Host Controller
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844306] usb usb6:
Manufacturer: Linux 3.8.0-30-generic xhci_hcd
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844307] usb usb6:
SerialNumber: 0000:04:00.0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844345] xHCI
xhci_add_endpoint called for root hub
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844346] xHCI
xhci_check_bandwidth called for root hub
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844358] hub 6-0:1.0: USB hub found
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844364] hub 6-0:1.0: 2 ports detected
Sep  9 10:08:11 Arbeits-PC kernel: [    0.844468] i8042: PNP: No PS/2
controller found. Probing ports directly.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847129] serio: i8042 KBD
port at 0x60,0x64 irq 1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847134] serio: i8042 AUX
port at 0x60,0x64 irq 12
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847202] mousedev: PS/2 mouse
device common for all mice
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847282] rtc_cmos 00:05: RTC
can wake from S4
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847382] rtc_cmos 00:05: rtc
core: registered rtc_cmos as rtc0
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847407] rtc0: alarms up to
one month, y3k, 242 bytes nvram, hpet irqs
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847459] device-mapper:
uevent: version 1.0.3
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847493] device-mapper:
ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847534] cpuidle: using governor ladder
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847588] cpuidle: using governor menu
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847590] ledtrig-cpu:
registered to indicate activity on CPUs
Sep  9 10:08:11 Arbeits-PC kernel: [    0.847591] EFI Variables
Facility v0.08 2004-May-17
Sep  9 10:08:11 Arbeits-PC kernel: [    0.897914] ashmem: initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    0.898002] TCP: cubic registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.898067] NET: Registered
protocol family 10
Sep  9 10:08:11 Arbeits-PC kernel: [    0.898177] NET: Registered
protocol family 17
Sep  9 10:08:11 Arbeits-PC kernel: [    0.898185] Key type
dns_resolver registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.898533] Loading module
verification certificates
Sep  9 10:08:11 Arbeits-PC kernel: [    0.899279] MODSIGN: Loaded cert
'Magrathea: Glacier signing key:
3a8155c013f798de7084673b6e86215ebed17697'
Sep  9 10:08:11 Arbeits-PC kernel: [    0.899289] registered taskstats version 1
Sep  9 10:08:11 Arbeits-PC kernel: [    0.901248] Key type trusted registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.902798] Key type encrypted registered
Sep  9 10:08:11 Arbeits-PC kernel: [    0.904693] rtc_cmos 00:05:
setting system clock to 2013-09-09 08:08:09 UTC (1378714089)
Sep  9 10:08:11 Arbeits-PC kernel: [    0.905243] BIOS EDD facility
v0.16 2004-Jun-25, 0 devices found
Sep  9 10:08:11 Arbeits-PC kernel: [    0.905244] EDD information not available.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.906341] Freeing unused
kernel memory: 996k freed
Sep  9 10:08:11 Arbeits-PC kernel: [    0.906427] Write protecting the
kernel read-only data: 12288k
Sep  9 10:08:11 Arbeits-PC kernel: [    0.908808] Freeing unused
kernel memory: 1168k freed
Sep  9 10:08:11 Arbeits-PC kernel: [    0.910893] Freeing unused
kernel memory: 1076k freed
Sep  9 10:08:11 Arbeits-PC kernel: [    0.934876] Disabling lock
debugging due to kernel taint
Sep  9 10:08:11 Arbeits-PC kernel: [    0.935275] e1000e: Intel(R)
PRO/1000 Network Driver - 2.1.4-k
Sep  9 10:08:11 Arbeits-PC kernel: [    0.935277] e1000e: Copyright(c)
1999 - 2012 Intel Corporation.
Sep  9 10:08:11 Arbeits-PC kernel: [    0.935310] e1000e 0000:00:19.0:
setting latency timer to 64
Sep  9 10:08:11 Arbeits-PC kernel: [    0.935361] e1000e 0000:00:19.0:
Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
Sep  9 10:08:11 Arbeits-PC kernel: [    0.935390] e1000e 0000:00:19.0:
irq 51 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    1.016857] usb 1-1: new
high-speed USB device number 2 using ehci-pci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.149006] usb 1-1: New USB
device found, idVendor=8087, idProduct=0024
Sep  9 10:08:11 Arbeits-PC kernel: [    1.149008] usb 1-1: New USB
device strings: Mfr=0, Product=0, SerialNumber=0
Sep  9 10:08:11 Arbeits-PC kernel: [    1.149276] hub 1-1:1.0: USB hub found
Sep  9 10:08:11 Arbeits-PC kernel: [    1.149378] hub 1-1:1.0: 6 ports detected
Sep  9 10:08:11 Arbeits-PC kernel: [    1.190948] e1000e 0000:00:19.0
eth0: (PCI Express:2.5GT/s:Width x1) 54:04:a6:2a:65:f6
Sep  9 10:08:11 Arbeits-PC kernel: [    1.190950] e1000e 0000:00:19.0
eth0: Intel(R) PRO/1000 Network Connection
Sep  9 10:08:11 Arbeits-PC kernel: [    1.190998] e1000e 0000:00:19.0
eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
Sep  9 10:08:11 Arbeits-PC kernel: [    1.191033] ahci 0000:00:1f.2: version 3.0
Sep  9 10:08:11 Arbeits-PC kernel: [    1.191116] ahci 0000:00:1f.2:
irq 52 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    1.204637] ahci 0000:00:1f.2:
AHCI 0001.0300 32 slots 6 ports 6 Gbps 0xb impl SATA mode
Sep  9 10:08:11 Arbeits-PC kernel: [    1.204640] ahci 0000:00:1f.2:
flags: 64bit ncq led clo pio slum part ems apst
Sep  9 10:08:11 Arbeits-PC kernel: [    1.204644] ahci 0000:00:1f.2:
setting latency timer to 64
Sep  9 10:08:11 Arbeits-PC kernel: [    1.220874] scsi0 : ahci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.220999] scsi1 : ahci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221112] scsi2 : ahci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221209] scsi3 : ahci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221304] scsi4 : ahci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221405] scsi5 : ahci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221462] ata1: SATA max
UDMA/133 abar m2048@0xf7426000 port 0xf7426100 irq 52
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221465] ata2: SATA max
UDMA/133 abar m2048@0xf7426000 port 0xf7426180 irq 52
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221466] ata3: DUMMY
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221468] ata4: SATA max
UDMA/133 abar m2048@0xf7426000 port 0xf7426280 irq 52
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221469] ata5: DUMMY
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221470] ata6: DUMMY
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221584] ahci 0000:05:00.0:
AHCI 0001.0100 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221586] ahci 0000:05:00.0:
flags: 64bit ncq pm led clo pmp pio slum part
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221771] scsi6 : ahci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221853] scsi7 : ahci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221879] ata7: SATA max
UDMA/133 abar m512@0xf7110000 port 0xf7110100 irq 18
Sep  9 10:08:11 Arbeits-PC kernel: [    1.221882] ata8: SATA max
UDMA/133 abar m512@0xf7110000 port 0xf7110180 irq 18
Sep  9 10:08:11 Arbeits-PC kernel: [    1.260513] usb 2-1: new
high-speed USB device number 2 using ehci-pci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.392686] usb 2-1: New USB
device found, idVendor=8087, idProduct=0024
Sep  9 10:08:11 Arbeits-PC kernel: [    1.392689] usb 2-1: New USB
device strings: Mfr=0, Product=0, SerialNumber=0
Sep  9 10:08:11 Arbeits-PC kernel: [    1.392931] hub 2-1:1.0: USB hub found
Sep  9 10:08:11 Arbeits-PC kernel: [    1.393031] hub 2-1:1.0: 8 ports detected
Sep  9 10:08:11 Arbeits-PC kernel: [    1.540143] ata7: SATA link down
(SStatus 0 SControl 300)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.540145] ata1: SATA link up
6.0 Gbps (SStatus 133 SControl 300)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.540191] ata4: SATA link up
1.5 Gbps (SStatus 113 SControl 300)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.540197] ata8: SATA link down
(SStatus 0 SControl 300)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.543256] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.543261] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT3._GTF] (Node
ffff8802130b2438), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.543268] ata4.00: ATAPI:
HL-DT-ST DVDRAM GH22LS50, TL02, max UDMA/100
Sep  9 10:08:11 Arbeits-PC kernel: [    1.547038] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.547042] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT3._GTF] (Node
ffff8802130b2438), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.547050] ata4.00: configured
for UDMA/100
Sep  9 10:08:11 Arbeits-PC kernel: [    1.548102] ata2: SATA link up
3.0 Gbps (SStatus 123 SControl 300)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.548870] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.548874] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node
ffff8802130b2348), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.549046] ata2.00: HPA
detected: current 1250261615, native 1250263728
Sep  9 10:08:11 Arbeits-PC kernel: [    1.549165] ata2.00: ATA-8: WDC
WD6400AAKS-07A7B0, 01.03B01, max UDMA/133
Sep  9 10:08:11 Arbeits-PC kernel: [    1.549167] ata2.00: 1250261615
sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Sep  9 10:08:11 Arbeits-PC kernel: [    1.550028] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.550032] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node
ffff8802130b2348), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.550302] ata2.00: configured
for UDMA/133
Sep  9 10:08:11 Arbeits-PC kernel: [    1.551335] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.551339] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node
ffff8802130b22d0), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.552200] ata1.00: ATA-8:
SanDisk SDSSDX120GG25, R112, max UDMA/133
Sep  9 10:08:11 Arbeits-PC kernel: [    1.552202] ata1.00: 234441648
sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Sep  9 10:08:11 Arbeits-PC kernel: [    1.560086] usb 3-1: new
high-speed USB device number 2 using xhci_hcd
Sep  9 10:08:11 Arbeits-PC kernel: [    1.561318] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20121018/psargs-359)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.561322] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node
ffff8802130b22d0), AE_NOT_FOUND (20121018/psparse-537)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562083] ata1.00: configured
for UDMA/133
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562234] scsi 0:0:0:0:
Direct-Access     ATA      SanDisk SDSSDX12 R112 PQ: 0 ANSI: 5
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562345] sd 0:0:0:0: [sda]
234441648 512-byte logical blocks: (120 GB/111 GiB)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562385] sd 0:0:0:0: Attached
scsi generic sg0 type 0
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562391] sd 0:0:0:0: [sda]
Write Protect is off
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562393] sd 0:0:0:0: [sda]
Mode Sense: 00 3a 00 00
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562405] sd 0:0:0:0: [sda]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562545] scsi 1:0:0:0:
Direct-Access     ATA      WDC WD6400AAKS-0 01.0 PQ: 0 ANSI: 5
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562646] sd 1:0:0:0: [sdb]
1250261615 512-byte logical blocks: (640 GB/596 GiB)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562655] sd 1:0:0:0: Attached
scsi generic sg1 type 0
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562706] sd 1:0:0:0: [sdb]
Write Protect is off
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562708] sd 1:0:0:0: [sdb]
Mode Sense: 00 3a 00 00
Sep  9 10:08:11 Arbeits-PC kernel: [    1.562738] sd 1:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep  9 10:08:11 Arbeits-PC kernel: [    1.563231]  sda: sda1 sda2 sda3
Sep  9 10:08:11 Arbeits-PC kernel: [    1.563435] sd 0:0:0:0: [sda]
Attached SCSI disk
Sep  9 10:08:11 Arbeits-PC kernel: [    1.566132] scsi 3:0:0:0: CD-ROM
           HL-DT-ST DVDRAM GH22LS50  TL02 PQ: 0 ANSI: 5
Sep  9 10:08:11 Arbeits-PC kernel: [    1.574559] sr0: scsi3-mmc
drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Sep  9 10:08:11 Arbeits-PC kernel: [    1.574562] cdrom: Uniform
CD-ROM driver Revision: 3.20
Sep  9 10:08:11 Arbeits-PC kernel: [    1.574675] sr 3:0:0:0: Attached
scsi CD-ROM sr0
Sep  9 10:08:11 Arbeits-PC kernel: [    1.574732] sr 3:0:0:0: Attached
scsi generic sg2 type 5
Sep  9 10:08:11 Arbeits-PC kernel: [    1.577106] usb 3-1: New USB
device found, idVendor=1058, idProduct=1021
Sep  9 10:08:11 Arbeits-PC kernel: [    1.577108] usb 3-1: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Sep  9 10:08:11 Arbeits-PC kernel: [    1.577110] usb 3-1: Product: Ext HDD 1021
Sep  9 10:08:11 Arbeits-PC kernel: [    1.577111] usb 3-1:
Manufacturer: Western Digital
Sep  9 10:08:11 Arbeits-PC kernel: [    1.577112] usb 3-1:
SerialNumber: 574D43315430333633353930
Sep  9 10:08:11 Arbeits-PC kernel: [    1.579330] Initializing USB
Mass Storage driver...
Sep  9 10:08:11 Arbeits-PC kernel: [    1.579414] scsi8 : usb-storage 3-1:1.0
Sep  9 10:08:11 Arbeits-PC kernel: [    1.579457] usbcore: registered
new interface driver usb-storage
Sep  9 10:08:11 Arbeits-PC kernel: [    1.579458] USB Mass Storage
support registered.
Sep  9 10:08:11 Arbeits-PC kernel: [    1.626014]  sdb: sdb1
Sep  9 10:08:11 Arbeits-PC kernel: [    1.626489] sd 1:0:0:0: [sdb]
Attached SCSI disk
Sep  9 10:08:11 Arbeits-PC kernel: [    1.655936] tsc: Refined TSC
clocksource calibration: 2809.164 MHz
Sep  9 10:08:11 Arbeits-PC kernel: [    1.655940] Switching to clocksource tsc
Sep  9 10:08:11 Arbeits-PC kernel: [    1.668842] EXT4-fs (sda2):
mounted filesystem with ordered data mode. Opts: (null)
Sep  9 10:08:11 Arbeits-PC kernel: [    1.743812] usb 3-2: new
high-speed USB device number 3 using xhci_hcd
Sep  9 10:08:11 Arbeits-PC kernel: [    1.760585] usb 3-2: New USB
device found, idVendor=1058, idProduct=1001
Sep  9 10:08:11 Arbeits-PC kernel: [    1.760588] usb 3-2: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Sep  9 10:08:11 Arbeits-PC kernel: [    1.760589] usb 3-2: Product:
External HDD
Sep  9 10:08:11 Arbeits-PC kernel: [    1.760591] usb 3-2:
Manufacturer: Western Digital
Sep  9 10:08:11 Arbeits-PC kernel: [    1.760592] usb 3-2:
SerialNumber: 574341553433313736393333
Sep  9 10:08:11 Arbeits-PC kernel: [    1.761442] scsi9 : usb-storage 3-2:1.0
Sep  9 10:08:11 Arbeits-PC kernel: [    1.831763] usb 1-1.3: new
high-speed USB device number 3 using ehci-pci
Sep  9 10:08:11 Arbeits-PC kernel: [    1.947781] usb 1-1.3: New USB
device found, idVendor=0bda, idProduct=8178
Sep  9 10:08:11 Arbeits-PC kernel: [    1.947784] usb 1-1.3: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Sep  9 10:08:11 Arbeits-PC kernel: [    1.947785] usb 1-1.3: Product: USB WLAN
Sep  9 10:08:11 Arbeits-PC kernel: [    1.947786] usb 1-1.3:
Manufacturer: 802.11n
Sep  9 10:08:11 Arbeits-PC kernel: [    1.947788] usb 1-1.3:
SerialNumber: 00e04c000001
Sep  9 10:08:11 Arbeits-PC kernel: [    1.989846] Adding 8354812k swap
on /dev/sda3.  Priority:-1 extents:1 across:8354812k SS
Sep  9 10:08:11 Arbeits-PC kernel: [    1.997649] IPv6:
ADDRCONF(NETDEV_UP): eth0: link is not ready
Sep  9 10:08:11 Arbeits-PC kernel: [    2.018434] lp: driver loaded
but no devices found
Sep  9 10:08:11 Arbeits-PC kernel: [    2.023480] usb 2-1.3: new
full-speed USB device number 3 using ehci-pci
Sep  9 10:08:11 Arbeits-PC kernel: [    2.030847] mei 0000:00:16.0:
setting latency timer to 64
Sep  9 10:08:11 Arbeits-PC kernel: [    2.030896] mei 0000:00:16.0:
irq 53 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    2.037395] [drm] Initialized
drm 1.1.0 20060810
Sep  9 10:08:11 Arbeits-PC kernel: [    2.043597] wmi: Mapper loaded
Sep  9 10:08:11 Arbeits-PC kernel: [    2.044855] nvidia: module
license 'NVIDIA' taints kernel.
Sep  9 10:08:11 Arbeits-PC kernel: [    2.050764] vgaarb: device
changed decodes:
PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
Sep  9 10:08:11 Arbeits-PC kernel: [    2.050914] [drm] Initialized
nvidia-drm 0.0.0 20130102 for 0000:01:00.0 on minor 0
Sep  9 10:08:11 Arbeits-PC kernel: [    2.050919] NVRM: loading NVIDIA
UNIX x86_64 Kernel Module  325.15  Wed Jul 31 18:50:56 PDT 2013
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054899] ACPI Warning:
0x0000000000000428-0x000000000000042f SystemIO conflicts with Region
\PMIO 1 (20121018/utaddress-251)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054904] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054907] ACPI Warning:
0x0000000000000540-0x000000000000054f SystemIO conflicts with Region
\GPIO 1 (20121018/utaddress-251)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054910] ACPI Warning:
0x0000000000000540-0x000000000000054f SystemIO conflicts with Region
\_SB_.PCI0.LPCB.GPBX 2 (20121018/utaddress-251)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054912] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054913] ACPI Warning:
0x0000000000000530-0x000000000000053f SystemIO conflicts with Region
\GPIO 1 (20121018/utaddress-251)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054915] ACPI Warning:
0x0000000000000530-0x000000000000053f SystemIO conflicts with Region
\_SB_.PCI0.LPCB.GPBX 2 (20121018/utaddress-251)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054917] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054918] ACPI Warning:
0x0000000000000500-0x000000000000052f SystemIO conflicts with Region
\GPIO 1 (20121018/utaddress-251)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054920] ACPI Warning:
0x0000000000000500-0x000000000000052f SystemIO conflicts with Region
\_SB_.PCI0.LPCB.GPBX 2 (20121018/utaddress-251)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054922] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 10:08:11 Arbeits-PC kernel: [    2.054923] lpc_ich: Resource
conflict(s) found affecting gpio_ich
Sep  9 10:08:11 Arbeits-PC kernel: [    2.097933] snd_hda_intel
0000:00:1b.0: enabling device (0000 -> 0002)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.097997] snd_hda_intel
0000:00:1b.0: irq 54 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    2.098545] microcode: CPU0
sig=0x206a7, pf=0x2, revision=0x28
Sep  9 10:08:11 Arbeits-PC kernel: [    2.121481] type=1400
audit(1378714090.712:2): apparmor="STATUS" operation="profile_load"
name="/sbin/dhclient" pid=693 comm="apparmor_parser"
Sep  9 10:08:11 Arbeits-PC kernel: [    2.121750] type=1400
audit(1378714090.712:3): apparmor="STATUS" operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=693
comm="apparmor_parser"
Sep  9 10:08:11 Arbeits-PC kernel: [    2.121898] type=1400
audit(1378714090.712:4): apparmor="STATUS" operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" pid=693
comm="apparmor_parser"
Sep  9 10:08:11 Arbeits-PC kernel: [    2.127291] usb 2-1.3: New USB
device found, idVendor=045e, idProduct=0768
Sep  9 10:08:11 Arbeits-PC kernel: [    2.127295] usb 2-1.3: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Sep  9 10:08:11 Arbeits-PC kernel: [    2.127297] usb 2-1.3: Product:
Microsoft® SiderWinderTM X4 Keyboard
Sep  9 10:08:11 Arbeits-PC kernel: [    2.127298] usb 2-1.3:
Manufacturer: Microsoft
Sep  9 10:08:11 Arbeits-PC kernel: [    2.129636] input: HDA Intel PCH
Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input2
Sep  9 10:08:11 Arbeits-PC kernel: [    2.131712] input: HDA Intel PCH
Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input3
Sep  9 10:08:11 Arbeits-PC kernel: [    2.131806] input: HDA Intel PCH
Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
Sep  9 10:08:11 Arbeits-PC kernel: [    2.131873] input: HDA Intel PCH
Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
Sep  9 10:08:11 Arbeits-PC kernel: [    2.131935] input: HDA Intel PCH
Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
Sep  9 10:08:11 Arbeits-PC kernel: [    2.131994] input: HDA Intel PCH
Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
Sep  9 10:08:11 Arbeits-PC kernel: [    2.132057] input: HDA Intel PCH
Line Out Surround as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
Sep  9 10:08:11 Arbeits-PC kernel: [    2.132119] input: HDA Intel PCH
Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
Sep  9 10:08:11 Arbeits-PC kernel: [    2.133282] snd_hda_intel
0000:01:00.1: enabling device (0000 -> 0002)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.133288] hda_intel: Disabling MSI
Sep  9 10:08:11 Arbeits-PC kernel: [    2.133293] hda-intel
0000:01:00.1: Handle VGA-switcheroo audio client
Sep  9 10:08:11 Arbeits-PC kernel: [    2.153893] microcode: CPU1
sig=0x206a7, pf=0x2, revision=0x28
Sep  9 10:08:11 Arbeits-PC kernel: [    2.160747] microcode: CPU2
sig=0x206a7, pf=0x2, revision=0x28
Sep  9 10:08:11 Arbeits-PC kernel: [    2.162102] microcode: CPU3
sig=0x206a7, pf=0x2, revision=0x28
Sep  9 10:08:11 Arbeits-PC kernel: [    2.162970] asus_wmi: ASUS WMI
generic driver loaded
Sep  9 10:08:11 Arbeits-PC kernel: [    2.164265] asus_wmi:
Initialization: 0x0asus_wmi: BIOS WMI version: 0.9
Sep  9 10:08:11 Arbeits-PC kernel: [    2.164307] asus_wmi: SFUN
value: 0x0<6>[    2.164493] input: Eee PC WMI hotkeys as
/devices/platform/eeepc-wmi/input/input10
Sep  9 10:08:11 Arbeits-PC kernel: [    2.165417] asus_wmi: Disabling
ACPI video driver
Sep  9 10:08:11 Arbeits-PC kernel: [    2.166007] microcode: Microcode
Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Sep  9 10:08:11 Arbeits-PC kernel: [    2.193250] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:08:11 Arbeits-PC kernel: [    2.193921] usbcore: registered
new interface driver usbhid
Sep  9 10:08:11 Arbeits-PC kernel: [    2.193923] usbhid: USB HID core driver
Sep  9 10:08:11 Arbeits-PC kernel: [    2.196405] input: Microsoft
Microsoft® SiderWinderTM X4 Keyboard as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input11
Sep  9 10:08:11 Arbeits-PC kernel: [    2.196557] hid-generic
0003:045E:0768.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsoft
Microsoft® SiderWinderTM X4 Keyboard] on usb-0000:00:1d.0-1.3/input0
Sep  9 10:08:11 Arbeits-PC kernel: [    2.199302] usb 2-1.4: new
low-speed USB device number 4 using ehci-pci
Sep  9 10:08:11 Arbeits-PC kernel: [    2.207112] input: Microsoft
Microsoft® SiderWinderTM X4 Keyboard as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/input/input12
Sep  9 10:08:11 Arbeits-PC kernel: [    2.207418] hid-generic
0003:045E:0768.0002: input,hidraw1: USB HID v1.11 Keyboard [Microsoft
Microsoft® SiderWinderTM X4 Keyboard] on usb-0000:00:1d.0-1.3/input1
Sep  9 10:08:11 Arbeits-PC kernel: [    2.217322] rtl8192cu: Chip version 0x11
Sep  9 10:08:11 Arbeits-PC kernel: [    2.235140] cfg80211: World
regulatory domain updated:
Sep  9 10:08:11 Arbeits-PC kernel: [    2.235143] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.235144] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.235158] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.235159] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.235161] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.235162] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.281620] EXT4-fs (sda2):
re-mounted. Opts: errors=remount-ro
Sep  9 10:08:11 Arbeits-PC kernel: [    2.294216] rtl8192cu: MAC
address: f8:1a:67:19:16:94
Sep  9 10:08:11 Arbeits-PC kernel: [    2.294219] rtl8192cu: Board Type 0
Sep  9 10:08:11 Arbeits-PC kernel: [    2.294466] rtlwifi: rx_max_size
15360, rx_urb_num 8, in_ep 1
Sep  9 10:08:11 Arbeits-PC kernel: [    2.294487] rtl8192cu: Loading
firmware rtlwifi/rtl8192cufw.bin
Sep  9 10:08:11 Arbeits-PC kernel: [    2.294539] usbcore: registered
new interface driver rtl8192cu
Sep  9 10:08:11 Arbeits-PC kernel: [    2.296836] usb 2-1.4: New USB
device found, idVendor=046d, idProduct=c051
Sep  9 10:08:11 Arbeits-PC kernel: [    2.296839] usb 2-1.4: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Sep  9 10:08:11 Arbeits-PC kernel: [    2.296840] usb 2-1.4: Product:
USB-PS/2 Optical Mouse
Sep  9 10:08:11 Arbeits-PC kernel: [    2.296842] usb 2-1.4:
Manufacturer: Logitech
Sep  9 10:08:11 Arbeits-PC kernel: [    2.301340] input: Logitech
USB-PS/2 Optical Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input13
Sep  9 10:08:11 Arbeits-PC kernel: [    2.301406] hid-generic
0003:046D:C051.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech
USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.4/input0
Sep  9 10:08:11 Arbeits-PC kernel: [    2.305888] ieee80211 phy0:
Selected rate control algorithm 'rtl_rc'
Sep  9 10:08:11 Arbeits-PC kernel: [    2.306194] rtlwifi: wireless switch is on
Sep  9 10:08:11 Arbeits-PC kernel: [    2.382951] Bluetooth: Core ver 2.16
Sep  9 10:08:11 Arbeits-PC kernel: [    2.382964] NET: Registered
protocol family 31
Sep  9 10:08:11 Arbeits-PC kernel: [    2.382965] Bluetooth: HCI
device and connection manager initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    2.383114] Bluetooth: HCI
socket layer initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    2.383117] Bluetooth: L2CAP
socket layer initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    2.383120] Bluetooth: SCO
socket layer initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    2.385127] Bluetooth: BNEP
(Ethernet Emulation) ver 1.3
Sep  9 10:08:11 Arbeits-PC kernel: [    2.385129] Bluetooth: BNEP
filters: protocol multicast
Sep  9 10:08:11 Arbeits-PC kernel: [    2.385134] Bluetooth: BNEP
socket layer initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    2.387743] Bluetooth: RFCOMM
TTY layer initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    2.387750] Bluetooth: RFCOMM
socket layer initialized
Sep  9 10:08:11 Arbeits-PC kernel: [    2.387751] Bluetooth: RFCOMM ver 1.11
Sep  9 10:08:11 Arbeits-PC kernel: [    2.551565] type=1400
audit(1378714091.144:5): apparmor="STATUS" operation="profile_replace"
name="/sbin/dhclient" pid=1029 comm="apparmor_parser"
Sep  9 10:08:11 Arbeits-PC kernel: [    2.551824] type=1400
audit(1378714091.144:6): apparmor="STATUS" operation="profile_load"
name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-freerdp/freerdp-session-wrapper"
pid=1027 comm="apparmor_parser"
Sep  9 10:08:11 Arbeits-PC kernel: [    2.551831] type=1400
audit(1378714091.144:7): apparmor="STATUS" operation="profile_load"
name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-uccsconfigure/uccsconfigure-session-wrapper"
pid=1028 comm="apparmor_parser"
Sep  9 10:08:11 Arbeits-PC kernel: [    2.551842] type=1400
audit(1378714091.144:8): apparmor="STATUS" operation="profile_load"
name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=1026
comm="apparmor_parser"
Sep  9 10:08:11 Arbeits-PC kernel: [    2.551847] type=1400
audit(1378714091.144:9): apparmor="STATUS" operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1029
comm="apparmor_parser"
Sep  9 10:08:11 Arbeits-PC kernel: [    2.551997] type=1400
audit(1378714091.144:10): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=1029
comm="apparmor_parser"
Sep  9 10:08:11 Arbeits-PC kernel: [    2.576590] scsi 8:0:0:0:
Direct-Access     WD       Ext HDD 1021     2021 PQ: 0 ANSI: 4
Sep  9 10:08:11 Arbeits-PC kernel: [    2.576994] sd 8:0:0:0: Attached
scsi generic sg3 type 0
Sep  9 10:08:11 Arbeits-PC kernel: [    2.577372] sd 8:0:0:0: [sdc]
732566016 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.578880] sd 8:0:0:0: [sdc]
Write Protect is off
Sep  9 10:08:11 Arbeits-PC kernel: [    2.578883] sd 8:0:0:0: [sdc]
Mode Sense: 17 00 10 08
Sep  9 10:08:11 Arbeits-PC kernel: [    2.580384] sd 8:0:0:0: [sdc] No
Caching mode page present
Sep  9 10:08:11 Arbeits-PC kernel: [    2.580387] sd 8:0:0:0: [sdc]
Assuming drive cache: write through
Sep  9 10:08:11 Arbeits-PC kernel: [    2.580910] sd 8:0:0:0: [sdc]
732566016 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.583860] sd 8:0:0:0: [sdc] No
Caching mode page present
Sep  9 10:08:11 Arbeits-PC kernel: [    2.583862] sd 8:0:0:0: [sdc]
Assuming drive cache: write through
Sep  9 10:08:11 Arbeits-PC kernel: [    2.584134]  sdc: sdc1
Sep  9 10:08:11 Arbeits-PC kernel: [    2.584736] sd 8:0:0:0: [sdc]
732566016 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Sep  9 10:08:11 Arbeits-PC avahi-daemon[1058]: Found user 'avahi' (UID
111) and group 'avahi' (GID 118).
Sep  9 10:08:11 Arbeits-PC avahi-daemon[1058]: Successfully dropped
root privileges.
Sep  9 10:08:11 Arbeits-PC avahi-daemon[1058]: avahi-daemon 0.6.31 starting up.
Sep  9 10:08:11 Arbeits-PC kernel: [    2.589672] sd 8:0:0:0: [sdc] No
Caching mode page present
Sep  9 10:08:11 Arbeits-PC kernel: [    2.589675] sd 8:0:0:0: [sdc]
Assuming drive cache: write through
Sep  9 10:08:11 Arbeits-PC kernel: [    2.589678] sd 8:0:0:0: [sdc]
Attached SCSI disk
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> NetworkManager
(version 0.9.8.0) is starting...
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> Read config
file /etc/NetworkManager/NetworkManager.conf
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> WEXT support is enabled
Sep  9 10:08:11 Arbeits-PC avahi-daemon[1058]: Successfully called chroot().
Sep  9 10:08:11 Arbeits-PC avahi-daemon[1058]: Successfully dropped
remaining capabilities.
Sep  9 10:08:11 Arbeits-PC avahi-daemon[1058]: Loading service file
/services/udisks.service.
Sep  9 10:08:11 Arbeits-PC avahi-daemon[1058]: Network interface
enumeration completed.
Sep  9 10:08:11 Arbeits-PC avahi-daemon[1058]: Registering HINFO
record with values 'X86_64'/'LINUX'.
Sep  9 10:08:11 Arbeits-PC avahi-daemon[1058]: Server startup
complete. Host name is Arbeits-PC.local. Local service cookie is
3936324030.
Sep  9 10:08:11 Arbeits-PC avahi-daemon[1058]: Service "Arbeits-PC"
(/services/udisks.service) successfully established.
Sep  9 10:08:11 Arbeits-PC kernel: [    2.595246] ppdev: user-space
parallel port driver
Sep  9 10:08:11 Arbeits-PC kernel: [    2.606623] input: HDA NVidia
HDMI/DP,pcm=9 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
Sep  9 10:08:11 Arbeits-PC kernel: [    2.606681] input: HDA NVidia
HDMI/DP,pcm=8 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
Sep  9 10:08:11 Arbeits-PC kernel: [    2.606720] input: HDA NVidia
HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
Sep  9 10:08:11 Arbeits-PC kernel: [    2.606791] input: HDA NVidia
HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> VPN: loaded
org.freedesktop.NetworkManager.pptp
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> DNS: loaded
plugin dnsmasq
Sep  9 10:08:11 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.PolicyKit1' (using servicehelper)
Sep  9 10:08:11 Arbeits-PC anacron[1140]: Anacron 2.3 started on 2013-09-09
Sep  9 10:08:11 Arbeits-PC acpid: starting up with proc fs
Sep  9 10:08:11 Arbeits-PC nvidia-persistenced: Started (1143)
Sep  9 10:08:11 Arbeits-PC nvidia-persistenced: Failed to query NVIDIA
devices. Please ensure that the NVIDIA device files (/dev/nvidia*)
exist, and that user 999 has read and write permissions for those
files.
Sep  9 10:08:11 Arbeits-PC nvidia-persistenced: The daemon no longer
has permission to remove its runtime data directory
/var/run/nvidia-persistenced
Sep  9 10:08:11 Arbeits-PC nvidia-persistenced: Shutdown (1143)
Sep  9 10:08:11 Arbeits-PC anacron[1140]: Normal exit (0 jobs run)
Sep  9 10:08:11 Arbeits-PC cron[1112]: (CRON) INFO (pidfile fd = 3)
Sep  9 10:08:11 Arbeits-PC cron[1195]: (CRON) STARTUP (fork ok)
Sep  9 10:08:11 Arbeits-PC cron[1195]: (CRON) INFO (Running @reboot jobs)
Sep  9 10:08:11 Arbeits-PC polkitd[1125]: started daemon version 0.105
using authority implementation `local' version `0.105'
Sep  9 10:08:11 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.PolicyKit1'
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown: init!
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
update_system_hostname
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPluginIfupdown:
management mode: unmanaged
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
devices added (path: /sys/devices/pci0000:00/0000:00:19.0/net/eth0,
iface: eth0)
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
device added (path: /sys/devices/pci0000:00/0000:00:19.0/net/eth0,
iface: eth0): no ifupdown configuration found.
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
devices added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0)
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
device added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0): no ifupdown configuration found.
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
devices added (path: /sys/devices/virtual/net/lo, iface: lo)
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
device added (path: /sys/devices/virtual/net/lo, iface: lo): no
ifupdown configuration found.
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
end _init.
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> Loaded plugin
ifupdown: (C) 2008 Canonical Ltd.  To report bugs please use the
NetworkManager mailing list.
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> Loaded plugin
keyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the
NetworkManager mailing list.
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    Ifupdown: get
unmanaged devices count: 0
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
(20063408) ... get_connections.
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
(20063408) ... get_connections (managed=false): return empty list.
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    keyfile: parsing Festung ...
Sep  9 10:08:11 Arbeits-PC ntpdate[1192]: Can't find host
ntp.ubuntu.com: System error (-11)
Sep  9 10:08:11 Arbeits-PC ntpdate[1192]: no servers can be used, exiting
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    keyfile:     read
connection 'Festung'
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    keyfile: parsing WG-WLAN ...
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    keyfile:     read
connection 'WG-WLAN'
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    keyfile: parsing
WG-WLAN 1 ...
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    keyfile:     read
connection 'WG-WLAN 1'
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]:    Ifupdown: get
unmanaged devices count: 0
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> modem-manager
is now available
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> monitoring
kernel firmware directory '/lib/firmware'.
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> rfkill0: found
WiFi radio killswitch (at
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/ieee80211/phy0/rfkill0)
(driver rtl8192cu)
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> WiFi hardware
radio set enabled
Sep  9 10:08:11 Arbeits-PC acpid: 33 rules loaded
Sep  9 10:08:11 Arbeits-PC acpid: waiting for events: event logging is off
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> WiFi enabled
by radio killswitch; enabled by state file
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> WWAN enabled
by radio killswitch; enabled by state file
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> WiMAX enabled
by radio killswitch; enabled by state file
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> Networking is
enabled by state file
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <warn> failed to
allocate link cache: (-10) Operation not supported
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (eth0): carrier is OFF
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (eth0): new
Ethernet device (driver: 'e1000e' ifindex: 2)
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (eth0):
exported as /org/freedesktop/NetworkManager/Devices/0
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (eth0): device
state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (eth0):
bringing up device.
Sep  9 10:08:11 Arbeits-PC acpid: client connected from 1242[0:0]
Sep  9 10:08:11 Arbeits-PC acpid: 1 client rule loaded
Sep  9 10:08:11 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.ColorManager' (using servicehelper)
Sep  9 10:08:11 Arbeits-PC colord: Using config file /etc/colord.conf
Sep  9 10:08:11 Arbeits-PC colord: Using mapping database file
/var/lib/colord/mapping.db
Sep  9 10:08:11 Arbeits-PC colord: Using device database file
/var/lib/colord/storage.db
Sep  9 10:08:11 Arbeits-PC colord: loaded plugin libcd_plugin_scanner.so
Sep  9 10:08:11 Arbeits-PC colord: plugin
/usr/lib/colord-plugins/libcd_plugin_sane.so not loaded: plugin
refused to load
Sep  9 10:08:11 Arbeits-PC colord: loaded plugin libcd_plugin_camera.so
Sep  9 10:08:11 Arbeits-PC colord: Daemon ready for requests
Sep  9 10:08:11 Arbeits-PC kernel: [    2.758660] scsi 9:0:0:0:
Direct-Access     WD       10EAVS External  1.05 PQ: 0 ANSI: 4
Sep  9 10:08:11 Arbeits-PC kernel: [    2.759083] sd 9:0:0:0: Attached
scsi generic sg4 type 0
Sep  9 10:08:11 Arbeits-PC kernel: [    2.759643] sd 9:0:0:0: [sdd]
1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.760181] sd 9:0:0:0: [sdd]
Write Protect is off
Sep  9 10:08:11 Arbeits-PC kernel: [    2.760184] sd 9:0:0:0: [sdd]
Mode Sense: 21 00 00 00
Sep  9 10:08:11 Arbeits-PC kernel: [    2.761133] sd 9:0:0:0: [sdd] No
Caching mode page present
Sep  9 10:08:11 Arbeits-PC kernel: [    2.761135] sd 9:0:0:0: [sdd]
Assuming drive cache: write through
Sep  9 10:08:11 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.ColorManager'
Sep  9 10:08:11 Arbeits-PC anacron[1279]: Anacron 2.3 started on 2013-09-09
Sep  9 10:08:11 Arbeits-PC anacron[1279]: Normal exit (0 jobs run)
Sep  9 10:08:11 Arbeits-PC kernel: [    2.769404] sd 9:0:0:0: [sdd] No
Caching mode page present
Sep  9 10:08:11 Arbeits-PC kernel: [    2.769407] sd 9:0:0:0: [sdd]
Assuming drive cache: write through
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-709099b11b3ec2828a314682a3c09f75
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-22f24c14dfa0237c65ce91cbdc840c69
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-d3ee37ff47fcdf614fb5cb62fb3e16a7
Sep  9 10:08:11 Arbeits-PC kernel: [    2.775437] nvidia 0000:01:00.0:
irq 55 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-7da394e6f8f9718fc7b52b32566dac05
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-e7ecfce2d984c9f0c90f4ef1cdc9ac7e
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-798efa4314bbd0274499de21fdf4ee5e
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-f844a65e79050c828a5f8381a0798e49
Sep  9 10:08:11 Arbeits-PC kernel: [    2.782909]  sdd: sdd1
Sep  9 10:08:11 Arbeits-PC kernel: [    2.784727] sd 9:0:0:0: [sdd] No
Caching mode page present
Sep  9 10:08:11 Arbeits-PC kernel: [    2.784730] sd 9:0:0:0: [sdd]
Assuming drive cache: write through
Sep  9 10:08:11 Arbeits-PC kernel: [    2.784732] sd 9:0:0:0: [sdd]
Attached SCSI disk
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-f1d6e4a79454dcf348e740f8258ebc8b
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-5e1ebb54becd93f823c07c22bc1938e0
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-e9984ac92492c61ae319f57aa7cbb102
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-578e8c43d0440cff3239ced4417c691a
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-6590422afc1260c68d531b8de865eda1
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-8032ad23c1912c7ffae56745d279fde7
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-f5cf9cb1331928471dbcd67d7229aff5
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-9cc8e51f95b2209f235c230393230ead
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-429bb399c0de0c6fe69826993b46c219
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-8ab229960e966f047a0fb62c4cb1f390
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-adb5ebe2a14b98599a170cd3ab54fe76
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-29f7c3bb18648f967e9cc450f5b0821e
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-dff20c58ed34af3a30bc97b2b2a1b6c5
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-ae0f19a77ff01ea1932ef5fd9609ef9d
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-0ef971da00dac3a46e0c86550c54d5ad
Sep  9 10:08:11 Arbeits-PC colord: Profile added:
icc-0bd9f292ce7882699e93ff844071783d
Sep  9 10:08:11 Arbeits-PC colord: Profile added: EPSON-WF-2510-Series-Gray..
Sep  9 10:08:11 Arbeits-PC colord: Profile added: EPSON-WF-2510-Series-RGB..
Sep  9 10:08:11 Arbeits-PC colord: Device added: cups-EPSON-WF-2510-Series
Sep  9 10:08:11 Arbeits-PC kernel: [    2.870368] e1000e 0000:00:19.0:
irq 51 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (eth0):
preparing device.
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (eth0):
deactivating device (reason 'managed') [2]
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> Added default
wired connection 'Kabelnetzwerkverbindung 1' for
/sys/devices/pci0000:00/0000:00:19.0/net/eth0
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0): using
nl80211 for WiFi device control
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
driver supports Access Point (AP) mode
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0): new
802.11 WiFi device (driver: 'rtl8192cu' ifindex: 3)
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
exported as /org/freedesktop/NetworkManager/Devices/1
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: unmanaged -> unavailable (reason 'managed') [10
20 2]
Sep  9 10:08:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
bringing up device.
Sep  9 10:08:11 Arbeits-PC kernel: [    2.974110] e1000e 0000:00:19.0:
irq 51 for MSI/MSI-X
Sep  9 10:08:11 Arbeits-PC kernel: [    2.974205] IPv6:
ADDRCONF(NETDEV_UP): eth0: link is not ready
Sep  9 10:08:11 Arbeits-PC kernel: [    2.974431] IPv6:
ADDRCONF(NETDEV_UP): eth0: link is not ready
Sep  9 10:08:11 Arbeits-PC kernel: [    2.977477] rtl8192cu: MAC auto ON okay!
Sep  9 10:08:11 Arbeits-PC kernel: [    3.010556] rtl8192cu: Tx queue
select: 0x05
Sep  9 10:08:12 Arbeits-PC kernel: [    3.412894] NVRM: Your system is
not currently configured to drive a VGA console
Sep  9 10:08:12 Arbeits-PC kernel: [    3.412897] NVRM: on the primary
VGA device. The NVIDIA Linux graphics driver
Sep  9 10:08:12 Arbeits-PC kernel: [    3.412898] NVRM: requires the
use of a text-mode VGA console. Use of other console
Sep  9 10:08:12 Arbeits-PC kernel: [    3.412899] NVRM: drivers
including, but not limited to, vesafb, may result in
Sep  9 10:08:12 Arbeits-PC kernel: [    3.412900] NVRM: corruption and
stability problems, and is not supported.
Sep  9 10:08:12 Arbeits-PC acpid: client connected from 1242[0:0]
Sep  9 10:08:12 Arbeits-PC acpid: 1 client rule loaded
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.Accounts' (using servicehelper)
Sep  9 10:08:12 Arbeits-PC accounts-daemon[1421]: started daemon version 0.6.29
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.Accounts'
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.ConsoleKit' (using servicehelper)
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.ConsoleKit'
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
preparing device.
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
deactivating device (reason 'managed') [2]
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Activating service
name='fi.w1.wpa_supplicant1' (using servicehelper)
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <warn>
/sys/devices/virtual/net/lo: couldn't determine device driver;
ignoring...
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <warn>
/sys/devices/virtual/net/lo: couldn't determine device driver;
ignoring...
Sep  9 10:08:12 Arbeits-PC kernel: [    3.878505] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 10:08:12 Arbeits-PC kernel: [    3.878896] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Successfully activated
service 'fi.w1.wpa_supplicant1'
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <info> wpa_supplicant started
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0)
supports 4 scan SSIDs
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <warn> Trying to
remove a non-existant call id.
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: starting -> ready
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: unavailable -> disconnected (reason
'supplicant-available') [20 30 42]
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: ready -> inactive
Sep  9 10:08:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0)
supports 4 scan SSIDs
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.UPower' (using servicehelper)
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.UPower'
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.systemd1' (using servicehelper)
Sep  9 10:08:12 Arbeits-PC anacron[1652]: Anacron 2.3 started on 2013-09-09
Sep  9 10:08:12 Arbeits-PC anacron[1652]: Normal exit (0 jobs run)
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.systemd1'
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.RealtimeKit1' (using servicehelper)
Sep  9 10:08:12 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.RealtimeKit1'
Sep  9 10:08:12 Arbeits-PC rtkit-daemon[1766]: Successfully called chroot.
Sep  9 10:08:12 Arbeits-PC rtkit-daemon[1766]: Successfully dropped privileges.
Sep  9 10:08:12 Arbeits-PC rtkit-daemon[1766]: Successfully limited resources.
Sep  9 10:08:12 Arbeits-PC rtkit-daemon[1766]: Running.
Sep  9 10:08:12 Arbeits-PC rtkit-daemon[1766]: Watchdog thread running.
Sep  9 10:08:12 Arbeits-PC rtkit-daemon[1766]: Canary thread running.
Sep  9 10:08:12 Arbeits-PC rtkit-daemon[1766]: Successfully made
thread 1753 of process 1753 (n/a) owned by '110' high priority at nice
level -11.
Sep  9 10:08:12 Arbeits-PC rtkit-daemon[1766]: Supervising 1 threads
of 1 processes of 1 users.
Sep  9 10:08:12 Arbeits-PC colord: Device added: xrandr-Samsung
Electric Company-SMS27A550H-808465713
Sep  9 10:08:12 Arbeits-PC colord: Profile added:
icc-43452068d98938efc2ed29a6d513fbc0
Sep  9 10:08:13 Arbeits-PC rtkit-daemon[1766]: Successfully made
thread 1806 of process 1753 (n/a) owned by '110' RT at priority 5.
Sep  9 10:08:13 Arbeits-PC rtkit-daemon[1766]: Supervising 2 threads
of 1 processes of 1 users.
Sep  9 10:08:13 Arbeits-PC kernel: [    4.597811] hda-intel: IRQ
timing workaround is activated for card #1. Suggest a bigger
bdl_pos_adj.
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info>
Auto-activating connection 'WG-WLAN'.
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) starting connection 'WG-WLAN'
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: disconnected -> prepare (reason 'none') [30 40 0]
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless): connection 'WG-WLAN' has security, and secrets
exist.  No new secrets needed.
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Config: added
'ssid' value 'WG-WLAN'
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Config: added
'scan_ssid' value '1'
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Config: added
'auth_alg' value 'OPEN'
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Config: added
'psk' value '<omitted>'
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Config: set
interface ap_scan to 1
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: inactive -> scanning
Sep  9 10:08:13 Arbeits-PC wpa_supplicant[1532]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:08:13 Arbeits-PC kernel: [    5.334984] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:08:13 Arbeits-PC wpa_supplicant[1532]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:08:13 Arbeits-PC kernel: [    5.359220] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:08:13 Arbeits-PC kernel: [    5.361074] wlan0: authenticated
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:08:13 Arbeits-PC kernel: [    5.362636] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:08:13 Arbeits-PC wpa_supplicant[1532]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:08:13 Arbeits-PC kernel: [    5.368845] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:08:13 Arbeits-PC kernel: [    5.368868] wlan0: associated
Sep  9 10:08:13 Arbeits-PC kernel: [    5.368884] IPv6:
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:08:13 Arbeits-PC wpa_supplicant[1532]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:08:13 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(auth) [id=0 id_str=]
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'WG-WLAN'.
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: config -> ip-config (reason 'none') [50 70 0]
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> dhclient
started with pid 1811
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Beginning IP6 addrconf.
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Sep  9 10:08:13 Arbeits-PC dhclient: Internet Systems Consortium DHCP
Client 4.2.4
Sep  9 10:08:13 Arbeits-PC dhclient: Copyright 2004-2012 Internet
Systems Consortium.
Sep  9 10:08:13 Arbeits-PC dhclient: All rights reserved.
Sep  9 10:08:13 Arbeits-PC dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Sep  9 10:08:13 Arbeits-PC dhclient:
Sep  9 10:08:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
DHCPv4 state changed nbi -> preinit
Sep  9 10:08:14 Arbeits-PC dhclient: Listening on LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:08:14 Arbeits-PC dhclient: Sending on   LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:08:14 Arbeits-PC dhclient: Sending on   Socket/fallback
Sep  9 10:08:14 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 255.255.255.255 port 67 (xid=0x64fccf93)
Sep  9 10:08:14 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 10:08:14 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 3200 seconds.
Sep  9 10:08:14 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
DHCPv4 state changed preinit -> reboot
Sep  9 10:08:14 Arbeits-PC NetworkManager[1059]: <info>   address 192.168.1.103
Sep  9 10:08:14 Arbeits-PC NetworkManager[1059]: <info>   prefix 24
(255.255.255.0)
Sep  9 10:08:14 Arbeits-PC NetworkManager[1059]: <info>   gateway 192.168.1.1
Sep  9 10:08:14 Arbeits-PC NetworkManager[1059]: <info>   nameserver
'192.168.1.1'
Sep  9 10:08:14 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Sep  9 10:08:14 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Sep  9 10:08:14 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:08:14 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv4 for mDNS.
Sep  9 10:08:14 Arbeits-PC avahi-daemon[1058]: Registering new address
record for 192.168.1.103 on wlan0.IPv4.
Sep  9 10:08:15 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: ip-config -> secondaries (reason 'none') [70 90
0]
Sep  9 10:08:15 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Sep  9 10:08:15 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: secondaries -> activated (reason 'none') [90 100
0]
Sep  9 10:08:15 Arbeits-PC NetworkManager[1059]: <info> Policy set
'WG-WLAN' (wlan0) as default for IPv4 routing and DNS.
Sep  9 10:08:15 Arbeits-PC NetworkManager[1059]: <info> DNS: starting dnsmasq...
Sep  9 10:08:15 Arbeits-PC NetworkManager[1059]: <warn> dnsmasq not
available on the bus, can't update servers.
Sep  9 10:08:15 Arbeits-PC NetworkManager[1059]: <error>
[1378714095.14280] [nm-dns-dnsmasq.c:402] update(): dnsmasq owner not
found on bus: Could not get owner of name
'org.freedesktop.NetworkManager.dnsmasq': no such name
Sep  9 10:08:15 Arbeits-PC NetworkManager[1059]: <warn> DNS: plugin
dnsmasq update failed
Sep  9 10:08:15 Arbeits-PC NetworkManager[1059]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 10:08:15 Arbeits-PC dnsmasq[1815]: Gestartet, Version 2.65
Cache deaktiviert
Sep  9 10:08:15 Arbeits-PC dnsmasq[1815]: Übersetzungsoptionen: IPv6
GNU-getopt DBus i18n IDN DHCP DHCPv6 no-Lua TFTP conntrack
Sep  9 10:08:15 Arbeits-PC dnsmasq[1815]: DBus-Unterstützung
eingeschaltet: mit Systembus verbunden
Sep  9 10:08:15 Arbeits-PC dnsmasq[1815]: Warnung: keine vorgelagerten
(Upstream) Server konfiguriert
Sep  9 10:08:15 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:08:15 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv6 for mDNS.
Sep  9 10:08:15 Arbeits-PC avahi-daemon[1058]: Registering new address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.*.
Sep  9 10:08:16 Arbeits-PC kernel: [    7.627387] hda-intel
0000:00:1b.0: azx_get_response timeout, switching to polling mode:
last cmd=0x025a0000
Sep  9 10:08:16 Arbeits-PC rtkit-daemon[1766]: Successfully made
thread 1860 of process 1753 (n/a) owned by '110' RT at priority 5.
Sep  9 10:08:16 Arbeits-PC rtkit-daemon[1766]: Supervising 3 threads
of 1 processes of 1 users.
Sep  9 10:08:16 Arbeits-PC rtkit-daemon[1766]: Successfully made
thread 1861 of process 1753 (n/a) owned by '110' RT at priority 5.
Sep  9 10:08:16 Arbeits-PC rtkit-daemon[1766]: Supervising 4 threads
of 1 processes of 1 users.
Sep  9 10:08:16 Arbeits-PC rtkit-daemon[1766]: Successfully made
thread 1863 of process 1863 (n/a) owned by '110' high priority at nice
level -11.
Sep  9 10:08:16 Arbeits-PC rtkit-daemon[1766]: Supervising 5 threads
of 2 processes of 1 users.
Sep  9 10:08:16 Arbeits-PC pulseaudio[1863]: [pulseaudio] pid.c:
Daemon already running.
Sep  9 10:08:25 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) successful, device activated.
Sep  9 10:08:25 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:08:25 Arbeits-PC NetworkManager[1059]: <warn> dnsmasq
appeared on DBus: :1.37
Sep  9 10:08:25 Arbeits-PC NetworkManager[1059]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 10:08:25 Arbeits-PC dnsmasq[1815]: vorgelagerte Server von DBus gesetzt
Sep  9 10:08:25 Arbeits-PC dnsmasq[1815]: Benutze Namensserver 192.168.1.1#53
Sep  9 10:08:25 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:08:25 Arbeits-PC colord: device removed: xrandr-Samsung
Electric Company-SMS27A550H-808465713
Sep  9 10:08:25 Arbeits-PC colord: Profile removed:
icc-43452068d98938efc2ed29a6d513fbc0
Sep  9 10:08:25 Arbeits-PC rtkit-daemon[1766]: Successfully made
thread 2075 of process 2075 (n/a) owned by '1000' high priority at
nice level -11.
Sep  9 10:08:25 Arbeits-PC rtkit-daemon[1766]: Supervising 1 threads
of 1 processes of 2 users.
Sep  9 10:08:25 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.systemd1' (using servicehelper)
Sep  9 10:08:25 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.systemd1'
Sep  9 10:08:25 Arbeits-PC colord: Device added: xrandr-Samsung
Electric Company-SMS27A550H-808465713
Sep  9 10:08:25 Arbeits-PC rtkit-daemon[1766]: Successfully made
thread 2103 of process 2075 (n/a) owned by '1000' RT at priority 5.
Sep  9 10:08:25 Arbeits-PC rtkit-daemon[1766]: Supervising 2 threads
of 1 processes of 2 users.
Sep  9 10:08:26 Arbeits-PC rtkit-daemon[1766]: Successfully made
thread 2104 of process 2075 (n/a) owned by '1000' RT at priority 5.
Sep  9 10:08:26 Arbeits-PC rtkit-daemon[1766]: Supervising 3 threads
of 1 processes of 2 users.
Sep  9 10:08:26 Arbeits-PC rtkit-daemon[1766]: Successfully made
thread 2105 of process 2075 (n/a) owned by '1000' RT at priority 5.
Sep  9 10:08:26 Arbeits-PC rtkit-daemon[1766]: Supervising 4 threads
of 1 processes of 2 users.
Sep  9 10:08:26 Arbeits-PC rtkit-daemon[1766]: Successfully made
thread 2107 of process 2107 (n/a) owned by '1000' high priority at
nice level -11.
Sep  9 10:08:26 Arbeits-PC rtkit-daemon[1766]: Supervising 5 threads
of 2 processes of 2 users.
Sep  9 10:08:26 Arbeits-PC pulseaudio[2107]: [pulseaudio] pid.c:
Daemon already running.
Sep  9 10:08:26 Arbeits-PC colord: Profile added:
icc-d78f3944822b856ad4092fc58ca09547
Sep  9 10:08:26 Arbeits-PC colord: Profile added:
icc-51d0587849c3109e19cf97296ee1f39f
Sep  9 10:08:26 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.UDisks2' (using servicehelper)
Sep  9 10:08:26 Arbeits-PC udisksd[2143]: udisks daemon version 2.1.0 starting
Sep  9 10:08:26 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.UDisks2'
Sep  9 10:08:26 Arbeits-PC udisksd[2143]: Cleaning up mount point
/media/vincent/Elements (device 8:49 is not mounted)
Sep  9 10:08:26 Arbeits-PC udisksd[2143]: Cleaning up mount point
/media/vincent/Elements1 (device 8:33 is not mounted)
Sep  9 10:08:26 Arbeits-PC udisksd[2143]: Acquired the name
org.freedesktop.UDisks2 on the system message bus
Sep  9 10:08:26 Arbeits-PC udisksd[2143]: Cleaning up mount point
/media/vincent/c08c4653-e319-4cce-8862-07874a4d20e7 (device 8:17 is
not mounted)
Sep  9 10:08:27 Arbeits-PC nm-dispatcher.action: Script
'/etc/NetworkManager/dispatcher.d/01ifupdown' took too long; killing
it.
Sep  9 10:08:28 Arbeits-PC ntfs-3g[2310]: Version 2013.1.13 external FUSE 29
Sep  9 10:08:28 Arbeits-PC ntfs-3g[2310]: Mounted /dev/sdd1
(Read-Write, label "Elements", NTFS 3.1)
Sep  9 10:08:28 Arbeits-PC ntfs-3g[2310]: Cmdline options:
rw,nosuid,nodev,uhelper=udisks2,uid=1000,gid=1000,dmask=0077,fmask=0177
Sep  9 10:08:28 Arbeits-PC ntfs-3g[2310]: Mount options:
rw,nosuid,nodev,uhelper=udisks2,allow_other,nonempty,relatime,default_permissions,fsname=/dev/sdd1,blkdev,blksize=4096
Sep  9 10:08:28 Arbeits-PC ntfs-3g[2310]: Global ownership and
permissions enforced, configuration type 7
Sep  9 10:08:28 Arbeits-PC udisksd[2143]: Mounted /dev/sdd1 at
/media/vincent/Elements on behalf of uid 1000
Sep  9 10:08:29 Arbeits-PC ntfs-3g[2313]: Version 2013.1.13 external FUSE 29
Sep  9 10:08:29 Arbeits-PC ntfs-3g[2313]: Mounted /dev/sdc1
(Read-Write, label "Elements", NTFS 3.1)
Sep  9 10:08:29 Arbeits-PC ntfs-3g[2313]: Cmdline options:
rw,nosuid,nodev,uhelper=udisks2,uid=1000,gid=1000,dmask=0077,fmask=0177
Sep  9 10:08:29 Arbeits-PC ntfs-3g[2313]: Mount options:
rw,nosuid,nodev,uhelper=udisks2,allow_other,nonempty,relatime,default_permissions,fsname=/dev/sdc1,blkdev,blksize=4096
Sep  9 10:08:29 Arbeits-PC ntfs-3g[2313]: Global ownership and
permissions enforced, configuration type 7
Sep  9 10:08:29 Arbeits-PC udisksd[2143]: Mounted /dev/sdc1 at
/media/vincent/Elements1 on behalf of uid 1000
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <info> (wlan0): IP6
addrconf timed out or failed.
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> Dispatcher
script timed out: Script '/etc/NetworkManager/dispatcher.d/01ifupdown'
timed out.
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.enable-disable-network: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.sleep-wake: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.enable-disable-wifi: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.enable-disable-wwan: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.enable-disable-wimax: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.network-control:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.settings.modify.system: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.settings.modify.own: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.settings.modify.hostname: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.29': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.enable-disable-network: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.sleep-wake: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.enable-disable-wifi: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.enable-disable-wwan: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.enable-disable-wimax: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.network-control:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.wifi.share.protected: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for org.freedesktop.NetworkManager.wifi.share.open:
(3) GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.settings.modify.system: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.settings.modify.own: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:08:35 Arbeits-PC NetworkManager[1059]: <warn> error
requesting auth for
org.freedesktop.NetworkManager.settings.modify.hostname: (3)
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner:
GDBus.Error:org.freedesktop.DBus.Error.NameHasNoOwner: Could not get
UID of name ':1.25': no such name
Sep  9 10:09:11 Arbeits-PC kernel: [   62.535345] EXT4-fs (sdb1):
mounted filesystem with ordered data mode. Opts: (null)
Sep  9 10:09:11 Arbeits-PC udisksd[2143]: Mounted /dev/sdb1 at
/media/vincent/c08c4653-e319-4cce-8862-07874a4d20e7 on behalf of uid
1000
Sep  9 10:09:11 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.hostname1' (using servicehelper)
Sep  9 10:09:11 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.hostname1'
Sep  9 10:10:48 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: activated -> disconnected (reason
'user-requested') [100 30 39]
Sep  9 10:10:48 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
deactivating device (reason 'user-requested') [39]
Sep  9 10:10:49 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
canceled DHCP transaction, DHCP client pid 1811
Sep  9 10:10:49 Arbeits-PC avahi-daemon[1058]: Withdrawing address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.
Sep  9 10:10:49 Arbeits-PC avahi-daemon[1058]: Leaving mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:10:49 Arbeits-PC avahi-daemon[1058]: Interface wlan0.IPv6 no
longer relevant for mDNS.
Sep  9 10:10:49 Arbeits-PC kernel: [  160.375042] wlan0:
deauthenticating from a0:f3:c1:05:80:ec by local choice (reason=3)
Sep  9 10:10:49 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
Sep  9 10:10:49 Arbeits-PC avahi-daemon[1058]: Withdrawing address
record for 192.168.1.103 on wlan0.
Sep  9 10:10:49 Arbeits-PC avahi-daemon[1058]: Leaving mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:10:49 Arbeits-PC avahi-daemon[1058]: Interface wlan0.IPv4 no
longer relevant for mDNS.
Sep  9 10:10:49 Arbeits-PC NetworkManager[1059]: <warn> DNS: plugin
dnsmasq update failed
Sep  9 10:10:49 Arbeits-PC NetworkManager[1059]: <info> Removing DNS
information from /sbin/resolvconf
Sep  9 10:10:49 Arbeits-PC dnsmasq[1815]: vorgelagerte Server von DBus gesetzt
Sep  9 10:10:49 Arbeits-PC kernel: [  160.405037] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:10:49 Arbeits-PC kernel: [  160.409571] cfg80211: World
regulatory domain updated:
Sep  9 10:10:49 Arbeits-PC kernel: [  160.409575] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:10:49 Arbeits-PC kernel: [  160.409578] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:10:49 Arbeits-PC kernel: [  160.409581] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:10:49 Arbeits-PC kernel: [  160.409583] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:10:49 Arbeits-PC kernel: [  160.409585] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:10:49 Arbeits-PC kernel: [  160.409587] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:10:49 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:10:49 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:10:49 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:10:50 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:10:50 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv6 for mDNS.
Sep  9 10:10:50 Arbeits-PC avahi-daemon[1058]: Registering new address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.*.
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) starting connection 'WG-WLAN'
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: disconnected -> prepare (reason 'none') [30 40 0]
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless): access point 'WG-WLAN' has security, but secrets are
required.
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: config -> need-auth (reason 'none') [50 60 0]
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: need-auth -> prepare (reason 'none') [60 40 0]
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless): connection 'WG-WLAN' has security, and secrets
exist.  No new secrets needed.
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Config: added
'ssid' value 'WG-WLAN'
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Config: added
'scan_ssid' value '1'
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Config: added
'auth_alg' value 'OPEN'
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Config: added
'psk' value '<omitted>'
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> Config: set
interface ap_scan to 1
Sep  9 10:10:58 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:10:59 Arbeits-PC wpa_supplicant[1532]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:10:59 Arbeits-PC kernel: [  170.850005] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:10:59 Arbeits-PC kernel: [  170.874556] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:10:59 Arbeits-PC wpa_supplicant[1532]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:10:59 Arbeits-PC kernel: [  170.881290] wlan0: authenticated
Sep  9 10:10:59 Arbeits-PC kernel: [  170.881624] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:10:59 Arbeits-PC wpa_supplicant[1532]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:10:59 Arbeits-PC kernel: [  170.888789] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:10:59 Arbeits-PC kernel: [  170.888831] wlan0: associated
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:10:59 Arbeits-PC wpa_supplicant[1532]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:10:59 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'WG-WLAN'.
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: config -> ip-config (reason 'none') [50 70 0]
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> dhclient
started with pid 3468
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Beginning IP6 addrconf.
Sep  9 10:10:59 Arbeits-PC avahi-daemon[1058]: Withdrawing address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.
Sep  9 10:10:59 Arbeits-PC avahi-daemon[1058]: Leaving mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:10:59 Arbeits-PC avahi-daemon[1058]: Interface wlan0.IPv6 no
longer relevant for mDNS.
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Sep  9 10:10:59 Arbeits-PC dhclient: Internet Systems Consortium DHCP
Client 4.2.4
Sep  9 10:10:59 Arbeits-PC dhclient: Copyright 2004-2012 Internet
Systems Consortium.
Sep  9 10:10:59 Arbeits-PC dhclient: All rights reserved.
Sep  9 10:10:59 Arbeits-PC dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Sep  9 10:10:59 Arbeits-PC dhclient:
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
DHCPv4 state changed nbi -> preinit
Sep  9 10:10:59 Arbeits-PC dhclient: Listening on LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:10:59 Arbeits-PC dhclient: Sending on   LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:10:59 Arbeits-PC dhclient: Sending on   Socket/fallback
Sep  9 10:10:59 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 255.255.255.255 port 67 (xid=0xf17b752)
Sep  9 10:10:59 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 10:10:59 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 3504 seconds.
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
DHCPv4 state changed preinit -> reboot
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info>   address 192.168.1.103
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info>   prefix 24
(255.255.255.0)
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info>   gateway 192.168.1.1
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info>   nameserver
'192.168.1.1'
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Sep  9 10:10:59 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Sep  9 10:10:59 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:10:59 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv4 for mDNS.
Sep  9 10:10:59 Arbeits-PC avahi-daemon[1058]: Registering new address
record for 192.168.1.103 on wlan0.IPv4.
Sep  9 10:11:00 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: ip-config -> secondaries (reason 'none') [70 90
0]
Sep  9 10:11:00 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Sep  9 10:11:00 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: secondaries -> activated (reason 'none') [90 100
0]
Sep  9 10:11:00 Arbeits-PC NetworkManager[1059]: <info> Policy set
'WG-WLAN' (wlan0) as default for IPv4 routing and DNS.
Sep  9 10:11:00 Arbeits-PC NetworkManager[1059]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 10:11:00 Arbeits-PC dnsmasq[1815]: vorgelagerte Server von DBus gesetzt
Sep  9 10:11:00 Arbeits-PC dnsmasq[1815]: Benutze Namensserver 192.168.1.1#53
Sep  9 10:11:01 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:11:01 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv6 for mDNS.
Sep  9 10:11:01 Arbeits-PC avahi-daemon[1058]: Registering new address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.*.
Sep  9 10:11:10 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) successful, device activated.
Sep  9 10:11:10 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:11:10 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:11:13 Arbeits-PC nm-dispatcher.action: Script
'/etc/NetworkManager/dispatcher.d/01ifupdown' took too long; killing
it.
Sep  9 10:11:13 Arbeits-PC NetworkManager[1059]: <warn> Dispatcher
script timed out: Script '/etc/NetworkManager/dispatcher.d/01ifupdown'
timed out.
Sep  9 10:11:19 Arbeits-PC NetworkManager[1059]: <info> (wlan0): IP6
addrconf timed out or failed.
Sep  9 10:11:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Sep  9 10:11:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Sep  9 10:11:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Sep  9 10:11:29 Arbeits-PC kernel: [  200.923224] hda-intel
0000:00:1b.0: Unstable LPIB (8108 >= 4056); disabling LPIB delay
counting
Sep  9 10:11:37 Arbeits-PC pulseaudio[2075]: [alsa-sink] alsa-sink.c:
ALSA weckte uns auf, um neue Daten auf das Gerät zu schreiben, doch es
gab nichts zum Schreiben!
Sep  9 10:11:37 Arbeits-PC pulseaudio[2075]: [alsa-sink] alsa-sink.c:
Dies ist höchstwahrscheinlich ein Fehler im ALSA-Treiber
'snd_hda_intel'. Bitte melden Sie diesen Fehler den ALSA-Entwicklern.
Sep  9 10:11:37 Arbeits-PC pulseaudio[2075]: [alsa-sink] alsa-sink.c:
Wir wurden durch das POLLOUT-Set geweckt, allerdings lieferte ein
anschliessender snd_pcm_avail() den Wert 0 oder einen anderen Wert <
min_avail.
Sep  9 10:15:21 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.hostname1' (using servicehelper)
Sep  9 10:15:21 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.hostname1'
Sep  9 10:17:01 Arbeits-PC CRON[4107]: (root) CMD (   cd / &&
run-parts --report /etc/cron.hourly)
Sep  9 10:24:58 Arbeits-PC kernel: [ 1008.769835] usbcore:
deregistering interface driver rtl8192cu
Sep  9 10:24:58 Arbeits-PC kernel: [ 1008.770157] wlan0:
deauthenticating from a0:f3:c1:05:80:ec by local choice (reason=3)
Sep  9 10:24:58 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=3
Sep  9 10:24:58 Arbeits-PC kernel: [ 1008.789752] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:24:58 Arbeits-PC avahi-daemon[1058]: Interface wlan0.IPv6 no
longer relevant for mDNS.
Sep  9 10:24:58 Arbeits-PC avahi-daemon[1058]: Leaving mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:24:58 Arbeits-PC avahi-daemon[1058]: Interface wlan0.IPv4 no
longer relevant for mDNS.
Sep  9 10:24:58 Arbeits-PC avahi-daemon[1058]: Leaving mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:24:58 Arbeits-PC dhclient: receive_packet failed on wlan0:
Network is down
Sep  9 10:24:58 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
roamed from BSSID A0:F3:C1:05:80:EC (WG-WLAN) to (none) ((none))
Sep  9 10:24:58 Arbeits-PC avahi-daemon[1058]: Withdrawing address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.
Sep  9 10:24:58 Arbeits-PC avahi-daemon[1058]: Withdrawing address
record for 192.168.1.103 on wlan0.
Sep  9 10:24:58 Arbeits-PC avahi-daemon[1058]: Withdrawing workstation
service for wlan0.
Sep  9 10:24:58 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
devices removed (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0)
Sep  9 10:24:58 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: activated -> unmanaged (reason 'removed') [100 10
36]
Sep  9 10:24:58 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
deactivating device (reason 'removed') [36]
Sep  9 10:24:58 Arbeits-PC kernel: [ 1008.814888] cfg80211: World
regulatory domain updated:
Sep  9 10:24:58 Arbeits-PC kernel: [ 1008.814892] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:24:58 Arbeits-PC kernel: [ 1008.814895] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:24:58 Arbeits-PC kernel: [ 1008.814898] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:24:58 Arbeits-PC kernel: [ 1008.814900] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:24:58 Arbeits-PC kernel: [ 1008.814902] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:24:58 Arbeits-PC kernel: [ 1008.814904] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
canceled DHCP transaction, DHCP client pid 3468
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <warn> sysctl: failed
to open '/proc/sys/net/ipv6/conf/wlan0/accept_ra': (2) Datei oder
Verzeichnis nicht gefunden
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <warn> sysctl: failed
to open '/proc/sys/net/ipv6/conf/wlan0/use_tempaddr': (2) Datei oder
Verzeichnis nicht gefunden
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <warn> (3) failed to
find interface name for index
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]:
(nm-system.c:766):nm_system_iface_get_flags: runtime check failed:
(iface != NULL)
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <error>
[1378715099.55263] [nm-system.c:768] nm_system_iface_get_flags():
(unknown): failed to get interface link object
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <warn> (3) failed to
find interface name for index
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]:
(nm-system.c:766):nm_system_iface_get_flags: runtime check failed:
(iface != NULL)
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <error>
[1378715099.55361] [nm-system.c:768] nm_system_iface_get_flags():
(unknown): failed to get interface link object
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
bringing up device.
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <warn> (3) failed to
find interface name for index
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]:
nm_system_iface_flush_routes: assertion `iface != NULL' failed
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <warn> (3) failed to
find interface name for index
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <warn> DNS: plugin
dnsmasq update failed
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <info> Removing DNS
information from /sbin/resolvconf
Sep  9 10:24:59 Arbeits-PC dnsmasq[1815]: vorgelagerte Server von DBus gesetzt
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <info> (wlan0): cleaning up...
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <warn> (3) failed to
find interface name for index
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]:
(nm-system.c:766):nm_system_iface_get_flags: runtime check failed:
(iface != NULL)
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <error>
[1378715099.85966] [nm-system.c:768] nm_system_iface_get_flags():
(unknown): failed to get interface link object
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <info> Unmanaged
Device found; state CONNECTED forced. (see
http://bugs.launchpad.net/bugs/191889)
Sep  9 10:24:59 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:24:59 Arbeits-PC NetworkManager[1059]: <info> radio
killswitch /sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/ieee80211/phy0/rfkill0
disappeared
Sep  9 10:24:59 Arbeits-PC wpa_supplicant[1532]: Could not read
interface wlan0 flags: No such device
Sep  9 10:24:59 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:25:04 Arbeits-PC kernel: [ 1014.890058] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:25:04 Arbeits-PC kernel: [ 1014.896014] cfg80211: World
regulatory domain updated:
Sep  9 10:25:04 Arbeits-PC kernel: [ 1014.896018] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:25:04 Arbeits-PC kernel: [ 1014.896021] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:04 Arbeits-PC kernel: [ 1014.896023] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:04 Arbeits-PC kernel: [ 1014.896026] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:04 Arbeits-PC kernel: [ 1014.896028] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:04 Arbeits-PC kernel: [ 1014.896030] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:04 Arbeits-PC kernel: [ 1014.910149] rtl8192cu: Chip version 0x11
Sep  9 10:25:05 Arbeits-PC kernel: [ 1014.987287] rtl8192cu: MAC
address: f8:1a:67:19:16:94
Sep  9 10:25:05 Arbeits-PC kernel: [ 1014.987292] rtl8192cu: Board Type 0
Sep  9 10:25:05 Arbeits-PC kernel: [ 1014.987534] rtlwifi: rx_max_size
15360, rx_urb_num 8, in_ep 1
Sep  9 10:25:05 Arbeits-PC kernel: [ 1014.987565] rtl8192cu: Loading
firmware rtlwifi/rtl8192cufw.bin
Sep  9 10:25:05 Arbeits-PC kernel: [ 1014.987735] ieee80211 phy0:
Selected rate control algorithm 'rtl_rc'
Sep  9 10:25:05 Arbeits-PC kernel: [ 1014.988131] usbcore: registered
new interface driver rtl8192cu
Sep  9 10:25:05 Arbeits-PC kernel: [ 1014.988183] rtlwifi: wireless switch is on
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> rfkill1: found
WiFi radio killswitch (at
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/ieee80211/phy0/rfkill1)
(driver rtl8192cu)
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
devices added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0)
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
device added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0): no ifupdown configuration found.
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0): using
nl80211 for WiFi device control
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
driver supports Access Point (AP) mode
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0): new
802.11 WiFi device (driver: 'rtl8192cu' ifindex: 4)
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
exported as /org/freedesktop/NetworkManager/Devices/2
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: unmanaged -> unavailable (reason 'managed') [10
20 2]
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
bringing up device.
Sep  9 10:25:05 Arbeits-PC kernel: [ 1014.996398] rtl8192cu: MAC auto ON okay!
Sep  9 10:25:05 Arbeits-PC kernel: [ 1015.029353] rtl8192cu: Tx queue
select: 0x05
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
preparing device.
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
deactivating device (reason 'managed') [2]
Sep  9 10:25:05 Arbeits-PC kernel: [ 1015.394893] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 10:25:05 Arbeits-PC kernel: [ 1015.395221] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0)
supports 4 scan SSIDs
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <warn> Trying to
remove a non-existant call id.
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: starting -> ready
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: unavailable -> disconnected (reason
'supplicant-available') [20 30 42]
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: ready -> inactive
Sep  9 10:25:05 Arbeits-PC NetworkManager[1059]: <info> (wlan0)
supports 4 scan SSIDs
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info>
Auto-activating connection 'WG-WLAN'.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) starting connection 'WG-WLAN'
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: disconnected -> prepare (reason 'none') [30 40 0]
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless): access point 'WG-WLAN' has security, but secrets are
required.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: config -> need-auth (reason 'none') [50 60 0]
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: need-auth -> prepare (reason 'none') [60 40 0]
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless): connection 'WG-WLAN' has security, and secrets
exist.  No new secrets needed.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Config: added
'ssid' value 'WG-WLAN'
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Config: added
'scan_ssid' value '1'
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Config: added
'auth_alg' value 'OPEN'
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Config: added
'psk' value '<omitted>'
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Config: set
interface ap_scan to 1
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: inactive -> scanning
Sep  9 10:25:06 Arbeits-PC wpa_supplicant[1532]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:25:06 Arbeits-PC kernel: [ 1016.854651] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:25:06 Arbeits-PC wpa_supplicant[1532]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:25:06 Arbeits-PC kernel: [ 1016.878735] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:25:06 Arbeits-PC kernel: [ 1016.881081] wlan0: authenticated
Sep  9 10:25:06 Arbeits-PC kernel: [ 1016.882176] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:25:06 Arbeits-PC wpa_supplicant[1532]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:25:06 Arbeits-PC kernel: [ 1016.900970] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:25:06 Arbeits-PC kernel: [ 1016.901016] wlan0: associated
Sep  9 10:25:06 Arbeits-PC kernel: [ 1016.901035] IPv6:
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:25:06 Arbeits-PC wpa_supplicant[1532]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:25:06 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(auth) [id=0 id_str=]
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'WG-WLAN'.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: config -> ip-config (reason 'none') [50 70 0]
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> dhclient
started with pid 4338
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Beginning IP6 addrconf.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Sep  9 10:25:06 Arbeits-PC dhclient: Internet Systems Consortium DHCP
Client 4.2.4
Sep  9 10:25:06 Arbeits-PC dhclient: Copyright 2004-2012 Internet
Systems Consortium.
Sep  9 10:25:06 Arbeits-PC dhclient: All rights reserved.
Sep  9 10:25:06 Arbeits-PC dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Sep  9 10:25:06 Arbeits-PC dhclient:
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
DHCPv4 state changed nbi -> preinit
Sep  9 10:25:06 Arbeits-PC dhclient: Listening on LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:25:06 Arbeits-PC dhclient: Sending on   LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:25:06 Arbeits-PC dhclient: Sending on   Socket/fallback
Sep  9 10:25:06 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 255.255.255.255 port 67 (xid=0x79fceecf)
Sep  9 10:25:06 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 10:25:06 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 3027 seconds.
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
DHCPv4 state changed preinit -> reboot
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info>   address 192.168.1.103
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info>   prefix 24
(255.255.255.0)
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info>   gateway 192.168.1.1
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info>   nameserver
'192.168.1.1'
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Sep  9 10:25:06 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Sep  9 10:25:06 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:25:06 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv4 for mDNS.
Sep  9 10:25:06 Arbeits-PC avahi-daemon[1058]: Registering new address
record for 192.168.1.103 on wlan0.IPv4.
Sep  9 10:25:07 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: ip-config -> secondaries (reason 'none') [70 90
0]
Sep  9 10:25:07 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Sep  9 10:25:07 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: secondaries -> activated (reason 'none') [90 100
0]
Sep  9 10:25:07 Arbeits-PC NetworkManager[1059]: <info> Policy set
'WG-WLAN' (wlan0) as default for IPv4 routing and DNS.
Sep  9 10:25:07 Arbeits-PC NetworkManager[1059]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 10:25:07 Arbeits-PC dnsmasq[1815]: vorgelagerte Server von DBus gesetzt
Sep  9 10:25:07 Arbeits-PC dnsmasq[1815]: Benutze Namensserver 192.168.1.1#53
Sep  9 10:25:08 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:25:08 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv6 for mDNS.
Sep  9 10:25:08 Arbeits-PC avahi-daemon[1058]: Registering new address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.*.
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) successful, device activated.
Sep  9 10:25:18 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:25:18 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
disconnecting for new activation request.
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: activated -> disconnected (reason 'none') [100 30
0]
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
deactivating device (reason 'none') [0]
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
canceled DHCP transaction, DHCP client pid 4338
Sep  9 10:25:18 Arbeits-PC avahi-daemon[1058]: Withdrawing address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.
Sep  9 10:25:18 Arbeits-PC avahi-daemon[1058]: Leaving mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:25:18 Arbeits-PC avahi-daemon[1058]: Interface wlan0.IPv6 no
longer relevant for mDNS.
Sep  9 10:25:18 Arbeits-PC kernel: [ 1028.196153] wlan0:
deauthenticating from a0:f3:c1:05:80:ec by local choice (reason=3)
Sep  9 10:25:18 Arbeits-PC avahi-daemon[1058]: Withdrawing address
record for 192.168.1.103 on wlan0.
Sep  9 10:25:18 Arbeits-PC avahi-daemon[1058]: Leaving mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:25:18 Arbeits-PC avahi-daemon[1058]: Interface wlan0.IPv4 no
longer relevant for mDNS.
Sep  9 10:25:18 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <warn> DNS: plugin
dnsmasq update failed
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Removing DNS
information from /sbin/resolvconf
Sep  9 10:25:18 Arbeits-PC dnsmasq[1815]: vorgelagerte Server von DBus gesetzt
Sep  9 10:25:18 Arbeits-PC kernel: [ 1028.210396] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:25:18 Arbeits-PC kernel: [ 1028.214818] cfg80211: World
regulatory domain updated:
Sep  9 10:25:18 Arbeits-PC kernel: [ 1028.214822] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:25:18 Arbeits-PC kernel: [ 1028.214825] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:18 Arbeits-PC kernel: [ 1028.214828] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:18 Arbeits-PC kernel: [ 1028.214830] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:18 Arbeits-PC kernel: [ 1028.214832] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:18 Arbeits-PC kernel: [ 1028.214834] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) starting connection 'WG-WLAN'
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: disconnected -> prepare (reason 'none') [30 40 0]
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless): access point 'WG-WLAN' has security, but secrets are
required.
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: config -> need-auth (reason 'none') [50 60 0]
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: need-auth -> prepare (reason 'none') [60 40 0]
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless): connection 'WG-WLAN' has security, and secrets
exist.  No new secrets needed.
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Config: added
'ssid' value 'WG-WLAN'
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Config: added
'scan_ssid' value '1'
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Config: added
'auth_alg' value 'OPEN'
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Config: added
'psk' value '<omitted>'
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:25:18 Arbeits-PC NetworkManager[1059]: <info> Config: set
interface ap_scan to 1
Sep  9 10:25:18 Arbeits-PC wpa_supplicant[1532]: wlan0: Failed to
initiate AP scan
Sep  9 10:25:19 Arbeits-PC wpa_supplicant[1532]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:25:19 Arbeits-PC kernel: [ 1028.945388] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: disconnected -> authenticating
Sep  9 10:25:19 Arbeits-PC kernel: [ 1028.969342] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:25:19 Arbeits-PC kernel: [ 1029.172540] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:25:19 Arbeits-PC kernel: [ 1029.376261] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:25:19 Arbeits-PC wpa_supplicant[1532]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:25:19 Arbeits-PC kernel: [ 1029.389488] wlan0: authenticated
Sep  9 10:25:19 Arbeits-PC kernel: [ 1029.392248] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:25:19 Arbeits-PC wpa_supplicant[1532]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:25:19 Arbeits-PC kernel: [ 1029.421329] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:25:19 Arbeits-PC kernel: [ 1029.421375] wlan0: associated
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:25:19 Arbeits-PC wpa_supplicant[1532]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:25:19 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'WG-WLAN'.
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: config -> ip-config (reason 'none') [50 70 0]
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> dhclient
started with pid 4442
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Beginning IP6 addrconf.
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Sep  9 10:25:19 Arbeits-PC dhclient: Internet Systems Consortium DHCP
Client 4.2.4
Sep  9 10:25:19 Arbeits-PC dhclient: Copyright 2004-2012 Internet
Systems Consortium.
Sep  9 10:25:19 Arbeits-PC dhclient: All rights reserved.
Sep  9 10:25:19 Arbeits-PC dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Sep  9 10:25:19 Arbeits-PC dhclient:
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
DHCPv4 state changed nbi -> preinit
Sep  9 10:25:19 Arbeits-PC dhclient: Listening on LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:25:19 Arbeits-PC dhclient: Sending on   LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:25:19 Arbeits-PC dhclient: Sending on   Socket/fallback
Sep  9 10:25:19 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 255.255.255.255 port 67 (xid=0x30a2ea80)
Sep  9 10:25:19 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 10:25:19 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 3571 seconds.
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
DHCPv4 state changed preinit -> reboot
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info>   address 192.168.1.103
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info>   prefix 24
(255.255.255.0)
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info>   gateway 192.168.1.1
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info>   nameserver
'192.168.1.1'
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Sep  9 10:25:19 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Sep  9 10:25:19 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:25:19 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv4 for mDNS.
Sep  9 10:25:19 Arbeits-PC avahi-daemon[1058]: Registering new address
record for 192.168.1.103 on wlan0.IPv4.
Sep  9 10:25:20 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: ip-config -> secondaries (reason 'none') [70 90
0]
Sep  9 10:25:20 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Sep  9 10:25:20 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: secondaries -> activated (reason 'none') [90 100
0]
Sep  9 10:25:20 Arbeits-PC NetworkManager[1059]: <info> Policy set
'WG-WLAN' (wlan0) as default for IPv4 routing and DNS.
Sep  9 10:25:20 Arbeits-PC NetworkManager[1059]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 10:25:20 Arbeits-PC dnsmasq[1815]: vorgelagerte Server von DBus gesetzt
Sep  9 10:25:20 Arbeits-PC dnsmasq[1815]: Benutze Namensserver 192.168.1.1#53
Sep  9 10:25:20 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) successful, device activated.
Sep  9 10:25:21 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:25:21 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv6 for mDNS.
Sep  9 10:25:21 Arbeits-PC avahi-daemon[1058]: Registering new address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.*.
Sep  9 10:25:21 Arbeits-PC nm-dispatcher.action: Script
'/etc/NetworkManager/dispatcher.d/01ifupdown' took too long; killing
it.
Sep  9 10:25:21 Arbeits-PC NetworkManager[1059]: <warn> Dispatcher
script timed out: Script '/etc/NetworkManager/dispatcher.d/01ifupdown'
timed out.
Sep  9 10:25:27 Arbeits-PC ntpdate[4521]: adjust time server
91.189.94.4 offset -0.323524 sec
Sep  9 10:25:39 Arbeits-PC NetworkManager[1059]: <info> (wlan0): IP6
addrconf timed out or failed.
Sep  9 10:25:39 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Sep  9 10:25:39 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Sep  9 10:25:39 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Sep  9 10:25:53 Arbeits-PC kernel: [ 1063.580218] usbcore:
deregistering interface driver rtl8192cu
Sep  9 10:25:53 Arbeits-PC kernel: [ 1063.580551] wlan0:
deauthenticating from a0:f3:c1:05:80:ec by local choice (reason=3)
Sep  9 10:25:53 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=3
Sep  9 10:25:53 Arbeits-PC kernel: [ 1063.600188] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:25:53 Arbeits-PC avahi-daemon[1058]: Interface wlan0.IPv6 no
longer relevant for mDNS.
Sep  9 10:25:53 Arbeits-PC avahi-daemon[1058]: Leaving mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:25:53 Arbeits-PC avahi-daemon[1058]: Interface wlan0.IPv4 no
longer relevant for mDNS.
Sep  9 10:25:53 Arbeits-PC avahi-daemon[1058]: Leaving mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:25:53 Arbeits-PC dhclient: receive_packet failed on wlan0:
Network is down
Sep  9 10:25:53 Arbeits-PC avahi-daemon[1058]: Withdrawing address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.
Sep  9 10:25:53 Arbeits-PC avahi-daemon[1058]: Withdrawing address
record for 192.168.1.103 on wlan0.
Sep  9 10:25:53 Arbeits-PC avahi-daemon[1058]: Withdrawing workstation
service for wlan0.
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
devices removed (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0)
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: activated -> unmanaged (reason 'removed') [100 10
36]
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
deactivating device (reason 'removed') [36]
Sep  9 10:25:53 Arbeits-PC kernel: [ 1063.628942] cfg80211: World
regulatory domain updated:
Sep  9 10:25:53 Arbeits-PC kernel: [ 1063.628947] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:25:53 Arbeits-PC kernel: [ 1063.628950] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:53 Arbeits-PC kernel: [ 1063.628952] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:53 Arbeits-PC kernel: [ 1063.628955] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:53 Arbeits-PC kernel: [ 1063.628957] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:53 Arbeits-PC kernel: [ 1063.628959] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
canceled DHCP transaction, DHCP client pid 4442
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <warn> sysctl: failed
to open '/proc/sys/net/ipv6/conf/wlan0/accept_ra': (2) Datei oder
Verzeichnis nicht gefunden
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <warn> sysctl: failed
to open '/proc/sys/net/ipv6/conf/wlan0/use_tempaddr': (2) Datei oder
Verzeichnis nicht gefunden
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <warn> (4) failed to
find interface name for index
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]:
(nm-system.c:766):nm_system_iface_get_flags: runtime check failed:
(iface != NULL)
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <error>
[1378715153.935285] [nm-system.c:768] nm_system_iface_get_flags():
(unknown): failed to get interface link object
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <warn> (4) failed to
find interface name for index
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]:
(nm-system.c:766):nm_system_iface_get_flags: runtime check failed:
(iface != NULL)
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <error>
[1378715153.935382] [nm-system.c:768] nm_system_iface_get_flags():
(unknown): failed to get interface link object
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
bringing up device.
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <warn> (4) failed to
find interface name for index
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]:
nm_system_iface_flush_routes: assertion `iface != NULL' failed
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <warn> (4) failed to
find interface name for index
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <warn> DNS: plugin
dnsmasq update failed
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <info> Removing DNS
information from /sbin/resolvconf
Sep  9 10:25:53 Arbeits-PC dnsmasq[1815]: vorgelagerte Server von DBus gesetzt
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <info> (wlan0): cleaning up...
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <warn> (4) failed to
find interface name for index
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]:
(nm-system.c:766):nm_system_iface_get_flags: runtime check failed:
(iface != NULL)
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <error>
[1378715153.965461] [nm-system.c:768] nm_system_iface_get_flags():
(unknown): failed to get interface link object
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <info> Unmanaged
Device found; state CONNECTED forced. (see
http://bugs.launchpad.net/bugs/191889)
Sep  9 10:25:53 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:25:53 Arbeits-PC NetworkManager[1059]: <info> radio
killswitch /sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/ieee80211/phy0/rfkill1
disappeared
Sep  9 10:25:53 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:25:53 Arbeits-PC wpa_supplicant[1532]: Could not read
interface wlan0 flags: No such device
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.175664] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.187015] cfg80211: World
regulatory domain updated:
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.187018] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.187020] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.187021] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.187022] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.187023] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.187025] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.194264] rtl8192cu: Chip version 0x11
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.271417] rtl8192cu: MAC
address: f8:1a:67:19:16:94
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.271428] rtl8192cu: Board Type 0
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> rfkill2: found
WiFi radio killswitch (at
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/ieee80211/phy0/rfkill2)
(driver rtl8192cu)
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.271698] rtlwifi: rx_max_size
15360, rx_urb_num 8, in_ep 1
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.271730] rtl8192cu: Loading
firmware rtlwifi/rtl8192cufw.bin
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.271929] ieee80211 phy0:
Selected rate control algorithm 'rtl_rc'
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.272406] rtlwifi: wireless switch is on
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.272420] usbcore: registered
new interface driver rtl8192cu
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
devices added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0)
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]:    SCPlugin-Ifupdown:
device added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0): no ifupdown configuration found.
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0): using
nl80211 for WiFi device control
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
driver supports Access Point (AP) mode
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0): new
802.11 WiFi device (driver: 'rtl8192cu' ifindex: 5)
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
exported as /org/freedesktop/NetworkManager/Devices/3
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: unmanaged -> unavailable (reason 'managed') [10
20 2]
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
bringing up device.
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.280510] rtl8192cu: MAC auto ON okay!
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.313342] rtl8192cu: Tx queue
select: 0x05
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
preparing device.
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
deactivating device (reason 'managed') [2]
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.679795] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 10:26:11 Arbeits-PC kernel: [ 1081.680116] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0)
supports 4 scan SSIDs
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <warn> Trying to
remove a non-existant call id.
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: starting -> ready
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: unavailable -> disconnected (reason
'supplicant-available') [20 30 42]
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: ready -> inactive
Sep  9 10:26:11 Arbeits-PC NetworkManager[1059]: <info> (wlan0)
supports 4 scan SSIDs
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info>
Auto-activating connection 'WG-WLAN'.
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) starting connection 'WG-WLAN'
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: disconnected -> prepare (reason 'none') [30 40 0]
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless): access point 'WG-WLAN' has security, but secrets are
required.
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: config -> need-auth (reason 'none') [50 60 0]
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: need-auth -> prepare (reason 'none') [60 40 0]
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless): connection 'WG-WLAN' has security, and secrets
exist.  No new secrets needed.
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Config: added
'ssid' value 'WG-WLAN'
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Config: added
'scan_ssid' value '1'
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Config: added
'auth_alg' value 'OPEN'
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Config: added
'psk' value '<omitted>'
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> Config: set
interface ap_scan to 1
Sep  9 10:26:12 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: inactive -> scanning
Sep  9 10:26:13 Arbeits-PC wpa_supplicant[1532]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:26:13 Arbeits-PC kernel: [ 1083.138419] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:26:13 Arbeits-PC kernel: [ 1083.162483] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:26:13 Arbeits-PC wpa_supplicant[1532]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:26:13 Arbeits-PC kernel: [ 1083.174222] wlan0: authenticated
Sep  9 10:26:13 Arbeits-PC kernel: [ 1083.177900] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:26:13 Arbeits-PC wpa_supplicant[1532]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:26:13 Arbeits-PC kernel: [ 1083.191445] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:26:13 Arbeits-PC kernel: [ 1083.191492] wlan0: associated
Sep  9 10:26:13 Arbeits-PC kernel: [ 1083.191529] IPv6:
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:26:13 Arbeits-PC wpa_supplicant[1532]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:26:13 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(auth) [id=0 id_str=]
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'WG-WLAN'.
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: config -> ip-config (reason 'none') [50 70 0]
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> dhclient
started with pid 4675
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Beginning IP6 addrconf.
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Sep  9 10:26:13 Arbeits-PC dhclient: Internet Systems Consortium DHCP
Client 4.2.4
Sep  9 10:26:13 Arbeits-PC dhclient: Copyright 2004-2012 Internet
Systems Consortium.
Sep  9 10:26:13 Arbeits-PC dhclient: All rights reserved.
Sep  9 10:26:13 Arbeits-PC dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Sep  9 10:26:13 Arbeits-PC dhclient:
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
DHCPv4 state changed nbi -> preinit
Sep  9 10:26:13 Arbeits-PC dhclient: Listening on LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:26:13 Arbeits-PC dhclient: Sending on   LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:26:13 Arbeits-PC dhclient: Sending on   Socket/fallback
Sep  9 10:26:13 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 255.255.255.255 port 67 (xid=0x5e552ed4)
Sep  9 10:26:13 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 10:26:13 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 3325 seconds.
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
DHCPv4 state changed preinit -> reboot
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info>   address 192.168.1.103
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info>   prefix 24
(255.255.255.0)
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info>   gateway 192.168.1.1
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info>   nameserver
'192.168.1.1'
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Sep  9 10:26:13 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Sep  9 10:26:13 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:26:13 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv4 for mDNS.
Sep  9 10:26:13 Arbeits-PC avahi-daemon[1058]: Registering new address
record for 192.168.1.103 on wlan0.IPv4.
Sep  9 10:26:14 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: ip-config -> secondaries (reason 'none') [70 90
0]
Sep  9 10:26:14 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Sep  9 10:26:14 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
device state change: secondaries -> activated (reason 'none') [90 100
0]
Sep  9 10:26:14 Arbeits-PC NetworkManager[1059]: <info> Policy set
'WG-WLAN' (wlan0) as default for IPv4 routing and DNS.
Sep  9 10:26:14 Arbeits-PC NetworkManager[1059]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 10:26:14 Arbeits-PC dnsmasq[1815]: vorgelagerte Server von DBus gesetzt
Sep  9 10:26:14 Arbeits-PC dnsmasq[1815]: Benutze Namensserver 192.168.1.1#53
Sep  9 10:26:15 Arbeits-PC avahi-daemon[1058]: Joining mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:26:15 Arbeits-PC avahi-daemon[1058]: New relevant interface
wlan0.IPv6 for mDNS.
Sep  9 10:26:15 Arbeits-PC avahi-daemon[1058]: Registering new address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.*.
Sep  9 10:26:24 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) successful, device activated.
Sep  9 10:26:24 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:26:24 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:26:27 Arbeits-PC nm-dispatcher.action: Script
'/etc/NetworkManager/dispatcher.d/01ifupdown' took too long; killing
it.
Sep  9 10:26:27 Arbeits-PC NetworkManager[1059]: <warn> Dispatcher
script timed out: Script '/etc/NetworkManager/dispatcher.d/01ifupdown'
timed out.
Sep  9 10:26:33 Arbeits-PC NetworkManager[1059]: <info> (wlan0): IP6
addrconf timed out or failed.
Sep  9 10:26:33 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Sep  9 10:26:33 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Sep  9 10:26:33 Arbeits-PC NetworkManager[1059]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Sep  9 10:36:49 Arbeits-PC kernel: [ 1718.782155] SGI XFS with ACLs,
security attributes, realtime, large block/inode numbers, no debug
enabled
Sep  9 10:36:49 Arbeits-PC kernel: [ 1718.792421] JFS: nTxBlock =
8192, nTxLock = 65536
Sep  9 10:36:49 Arbeits-PC kernel: [ 1718.803737] NTFS driver 2.1.30
[Flags: R/O MODULE].
Sep  9 10:36:49 Arbeits-PC kernel: [ 1718.822951] QNX4 filesystem
0.2.3 registered.
Sep  9 10:36:49 Arbeits-PC kernel: [ 1718.835881] Btrfs loaded
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC 10freedos: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC 10qnx: debug: /dev/sda1 is not a QNX4
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20macosx on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC macosx-prober: debug: /dev/sda1 is not an
HFS+ partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC 20microsoft: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC 30utility: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/83haiku on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC 83haiku: debug: /dev/sda1 is not a BeFS
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: /dev/sda3: is active swap
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC 10freedos: debug: /dev/sdb1 is not a FAT
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC 10qnx: debug: /dev/sdb1 is not a QNX4
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20macosx on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC macosx-prober: debug: /dev/sdb1 is not an
HFS+ partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC 20microsoft: debug: /dev/sdb1 is not a MS
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC 30utility: debug: /dev/sdb1 is not a FAT
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/83haiku on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC 83haiku: debug: /dev/sdb1 is not a BeFS
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sdb1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC 10freedos: debug: /dev/sdc1 is not a FAT
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC 10qnx: debug: /dev/sdc1 is not a QNX4
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20macosx on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC macosx-prober: debug: /dev/sdc1 is not an
HFS+ partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC 20microsoft: debug: /dev/sdc1 is a FUSE partition
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC 30utility: debug: /dev/sdc1 is not a FAT
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/83haiku on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC 83haiku: debug: /dev/sdc1 is not a BeFS
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sdc1
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sdd1
Sep  9 10:36:49 Arbeits-PC 10freedos: debug: /dev/sdd1 is not a FAT
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sdd1
Sep  9 10:36:49 Arbeits-PC 10qnx: debug: /dev/sdd1 is not a QNX4
partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20macosx on mounted /dev/sdd1
Sep  9 10:36:49 Arbeits-PC macosx-prober: debug: /dev/sdd1 is not an
HFS+ partition: exiting
Sep  9 10:36:49 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sdd1
Sep  9 10:36:49 Arbeits-PC 20microsoft: debug: /dev/sdd1 is a FUSE partition
Sep  9 10:36:50 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sdd1
Sep  9 10:36:50 Arbeits-PC 30utility: debug: /dev/sdd1 is not a FAT
partition: exiting
Sep  9 10:36:50 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sdd1
Sep  9 10:36:50 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sdd1
Sep  9 10:36:50 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sdd1
Sep  9 10:36:50 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/83haiku on mounted /dev/sdd1
Sep  9 10:36:50 Arbeits-PC 83haiku: debug: /dev/sdd1 is not a BeFS
partition: exiting
Sep  9 10:36:50 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sdd1
Sep  9 10:36:50 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sdd1
Sep  9 10:37:47 Arbeits-PC kernel: [ 1776.814425] wlan0:
deauthenticated from a0:f3:c1:05:80:ec (Reason: 6)
Sep  9 10:37:47 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=6
Sep  9 10:37:47 Arbeits-PC kernel: [ 1776.836009] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:37:47 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:37:47 Arbeits-PC kernel: [ 1776.840195] cfg80211: World
regulatory domain updated:
Sep  9 10:37:47 Arbeits-PC kernel: [ 1776.840199] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:37:47 Arbeits-PC kernel: [ 1776.840202] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:37:47 Arbeits-PC kernel: [ 1776.840204] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:37:47 Arbeits-PC kernel: [ 1776.840206] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:37:47 Arbeits-PC kernel: [ 1776.840208] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:37:47 Arbeits-PC kernel: [ 1776.840211] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:37:47 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:37:48 Arbeits-PC wpa_supplicant[1532]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:37:48 Arbeits-PC kernel: [ 1777.635691] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:37:48 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:37:48 Arbeits-PC kernel: [ 1777.660550] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:37:48 Arbeits-PC wpa_supplicant[1532]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:37:48 Arbeits-PC kernel: [ 1777.664415] wlan0: authenticated
Sep  9 10:37:48 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:37:48 Arbeits-PC kernel: [ 1777.667138] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:37:48 Arbeits-PC wpa_supplicant[1532]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:37:48 Arbeits-PC kernel: [ 1777.683803] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:37:48 Arbeits-PC kernel: [ 1777.683849] wlan0: associated
Sep  9 10:37:48 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:37:48 Arbeits-PC wpa_supplicant[1532]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:37:48 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:37:48 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:39:20 Arbeits-PC udisksd[2143]: Cleaning up mount point
/media/vincent/Elements (device 8:49 is not mounted)
Sep  9 10:39:20 Arbeits-PC ntfs-3g[2310]: Unmounting /dev/sdd1 (Elements)
Sep  9 10:39:20 Arbeits-PC udisksd[2143]: Unmounted /dev/sdd1 on
behalf of uid 1000
Sep  9 10:39:25 Arbeits-PC udisksd[2143]: Cleaning up mount point
/media/vincent/Elements1 (device 8:33 is not mounted)
Sep  9 10:39:25 Arbeits-PC ntfs-3g[2313]: Unmounting /dev/sdc1 (Elements)
Sep  9 10:39:25 Arbeits-PC udisksd[2143]: Unmounted /dev/sdc1 on
behalf of uid 1000
Sep  9 10:39:29 Arbeits-PC kernel: [ 1878.652288] usb 3-2: USB
disconnect, device number 3
Sep  9 10:39:39 Arbeits-PC kernel: [ 1888.560170] usb 3-2: new
high-speed USB device number 4 using xhci_hcd
Sep  9 10:39:39 Arbeits-PC kernel: [ 1888.577120] usb 3-2: New USB
device found, idVendor=18d1, idProduct=4ee1
Sep  9 10:39:39 Arbeits-PC kernel: [ 1888.577125] usb 3-2: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Sep  9 10:39:39 Arbeits-PC kernel: [ 1888.577128] usb 3-2: Product: Nexus 4
Sep  9 10:39:39 Arbeits-PC kernel: [ 1888.577130] usb 3-2: Manufacturer: LGE
Sep  9 10:39:39 Arbeits-PC kernel: [ 1888.577133] usb 3-2:
SerialNumber: 00294807ce91f316
Sep  9 10:39:39 Arbeits-PC dbus[956]: [system] Activating service
name='org.freedesktop.hostname1' (using servicehelper)
Sep  9 10:39:39 Arbeits-PC dbus[956]: [system] Successfully activated
service 'org.freedesktop.hostname1'
Sep  9 10:41:32 Arbeits-PC kernel: [ 2001.552758] wlan0:
deauthenticated from a0:f3:c1:05:80:ec (Reason: 6)
Sep  9 10:41:32 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=6
Sep  9 10:41:32 Arbeits-PC kernel: [ 2001.574408] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:41:32 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:41:32 Arbeits-PC kernel: [ 2001.578848] cfg80211: World
regulatory domain updated:
Sep  9 10:41:32 Arbeits-PC kernel: [ 2001.578852] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:41:32 Arbeits-PC kernel: [ 2001.578855] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:41:32 Arbeits-PC kernel: [ 2001.578858] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:41:32 Arbeits-PC kernel: [ 2001.578860] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:41:32 Arbeits-PC kernel: [ 2001.578862] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:41:32 Arbeits-PC kernel: [ 2001.578865] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:41:32 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:41:33 Arbeits-PC wpa_supplicant[1532]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:41:33 Arbeits-PC kernel: [ 2002.373596] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:41:33 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:41:33 Arbeits-PC kernel: [ 2002.397664] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:41:33 Arbeits-PC wpa_supplicant[1532]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:41:33 Arbeits-PC kernel: [ 2002.410536] wlan0: authenticated
Sep  9 10:41:33 Arbeits-PC kernel: [ 2002.413119] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:41:33 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:41:33 Arbeits-PC wpa_supplicant[1532]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:41:33 Arbeits-PC kernel: [ 2002.422636] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:41:33 Arbeits-PC kernel: [ 2002.422677] wlan0: associated
Sep  9 10:41:33 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:41:33 Arbeits-PC wpa_supplicant[1532]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:41:33 Arbeits-PC wpa_supplicant[1532]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:41:33 Arbeits-PC NetworkManager[1059]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:41:45 Arbeits-PC NetworkManager[1059]: <info> kernel
firmware directory '/lib/firmware' changed
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC 10freedos: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC 10qnx: debug: /dev/sda1 is not a QNX4
partition: exiting
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20macosx on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC macosx-prober: debug: /dev/sda1 is not an
HFS+ partition: exiting
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC 20microsoft: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC 30utility: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/83haiku on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC 83haiku: debug: /dev/sda1 is not a BeFS
partition: exiting
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda1
Sep  9 10:41:55 Arbeits-PC os-prober: debug: /dev/sda3: is active swap
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC 10freedos: debug: /dev/sdb1 is not a FAT
partition: exiting
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC 10qnx: debug: /dev/sdb1 is not a QNX4
partition: exiting
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20macosx on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC macosx-prober: debug: /dev/sdb1 is not an
HFS+ partition: exiting
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC 20microsoft: debug: /dev/sdb1 is not a MS
partition: exiting
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC 30utility: debug: /dev/sdb1 is not a FAT
partition: exiting
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/83haiku on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC 83haiku: debug: /dev/sdb1 is not a BeFS
partition: exiting
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sdb1
Sep  9 10:41:55 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/50mounted-tests on /dev/sdc1
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: mounted using GRUB,
but unknown filesystem?
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/10freedos
Sep  9 10:41:56 Arbeits-PC 10freedos: debug: /dev/sdc1 is not a FAT
partition: exiting
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/10qnx
Sep  9 10:41:56 Arbeits-PC 10qnx: debug: /dev/sdc1 is not a QNX4
partition: exiting
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/20macosx
Sep  9 10:41:56 Arbeits-PC macosx-prober: debug: /dev/sdc1 is not an
HFS+ partition: exiting
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/20microsoft
Sep  9 10:41:56 Arbeits-PC 20microsoft: debug: /dev/sdc1 is a FUSE partition
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/30utility
Sep  9 10:41:56 Arbeits-PC 30utility: debug: /dev/sdc1 is not a FAT
partition: exiting
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/40lsb
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/70hurd
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/80minix
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/83haiku
Sep  9 10:41:56 Arbeits-PC 83haiku: debug: /dev/sdc1 is not a BeFS
partition: exiting
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/90linux-distro
Sep  9 10:41:56 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/90solaris
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC 10freedos: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC 10qnx: debug: /dev/sda1 is not a QNX4
partition: exiting
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20macosx on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC macosx-prober: debug: /dev/sda1 is not an
HFS+ partition: exiting
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC 20microsoft: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC 30utility: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/83haiku on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC 83haiku: debug: /dev/sda1 is not a BeFS
partition: exiting
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda1
Sep  9 10:42:58 Arbeits-PC os-prober: debug: /dev/sda3: is active swap
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC 10freedos: debug: /dev/sdb1 is not a FAT
partition: exiting
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC 10qnx: debug: /dev/sdb1 is not a QNX4
partition: exiting
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20macosx on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC macosx-prober: debug: /dev/sdb1 is not an
HFS+ partition: exiting
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC 20microsoft: debug: /dev/sdb1 is not a MS
partition: exiting
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC 30utility: debug: /dev/sdb1 is not a FAT
partition: exiting
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/83haiku on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC 83haiku: debug: /dev/sdb1 is not a BeFS
partition: exiting
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sdb1
Sep  9 10:42:58 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/50mounted-tests on /dev/sdc1
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: mounted using GRUB,
but unknown filesystem?
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/10freedos
Sep  9 10:42:58 Arbeits-PC 10freedos: debug: /dev/sdc1 is not a FAT
partition: exiting
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/10qnx
Sep  9 10:42:58 Arbeits-PC 10qnx: debug: /dev/sdc1 is not a QNX4
partition: exiting
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/20macosx
Sep  9 10:42:58 Arbeits-PC macosx-prober: debug: /dev/sdc1 is not an
HFS+ partition: exiting
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/20microsoft
Sep  9 10:42:58 Arbeits-PC 20microsoft: debug: /dev/sdc1 is a FUSE partition
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/30utility
Sep  9 10:42:58 Arbeits-PC 30utility: debug: /dev/sdc1 is not a FAT
partition: exiting
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/40lsb
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/70hurd
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/80minix
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/83haiku
Sep  9 10:42:58 Arbeits-PC 83haiku: debug: /dev/sdc1 is not a BeFS
partition: exiting
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/90linux-distro
Sep  9 10:42:58 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/90solaris
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC 10freedos: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC 10qnx: debug: /dev/sda1 is not a QNX4
partition: exiting
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20macosx on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC macosx-prober: debug: /dev/sda1 is not an
HFS+ partition: exiting
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC 20microsoft: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC 30utility: debug: /dev/sda1 is a FAT32 partition
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/83haiku on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC 83haiku: debug: /dev/sda1 is not a BeFS
partition: exiting
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sda1
Sep  9 10:43:26 Arbeits-PC os-prober: debug: /dev/sda3: is active swap
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10freedos on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC 10freedos: debug: /dev/sdb1 is not a FAT
partition: exiting
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/10qnx on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC 10qnx: debug: /dev/sdb1 is not a QNX4
partition: exiting
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20macosx on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC macosx-prober: debug: /dev/sdb1 is not an
HFS+ partition: exiting
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/20microsoft on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC 20microsoft: debug: /dev/sdb1 is not a MS
partition: exiting
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/30utility on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC 30utility: debug: /dev/sdb1 is not a FAT
partition: exiting
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/40lsb on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/70hurd on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/80minix on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/83haiku on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC 83haiku: debug: /dev/sdb1 is not a BeFS
partition: exiting
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/mounted/90solaris on mounted /dev/sdb1
Sep  9 10:43:26 Arbeits-PC os-prober: debug: running
/usr/lib/os-probes/50mounted-tests on /dev/sdc1
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: mounted using GRUB,
but unknown filesystem?
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/10freedos
Sep  9 10:43:26 Arbeits-PC 10freedos: debug: /dev/sdc1 is not a FAT
partition: exiting
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/10qnx
Sep  9 10:43:26 Arbeits-PC 10qnx: debug: /dev/sdc1 is not a QNX4
partition: exiting
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/20macosx
Sep  9 10:43:26 Arbeits-PC macosx-prober: debug: /dev/sdc1 is not an
HFS+ partition: exiting
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/20microsoft
Sep  9 10:43:26 Arbeits-PC 20microsoft: debug: /dev/sdc1 is a FUSE partition
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/30utility
Sep  9 10:43:26 Arbeits-PC 30utility: debug: /dev/sdc1 is not a FAT
partition: exiting
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/40lsb
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/70hurd
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/80minix
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/83haiku
Sep  9 10:43:26 Arbeits-PC 83haiku: debug: /dev/sdc1 is not a BeFS
partition: exiting
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/90linux-distro
Sep  9 10:43:26 Arbeits-PC 50mounted-tests: debug: running subtest
/usr/lib/os-probes/mounted/90solaris
Sep  9 10:44:05 Arbeits-PC kernel: imklog 5.8.11, log source =
/proc/kmsg started.
Sep  9 10:44:05 Arbeits-PC rsyslogd: [origin software="rsyslogd"
swVersion="5.8.11" x-pid="928" x-info="http://www.rsyslog.com"] start
Sep  9 10:44:05 Arbeits-PC rsyslogd: rsyslogd's groupid changed to 103
Sep  9 10:44:05 Arbeits-PC rsyslogd: rsyslogd's userid changed to 101
Sep  9 10:44:05 Arbeits-PC rsyslogd-2039: Could not open output pipe
'/dev/xconsole' [try http://www.rsyslog.com/e/2039 ]
Sep  9 10:44:05 Arbeits-PC failsafe: Failsafe of 120 seconds reached.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Initializing cgroup
subsys cpuset
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Initializing cgroup subsys cpu
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Initializing cgroup
subsys cpuacct
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Linux version
3.11.0-031100-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro
4.6.3-1ubuntu5) ) #201309021735 SMP Mon Sep 2 21:36:21 UTC 2013
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Command line:
BOOT_IMAGE=/boot/vmlinuz-3.11.0-031100-generic
root=UUID=b44f3d14-b5d6-4775-a304-5d29e8fcd2db ro nomodeset
acpi_osi=Linux quiet splash vt.handoff=7
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] KERNEL supported cpus:
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   Intel GenuineIntel
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   AMD AuthenticAMD
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   Centaur CentaurHauls
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] e820: BIOS-provided
physical RAM map:
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x0000000000000000-0x000000000009efff] usable
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x000000000009f000-0x000000000009ffff] reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x0000000000100000-0x00000000deb8efff] usable
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000deb8f000-0x00000000df13efff] reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df13f000-0x00000000df383fff] ACPI NVS
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df384000-0x00000000df391fff] ACPI data
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df392000-0x00000000df3befff] ACPI NVS
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df3bf000-0x00000000df3c3fff] ACPI data
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df3c4000-0x00000000df406fff] ACPI NVS
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000df407000-0x00000000df7fffff] usable
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000f8000000-0x00000000fbffffff] reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fec00000-0x00000000fec00fff] reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fed00000-0x00000000fed03fff] reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fed1c000-0x00000000fed1ffff] reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000fee00000-0x00000000fee00fff] reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x00000000ff000000-0x00000000ffffffff] reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BIOS-e820: [mem
0x0000000100000000-0x000000021effffff] usable
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] NX (Execute Disable)
protection: active
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: EFI v2.31 by
American Megatrends
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi:
ACPI=0xdf384000  ACPI 2.0=0xdf384000  SMBIOS=0xdec27e98  MPS=0xfc980
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem00: type=3,
attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem01: type=7,
attr=0xf, range=[0x0000000000008000-0x0000000000048000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem02: type=4,
attr=0xf, range=[0x0000000000048000-0x0000000000059000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem03: type=7,
attr=0xf, range=[0x0000000000059000-0x000000000005f000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem04: type=4,
attr=0xf, range=[0x000000000005f000-0x0000000000060000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem05: type=3,
attr=0xf, range=[0x0000000000060000-0x000000000009f000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem06: type=6,
attr=0x800000000000000f, range=[0x000000000009f000-0x00000000000a0000)
(0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem07: type=7,
attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem08: type=2,
attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem09: type=4,
attr=0xf, range=[0x0000000001100000-0x0000000001984000) (8MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem10: type=3,
attr=0xf, range=[0x0000000001984000-0x0000000001986000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem11: type=4,
attr=0xf, range=[0x0000000001986000-0x0000000001988000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem12: type=3,
attr=0xf, range=[0x0000000001988000-0x000000000198c000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem13: type=4,
attr=0xf, range=[0x000000000198c000-0x0000000001991000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem14: type=3,
attr=0xf, range=[0x0000000001991000-0x000000000199e000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem15: type=4,
attr=0xf, range=[0x000000000199e000-0x0000000001da4000) (4MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem16: type=3,
attr=0xf, range=[0x0000000001da4000-0x0000000001da5000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem17: type=4,
attr=0xf, range=[0x0000000001da5000-0x0000000001da9000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem18: type=3,
attr=0xf, range=[0x0000000001da9000-0x0000000001daa000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem19: type=4,
attr=0xf, range=[0x0000000001daa000-0x0000000001daf000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem20: type=3,
attr=0xf, range=[0x0000000001daf000-0x0000000001db0000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem21: type=4,
attr=0xf, range=[0x0000000001db0000-0x0000000001db1000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem22: type=3,
attr=0xf, range=[0x0000000001db1000-0x0000000001db2000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem23: type=4,
attr=0xf, range=[0x0000000001db2000-0x0000000001dbf000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem24: type=3,
attr=0xf, range=[0x0000000001dbf000-0x0000000001dc0000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem25: type=4,
attr=0xf, range=[0x0000000001dc0000-0x0000000001dc1000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem26: type=3,
attr=0xf, range=[0x0000000001dc1000-0x0000000001dc7000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem27: type=4,
attr=0xf, range=[0x0000000001dc7000-0x0000000001dc9000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem28: type=3,
attr=0xf, range=[0x0000000001dc9000-0x0000000001dca000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem29: type=4,
attr=0xf, range=[0x0000000001dca000-0x0000000001dcf000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem30: type=3,
attr=0xf, range=[0x0000000001dcf000-0x0000000001dd1000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem31: type=4,
attr=0xf, range=[0x0000000001dd1000-0x0000000001dd7000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem32: type=3,
attr=0xf, range=[0x0000000001dd7000-0x0000000001dda000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem33: type=4,
attr=0xf, range=[0x0000000001dda000-0x0000000001ddc000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem34: type=3,
attr=0xf, range=[0x0000000001ddc000-0x0000000001dde000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem35: type=4,
attr=0xf, range=[0x0000000001dde000-0x0000000001ded000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem36: type=3,
attr=0xf, range=[0x0000000001ded000-0x0000000001def000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem37: type=4,
attr=0xf, range=[0x0000000001def000-0x0000000001df0000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem38: type=3,
attr=0xf, range=[0x0000000001df0000-0x0000000001df1000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem39: type=4,
attr=0xf, range=[0x0000000001df1000-0x0000000001df2000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem40: type=3,
attr=0xf, range=[0x0000000001df2000-0x0000000001df3000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem41: type=4,
attr=0xf, range=[0x0000000001df3000-0x0000000001df7000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem42: type=3,
attr=0xf, range=[0x0000000001df7000-0x0000000001df9000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem43: type=4,
attr=0xf, range=[0x0000000001df9000-0x0000000001dfd000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem44: type=3,
attr=0xf, range=[0x0000000001dfd000-0x0000000001dff000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem45: type=4,
attr=0xf, range=[0x0000000001dff000-0x0000000001e07000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem46: type=3,
attr=0xf, range=[0x0000000001e07000-0x0000000001e0b000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem47: type=4,
attr=0xf, range=[0x0000000001e0b000-0x0000000001e0d000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem48: type=3,
attr=0xf, range=[0x0000000001e0d000-0x0000000001e0f000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem49: type=4,
attr=0xf, range=[0x0000000001e0f000-0x0000000001e11000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem50: type=3,
attr=0xf, range=[0x0000000001e11000-0x0000000001e13000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem51: type=4,
attr=0xf, range=[0x0000000001e13000-0x0000000001e23000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem52: type=3,
attr=0xf, range=[0x0000000001e23000-0x0000000001e27000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem53: type=4,
attr=0xf, range=[0x0000000001e27000-0x0000000001e2d000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem54: type=3,
attr=0xf, range=[0x0000000001e2d000-0x0000000001e2e000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem55: type=4,
attr=0xf, range=[0x0000000001e2e000-0x0000000001e4d000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem56: type=3,
attr=0xf, range=[0x0000000001e4d000-0x0000000001e4e000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem57: type=4,
attr=0xf, range=[0x0000000001e4e000-0x0000000001e59000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem58: type=3,
attr=0xf, range=[0x0000000001e59000-0x0000000001e5d000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem59: type=4,
attr=0xf, range=[0x0000000001e5d000-0x0000000001e76000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem60: type=3,
attr=0xf, range=[0x0000000001e76000-0x0000000001e80000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem61: type=4,
attr=0xf, range=[0x0000000001e80000-0x0000000001e8f000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem62: type=3,
attr=0xf, range=[0x0000000001e8f000-0x0000000001e93000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem63: type=4,
attr=0xf, range=[0x0000000001e93000-0x0000000001e96000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem64: type=3,
attr=0xf, range=[0x0000000001e96000-0x0000000001e97000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem65: type=4,
attr=0xf, range=[0x0000000001e97000-0x00000000022ae000) (4MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem66: type=3,
attr=0xf, range=[0x00000000022ae000-0x00000000022b8000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem67: type=4,
attr=0xf, range=[0x00000000022b8000-0x00000000022c7000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem68: type=3,
attr=0xf, range=[0x00000000022c7000-0x00000000022cd000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem69: type=4,
attr=0xf, range=[0x00000000022cd000-0x00000000022d1000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem70: type=3,
attr=0xf, range=[0x00000000022d1000-0x00000000022d2000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem71: type=4,
attr=0xf, range=[0x00000000022d2000-0x00000000022d3000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem72: type=3,
attr=0xf, range=[0x00000000022d3000-0x00000000022d5000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem73: type=4,
attr=0xf, range=[0x00000000022d5000-0x00000000022d6000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem74: type=3,
attr=0xf, range=[0x00000000022d6000-0x00000000022d7000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem75: type=4,
attr=0xf, range=[0x00000000022d7000-0x00000000022de000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem76: type=3,
attr=0xf, range=[0x00000000022de000-0x00000000022df000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem77: type=4,
attr=0xf, range=[0x00000000022df000-0x00000000022fc000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem78: type=3,
attr=0xf, range=[0x00000000022fc000-0x0000000002309000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem79: type=4,
attr=0xf, range=[0x0000000002309000-0x0000000002317000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem80: type=3,
attr=0xf, range=[0x0000000002317000-0x000000000231c000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem81: type=4,
attr=0xf, range=[0x000000000231c000-0x0000000002320000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem82: type=3,
attr=0xf, range=[0x0000000002320000-0x0000000002324000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem83: type=4,
attr=0xf, range=[0x0000000002324000-0x000000000232a000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem84: type=3,
attr=0xf, range=[0x000000000232a000-0x000000000232d000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem85: type=4,
attr=0xf, range=[0x000000000232d000-0x0000000002344000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem86: type=3,
attr=0xf, range=[0x0000000002344000-0x0000000002348000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem87: type=4,
attr=0xf, range=[0x0000000002348000-0x000000000234b000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem88: type=3,
attr=0xf, range=[0x000000000234b000-0x0000000002351000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem89: type=4,
attr=0xf, range=[0x0000000002351000-0x0000000002362000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem90: type=3,
attr=0xf, range=[0x0000000002362000-0x0000000002363000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem91: type=4,
attr=0xf, range=[0x0000000002363000-0x0000000002367000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem92: type=3,
attr=0xf, range=[0x0000000002367000-0x0000000002374000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem93: type=4,
attr=0xf, range=[0x0000000002374000-0x000000000237b000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem94: type=3,
attr=0xf, range=[0x000000000237b000-0x000000000237e000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem95: type=4,
attr=0xf, range=[0x000000000237e000-0x0000000002386000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem96: type=3,
attr=0xf, range=[0x0000000002386000-0x0000000002389000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem97: type=4,
attr=0xf, range=[0x0000000002389000-0x0000000002391000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem98: type=3,
attr=0xf, range=[0x0000000002391000-0x0000000002395000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem99: type=4,
attr=0xf, range=[0x0000000002395000-0x000000000239e000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem100: type=3,
attr=0xf, range=[0x000000000239e000-0x00000000023a0000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem101: type=4,
attr=0xf, range=[0x00000000023a0000-0x00000000023a2000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem102: type=3,
attr=0xf, range=[0x00000000023a2000-0x00000000023aa000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem103: type=4,
attr=0xf, range=[0x00000000023aa000-0x00000000023b0000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem104: type=3,
attr=0xf, range=[0x00000000023b0000-0x00000000023c8000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem105: type=4,
attr=0xf, range=[0x00000000023c8000-0x00000000023cb000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem106: type=3,
attr=0xf, range=[0x00000000023cb000-0x00000000023ce000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem107: type=4,
attr=0xf, range=[0x00000000023ce000-0x00000000023d1000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem108: type=3,
attr=0xf, range=[0x00000000023d1000-0x00000000023d5000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem109: type=4,
attr=0xf, range=[0x00000000023d5000-0x00000000023d6000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem110: type=3,
attr=0xf, range=[0x00000000023d6000-0x00000000023da000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem111: type=4,
attr=0xf, range=[0x00000000023da000-0x00000000023dd000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem112: type=3,
attr=0xf, range=[0x00000000023dd000-0x00000000023df000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem113: type=4,
attr=0xf, range=[0x00000000023df000-0x00000000023e0000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem114: type=3,
attr=0xf, range=[0x00000000023e0000-0x00000000023e3000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem115: type=4,
attr=0xf, range=[0x00000000023e3000-0x00000000023ed000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem116: type=3,
attr=0xf, range=[0x00000000023ed000-0x00000000023f0000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem117: type=4,
attr=0xf, range=[0x00000000023f0000-0x00000000023fd000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem118: type=3,
attr=0xf, range=[0x00000000023fd000-0x00000000023ff000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem119: type=4,
attr=0xf, range=[0x00000000023ff000-0x0000000002403000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem120: type=3,
attr=0xf, range=[0x0000000002403000-0x0000000002409000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem121: type=4,
attr=0xf, range=[0x0000000002409000-0x0000000002410000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem122: type=3,
attr=0xf, range=[0x0000000002410000-0x0000000002417000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem123: type=4,
attr=0xf, range=[0x0000000002417000-0x0000000002445000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem124: type=3,
attr=0xf, range=[0x0000000002445000-0x000000000244c000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem125: type=4,
attr=0xf, range=[0x000000000244c000-0x0000000002465000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem126: type=3,
attr=0xf, range=[0x0000000002465000-0x0000000002471000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem127: type=4,
attr=0xf, range=[0x0000000002471000-0x0000000002479000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem128: type=3,
attr=0xf, range=[0x0000000002479000-0x000000000247d000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem129: type=4,
attr=0xf, range=[0x000000000247d000-0x0000000002480000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem130: type=3,
attr=0xf, range=[0x0000000002480000-0x00000000024bf000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem131: type=4,
attr=0xf, range=[0x00000000024bf000-0x00000000024e6000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem132: type=3,
attr=0xf, range=[0x00000000024e6000-0x000000000250b000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem133: type=4,
attr=0xf, range=[0x000000000250b000-0x0000000002534000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem134: type=3,
attr=0xf, range=[0x0000000002534000-0x000000000253c000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem135: type=4,
attr=0xf, range=[0x000000000253c000-0x000000000253e000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem136: type=3,
attr=0xf, range=[0x000000000253e000-0x0000000002540000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem137: type=4,
attr=0xf, range=[0x0000000002540000-0x0000000002554000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem138: type=3,
attr=0xf, range=[0x0000000002554000-0x0000000002555000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem139: type=4,
attr=0xf, range=[0x0000000002555000-0x0000000002556000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem140: type=3,
attr=0xf, range=[0x0000000002556000-0x000000000255b000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem141: type=4,
attr=0xf, range=[0x000000000255b000-0x000000000255e000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem142: type=3,
attr=0xf, range=[0x000000000255e000-0x000000000256d000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem143: type=4,
attr=0xf, range=[0x000000000256d000-0x0000000002572000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem144: type=3,
attr=0xf, range=[0x0000000002572000-0x0000000002574000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem145: type=4,
attr=0xf, range=[0x0000000002574000-0x0000000002575000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem146: type=3,
attr=0xf, range=[0x0000000002575000-0x0000000002576000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem147: type=4,
attr=0xf, range=[0x0000000002576000-0x000000000258e000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem148: type=3,
attr=0xf, range=[0x000000000258e000-0x0000000002590000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem149: type=4,
attr=0xf, range=[0x0000000002590000-0x0000000002598000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem150: type=3,
attr=0xf, range=[0x0000000002598000-0x00000000025a1000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem151: type=4,
attr=0xf, range=[0x00000000025a1000-0x00000000025c3000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem152: type=3,
attr=0xf, range=[0x00000000025c3000-0x00000000025d7000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem153: type=4,
attr=0xf, range=[0x00000000025d7000-0x00000000025db000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem154: type=3,
attr=0xf, range=[0x00000000025db000-0x00000000025dd000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem155: type=4,
attr=0xf, range=[0x00000000025dd000-0x00000000025e7000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem156: type=3,
attr=0xf, range=[0x00000000025e7000-0x00000000025ec000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem157: type=4,
attr=0xf, range=[0x00000000025ec000-0x00000000025ee000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem158: type=3,
attr=0xf, range=[0x00000000025ee000-0x00000000025f0000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem159: type=4,
attr=0xf, range=[0x00000000025f0000-0x00000000025f3000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem160: type=3,
attr=0xf, range=[0x00000000025f3000-0x00000000025f6000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem161: type=4,
attr=0xf, range=[0x00000000025f6000-0x00000000025fc000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem162: type=3,
attr=0xf, range=[0x00000000025fc000-0x00000000025ff000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem163: type=4,
attr=0xf, range=[0x00000000025ff000-0x00000000026b4000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem164: type=3,
attr=0xf, range=[0x00000000026b4000-0x0000000002ac2000) (4MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem165: type=4,
attr=0xf, range=[0x0000000002ac2000-0x000000000c345000) (152MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem166: type=3,
attr=0xf, range=[0x000000000c345000-0x000000000c34b000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem167: type=4,
attr=0xf, range=[0x000000000c34b000-0x000000000c355000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem168: type=3,
attr=0xf, range=[0x000000000c355000-0x000000000c357000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem169: type=4,
attr=0xf, range=[0x000000000c357000-0x000000000c4c7000) (1MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem170: type=3,
attr=0xf, range=[0x000000000c4c7000-0x000000000c4e6000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem171: type=4,
attr=0xf, range=[0x000000000c4e6000-0x000000000c5bc000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem172: type=7,
attr=0xf, range=[0x000000000c5bc000-0x000000000c5c0000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem173: type=4,
attr=0xf, range=[0x000000000c5c0000-0x000000000c5d8000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem174: type=7,
attr=0xf, range=[0x000000000c5d8000-0x000000000c5ea000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem175: type=1,
attr=0xf, range=[0x000000000c5ea000-0x000000000c608000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem176: type=2,
attr=0xf, range=[0x000000000c608000-0x000000000da0e000) (20MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem177: type=7,
attr=0xf, range=[0x000000000da0e000-0x000000000e000000) (5MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem178: type=2,
attr=0xf, range=[0x000000000e000000-0x000000000f406000) (20MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem179: type=7,
attr=0xf, range=[0x000000000f406000-0x0000000036080000) (620MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem180: type=2,
attr=0xf, range=[0x0000000036080000-0x0000000037038000) (15MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem181: type=7,
attr=0xf, range=[0x0000000037038000-0x00000000a9e69000) (1838MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem182: type=2,
attr=0xf, range=[0x00000000a9e69000-0x00000000deb8f000) (845MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem183: type=5,
attr=0x800000000000000f, range=[0x00000000deb8f000-0x00000000debd4000)
(0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem184: type=6,
attr=0x800000000000000f, range=[0x00000000debd4000-0x00000000dec04000)
(0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem185: type=5,
attr=0x800000000000000f, range=[0x00000000dec04000-0x00000000dec15000)
(0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem186: type=6,
attr=0x800000000000000f, range=[0x00000000dec15000-0x00000000dec25000)
(0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem187: type=6,
attr=0x800000000000000f, range=[0x00000000dec25000-0x00000000dec26000)
(0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem188: type=6,
attr=0x800000000000000f, range=[0x00000000dec26000-0x00000000dec27000)
(0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem189: type=6,
attr=0x800000000000000f, range=[0x00000000dec27000-0x00000000dec3f000)
(0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem190: type=0,
attr=0xf, range=[0x00000000dec3f000-0x00000000dee70000) (2MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem191: type=0,
attr=0xf, range=[0x00000000dee70000-0x00000000df13f000) (2MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem192:
type=10, attr=0xf, range=[0x00000000df13f000-0x00000000df300000) (1MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem193:
type=10, attr=0xf, range=[0x00000000df300000-0x00000000df384000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem194: type=9,
attr=0xf, range=[0x00000000df384000-0x00000000df392000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem195:
type=10, attr=0xf, range=[0x00000000df392000-0x00000000df3a3000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem196:
type=10, attr=0xf, range=[0x00000000df3a3000-0x00000000df3b0000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem197:
type=10, attr=0xf, range=[0x00000000df3b0000-0x00000000df3bf000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem198: type=9,
attr=0xf, range=[0x00000000df3bf000-0x00000000df3c3000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem199: type=9,
attr=0xf, range=[0x00000000df3c3000-0x00000000df3c4000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem200:
type=10, attr=0xf, range=[0x00000000df3c4000-0x00000000df407000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem201: type=4,
attr=0xf, range=[0x00000000df407000-0x00000000df54d000) (1MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem202: type=3,
attr=0xf, range=[0x00000000df54d000-0x00000000df7db000) (2MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem203: type=4,
attr=0xf, range=[0x00000000df7db000-0x00000000df7e3000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem204: type=3,
attr=0xf, range=[0x00000000df7e3000-0x00000000df7ed000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem205: type=4,
attr=0xf, range=[0x00000000df7ed000-0x00000000df800000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem206: type=7,
attr=0xf, range=[0x0000000100000000-0x000000021f000000) (4592MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem207:
type=11, attr=0x8000000000000001,
range=[0x00000000f8000000-0x00000000fc000000) (64MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem208:
type=11, attr=0x8000000000000001,
range=[0x00000000fec00000-0x00000000fec01000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem209:
type=11, attr=0x8000000000000001,
range=[0x00000000fed00000-0x00000000fed04000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem210:
type=11, attr=0x8000000000000001,
range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem211:
type=11, attr=0x8000000000000001,
range=[0x00000000fee00000-0x00000000fee01000) (0MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] efi: mem212:
type=11, attr=0x8000000000000001,
range=[0x00000000ff000000-0x0000000100000000) (16MB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] SMBIOS 2.6 present.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] DMI: System
manufacturer System Product Name/Maximus IV GENE-Z, BIOS 3603
11/09/2012
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] e820: update [mem
0x00000000-0x00000fff] usable ==> reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] e820: remove [mem
0x000a0000-0x000fffff] usable
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] No AGP bridge found
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] e820: last_pfn =
0x21f000 max_arch_pfn = 0x400000000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] MTRR default type: uncachable
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] MTRR fixed ranges enabled:
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   00000-9FFFF write-back
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   A0000-BFFFF uncachable
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   C0000-D3FFF write-protect
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   D4000-DFFFF uncachable
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   E0000-E7FFF write-through
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   E8000-FFFFF write-protect
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] MTRR variable ranges enabled:
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   0 base 000000000
mask E00000000 write-back
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   1 base 200000000
mask FF0000000 write-back
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   2 base 210000000
mask FF8000000 write-back
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   3 base 218000000
mask FFC000000 write-back
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   4 base 21C000000
mask FFE000000 write-back
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   5 base 21E000000
mask FFF000000 write-back
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   6 base 0E0000000
mask FE0000000 uncachable
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   7 disabled
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   8 disabled
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   9 disabled
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] x86 PAT enabled: cpu
0, old 0x7040600070406, new 0x7010600070106
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] original variable MTRRs
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 0, base: 0GB,
range: 8GB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 1, base: 8GB,
range: 256MB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 2, base: 8448MB,
range: 128MB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 3, base: 8576MB,
range: 64MB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 4, base: 8640MB,
range: 32MB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 5, base: 8672MB,
range: 16MB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 6, base: 3584MB,
range: 512MB, type UC
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] total RAM covered: 8176M
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Found optimal
setting for mtrr clean up
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  gran_size: 64K
chunk_size: 32M num_reg: 6   lose cover RAM: 0G
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] New variable MTRRs
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 0, base: 0GB,
range: 2GB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 1, base: 2GB,
range: 1GB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 2, base: 3GB,
range: 512MB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 3, base: 4GB,
range: 4GB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 4, base: 8GB,
range: 512MB, type WB
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] reg 5, base: 8688MB,
range: 16MB, type UC
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] e820: update [mem
0xe0000000-0xffffffff] usable ==> reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] e820: last_pfn =
0xdf800 max_arch_pfn = 0x400000000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] found SMP MP-table
at [mem 0x000fccf0-0x000fccff] mapped at [ffff8800000fccf0]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Scanning 1 areas for
low memory corruption
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Base memory
trampoline at [ffff880000097000] 97000 size 24576
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0x00000000-0x000fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  [mem
0x00000000-0x000fffff] page 4k
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BRK [0x0efe4000,
0x0efe4fff] PGTABLE
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BRK [0x0efe5000,
0x0efe5fff] PGTABLE
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BRK [0x0efe6000,
0x0efe6fff] PGTABLE
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0x21ee00000-0x21effffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  [mem
0x21ee00000-0x21effffff] page 2M
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BRK [0x0efe7000,
0x0efe7fff] PGTABLE
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0x21c000000-0x21edfffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  [mem
0x21c000000-0x21edfffff] page 2M
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0x200000000-0x21bffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  [mem
0x200000000-0x21bffffff] page 2M
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0x00100000-0xdeb8efff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  [mem
0x00100000-0x001fffff] page 4k
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  [mem
0x00200000-0xde9fffff] page 2M
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  [mem
0xdea00000-0xdeb8efff] page 4k
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0xdf407000-0xdf7fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  [mem
0xdf407000-0xdf5fffff] page 4k
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  [mem
0xdf600000-0xdf7fffff] page 2M
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BRK [0x0efe8000,
0x0efe8fff] PGTABLE
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] init_memory_mapping:
[mem 0x100000000-0x1ffffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]  [mem
0x100000000-0x1ffffffff] page 2M
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] BRK [0x0efe9000,
0x0efe9fff] PGTABLE
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] RAMDISK: [mem
0x36080000-0x37037fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: RSDP
00000000df384000 00024 (v02 ALASKA)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: XSDT
00000000df384070 0005C (v01 ALASKA    A M I 01072009 AMI  00010013)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: FACP
00000000df38fc70 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: DSDT
00000000df384168 0BB02 (v02 ALASKA    A M I 00000015 INTL 20051117)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: FACS
00000000df3bdf80 00040
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: APIC
00000000df38fd68 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: MCFG
00000000df38fde0 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: HPET
00000000df38fe20 00038 (v01 ALASKA    A M I 01072009 AMI. 00000005)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: SSDT
00000000df38fe58 0036D (v01 SataRe SataTabl 00001000 INTL 20091112)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: SSDT
00000000df3901c8 00926 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: SSDT
00000000df390af0 00A92 (v01  PmRef    CpuPm 00003000 INTL 20051117)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Sep  9 10:44:05 Arbeits-PC avahi-daemon[954]: Found user 'avahi' (UID
111) and group 'avahi' (GID 118).
Sep  9 10:44:05 Arbeits-PC avahi-daemon[954]: Successfully dropped
root privileges.
Sep  9 10:44:05 Arbeits-PC avahi-daemon[954]: avahi-daemon 0.6.31 starting up.
Sep  9 10:44:05 Arbeits-PC bluetoothd[911]: Failed to init gatt_example plugin
Sep  9 10:44:05 Arbeits-PC bluetoothd[911]: Bluetooth Management
interface initialized
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] No NUMA configuration found
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Faking a node at
[mem 0x0000000000000000-0x000000021effffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Initmem setup node 0
[mem 0x00000000-0x21effffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   NODE_DATA [mem
0x21eff4000-0x21eff8fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]
[ffffea0000000000-ffffea00087fffff] PMD ->
[ffff880216600000-ffff88021e5fffff] on node 0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Zone ranges:
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   DMA      [mem
0x00001000-0x00ffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   DMA32    [mem
0x01000000-0xffffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   Normal   [mem
0x100000000-0x21effffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Movable zone start
for each node
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Early memory node ranges
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0x00001000-0x0009efff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0x00100000-0xdeb8efff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0xdf407000-0xdf7fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   node   0: [mem
0x100000000-0x21effffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] On node 0 totalpages: 2088742
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   DMA zone: 64 pages
used for memmap
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   DMA zone: 44 pages reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   DMA zone: 3998
pages, LIFO batch:0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   DMA32 zone: 14207
pages used for memmap
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   DMA32 zone: 909192
pages, LIFO batch:31
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   Normal zone: 18368
pages used for memmap
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000]   Normal zone:
1175552 pages, LIFO batch:31
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x00] enabled)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x02] lapic_id[0x02] enabled)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x03] lapic_id[0x04] enabled)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x04] lapic_id[0x06] enabled)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0xff] high edge lint[0x1])
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: IOAPIC
(id[0x02] address[0xfec00000] gsi_base[0])
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] IOAPIC[0]: apic_id
2, version 32, address 0xfec00000, GSI 0-23
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 0 global_irq 2 dfl dfl)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: INT_SRC_OVR
(bus 0 bus_irq 9 global_irq 9 high level)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: IRQ0 used by override.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: IRQ2 used by override.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: IRQ9 used by override.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Using ACPI (MADT)
for SMP configuration information
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] ACPI: HPET id:
0x8086a701 base: 0xfed00000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] smpboot: Allowing 4
CPUs, 0 hotplug CPUs
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] nr_irqs_gsi: 40
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0x0009f000-0x0009ffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0x000a0000-0x000fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xdeb8f000-0xdf13efff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xdf13f000-0xdf383fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xdf384000-0xdf391fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xdf392000-0xdf3befff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xdf3bf000-0xdf3c3fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xdf3c4000-0xdf406fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xdf800000-0xf7ffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xf8000000-0xfbffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xfc000000-0xfebfffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xfec00000-0xfec00fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xfec01000-0xfecfffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xfed00000-0xfed03fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xfed04000-0xfed1bfff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xfed1c000-0xfed1ffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xfed20000-0xfedfffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xfee00000-0xfee00fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xfee01000-0xfeffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PM: Registered
nosave memory: [mem 0xff000000-0xffffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] e820: [mem
0xdf800000-0xf7ffffff] available for PCI devices
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Booting
paravirtualized kernel on bare hardware
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] setup_percpu:
NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PERCPU: Embedded 29
pages/cpu @ffff88021ec00000 s86720 r8192 d23872 u524288
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] pcpu-alloc: s86720
r8192 d23872 u524288 alloc=1*2097152
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Built 1 zonelists in
Zone order, mobility grouping on.  Total pages: 2056059
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Policy zone: Normal
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-3.11.0-031100-generic
root=UUID=b44f3d14-b5d6-4775-a304-5d29e8fcd2db ro nomodeset
acpi_osi=Linux quiet splash vt.handoff=7
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] PID hash table
entries: 4096 (order: 3, 32768 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] xsave: enabled
xstate_bv 0x7, cntxt size 0x340
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Checking aperture...
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] No AGP bridge found
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Calgary: detecting
Calgary via BIOS EBDA area
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Calgary: Unable to
locate Rio Grande table in EBDA - bailing!
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Memory:
7935272K/8354968K available (7400K kernel code, 1082K rwdata, 3420K
rodata, 1380K init, 1484K bss, 419696K reserved)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] SLUB: HWalign=64,
Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Hierarchical RCU
implementation.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] RCU dyntick-idle
grace-period acceleration is enabled.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] RCU restricting CPUs
from NR_CPUS=256 to nr_cpu_ids=4.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Offload RCU
callbacks from all CPUs
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Offload RCU
callbacks from CPUs: 0-255.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] NR_IRQS:16640 nr_irqs:712 16
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] Console: colour
dummy device 80x25
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] console [tty0] enabled
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] allocated 33554432
bytes of page_cgroup
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] please try
'cgroup_disable=memory' option if you don't want memory cgroups
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] hpet clockevent registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000000] tsc: Fast TSC
calibration using PIT
Sep  9 10:44:05 Arbeits-PC kernel: [    0.004000] tsc: Detected
2809.243 MHz processor
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000002] Calibrating delay
loop (skipped), value calculated using timer frequency.. 5618.48
BogoMIPS (lpj=11236972)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000004] pid_max: default:
32768 minimum: 301
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000028] init_memory_mapping:
[mem 0xdeb8f000-0xdebd3fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000030]  [mem
0xdeb8f000-0xdebd3fff] page 4k
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000039] init_memory_mapping:
[mem 0xdebd4000-0xdec03fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000040]  [mem
0xdebd4000-0xdec03fff] page 4k
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000047] init_memory_mapping:
[mem 0xdec04000-0xdec14fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000048]  [mem
0xdec04000-0xdec14fff] page 4k
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000054] init_memory_mapping:
[mem 0xdec15000-0xdec3efff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.000055]  [mem
0xdec15000-0xdec3efff] page 4k
Sep  9 10:44:05 Arbeits-PC kernel: [    0.009797] Security Framework initialized
Sep  9 10:44:05 Arbeits-PC kernel: [    0.009807] AppArmor: AppArmor initialized
Sep  9 10:44:05 Arbeits-PC kernel: [    0.009808] Yama: becoming mindful.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.010256] Dentry cache hash
table entries: 1048576 (order: 11, 8388608 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.011643] Inode-cache hash
table entries: 524288 (order: 10, 4194304 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012224] Mount-cache hash
table entries: 256
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012363] Initializing cgroup
subsys memory
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012370] Initializing cgroup
subsys devices
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012372] Initializing cgroup
subsys freezer
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012373] Initializing cgroup
subsys blkio
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012374] Initializing cgroup
subsys perf_event
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012376] Initializing cgroup
subsys hugetlb
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012394] CPU: Physical Processor ID: 0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012395] CPU: Processor Core ID: 0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012399] ENERGY_PERF_BIAS:
Set to 'normal', was 'performance'
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012399] ENERGY_PERF_BIAS:
View and update with x86_energy_perf_policy(8)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012402] mce: CPU supports 9 MCE banks
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012413] CPU0: Thermal
monitoring enabled (TM1)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012420] Last level iTLB
entries: 4KB 512, 2MB 0, 4MB 0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012420] Last level dTLB
entries: 4KB 512, 2MB 32, 4MB 32
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012420] tlb_flushall_shift: 5
Sep  9 10:44:05 Arbeits-PC kernel: [    0.012510] Freeing SMP
alternatives memory: 24K (ffffffff81e69000 - ffffffff81e6f000)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.014760] ACPI: Core revision 20130517
Sep  9 10:44:05 Arbeits-PC kernel: [    0.019656] ACPI: All ACPI
Tables successfully acquired
Sep  9 10:44:05 Arbeits-PC kernel: [    0.242212] ftrace: allocating
30693 entries in 120 pages
Sep  9 10:44:05 Arbeits-PC kernel: [    0.255337] ..TIMER: vector=0x30
apic1=0 pin1=2 apic2=-1 pin2=-1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.295075] smpboot: CPU0:
Intel(R) Core(TM) i5-2300 CPU @ 2.80GHz (fam: 06, model: 2a, stepping:
07)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.295082] TSC deadline timer enabled
Sep  9 10:44:05 Arbeits-PC kernel: [    0.295090] Performance Events:
PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters,
Intel PMU driver.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.295098] ... version:                3
Sep  9 10:44:05 Arbeits-PC kernel: [    0.295099] ... bit width:              48
Sep  9 10:44:05 Arbeits-PC kernel: [    0.295100] ... generic registers:      8
Sep  9 10:44:05 Arbeits-PC kernel: [    0.295101] ... value mask:
       0000ffffffffffff
Sep  9 10:44:05 Arbeits-PC kernel: [    0.295102] ... max period:
       0000ffffffffffff
Sep  9 10:44:05 Arbeits-PC kernel: [    0.295102] ... fixed-purpose events:   3
Sep  9 10:44:05 Arbeits-PC kernel: [    0.295103] ... event mask:
       00000007000000ff
Sep  9 10:44:05 Arbeits-PC kernel: [    0.296289] NMI watchdog:
Disabled lockup detectors by default for full dynticks
Sep  9 10:44:05 Arbeits-PC kernel: [    0.296290] NMI watchdog: You
can reactivate it with 'sysctl -w kernel.watchdog=1'
Sep  9 10:44:05 Arbeits-PC kernel: [    0.296352] smpboot: Booting
Node   0, Processors  #1 #2 #3 OK
Sep  9 10:44:05 Arbeits-PC kernel: [    0.335883] Brought up 4 CPUs
Sep  9 10:44:05 Arbeits-PC kernel: [    0.335886] smpboot: Total of 4
processors activated (22473.94 BogoMIPS)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.338985] devtmpfs: initialized
Sep  9 10:44:05 Arbeits-PC kernel: [    0.339918] EVM: security.selinux
Sep  9 10:44:05 Arbeits-PC kernel: [    0.339919] EVM: security.SMACK64
Sep  9 10:44:05 Arbeits-PC kernel: [    0.339920] EVM: security.capability
Sep  9 10:44:05 Arbeits-PC kernel: [    0.339963] PM: Registering ACPI
NVS region [mem 0xdf13f000-0xdf383fff] (2379776 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.339991] PM: Registering ACPI
NVS region [mem 0xdf392000-0xdf3befff] (184320 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.339995] PM: Registering ACPI
NVS region [mem 0xdf3c4000-0xdf406fff] (274432 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.340702] regulator-dummy: no parameters
Sep  9 10:44:05 Arbeits-PC kernel: [    0.340731] RTC time:  8:44:03,
date: 09/09/13
Sep  9 10:44:05 Arbeits-PC kernel: [    0.340760] NET: Registered
protocol family 16
Sep  9 10:44:05 Arbeits-PC kernel: [    0.340882] ACPI FADT declares
the system doesn't support PCIe ASPM, so disable it
Sep  9 10:44:05 Arbeits-PC kernel: [    0.340884] ACPI: bus type PCI registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.340885] acpiphp: ACPI Hot
Plug PCI Controller Driver version: 0.5
Sep  9 10:44:05 Arbeits-PC kernel: [    0.340928] PCI: MMCONFIG for
domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base
0xf8000000)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.340930] PCI: MMCONFIG at
[mem 0xf8000000-0xfbffffff] reserved in E820
Sep  9 10:44:05 Arbeits-PC kernel: [    0.345491] PCI: Using
configuration type 1 for base access
Sep  9 10:44:05 Arbeits-PC kernel: [    0.346241] bio: create slab <bio-0> at 0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.346364] ACPI: Added
_OSI(Module Device)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.346366] ACPI: Added
_OSI(Processor Device)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.346367] ACPI: Added _OSI(3.0
_SCP Extensions)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.346368] ACPI: Added
_OSI(Processor Aggregator Device)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.346369] ACPI: Added _OSI(Linux)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.347710] ACPI: EC: Look up EC in DSDT
Sep  9 10:44:05 Arbeits-PC kernel: [    0.349008] ACPI: Executed 1
blocks of module-level executable AML code
Sep  9 10:44:05 Arbeits-PC kernel: [    0.355130] ACPI: SSDT
00000000df0ec018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.355472] ACPI: Dynamic OEM Table Load:
Sep  9 10:44:05 Arbeits-PC kernel: [    0.355474] ACPI: SSDT
(null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.359010] ACPI: SSDT
00000000df0eda98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.359374] ACPI: Dynamic OEM Table Load:
Sep  9 10:44:05 Arbeits-PC kernel: [    0.359376] ACPI: SSDT
(null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.362907] ACPI: SSDT
00000000df0eec18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.363244] ACPI: Dynamic OEM Table Load:
Sep  9 10:44:05 Arbeits-PC kernel: [    0.363246] ACPI: SSDT
(null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.367310] ACPI: Interpreter enabled
Sep  9 10:44:05 Arbeits-PC kernel: [    0.367318] ACPI Exception:
AE_NOT_FOUND, While evaluating Sleep State [\_S2_]
(20130517/hwxface-571)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.367329] ACPI: (supports S0
S1 S3 S4 S5)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.367331] ACPI: Using IOAPIC
for interrupt routing
Sep  9 10:44:05 Arbeits-PC kernel: [    0.367351] PCI: Using host
bridge windows from ACPI; if necessary, use "pci=nocrs" and report a
bug
Sep  9 10:44:05 Arbeits-PC kernel: [    0.367470] ACPI: No dock devices found.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.372853] ACPI: Power Resource
[FN00] (off)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.372919] ACPI: Power Resource
[FN01] (off)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.372982] ACPI: Power Resource
[FN02] (off)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.373047] ACPI: Power Resource
[FN03] (off)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.373111] ACPI: Power Resource
[FN04] (off)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.373675] ACPI: PCI Root
Bridge [PCI0] (domain 0000 [bus 00-3e])
Sep  9 10:44:05 Arbeits-PC kernel: [    0.373732] \_SB_.PCI0:_OSC invalid UUID
Sep  9 10:44:05 Arbeits-PC kernel: [    0.373733] _OSC request data:1 8 0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374222] PCI host bridge to bus 0000:00
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374224] pci_bus 0000:00:
root bus resource [bus 00-3e]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374226] pci_bus 0000:00:
root bus resource [io  0x0000-0x0cf7]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374228] pci_bus 0000:00:
root bus resource [io  0x0d00-0xffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374229] pci_bus 0000:00:
root bus resource [mem 0x000a0000-0x000bffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374231] pci_bus 0000:00:
root bus resource [mem 0x000d4000-0x000d7fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374232] pci_bus 0000:00:
root bus resource [mem 0x000d8000-0x000dbfff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374234] pci_bus 0000:00:
root bus resource [mem 0x000dc000-0x000dffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374235] pci_bus 0000:00:
root bus resource [mem 0xe0000000-0xfeafffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374243] pci 0000:00:00.0:
[8086:0100] type 00 class 0x060000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374323] pci 0000:00:01.0:
[8086:0101] type 01 class 0x060400
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374350] pci 0000:00:01.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374393] pci 0000:00:01.0:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374447] pci 0000:00:16.0:
[8086:1c3a] type 00 class 0x078000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374472] pci 0000:00:16.0:
reg 0x10: [mem 0xf742c000-0xf742c00f 64bit]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374546] pci 0000:00:16.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374627] pci 0000:00:19.0:
[8086:1503] type 00 class 0x020000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374645] pci 0000:00:19.0:
reg 0x10: [mem 0xf7400000-0xf741ffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374654] pci 0000:00:19.0:
reg 0x14: [mem 0xf7429000-0xf7429fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374662] pci 0000:00:19.0:
reg 0x18: [io  0xf040-0xf05f]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374723] pci 0000:00:19.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374770] pci 0000:00:19.0:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374801] pci 0000:00:1a.0:
[8086:1c2d] type 00 class 0x0c0320
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374821] pci 0000:00:1a.0:
reg 0x10: [mem 0xf7428000-0xf74283ff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374909] pci 0000:00:1a.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374968] pci 0000:00:1a.0:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.374999] pci 0000:00:1b.0:
[8086:1c20] type 00 class 0x040300
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375014] pci 0000:00:1b.0:
reg 0x10: [mem 0xf7420000-0xf7423fff 64bit]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375078] pci 0000:00:1b.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375127] pci 0000:00:1b.0:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375158] pci 0000:00:1c.0:
[8086:1c10] type 01 class 0x060400
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375288] pci 0000:00:1c.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375349] pci 0000:00:1c.0:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375378] pci 0000:00:1c.4:
[8086:1c18] type 01 class 0x060400
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375454] pci 0000:00:1c.4:
PME# supported from D0 D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375504] pci 0000:00:1c.4:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375531] pci 0000:00:1c.5:
[8086:1c1a] type 01 class 0x060400
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375606] pci 0000:00:1c.5:
PME# supported from D0 D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375656] pci 0000:00:1c.5:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375683] pci 0000:00:1c.6:
[8086:1c1c] type 01 class 0x060400
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375758] pci 0000:00:1c.6:
PME# supported from D0 D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375809] pci 0000:00:1c.6:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375840] pci 0000:00:1d.0:
[8086:1c26] type 00 class 0x0c0320
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375860] pci 0000:00:1d.0:
reg 0x10: [mem 0xf7427000-0xf74273ff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.375952] pci 0000:00:1d.0:
PME# supported from D0 D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376011] pci 0000:00:1d.0:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376042] pci 0000:00:1f.0:
[8086:1c44] type 00 class 0x060100
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376211] pci 0000:00:1f.2:
[8086:1c02] type 00 class 0x010601
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376229] pci 0000:00:1f.2:
reg 0x10: [io  0xf090-0xf097]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376236] pci 0000:00:1f.2:
reg 0x14: [io  0xf080-0xf083]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376244] pci 0000:00:1f.2:
reg 0x18: [io  0xf070-0xf077]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376252] pci 0000:00:1f.2:
reg 0x1c: [io  0xf060-0xf063]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376259] pci 0000:00:1f.2:
reg 0x20: [io  0xf020-0xf03f]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376267] pci 0000:00:1f.2:
reg 0x24: [mem 0xf7426000-0xf74267ff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376310] pci 0000:00:1f.2:
PME# supported from D3hot
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376376] pci 0000:00:1f.3:
[8086:1c22] type 00 class 0x0c0500
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376391] pci 0000:00:1f.3:
reg 0x10: [mem 0xf7425000-0xf74250ff 64bit]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376411] pci 0000:00:1f.3:
reg 0x20: [io  0x0580-0x059f]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376522] pci 0000:01:00.0:
[10de:11c0] type 00 class 0x030000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376531] pci 0000:01:00.0:
reg 0x10: [mem 0xf6000000-0xf6ffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376541] pci 0000:01:00.0:
reg 0x14: [mem 0xe8000000-0xefffffff 64bit pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376551] pci 0000:01:00.0:
reg 0x1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376558] pci 0000:01:00.0:
reg 0x24: [io  0xe000-0xe07f]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376565] pci 0000:01:00.0:
reg 0x30: [mem 0xf7000000-0xf707ffff pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376634] pci 0000:01:00.1:
[10de:0e0b] type 00 class 0x040300
Sep  9 10:44:05 Arbeits-PC kernel: [    0.376644] pci 0000:01:00.1:
reg 0x10: [mem 0xf7080000-0xf7083fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.383987] pci 0000:00:01.0:
PCI bridge to [bus 01]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.383989] pci 0000:00:01.0:
bridge window [io  0xe000-0xefff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.383992] pci 0000:00:01.0:
bridge window [mem 0xf6000000-0xf70fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.383995] pci 0000:00:01.0:
bridge window [mem 0xe8000000-0xf1ffffff 64bit pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.384080] pci 0000:00:1c.0:
PCI bridge to [bus 02]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.384176] pci 0000:03:00.0:
[1b21:1042] type 00 class 0x0c0330
Sep  9 10:44:05 Arbeits-PC kernel: [    0.384205] pci 0000:03:00.0:
reg 0x10: [mem 0xf7300000-0xf7307fff 64bit]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.384352] pci 0000:03:00.0:
PME# supported from D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.384385] pci 0000:03:00.0:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.392005] pci 0000:00:1c.4:
PCI bridge to [bus 03]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.392011] pci 0000:00:1c.4:
bridge window [mem 0xf7300000-0xf73fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.392100] pci 0000:04:00.0:
[1b21:1042] type 00 class 0x0c0330
Sep  9 10:44:05 Arbeits-PC kernel: [    0.392128] pci 0000:04:00.0:
reg 0x10: [mem 0xf7200000-0xf7207fff 64bit]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.392275] pci 0000:04:00.0:
PME# supported from D3hot D3cold
Sep  9 10:44:05 Arbeits-PC kernel: [    0.392307] pci 0000:04:00.0:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400018] pci 0000:00:1c.5:
PCI bridge to [bus 04]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400025] pci 0000:00:1c.5:
bridge window [mem 0xf7200000-0xf72fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400111] pci 0000:05:00.0:
[197b:2362] type 00 class 0x010185
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400146] pci 0000:05:00.0:
reg 0x10: [io  0xd040-0xd047]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400162] pci 0000:05:00.0:
reg 0x14: [io  0xd030-0xd033]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400179] pci 0000:05:00.0:
reg 0x18: [io  0xd020-0xd027]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400195] pci 0000:05:00.0:
reg 0x1c: [io  0xd010-0xd013]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400210] pci 0000:05:00.0:
reg 0x20: [io  0xd000-0xd00f]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400227] pci 0000:05:00.0:
reg 0x24: [mem 0xf7110000-0xf71101ff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400243] pci 0000:05:00.0:
reg 0x30: [mem 0x00000000-0x0000ffff pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400305] pci 0000:05:00.0:
PME# supported from D3hot
Sep  9 10:44:05 Arbeits-PC kernel: [    0.400333] pci 0000:05:00.0:
System wakeup disabled by ACPI
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408034] pci 0000:00:1c.6:
PCI bridge to [bus 05]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408038] pci 0000:00:1c.6:
bridge window [io  0xd000-0xdfff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408042] pci 0000:00:1c.6:
bridge window [mem 0xf7100000-0xf71fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408117] \_SB_.PCI0:_OSC invalid UUID
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408118] _OSC request data:1 1f 0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408122] acpi PNP0A08:00:
ACPI _OSC support notification failed, disabling PCIe ASPM
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408123] acpi PNP0A08:00:
Unable to request _OSC control (_OSC support mask: 0x08)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408525] ACPI: PCI Interrupt
Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408571] ACPI: PCI Interrupt
Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408615] ACPI: PCI Interrupt
Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408659] ACPI: PCI Interrupt
Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408703] ACPI: PCI Interrupt
Link [LNKE] (IRQs 3 *4 5 6 10 11 12 14 15)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408747] ACPI: PCI Interrupt
Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408791] ACPI: PCI Interrupt
Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.408835] ACPI: PCI Interrupt
Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409050] ACPI: Enabled 6 GPEs
in block 00 to 3F
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409056] ACPI: \_SB_.PCI0:
notify handler is installed
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409111] Found 1 acpi root devices
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409124] ACPI: EC: GPE =
0x18, I/O: command/status = 0x66, data = 0x62
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409199] vgaarb: device
added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409201] vgaarb: loaded
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409202] vgaarb: bridge
control possible 0000:01:00.0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409317] SCSI subsystem initialized
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409319] ACPI: bus type ATA registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409346] libata version 3.00 loaded.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409361] ACPI: bus type USB registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409372] usbcore: registered
new interface driver usbfs
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409378] usbcore: registered
new interface driver hub
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409393] usbcore: registered
new device driver usb
Sep  9 10:44:05 Arbeits-PC kernel: [    0.409467] PCI: Using ACPI for
IRQ routing
Sep  9 10:44:05 Arbeits-PC kernel: [    0.410911] PCI:
pci_cache_line_size set to 64 bytes
Sep  9 10:44:05 Arbeits-PC kernel: [    0.410965] e820: reserve RAM
buffer [mem 0x0009f000-0x0009ffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.410966] e820: reserve RAM
buffer [mem 0xdeb8f000-0xdfffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.410968] e820: reserve RAM
buffer [mem 0xdf800000-0xdfffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.410969] e820: reserve RAM
buffer [mem 0x21f000000-0x21fffffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.411031] NetLabel: Initializing
Sep  9 10:44:05 Arbeits-PC kernel: [    0.411032] NetLabel:  domain
hash size = 128
Sep  9 10:44:05 Arbeits-PC kernel: [    0.411033] NetLabel:  protocols
= UNLABELED CIPSOv4
Sep  9 10:44:05 Arbeits-PC kernel: [    0.411040] NetLabel:  unlabeled
traffic allowed by default
Sep  9 10:44:05 Arbeits-PC kernel: [    0.411088] hpet0: at MMIO
0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.411093] hpet0: 8
comparators, 64-bit 14.318180 MHz counter
Sep  9 10:44:05 Arbeits-PC kernel: [    0.413117] Switched to clocksource hpet
Sep  9 10:44:05 Arbeits-PC kernel: [    0.416836] AppArmor: AppArmor
Filesystem Enabled
Sep  9 10:44:05 Arbeits-PC kernel: [    0.416855] pnp: PnP ACPI init
Sep  9 10:44:05 Arbeits-PC kernel: [    0.416865] ACPI: bus type PNP registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.416932] system 00:00: [mem
0xfed40000-0xfed44fff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.416935] system 00:00: Plug
and Play ACPI device, IDs PNP0c01 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.416946] pnp 00:01: [dma 4]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.416961] pnp 00:01: Plug and
Play ACPI device, IDs PNP0200 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.416975] pnp 00:02: Plug and
Play ACPI device, IDs INT0800 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417052] pnp 00:03: Plug and
Play ACPI device, IDs PNP0103 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417084] system 00:04: [io
0x0680-0x069f] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417086] system 00:04: [io
0x0200-0x020f] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417088] system 00:04: [io
0xffff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417090] system 00:04: [io
0xffff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417092] system 00:04: [io
0x0400-0x0453] could not be reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417093] system 00:04: [io
0x0458-0x047f] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417095] system 00:04: [io
0x0500-0x057f] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417097] system 00:04: [io
0x164e-0x164f] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417099] system 00:04: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417132] pnp 00:05: Plug and
Play ACPI device, IDs PNP0b00 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417169] system 00:06: [io
0x0454-0x0457] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417171] system 00:06: Plug
and Play ACPI device, IDs INT3f0d PNP0c02 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417238] system 00:07: [io
0x0290-0x029f] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417240] system 00:07: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417278] system 00:08: [io
0x04d0-0x04d1] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417280] system 00:08: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417300] pnp 00:09: Plug and
Play ACPI device, IDs PNP0c04 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417526] system 00:0a: [mem
0xfed1c000-0xfed1ffff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417528] system 00:0a: [mem
0xfed10000-0xfed17fff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417530] system 00:0a: [mem
0xfed18000-0xfed18fff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417531] system 00:0a: [mem
0xfed19000-0xfed19fff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417533] system 00:0a: [mem
0xf8000000-0xfbffffff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417535] system 00:0a: [mem
0xfed20000-0xfed3ffff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417536] system 00:0a: [mem
0xfed90000-0xfed93fff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417538] system 00:0a: [mem
0xfed45000-0xfed8ffff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417540] system 00:0a: [mem
0xff000000-0xffffffff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417542] system 00:0a: [mem
0xfee00000-0xfeefffff] could not be reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417543] system 00:0a: [mem
0xe0000000-0xe0000fff] has been reserved
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417546] system 00:0a: Plug
and Play ACPI device, IDs PNP0c02 (active)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417647] pnp: PnP ACPI: found
11 devices
Sep  9 10:44:05 Arbeits-PC kernel: [    0.417648] ACPI: bus type PNP
unregistered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423633] pci 0000:00:1c.0:
bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423636] pci 0000:00:1c.0:
bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02]
add_size 200000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423638] pci 0000:00:1c.0:
bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423662] pci 0000:00:1c.0:
res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423664] pci 0000:00:1c.0:
res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size
add_size 200000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423666] pci 0000:00:1c.0:
res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423670] pci 0000:00:1c.0:
BAR 14: assigned [mem 0xe0100000-0xe02fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423672] pci 0000:00:1c.0:
BAR 15: assigned [mem 0xe0300000-0xe04fffff 64bit pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423675] pci 0000:00:1c.6:
BAR 15: assigned [mem 0xe0500000-0xe05fffff pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423677] pci 0000:00:1c.0:
BAR 13: assigned [io  0x2000-0x2fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423679] pci 0000:00:01.0:
PCI bridge to [bus 01]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423682] pci 0000:00:01.0:
bridge window [io  0xe000-0xefff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423684] pci 0000:00:01.0:
bridge window [mem 0xf6000000-0xf70fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423687] pci 0000:00:01.0:
bridge window [mem 0xe8000000-0xf1ffffff 64bit pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423690] pci 0000:00:1c.0:
PCI bridge to [bus 02]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423693] pci 0000:00:1c.0:
bridge window [io  0x2000-0x2fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423700] pci 0000:00:1c.0:
bridge window [mem 0xe0100000-0xe02fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423704] pci 0000:00:1c.0:
bridge window [mem 0xe0300000-0xe04fffff 64bit pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423713] pci 0000:00:1c.4:
PCI bridge to [bus 03]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423718] pci 0000:00:1c.4:
bridge window [mem 0xf7300000-0xf73fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423726] pci 0000:00:1c.5:
PCI bridge to [bus 04]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423731] pci 0000:00:1c.5:
bridge window [mem 0xf7200000-0xf72fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423739] pci 0000:05:00.0:
BAR 6: assigned [mem 0xe0500000-0xe050ffff pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423741] pci 0000:00:1c.6:
PCI bridge to [bus 05]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423744] pci 0000:00:1c.6:
bridge window [io  0xd000-0xdfff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423749] pci 0000:00:1c.6:
bridge window [mem 0xf7100000-0xf71fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.423753] pci 0000:00:1c.6:
bridge window [mem 0xe0500000-0xe05fffff pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424052] pci_bus 0000:00:
resource 4 [io  0x0000-0x0cf7]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424054] pci_bus 0000:00:
resource 5 [io  0x0d00-0xffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424056] pci_bus 0000:00:
resource 6 [mem 0x000a0000-0x000bffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424057] pci_bus 0000:00:
resource 7 [mem 0x000d4000-0x000d7fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424059] pci_bus 0000:00:
resource 8 [mem 0x000d8000-0x000dbfff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424060] pci_bus 0000:00:
resource 9 [mem 0x000dc000-0x000dffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424062] pci_bus 0000:00:
resource 10 [mem 0xe0000000-0xfeafffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424063] pci_bus 0000:01:
resource 0 [io  0xe000-0xefff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424065] pci_bus 0000:01:
resource 1 [mem 0xf6000000-0xf70fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424066] pci_bus 0000:01:
resource 2 [mem 0xe8000000-0xf1ffffff 64bit pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424068] pci_bus 0000:02:
resource 0 [io  0x2000-0x2fff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424069] pci_bus 0000:02:
resource 1 [mem 0xe0100000-0xe02fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424071] pci_bus 0000:02:
resource 2 [mem 0xe0300000-0xe04fffff 64bit pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424072] pci_bus 0000:03:
resource 1 [mem 0xf7300000-0xf73fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424074] pci_bus 0000:04:
resource 1 [mem 0xf7200000-0xf72fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424076] pci_bus 0000:05:
resource 0 [io  0xd000-0xdfff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424077] pci_bus 0000:05:
resource 1 [mem 0xf7100000-0xf71fffff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424079] pci_bus 0000:05:
resource 2 [mem 0xe0500000-0xe05fffff pref]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424101] NET: Registered
protocol family 2
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424255] TCP established hash
table entries: 65536 (order: 8, 1048576 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424422] TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424533] TCP: Hash tables
configured (established 65536 bind 65536)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424550] TCP: reno registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424560] UDP hash table
entries: 4096 (order: 5, 131072 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424587] UDP-Lite hash table
entries: 4096 (order: 5, 131072 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.424642] NET: Registered
protocol family 1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.465287] pci 0000:01:00.0:
Boot video device
Sep  9 10:44:05 Arbeits-PC kernel: [    0.465428] PCI: CLS 64 bytes, default 64
Sep  9 10:44:05 Arbeits-PC kernel: [    0.465460] Trying to unpack
rootfs image as initramfs...
Sep  9 10:44:05 Arbeits-PC kernel: [    0.695776] Freeing initrd
memory: 16096K (ffff880036080000 - ffff880037038000)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.695781] PCI-DMA: Using
software bounce buffering for IO (SWIOTLB)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.695783] software IO TLB [mem
0xdab8f000-0xdeb8f000] (64MB) mapped at
[ffff8800dab8f000-ffff8800deb8efff]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.695976] Scanning for low
memory corruption every 60 seconds
Sep  9 10:44:05 Arbeits-PC kernel: [    0.696171] Initialise module verification
Sep  9 10:44:05 Arbeits-PC kernel: [    0.696206] audit: initializing
netlink socket (disabled)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.696214] type=2000
audit(1378716243.480:1): initialized
Sep  9 10:44:05 Arbeits-PC kernel: [    0.720007] bounce pool size: 64 pages
Sep  9 10:44:05 Arbeits-PC kernel: [    0.720014] HugeTLB registered 2
MB page size, pre-allocated 0 pages
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721073] VFS: Disk quotas dquot_6.5.2
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721104] Dquot-cache hash
table entries: 512 (order 0, 4096 bytes)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721447] fuse init (API version 7.22)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721501] msgmni has been set to 15899
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721851] Key type asymmetric registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721852] Asymmetric key
parser 'x509' registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721874] Block layer SCSI
generic (bsg) driver version 0.4 loaded (major 252)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721901] io scheduler noop registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721902] io scheduler
deadline registered (default)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721919] io scheduler cfq registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.721986] pcieport
0000:00:01.0: irq 40 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.722196] pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Sep  9 10:44:05 Arbeits-PC kernel: [    0.722207] pciehp: PCI Express
Hot Plug Controller Driver version: 0.4
Sep  9 10:44:05 Arbeits-PC kernel: [    0.722261] efifb: probing for efifb
Sep  9 10:44:05 Arbeits-PC kernel: [    0.722425] efifb: framebuffer
at 0xf1000000, mapped to 0xffffc9000a000000, using 1920k, total 1920k
Sep  9 10:44:05 Arbeits-PC kernel: [    0.722427] efifb: mode is
800x600x32, linelength=3200, pages=1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.722427] efifb: scrolling: redraw
Sep  9 10:44:05 Arbeits-PC kernel: [    0.722429] efifb: Truecolor:
size=8:8:8:8, shift=24:16:8:0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.723283] Console: switching
to colour frame buffer device 100x37
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724074] fb0: EFI VGA frame
buffer device
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724078] intel_idle: MWAIT
substates: 0x1120
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724079] intel_idle: v0.4 model 0x2A
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724080] intel_idle:
lapic_timer_reliable_states 0xffffffff
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724153] input: Power Button
as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724158] ACPI: Power Button [PWRB]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724185] input: Power Button
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724187] ACPI: Power Button [PWRF]
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724244] ACPI: Fan [FAN0] (off)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724263] ACPI: Fan [FAN1] (off)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724282] ACPI: Fan [FAN2] (off)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724299] ACPI: Fan [FAN3] (off)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724317] ACPI: Fan [FAN4] (off)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.724356] ACPI: Requesting acpi_cpufreq
Sep  9 10:44:05 Arbeits-PC kernel: [    0.737929] thermal LNXTHERM:00:
registered as thermal_zone0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.737932] ACPI: Thermal Zone
[TZ00] (28 C)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.738115] thermal LNXTHERM:01:
registered as thermal_zone1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.738117] ACPI: Thermal Zone
[TZ01] (30 C)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.738148] GHES: HEST is not enabled!
Sep  9 10:44:05 Arbeits-PC kernel: [    0.738199] Serial: 8250/16550
driver, 32 ports, IRQ sharing enabled
Sep  9 10:44:05 Arbeits-PC kernel: [    0.739193] Linux agpgart interface v0.103
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740065] brd: module loaded
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740541] loop: module loaded
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740776] libphy: Fixed MDIO Bus: probed
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740832] tun: Universal
TUN/TAP device driver, 1.6
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740833] tun: (C) 1999-2004
Max Krasnyansky <maxk@qualcomm.com>
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740860] PPP generic driver
version 2.4.2
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740890] ehci_hcd: USB 2.0
'Enhanced' Host Controller (EHCI) Driver
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740892] ehci-pci: EHCI PCI
platform driver
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740975] ehci-pci
0000:00:1a.0: setting latency timer to 64
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740982] ehci-pci
0000:00:1a.0: EHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740986] ehci-pci
0000:00:1a.0: new USB bus registered, assigned bus number 1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.740999] ehci-pci
0000:00:1a.0: debug port 2
Sep  9 10:44:05 Arbeits-PC kernel: [    0.744890] ehci-pci
0000:00:1a.0: cache line size of 64 is not supported
Sep  9 10:44:05 Arbeits-PC kernel: [    0.744905] ehci-pci
0000:00:1a.0: irq 16, io mem 0xf7428000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753575] ehci-pci
0000:00:1a.0: USB 2.0 started, EHCI 1.00
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753598] usb usb1: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753600] usb usb1: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753602] usb usb1: Product:
EHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753603] usb usb1:
Manufacturer: Linux 3.11.0-031100-generic ehci_hcd
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753604] usb usb1:
SerialNumber: 0000:00:1a.0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753680] hub 1-0:1.0: USB hub found
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753685] hub 1-0:1.0: 2 ports detected
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753837] ehci-pci
0000:00:1d.0: setting latency timer to 64
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753843] ehci-pci
0000:00:1d.0: EHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753847] ehci-pci
0000:00:1d.0: new USB bus registered, assigned bus number 2
Sep  9 10:44:05 Arbeits-PC kernel: [    0.753859] ehci-pci
0000:00:1d.0: debug port 2
Sep  9 10:44:05 Arbeits-PC kernel: [    0.757754] ehci-pci
0000:00:1d.0: cache line size of 64 is not supported
Sep  9 10:44:05 Arbeits-PC kernel: [    0.757768] ehci-pci
0000:00:1d.0: irq 23, io mem 0xf7427000
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769597] ehci-pci
0000:00:1d.0: USB 2.0 started, EHCI 1.00
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769608] usb usb2: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769610] usb usb2: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769611] usb usb2: Product:
EHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769612] usb usb2:
Manufacturer: Linux 3.11.0-031100-generic ehci_hcd
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769614] usb usb2:
SerialNumber: 0000:00:1d.0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769679] hub 2-0:1.0: USB hub found
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769682] hub 2-0:1.0: 2 ports detected
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769755] ehci-platform: EHCI
generic platform driver
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769761] ohci_hcd: USB 1.1
'Open' Host Controller (OHCI) Driver
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769762] ohci-platform: OHCI
generic platform driver
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769766] uhci_hcd: USB
Universal Host Controller Interface driver
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769822] xhci_hcd
0000:03:00.0: xHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.769826] xhci_hcd
0000:03:00.0: new USB bus registered, assigned bus number 3
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831066] xhci_hcd
0000:03:00.0: irq 41 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831070] xhci_hcd
0000:03:00.0: irq 42 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831074] xhci_hcd
0000:03:00.0: irq 43 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831078] xhci_hcd
0000:03:00.0: irq 44 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831081] xhci_hcd
0000:03:00.0: irq 45 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831169] usb usb3: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831171] usb usb3: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831172] usb usb3: Product:
xHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831173] usb usb3:
Manufacturer: Linux 3.11.0-031100-generic xhci_hcd
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831175] usb usb3:
SerialNumber: 0000:03:00.0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831221] xHCI
xhci_add_endpoint called for root hub
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831223] xHCI
xhci_check_bandwidth called for root hub
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831238] hub 3-0:1.0: USB hub found
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831245] hub 3-0:1.0: 2 ports detected
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831295] xhci_hcd
0000:03:00.0: xHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831298] xhci_hcd
0000:03:00.0: new USB bus registered, assigned bus number 4
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831331] usb usb4: New USB
device found, idVendor=1d6b, idProduct=0003
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831333] usb usb4: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831334] usb usb4: Product:
xHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831336] usb usb4:
Manufacturer: Linux 3.11.0-031100-generic xhci_hcd
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831337] usb usb4:
SerialNumber: 0000:03:00.0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831380] xHCI
xhci_add_endpoint called for root hub
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831381] xHCI
xhci_check_bandwidth called for root hub
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831395] hub 4-0:1.0: USB hub found
Sep  9 10:44:05 Arbeits-PC kernel: [    0.831401] hub 4-0:1.0: 2 ports detected
Sep  9 10:44:05 Arbeits-PC kernel: [    0.837731] xhci_hcd
0000:04:00.0: xHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.837735] xhci_hcd
0000:04:00.0: new USB bus registered, assigned bus number 5
Sep  9 10:44:05 Arbeits-PC kernel: [    0.898985] xhci_hcd
0000:04:00.0: irq 46 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.898991] xhci_hcd
0000:04:00.0: irq 47 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.898995] xhci_hcd
0000:04:00.0: irq 48 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899000] xhci_hcd
0000:04:00.0: irq 49 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899003] xhci_hcd
0000:04:00.0: irq 50 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899094] usb usb5: New USB
device found, idVendor=1d6b, idProduct=0002
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899096] usb usb5: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899097] usb usb5: Product:
xHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899099] usb usb5:
Manufacturer: Linux 3.11.0-031100-generic xhci_hcd
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899100] usb usb5:
SerialNumber: 0000:04:00.0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899146] xHCI
xhci_add_endpoint called for root hub
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899147] xHCI
xhci_check_bandwidth called for root hub
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899163] hub 5-0:1.0: USB hub found
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899170] hub 5-0:1.0: 2 ports detected
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899222] xhci_hcd
0000:04:00.0: xHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899225] xhci_hcd
0000:04:00.0: new USB bus registered, assigned bus number 6
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899255] usb usb6: New USB
device found, idVendor=1d6b, idProduct=0003
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899257] usb usb6: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899258] usb usb6: Product:
xHCI Host Controller
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899260] usb usb6:
Manufacturer: Linux 3.11.0-031100-generic xhci_hcd
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899261] usb usb6:
SerialNumber: 0000:04:00.0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899303] xHCI
xhci_add_endpoint called for root hub
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899304] xHCI
xhci_check_bandwidth called for root hub
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899317] hub 6-0:1.0: USB hub found
Sep  9 10:44:05 Arbeits-PC kernel: [    0.899324] hub 6-0:1.0: 2 ports detected
Sep  9 10:44:05 Arbeits-PC kernel: [    0.905808] i8042: PNP: No PS/2
controller found. Probing ports directly.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908271] serio: i8042 KBD
port at 0x60,0x64 irq 1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908274] serio: i8042 AUX
port at 0x60,0x64 irq 12
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908352] mousedev: PS/2 mouse
device common for all mice
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908443] rtc_cmos 00:05: RTC
can wake from S4
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908552] rtc_cmos 00:05: rtc
core: registered rtc_cmos as rtc0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908578] rtc_cmos 00:05:
alarms up to one month, y3k, 242 bytes nvram, hpet irqs
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908622] device-mapper:
uevent: version 1.0.3
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908663] device-mapper:
ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908668] Intel P-state driver
initializing.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908675] Intel pstate
controlling: cpu 0
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908687] Intel pstate
controlling: cpu 1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908695] Intel pstate
controlling: cpu 2
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908703] Intel pstate
controlling: cpu 3
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908775] cpuidle: using governor ladder
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908850] cpuidle: using governor menu
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908857] ledtrig-cpu:
registered to indicate activity on CPUs
Sep  9 10:44:05 Arbeits-PC kernel: [    0.908858] EFI Variables
Facility v0.08 2004-May-17
Sep  9 10:44:05 Arbeits-PC kernel: [    0.957492] hpet1: lost 2 rtc interrupts
Sep  9 10:44:05 Arbeits-PC kernel: [    0.958828] ashmem: initialized
Sep  9 10:44:05 Arbeits-PC kernel: [    0.958944] TCP: cubic registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.959007] NET: Registered
protocol family 10
Sep  9 10:44:05 Arbeits-PC kernel: [    0.959130] NET: Registered
protocol family 17
Sep  9 10:44:05 Arbeits-PC kernel: [    0.959136] Key type
dns_resolver registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.959306] PM: Hibernation
image not present or could not be loaded.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.959308] Loading module
verification certificates
Sep  9 10:44:05 Arbeits-PC kernel: [    0.960020] MODSIGN: Loaded cert
'Magrathea: Glacier signing key:
394cd8cbf63c2fa10ba65b7514a71f2cce77b906'
Sep  9 10:44:05 Arbeits-PC kernel: [    0.960028] registered taskstats version 1
Sep  9 10:44:05 Arbeits-PC kernel: [    0.962439] Key type trusted registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.964384] Key type encrypted registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.966887]   Magic number: 13:225:725
Sep  9 10:44:05 Arbeits-PC kernel: [    0.966893] block loop5: hash matches
Sep  9 10:44:05 Arbeits-PC kernel: [    0.966917] pci 0000:01:00.0: hash matches
Sep  9 10:44:05 Arbeits-PC kernel: [    0.966989] rtc_cmos 00:05:
setting system clock to 2013-09-09 08:44:04 UTC (1378716244)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.967157] BIOS EDD facility
v0.16 2004-Jun-25, 0 devices found
Sep  9 10:44:05 Arbeits-PC kernel: [    0.967159] EDD information not available.
Sep  9 10:44:05 Arbeits-PC kernel: [    0.968144] Freeing unused
kernel memory: 1380K (ffffffff81d10000 - ffffffff81e69000)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.968145] Write protecting the
kernel read-only data: 12288k
Sep  9 10:44:05 Arbeits-PC kernel: [    0.969564] Freeing unused
kernel memory: 780K (ffff88000e73d000 - ffff88000e800000)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.970691] Freeing unused
kernel memory: 676K (ffff88000eb57000 - ffff88000ec00000)
Sep  9 10:44:05 Arbeits-PC kernel: [    0.997664] pps_core: LinuxPPS
API ver. 1 registered
Sep  9 10:44:05 Arbeits-PC kernel: [    0.997666] pps_core: Software
ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
Sep  9 10:44:05 Arbeits-PC kernel: [    0.998750] PTP clock support registered
Sep  9 10:44:05 Arbeits-PC kernel: [    1.003029] e1000e: Intel(R)
PRO/1000 Network Driver - 2.3.2-k
Sep  9 10:44:05 Arbeits-PC kernel: [    1.003032] e1000e: Copyright(c)
1999 - 2013 Intel Corporation.
Sep  9 10:44:05 Arbeits-PC kernel: [    1.003145] e1000e 0000:00:19.0:
setting latency timer to 64
Sep  9 10:44:05 Arbeits-PC kernel: [    1.003194] e1000e 0000:00:19.0:
Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
Sep  9 10:44:05 Arbeits-PC kernel: [    1.003211] e1000e 0000:00:19.0:
irq 51 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    1.110050] usb 1-1: new
high-speed USB device number 2 using ehci-pci
Sep  9 10:44:05 Arbeits-PC kernel: [    1.242649] usb 1-1: New USB
device found, idVendor=8087, idProduct=0024
Sep  9 10:44:05 Arbeits-PC kernel: [    1.242652] usb 1-1: New USB
device strings: Mfr=0, Product=0, SerialNumber=0
Sep  9 10:44:05 Arbeits-PC kernel: [    1.242894] hub 1-1:1.0: USB hub found
Sep  9 10:44:05 Arbeits-PC kernel: [    1.243007] hub 1-1:1.0: 6 ports detected
Sep  9 10:44:05 Arbeits-PC kernel: [    1.269774] e1000e 0000:00:19.0
eth0: registered PHC clock
Sep  9 10:44:05 Arbeits-PC kernel: [    1.269777] e1000e 0000:00:19.0
eth0: (PCI Express:2.5GT/s:Width x1) 54:04:a6:2a:65:f6
Sep  9 10:44:05 Arbeits-PC kernel: [    1.269779] e1000e 0000:00:19.0
eth0: Intel(R) PRO/1000 Network Connection
Sep  9 10:44:05 Arbeits-PC kernel: [    1.269827] e1000e 0000:00:19.0
eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
Sep  9 10:44:05 Arbeits-PC kernel: [    1.269863] ahci 0000:00:1f.2: version 3.0
Sep  9 10:44:05 Arbeits-PC kernel: [    1.269983] ahci 0000:00:1f.2:
irq 52 for MSI/MSI-X
Sep  9 10:44:05 Arbeits-PC kernel: [    1.282304] ahci 0000:00:1f.2:
AHCI 0001.0300 32 slots 6 ports 6 Gbps 0xb impl SATA mode
Sep  9 10:44:05 Arbeits-PC kernel: [    1.282307] ahci 0000:00:1f.2:
flags: 64bit ncq led clo pio slum part ems apst
Sep  9 10:44:05 Arbeits-PC kernel: [    1.282311] ahci 0000:00:1f.2:
setting latency timer to 64
Sep  9 10:44:05 Arbeits-PC kernel: [    1.298702] scsi0 : ahci
Sep  9 10:44:05 Arbeits-PC kernel: [    1.298844] scsi1 : ahci
Sep  9 10:44:05 Arbeits-PC kernel: [    1.298994] scsi2 : ahci
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299107] scsi3 : ahci
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299230] scsi4 : ahci
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299349] scsi5 : ahci
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299437] ata1: SATA max
UDMA/133 abar m2048@0xf7426000 port 0xf7426100 irq 52
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299440] ata2: SATA max
UDMA/133 abar m2048@0xf7426000 port 0xf7426180 irq 52
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299441] ata3: DUMMY
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299443] ata4: SATA max
UDMA/133 abar m2048@0xf7426000 port 0xf7426280 irq 52
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299444] ata5: DUMMY
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299445] ata6: DUMMY
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299581] ahci 0000:05:00.0:
AHCI 0001.0100 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299583] ahci 0000:05:00.0:
flags: 64bit ncq pm led clo pmp pio slum part
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299776] scsi6 : ahci
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299867] scsi7 : ahci
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299898] ata7: SATA max
UDMA/133 abar m512@0xf7110000 port 0xf7110100 irq 18
Sep  9 10:44:05 Arbeits-PC kernel: [    1.299901] ata8: SATA max
UDMA/133 abar m512@0xf7110000 port 0xf7110180 irq 18
Sep  9 10:44:05 Arbeits-PC kernel: [    1.354389] usb 2-1: new
high-speed USB device number 2 using ehci-pci
Sep  9 10:44:05 Arbeits-PC kernel: [    1.486938] usb 2-1: New USB
device found, idVendor=8087, idProduct=0024
Sep  9 10:44:05 Arbeits-PC kernel: [    1.486941] usb 2-1: New USB
device strings: Mfr=0, Product=0, SerialNumber=0
Sep  9 10:44:05 Arbeits-PC kernel: [    1.487196] hub 2-1:1.0: USB hub found
Sep  9 10:44:05 Arbeits-PC kernel: [    1.487311] hub 2-1:1.0: 8 ports detected
Sep  9 10:44:05 Arbeits-PC kernel: [    1.618770] ata7: SATA link down
(SStatus 0 SControl 300)
Sep  9 10:44:05 Arbeits-PC kernel: [    1.618773] ata2: SATA link up
3.0 Gbps (SStatus 123 SControl 300)
Sep  9 10:44:05 Arbeits-PC kernel: [    1.618812] ata4: SATA link up
1.5 Gbps (SStatus 113 SControl 300)
Sep  9 10:44:05 Arbeits-PC kernel: [    1.618821] ata8: SATA link down
(SStatus 0 SControl 300)
Sep  9 10:44:05 Arbeits-PC kernel: [    1.618846] ata1: SATA link up
6.0 Gbps (SStatus 133 SControl 300)
Sep  9 10:44:05 Arbeits-PC kernel: [    1.619589] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20130517/psargs-359)
Sep  9 10:44:05 Arbeits-PC kernel: [    1.619597] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node
ffff8802130be348), AE_NOT_FOUND (20130517/psparse-536)
Sep  9 10:44:06 Arbeits-PC avahi-daemon[954]: Successfully called chroot().
Sep  9 10:44:06 Arbeits-PC avahi-daemon[954]: Successfully dropped
remaining capabilities.
Sep  9 10:44:06 Arbeits-PC kernel: [    1.619774] ata2.00: HPA
detected: current 1250261615, native 1250263728
Sep  9 10:44:06 Arbeits-PC kernel: [    1.619901] ata2.00: ATA-8: WDC
WD6400AAKS-07A7B0, 01.03B01, max UDMA/133
Sep  9 10:44:06 Arbeits-PC kernel: [    1.619905] ata2.00: 1250261615
sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Sep  9 10:44:06 Arbeits-PC kernel: [    1.620826] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20130517/psargs-359)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.620834] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node
ffff8802130be348), AE_NOT_FOUND (20130517/psparse-536)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.621131] ata2.00: configured
for UDMA/133
Sep  9 10:44:06 Arbeits-PC kernel: [    1.621911] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20130517/psargs-359)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.621919] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT3._GTF] (Node
ffff8802130be438), AE_NOT_FOUND (20130517/psparse-536)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.621930] ata4.00: ATAPI:
HL-DT-ST DVDRAM GH22LS50, TL02, max UDMA/100
Sep  9 10:44:06 Arbeits-PC kernel: [    1.625708] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20130517/psargs-359)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.625716] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT3._GTF] (Node
ffff8802130be438), AE_NOT_FOUND (20130517/psparse-536)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.625729] ata4.00: configured
for UDMA/100
Sep  9 10:44:06 Arbeits-PC kernel: [    1.629945] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20130517/psargs-359)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.629953] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node
ffff8802130be2d0), AE_NOT_FOUND (20130517/psparse-536)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.630798] ata1.00: ATA-8:
SanDisk SDSSDX120GG25, R112, max UDMA/133
Sep  9 10:44:06 Arbeits-PC kernel: [    1.630802] ata1.00: 234441648
sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Sep  9 10:44:06 Arbeits-PC kernel: [    1.639960] ACPI Error: [DSSP]
Namespace lookup failure, AE_NOT_FOUND (20130517/psargs-359)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.639968] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node
ffff8802130be2d0), AE_NOT_FOUND (20130517/psparse-536)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.640689] ata1.00: configured
for UDMA/133
Sep  9 10:44:06 Arbeits-PC kernel: [    1.640913] scsi 0:0:0:0:
Direct-Access     ATA      SanDisk SDSSDX12 R112 PQ: 0 ANSI: 5
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641106] sd 0:0:0:0: [sda]
234441648 512-byte logical blocks: (120 GB/111 GiB)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641161] sd 0:0:0:0: Attached
scsi generic sg0 type 0
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641165] sd 0:0:0:0: [sda]
Write Protect is off
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641168] sd 0:0:0:0: [sda]
Mode Sense: 00 3a 00 00
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641185] sd 0:0:0:0: [sda]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641410] scsi 1:0:0:0:
Direct-Access     ATA      WDC WD6400AAKS-0 01.0 PQ: 0 ANSI: 5
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641602] sd 1:0:0:0: [sdb]
1250261615 512-byte logical blocks: (640 GB/596 GiB)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641616] sd 1:0:0:0: Attached
scsi generic sg1 type 0
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641664] sd 1:0:0:0: [sdb]
Write Protect is off
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641667] sd 1:0:0:0: [sdb]
Mode Sense: 00 3a 00 00
Sep  9 10:44:06 Arbeits-PC kernel: [    1.641712] sd 1:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep  9 10:44:06 Arbeits-PC kernel: [    1.642390]  sda: sda1 sda2 sda3
Sep  9 10:44:06 Arbeits-PC kernel: [    1.642660] sd 0:0:0:0: [sda]
Attached SCSI disk
Sep  9 10:44:06 Arbeits-PC kernel: [    1.645000] scsi 3:0:0:0: CD-ROM
           HL-DT-ST DVDRAM GH22LS50  TL02 PQ: 0 ANSI: 5
Sep  9 10:44:06 Arbeits-PC kernel: [    1.653499] sr0: scsi3-mmc
drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Sep  9 10:44:06 Arbeits-PC kernel: [    1.653503] cdrom: Uniform
CD-ROM driver Revision: 3.20
Sep  9 10:44:06 Arbeits-PC kernel: [    1.653692] sr 3:0:0:0: Attached
scsi CD-ROM sr0
Sep  9 10:44:06 Arbeits-PC kernel: [    1.653777] sr 3:0:0:0: Attached
scsi generic sg2 type 5
Sep  9 10:44:06 Arbeits-PC kernel: [    1.654788] usb 3-1: new
high-speed USB device number 2 using xhci_hcd
Sep  9 10:44:06 Arbeits-PC kernel: [    1.671738] usb 3-1: New USB
device found, idVendor=1058, idProduct=1021
Sep  9 10:44:06 Arbeits-PC kernel: [    1.671742] usb 3-1: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Sep  9 10:44:06 Arbeits-PC kernel: [    1.671744] usb 3-1: Product: Ext HDD 1021
Sep  9 10:44:06 Arbeits-PC kernel: [    1.671746] usb 3-1:
Manufacturer: Western Digital
Sep  9 10:44:06 Arbeits-PC kernel: [    1.671748] usb 3-1:
SerialNumber: 574D43315430333633353930
Sep  9 10:44:06 Arbeits-PC kernel: [    1.677018] usb-storage 3-1:1.0:
USB Mass Storage device detected
Sep  9 10:44:06 Arbeits-PC kernel: [    1.677230] scsi8 : usb-storage 3-1:1.0
Sep  9 10:44:06 Arbeits-PC kernel: [    1.677284] usbcore: registered
new interface driver usb-storage
Sep  9 10:44:06 Arbeits-PC kernel: [    1.694813] tsc: Refined TSC
clocksource calibration: 2809.165 MHz
Sep  9 10:44:06 Arbeits-PC kernel: [    1.708397]  sdb: sdb1
Sep  9 10:44:06 Arbeits-PC kernel: [    1.708771] sd 1:0:0:0: [sdb]
Attached SCSI disk
Sep  9 10:44:06 Arbeits-PC kernel: [    1.720094] EXT4-fs (sda2):
INFO: recovery required on readonly filesystem
Sep  9 10:44:06 Arbeits-PC kernel: [    1.720097] EXT4-fs (sda2):
write access will be enabled during recovery
Sep  9 10:44:06 Arbeits-PC kernel: [    1.764112] EXT4-fs (sda2):
recovery complete
Sep  9 10:44:06 Arbeits-PC kernel: [    1.764529] EXT4-fs (sda2):
mounted filesystem with ordered data mode. Opts: (null)
Sep  9 10:44:06 Arbeits-PC kernel: [    1.839020] usb 3-2: new
high-speed USB device number 3 using xhci_hcd
Sep  9 10:44:06 Arbeits-PC kernel: [    1.855910] usb 3-2: New USB
device found, idVendor=18d1, idProduct=4ee1
Sep  9 10:44:06 Arbeits-PC kernel: [    1.855913] usb 3-2: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Sep  9 10:44:06 Arbeits-PC kernel: [    1.855915] usb 3-2: Product: Nexus 4
Sep  9 10:44:06 Arbeits-PC kernel: [    1.855916] usb 3-2: Manufacturer: LGE
Sep  9 10:44:06 Arbeits-PC kernel: [    1.855918] usb 3-2:
SerialNumber: 00294807ce91f316
Sep  9 10:44:06 Arbeits-PC kernel: [    1.927256] usb 1-1.3: new
high-speed USB device number 3 using ehci-pci
Sep  9 10:44:06 Arbeits-PC kernel: [    1.957959] Adding 8354812k swap
on /dev/sda3.  Priority:-1 extents:1 across:8354812k SSFS
Sep  9 10:44:06 Arbeits-PC kernel: [    2.021111] usb 1-1.3: New USB
device found, idVendor=0bda, idProduct=8178
Sep  9 10:44:06 Arbeits-PC kernel: [    2.021114] usb 1-1.3: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Sep  9 10:44:06 Arbeits-PC kernel: [    2.021115] usb 1-1.3: Product: USB WLAN
Sep  9 10:44:06 Arbeits-PC kernel: [    2.021117] usb 1-1.3:
Manufacturer: 802.11n
Sep  9 10:44:06 Arbeits-PC kernel: [    2.021118] usb 1-1.3:
SerialNumber: 00e04c000001
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051223] ACPI Warning:
0x0000000000000428-0x000000000000042f SystemIO conflicts with Region
\PMIO 1 (20130517/utaddress-251)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051229] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051232] ACPI Warning:
0x0000000000000540-0x000000000000054f SystemIO conflicts with Region
\GPIO 1 (20130517/utaddress-251)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051235] ACPI Warning:
0x0000000000000540-0x000000000000054f SystemIO conflicts with Region
\_SB_.PCI0.LPCB.GPBX 2 (20130517/utaddress-251)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051237] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051238] ACPI Warning:
0x0000000000000530-0x000000000000053f SystemIO conflicts with Region
\GPIO 1 (20130517/utaddress-251)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051240] ACPI Warning:
0x0000000000000530-0x000000000000053f SystemIO conflicts with Region
\_SB_.PCI0.LPCB.GPBX 2 (20130517/utaddress-251)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051242] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051243] ACPI Warning:
0x0000000000000500-0x000000000000052f SystemIO conflicts with Region
\GPIO 1 (20130517/utaddress-251)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051245] ACPI Warning:
0x0000000000000500-0x000000000000052f SystemIO conflicts with Region
\_SB_.PCI0.LPCB.GPBX 2 (20130517/utaddress-251)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051247] ACPI: If an ACPI
driver is available for this device, you should use it instead of the
native driver
Sep  9 10:44:06 Arbeits-PC kernel: [    2.051248] lpc_ich: Resource
conflict(s) found affecting gpio_ich
Sep  9 10:44:06 Arbeits-PC kernel: [    2.058303] lp: driver loaded
but no devices found
Sep  9 10:44:06 Arbeits-PC kernel: [    2.072457] [drm] Initialized
drm 1.1.0 20060810
Sep  9 10:44:06 Arbeits-PC kernel: [    2.074941] mei_me 0000:00:16.0:
setting latency timer to 64
Sep  9 10:44:06 Arbeits-PC kernel: [    2.074975] mei_me 0000:00:16.0:
irq 53 for MSI/MSI-X
Sep  9 10:44:06 Arbeits-PC kernel: [    2.091457] usb 2-1.3: new
full-speed USB device number 3 using ehci-pci
Sep  9 10:44:06 Arbeits-PC kernel: [    2.169387] wmi: Mapper loaded
Sep  9 10:44:06 Arbeits-PC kernel: [    2.194965] usb 2-1.3: New USB
device found, idVendor=045e, idProduct=0768
Sep  9 10:44:06 Arbeits-PC kernel: [    2.194968] usb 2-1.3: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.194970] usb 2-1.3: Product:
Microsoft® SiderWinderTM X4 Keyboard
Sep  9 10:44:06 Arbeits-PC kernel: [    2.194971] usb 2-1.3:
Manufacturer: Microsoft
Sep  9 10:44:06 Arbeits-PC kernel: [    2.267685] usb 2-1.4: new
low-speed USB device number 4 using ehci-pci
Sep  9 10:44:06 Arbeits-PC kernel: [    2.290359] asus_wmi: ASUS WMI
generic driver loaded
Sep  9 10:44:06 Arbeits-PC kernel: [    2.293013] hidraw: raw HID
events driver (C) Jiri Kosina
Sep  9 10:44:06 Arbeits-PC kernel: [    2.294502] asus_wmi: Initialization: 0x0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.294520] asus_wmi: BIOS WMI
version: 0.9
Sep  9 10:44:06 Arbeits-PC kernel: [    2.294549] asus_wmi: SFUN value: 0x0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.297746] input: Eee PC WMI
hotkeys as /devices/platform/eeepc-wmi/input/input2
Sep  9 10:44:06 Arbeits-PC kernel: [    2.298710] asus_wmi: Disabling
ACPI video driver
Sep  9 10:44:06 Arbeits-PC kernel: [    2.308495] usbcore: registered
new interface driver usbhid
Sep  9 10:44:06 Arbeits-PC kernel: [    2.308497] usbhid: USB HID core driver
Sep  9 10:44:06 Arbeits-PC kernel: [    2.310164] type=1400
audit(1378716245.836:2): apparmor="STATUS" operation="profile_load"
name="/sbin/dhclient" pid=500 comm="apparmor_parser"
Sep  9 10:44:06 Arbeits-PC kernel: [    2.310209] type=1400
audit(1378716245.836:3): apparmor="STATUS" operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=500
comm="apparmor_parser"
Sep  9 10:44:06 Arbeits-PC kernel: [    2.310254] type=1400
audit(1378716245.836:4): apparmor="STATUS" operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" pid=500
comm="apparmor_parser"
Sep  9 10:44:06 Arbeits-PC kernel: [    2.317641] input: Microsoft
Microsoft® SiderWinderTM X4 Keyboard as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input3
Sep  9 10:44:06 Arbeits-PC kernel: [    2.318034] hid-generic
0003:045E:0768.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsoft
Microsoft® SiderWinderTM X4 Keyboard] on usb-0000:00:1d.0-1.3/input0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.320960] input: Microsoft
Microsoft® SiderWinderTM X4 Keyboard as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.1/input/input4
Sep  9 10:44:06 Arbeits-PC kernel: [    2.321779] hid-generic
0003:045E:0768.0002: input,hidraw1: USB HID v1.11 Keyboard [Microsoft
Microsoft® SiderWinderTM X4 Keyboard] on usb-0000:00:1d.0-1.3/input1
Sep  9 10:44:06 Arbeits-PC kernel: [    2.325540] EXT4-fs (sda2):
re-mounted. Opts: errors=remount-ro
Sep  9 10:44:06 Arbeits-PC kernel: [    2.325626] snd_hda_intel
0000:00:1b.0: enabling device (0000 -> 0002)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.325742] snd_hda_intel
0000:00:1b.0: irq 54 for MSI/MSI-X
Sep  9 10:44:06 Arbeits-PC kernel: [    2.330492] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:44:06 Arbeits-PC kernel: [    2.338347] SKU: Nid=0x0
sku_cfg=0x0000846b
Sep  9 10:44:06 Arbeits-PC kernel: [    2.338350] SKU: port_connectivity=0x0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.338351] SKU: enable_pcbeep=0x1
Sep  9 10:44:06 Arbeits-PC kernel: [    2.338351] SKU: check_sum=0x00000000
Sep  9 10:44:06 Arbeits-PC kernel: [    2.338352] SKU: customization=0x00000000
Sep  9 10:44:06 Arbeits-PC kernel: [    2.338353] SKU: external_amp=0x5
Sep  9 10:44:06 Arbeits-PC kernel: [    2.338354] SKU: platform_type=0x0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.338355] SKU: swap=0x1
Sep  9 10:44:06 Arbeits-PC kernel: [    2.338355] SKU: override=0x1
Sep  9 10:44:06 Arbeits-PC kernel: [    2.339058] autoconfig:
line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
Sep  9 10:44:06 Arbeits-PC kernel: [    2.339060]    speaker_outs=0
(0x0/0x0/0x0/0x0/0x0)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.339061]    hp_outs=1
(0x1b/0x0/0x0/0x0/0x0)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.339062]    mono: mono_out=0x0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.339063]    dig-out=0x11/0x1e
Sep  9 10:44:06 Arbeits-PC kernel: [    2.339063]    inputs:
Sep  9 10:44:06 Arbeits-PC kernel: [    2.339065]      Front Mic=0x19
Sep  9 10:44:06 Arbeits-PC kernel: [    2.339066]      Rear Mic=0x18
Sep  9 10:44:06 Arbeits-PC kernel: [    2.339067]      Line=0x1a
Sep  9 10:44:06 Arbeits-PC kernel: [    2.339068] realtek: Enabling
init ASM_ID=0x846b CODEC_ID=10ec0889
Sep  9 10:44:06 Arbeits-PC kernel: [    2.345650] nvidia: module
license 'NVIDIA' taints kernel.
Sep  9 10:44:06 Arbeits-PC kernel: [    2.345653] Disabling lock
debugging due to kernel taint
Sep  9 10:44:06 Arbeits-PC kernel: [    2.348346] nvidia: module
verification failed: signature and/or required key missing - tainting
kernel
Sep  9 10:44:06 Arbeits-PC kernel: [    2.351449] vgaarb: device
changed decodes:
PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
Sep  9 10:44:06 Arbeits-PC kernel: [    2.351743] [drm] Initialized
nvidia-drm 0.0.0 20130102 for 0000:01:00.0 on minor 0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.351748] NVRM: loading NVIDIA
UNIX x86_64 Kernel Module  325.15  Wed Jul 31 18:50:56 PDT 2013
Sep  9 10:44:06 Arbeits-PC kernel: [    2.359452] input: HDA Intel PCH
Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
Sep  9 10:44:06 Arbeits-PC kernel: [    2.359548] input: HDA Intel PCH
Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
Sep  9 10:44:06 Arbeits-PC kernel: [    2.359627] input: HDA Intel PCH
Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
Sep  9 10:44:06 Arbeits-PC kernel: [    2.359717] input: HDA Intel PCH
Line Out Surround as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
Sep  9 10:44:06 Arbeits-PC kernel: [    2.359795] input: HDA Intel PCH
Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
Sep  9 10:44:06 Arbeits-PC kernel: [    2.359872] input: HDA Intel PCH
Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
Sep  9 10:44:06 Arbeits-PC kernel: [    2.359948] input: HDA Intel PCH
Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
Sep  9 10:44:06 Arbeits-PC kernel: [    2.360027] input: HDA Intel PCH
Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
Sep  9 10:44:06 Arbeits-PC kernel: [    2.360370] snd_hda_intel
0000:01:00.1: enabling device (0000 -> 0002)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.360424] hda_intel: Disabling MSI
Sep  9 10:44:06 Arbeits-PC kernel: [    2.360429] hda-intel
0000:01:00.1: Handle VGA-switcheroo audio client
Sep  9 10:44:06 Arbeits-PC kernel: [    2.360464] hda-intel
0000:01:00.1: Disabling 64bit DMA
Sep  9 10:44:06 Arbeits-PC kernel: [    2.364426] hda-intel
0000:01:00.1: Enable delay in RIRB handling
Sep  9 10:44:06 Arbeits-PC kernel: [    2.369820] usb 2-1.4: New USB
device found, idVendor=046d, idProduct=c051
Sep  9 10:44:06 Arbeits-PC kernel: [    2.369823] usb 2-1.4: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.369824] usb 2-1.4: Product:
USB-PS/2 Optical Mouse
Sep  9 10:44:06 Arbeits-PC kernel: [    2.369826] usb 2-1.4:
Manufacturer: Logitech
Sep  9 10:44:06 Arbeits-PC kernel: [    2.372838] rtl8192cu: Chip version 0x11
Sep  9 10:44:06 Arbeits-PC kernel: [    2.373691] input: Logitech
USB-PS/2 Optical Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input13
Sep  9 10:44:06 Arbeits-PC kernel: [    2.373794] hid-generic
0003:046D:C051.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech
USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.4/input0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.384658] cfg80211: World
regulatory domain updated:
Sep  9 10:44:06 Arbeits-PC kernel: [    2.384661] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.384663] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.384664] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.384665] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.384666] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.384667] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.436165] type=1400
audit(1378716245.964:5): apparmor="STATUS" operation="profile_replace"
name="/sbin/dhclient" pid=720 comm="apparmor_parser"
Sep  9 10:44:06 Arbeits-PC kernel: [    2.436205] type=1400
audit(1378716245.964:6): apparmor="STATUS" operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=720
comm="apparmor_parser"
Sep  9 10:44:06 Arbeits-PC kernel: [    2.436237] type=1400
audit(1378716245.964:7): apparmor="STATUS" operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=720
comm="apparmor_parser"
Sep  9 10:44:06 Arbeits-PC kernel: [    2.448981] Bluetooth: Core ver 2.16
Sep  9 10:44:06 Arbeits-PC kernel: [    2.449011] NET: Registered
protocol family 31
Sep  9 10:44:06 Arbeits-PC kernel: [    2.449013] Bluetooth: HCI
device and connection manager initialized
Sep  9 10:44:06 Arbeits-PC kernel: [    2.449019] Bluetooth: HCI
socket layer initialized
Sep  9 10:44:06 Arbeits-PC kernel: [    2.449020] Bluetooth: L2CAP
socket layer initialized
Sep  9 10:44:06 Arbeits-PC kernel: [    2.449024] Bluetooth: SCO
socket layer initialized
Sep  9 10:44:06 Arbeits-PC kernel: [    2.453366] Bluetooth: RFCOMM
TTY layer initialized
Sep  9 10:44:06 Arbeits-PC kernel: [    2.453376] Bluetooth: RFCOMM
socket layer initialized
Sep  9 10:44:06 Arbeits-PC kernel: [    2.453377] Bluetooth: RFCOMM ver 1.11
Sep  9 10:44:06 Arbeits-PC kernel: [    2.464001] Bluetooth: BNEP
(Ethernet Emulation) ver 1.3
Sep  9 10:44:06 Arbeits-PC kernel: [    2.464004] Bluetooth: BNEP
filters: protocol multicast
Sep  9 10:44:06 Arbeits-PC kernel: [    2.464010] Bluetooth: BNEP
socket layer initialized
Sep  9 10:44:06 Arbeits-PC avahi-daemon[954]: Loading service file
/services/udisks.service.
Sep  9 10:44:06 Arbeits-PC avahi-daemon[954]: Network interface
enumeration completed.
Sep  9 10:44:06 Arbeits-PC avahi-daemon[954]: Registering HINFO record
with values 'X86_64'/'LINUX'.
Sep  9 10:44:06 Arbeits-PC avahi-daemon[954]: Server startup complete.
Host name is Arbeits-PC.local. Local service cookie is 3570320876.
Sep  9 10:44:06 Arbeits-PC avahi-daemon[954]: Service "Arbeits-PC"
(/services/udisks.service) successfully established.
Sep  9 10:44:06 Arbeits-PC kernel: [    2.478542] ppdev: user-space
parallel port driver
Sep  9 10:44:06 Arbeits-PC kernel: [    2.507244] rtl8192cu: MAC
address: f8:1a:67:19:16:94
Sep  9 10:44:06 Arbeits-PC kernel: [    2.507248] rtl8192cu: Board Type 0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.507493] rtl_usb: rx_max_size
15360, rx_urb_num 8, in_ep 1
Sep  9 10:44:06 Arbeits-PC kernel: [    2.507513] rtl8192cu: Loading
firmware rtlwifi/rtl8192cufw.bin
Sep  9 10:44:06 Arbeits-PC kernel: [    2.507622] usbcore: registered
new interface driver rtl8192cu
Sep  9 10:44:06 Arbeits-PC kernel: [    2.678053] scsi 8:0:0:0:
Direct-Access     WD       Ext HDD 1021     2021 PQ: 0 ANSI: 4
Sep  9 10:44:06 Arbeits-PC kernel: [    2.678286] sd 8:0:0:0: Attached
scsi generic sg3 type 0
Sep  9 10:44:06 Arbeits-PC kernel: [    2.678714] sd 8:0:0:0: [sdc]
732566016 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Sep  9 10:44:06 Arbeits-PC kernel: [    2.680881] sd 8:0:0:0: [sdc]
Write Protect is off
Sep  9 10:44:06 Arbeits-PC kernel: [    2.680885] sd 8:0:0:0: [sdc]
Mode Sense: 17 00 10 08
Sep  9 10:44:06 Arbeits-PC kernel: [    2.682365] sd 8:0:0:0: [sdc] No
Caching mode page present
Sep  9 10:44:06 Arbeits-PC kernel: [    2.682368] sd 8:0:0:0: [sdc]
Assuming drive cache: write through
Sep  9 10:44:06 Arbeits-PC kernel: [    2.682899] sd 8:0:0:0: [sdc]
732566016 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  ModemManager
(version 0.6.0.0) starting...
Sep  9 10:44:06 Arbeits-PC kernel: [    2.686567] sd 8:0:0:0: [sdc] No
Caching mode page present
Sep  9 10:44:06 Arbeits-PC kernel: [    2.686571] sd 8:0:0:0: [sdc]
Assuming drive cache: write through
Sep  9 10:44:06 Arbeits-PC kernel: [    2.686863]  sdc: sdc1
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Linktop'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Nokia'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin
'Ericsson MBM'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'X22X'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'ZTE'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'AnyData'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Samsung'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Gobi'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin
'Longcheer'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Huawei'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'MotoC'
Sep  9 10:44:06 Arbeits-PC kernel: [    2.690540] sd 8:0:0:0: [sdc]
732566016 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin
'Option High-Speed'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Novatel'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Wavecom'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Sierra'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Option'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'SimTech'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Iridium'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin
'Cinterion'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Loaded plugin 'Generic'
Sep  9 10:44:06 Arbeits-PC modem-manager[1000]: <info>  Successfully
loaded 20 plugins
Sep  9 10:44:06 Arbeits-PC kernel: [    2.694681] sd 8:0:0:0: [sdc] No
Caching mode page present
Sep  9 10:44:06 Arbeits-PC kernel: [    2.694686] sd 8:0:0:0: [sdc]
Assuming drive cache: write through
Sep  9 10:44:06 Arbeits-PC kernel: [    2.694689] sd 8:0:0:0: [sdc]
Attached SCSI disk
Sep  9 10:44:06 Arbeits-PC kernel: [    2.700170] Switched to clocksource tsc
Sep  9 10:44:06 Arbeits-PC kernel: [    2.703852] ieee80211 phy0:
Selected rate control algorithm 'rtl_rc'
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> NetworkManager
(version 0.9.8.0) is starting...
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> Read config
file /etc/NetworkManager/NetworkManager.conf
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> WEXT support is enabled
Sep  9 10:44:06 Arbeits-PC kernel: [    2.704751] rtlwifi: wireless switch is on
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> VPN: loaded
org.freedesktop.NetworkManager.pptp
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> DNS: loaded
plugin dnsmasq
Sep  9 10:44:06 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.PolicyKit1' (using servicehelper)
Sep  9 10:44:06 Arbeits-PC polkitd[1060]: started daemon version 0.105
using authority implementation `local' version `0.105'
Sep  9 10:44:06 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.PolicyKit1'
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown: init!
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
update_system_hostname
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPluginIfupdown:
management mode: unmanaged
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
devices added (path: /sys/devices/pci0000:00/0000:00:19.0/net/eth0,
iface: eth0)
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
device added (path: /sys/devices/pci0000:00/0000:00:19.0/net/eth0,
iface: eth0): no ifupdown configuration found.
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
devices added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0)
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
device added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0): no ifupdown configuration found.
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
devices added (path: /sys/devices/virtual/net/lo, iface: lo)
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
device added (path: /sys/devices/virtual/net/lo, iface: lo): no
ifupdown configuration found.
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
end _init.
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> Loaded plugin
ifupdown: (C) 2008 Canonical Ltd.  To report bugs please use the
NetworkManager mailing list.
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> Loaded plugin
keyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the
NetworkManager mailing list.
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    Ifupdown: get
unmanaged devices count: 0
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
(21267632) ... get_connections.
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
(21267632) ... get_connections (managed=false): return empty list.
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    keyfile: parsing Festung ...
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    keyfile:     read
connection 'Festung'
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    keyfile: parsing WG-WLAN ...
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    keyfile:     read
connection 'WG-WLAN'
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    keyfile: parsing
WG-WLAN 1 ...
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    keyfile:     read
connection 'WG-WLAN 1'
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]:    Ifupdown: get
unmanaged devices count: 0
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> modem-manager
is now available
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> monitoring
kernel firmware directory '/lib/firmware'.
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> rfkill0: found
WiFi radio killswitch (at
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/ieee80211/phy0/rfkill0)
(driver rtl8192cu)
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> WiFi hardware
radio set enabled
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> WiFi enabled
by radio killswitch; enabled by state file
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> WWAN enabled
by radio killswitch; enabled by state file
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> WiMAX enabled
by radio killswitch; enabled by state file
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> Networking is
enabled by state file
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <warn> failed to
allocate link cache: (-10) Operation not supported
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (eth0): carrier is OFF
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (eth0): new
Ethernet device (driver: 'e1000e' ifindex: 2)
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (eth0):
exported as /org/freedesktop/NetworkManager/Devices/0
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (eth0): device
state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (eth0):
bringing up device.
Sep  9 10:44:06 Arbeits-PC kernel: [    2.872667] type=1400
audit(1378716246.398:8): apparmor="STATUS" operation="profile_load"
name="/usr/lib/cups/backend/cups-pdf" pid=1002 comm="apparmor_parser"
Sep  9 10:44:06 Arbeits-PC kernel: [    2.872754] type=1400
audit(1378716246.398:9): apparmor="STATUS" operation="profile_load"
name="/usr/sbin/cupsd" pid=1002 comm="apparmor_parser"
Sep  9 10:44:06 Arbeits-PC kernel: [    2.876432] input: HDA NVidia
HDMI/DP,pcm=9 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
Sep  9 10:44:06 Arbeits-PC kernel: [    2.876530] input: HDA NVidia
HDMI/DP,pcm=8 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
Sep  9 10:44:06 Arbeits-PC kernel: [    2.880412] input: HDA NVidia
HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
Sep  9 10:44:06 Arbeits-PC kernel: [    2.880489] input: HDA NVidia
HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
Sep  9 10:44:06 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.ColorManager' (using servicehelper)
Sep  9 10:44:06 Arbeits-PC colord: Using config file /etc/colord.conf
Sep  9 10:44:06 Arbeits-PC colord: Using mapping database file
/var/lib/colord/mapping.db
Sep  9 10:44:06 Arbeits-PC colord: Using device database file
/var/lib/colord/storage.db
Sep  9 10:44:06 Arbeits-PC colord: loaded plugin libcd_plugin_scanner.so
Sep  9 10:44:06 Arbeits-PC colord: plugin
/usr/lib/colord-plugins/libcd_plugin_sane.so not loaded: plugin
refused to load
Sep  9 10:44:06 Arbeits-PC colord: loaded plugin libcd_plugin_camera.so
Sep  9 10:44:06 Arbeits-PC colord: Daemon ready for requests
Sep  9 10:44:06 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.ColorManager'
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-709099b11b3ec2828a314682a3c09f75
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-22f24c14dfa0237c65ce91cbdc840c69
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-d3ee37ff47fcdf614fb5cb62fb3e16a7
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-7da394e6f8f9718fc7b52b32566dac05
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-e7ecfce2d984c9f0c90f4ef1cdc9ac7e
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-798efa4314bbd0274499de21fdf4ee5e
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-f844a65e79050c828a5f8381a0798e49
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-f1d6e4a79454dcf348e740f8258ebc8b
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-5e1ebb54becd93f823c07c22bc1938e0
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-e9984ac92492c61ae319f57aa7cbb102
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-578e8c43d0440cff3239ced4417c691a
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-6590422afc1260c68d531b8de865eda1
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-8032ad23c1912c7ffae56745d279fde7
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-f5cf9cb1331928471dbcd67d7229aff5
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-9cc8e51f95b2209f235c230393230ead
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-429bb399c0de0c6fe69826993b46c219
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-8ab229960e966f047a0fb62c4cb1f390
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-adb5ebe2a14b98599a170cd3ab54fe76
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-29f7c3bb18648f967e9cc450f5b0821e
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-dff20c58ed34af3a30bc97b2b2a1b6c5
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-ae0f19a77ff01ea1932ef5fd9609ef9d
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-0ef971da00dac3a46e0c86550c54d5ad
Sep  9 10:44:06 Arbeits-PC colord: Profile added:
icc-0bd9f292ce7882699e93ff844071783d
Sep  9 10:44:06 Arbeits-PC colord: Profile added: EPSON-WF-2510-Series-Gray..
Sep  9 10:44:06 Arbeits-PC colord: Profile added: EPSON-WF-2510-Series-RGB..
Sep  9 10:44:06 Arbeits-PC colord: Device added: cups-EPSON-WF-2510-Series
Sep  9 10:44:06 Arbeits-PC kernel: [    3.016661] e1000e 0000:00:19.0:
irq 51 for MSI/MSI-X
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (eth0):
preparing device.
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (eth0):
deactivating device (reason 'managed') [2]
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> Added default
wired connection 'Kabelnetzwerkverbindung 1' for
/sys/devices/pci0000:00/0000:00:19.0/net/eth0
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (wlan0): using
nl80211 for WiFi device control
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
driver supports Access Point (AP) mode
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (wlan0): new
802.11 WiFi device (driver: 'rtl8192cu' ifindex: 3)
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
exported as /org/freedesktop/NetworkManager/Devices/1
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: unmanaged -> unavailable (reason 'managed') [10
20 2]
Sep  9 10:44:06 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
bringing up device.
Sep  9 10:44:06 Arbeits-PC kernel: [    3.120730] e1000e 0000:00:19.0:
irq 51 for MSI/MSI-X
Sep  9 10:44:06 Arbeits-PC kernel: [    3.120821] IPv6:
ADDRCONF(NETDEV_UP): eth0: link is not ready
Sep  9 10:44:06 Arbeits-PC kernel: [    3.124296] rtl8192cu: MAC auto ON okay!
Sep  9 10:44:06 Arbeits-PC kernel: [    3.157092] rtl8192cu: Tx queue
select: 0x05
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
preparing device.
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
deactivating device (reason 'managed') [2]
Sep  9 10:44:07 Arbeits-PC dbus[891]: [system] Activating service
name='fi.w1.wpa_supplicant1' (using servicehelper)
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <warn>
/sys/devices/virtual/net/lo: couldn't determine device driver;
ignoring...
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <warn>
/sys/devices/virtual/net/lo: couldn't determine device driver;
ignoring...
Sep  9 10:44:07 Arbeits-PC kernel: [    3.529259] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 10:44:07 Arbeits-PC dbus[891]: [system] Successfully activated
service 'fi.w1.wpa_supplicant1'
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> wpa_supplicant started
Sep  9 10:44:07 Arbeits-PC ntpdate[1138]: Can't find host
ntp.ubuntu.com: System error (-11)
Sep  9 10:44:07 Arbeits-PC ntpdate[1138]: no servers can be used, exiting
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0)
supports 4 scan SSIDs
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <warn> Trying to
remove a non-existant call id.
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: starting -> ready
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: unavailable -> disconnected (reason
'supplicant-available') [20 30 42]
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: ready -> inactive
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0)
supports 4 scan SSIDs
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info>
Auto-activating connection 'WG-WLAN'.
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) starting connection 'WG-WLAN'
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: disconnected -> prepare (reason 'none') [30 40 0]
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0/wireless): connection 'WG-WLAN' has security, and secrets
exist.  No new secrets needed.
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Config: added
'ssid' value 'WG-WLAN'
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Config: added
'scan_ssid' value '1'
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Config: added
'auth_alg' value 'OPEN'
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Config: added
'psk' value '<omitted>'
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> Config: set
interface ap_scan to 1
Sep  9 10:44:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: inactive -> scanning
Sep  9 10:44:08 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:08 Arbeits-PC kernel: [    4.971514] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:44:08 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:08 Arbeits-PC kernel: [    4.995524] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:08 Arbeits-PC kernel: [    4.998376] wlan0: authenticated
Sep  9 10:44:08 Arbeits-PC kernel: [    4.999145] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:44:08 Arbeits-PC kernel: [    5.008161] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:44:08 Arbeits-PC kernel: [    5.008192] wlan0: associated
Sep  9 10:44:08 Arbeits-PC kernel: [    5.008199] IPv6:
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sep  9 10:44:08 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:44:08 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:44:08 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(auth) [id=0 id_str=]
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'WG-WLAN'.
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: config -> ip-config (reason 'none') [50 70 0]
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> dhclient
started with pid 1140
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Beginning IP6 addrconf.
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Sep  9 10:44:08 Arbeits-PC dhclient: Internet Systems Consortium DHCP
Client 4.2.4
Sep  9 10:44:08 Arbeits-PC dhclient: Copyright 2004-2012 Internet
Systems Consortium.
Sep  9 10:44:08 Arbeits-PC dhclient: All rights reserved.
Sep  9 10:44:08 Arbeits-PC dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Sep  9 10:44:08 Arbeits-PC dhclient:
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
DHCPv4 state changed nbi -> preinit
Sep  9 10:44:08 Arbeits-PC dhclient: Listening on LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:44:08 Arbeits-PC dhclient: Sending on   LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:44:08 Arbeits-PC dhclient: Sending on   Socket/fallback
Sep  9 10:44:08 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 255.255.255.255 port 67 (xid=0x4f6f2b04)
Sep  9 10:44:08 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 10:44:08 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 3114 seconds.
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
DHCPv4 state changed preinit -> reboot
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info>   address 192.168.1.103
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info>   prefix 24
(255.255.255.0)
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info>   gateway 192.168.1.1
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info>   nameserver
'192.168.1.1'
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Sep  9 10:44:08 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Sep  9 10:44:08 Arbeits-PC avahi-daemon[954]: Joining mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:44:08 Arbeits-PC avahi-daemon[954]: New relevant interface
wlan0.IPv4 for mDNS.
Sep  9 10:44:08 Arbeits-PC avahi-daemon[954]: Registering new address
record for 192.168.1.103 on wlan0.IPv4.
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: ip-config -> secondaries (reason 'none') [70 90
0]
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: secondaries -> activated (reason 'none') [90 100
0]
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <info> Policy set
'WG-WLAN' (wlan0) as default for IPv4 routing and DNS.
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <info> DNS: starting dnsmasq...
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <warn> dnsmasq not
available on the bus, can't update servers.
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <error>
[1378716249.591029] [nm-dns-dnsmasq.c:402] update(): dnsmasq owner not
found on bus: Could not get owner of name
'org.freedesktop.NetworkManager.dnsmasq': no such name
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <warn> DNS: plugin
dnsmasq update failed
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 10:44:09 Arbeits-PC dnsmasq[1145]: Gestartet, Version 2.65
Cache deaktiviert
Sep  9 10:44:09 Arbeits-PC dnsmasq[1145]: Übersetzungsoptionen: IPv6
GNU-getopt DBus i18n IDN DHCP DHCPv6 no-Lua TFTP conntrack
Sep  9 10:44:09 Arbeits-PC dnsmasq[1145]: DBus-Unterstützung
eingeschaltet: mit Systembus verbunden
Sep  9 10:44:09 Arbeits-PC dnsmasq[1145]: Warnung: keine vorgelagerten
(Upstream) Server konfiguriert
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) successful, device activated.
Sep  9 10:44:09 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <warn> dnsmasq
appeared on DBus: :1.15
Sep  9 10:44:09 Arbeits-PC NetworkManager[1051]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 10:44:09 Arbeits-PC dnsmasq[1145]: vorgelagerte Server von DBus gesetzt
Sep  9 10:44:09 Arbeits-PC dnsmasq[1145]: Benutze Namensserver 192.168.1.1#53
Sep  9 10:44:09 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:44:10 Arbeits-PC avahi-daemon[954]: Joining mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:44:10 Arbeits-PC avahi-daemon[954]: New relevant interface
wlan0.IPv6 for mDNS.
Sep  9 10:44:10 Arbeits-PC avahi-daemon[954]: Registering new address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.*.
Sep  9 10:44:10 Arbeits-PC kernel: [    6.971280] audit_printk_skb: 48
callbacks suppressed
Sep  9 10:44:10 Arbeits-PC kernel: [    6.971283] type=1400
audit(1378716250.490:26): apparmor="STATUS" operation="profile_load"
name="/usr/bin/evince" pid=1084 comm="apparmor_parser"
Sep  9 10:44:10 Arbeits-PC kernel: [    6.971626] type=1400
audit(1378716250.490:27): apparmor="STATUS" operation="profile_load"
name="/usr/bin/evince//sanitized_helper" pid=1084
comm="apparmor_parser"
Sep  9 10:44:10 Arbeits-PC kernel: [    6.971973] type=1400
audit(1378716250.490:28): apparmor="STATUS" operation="profile_load"
name="/usr/bin/evince-previewer" pid=1084 comm="apparmor_parser"
Sep  9 10:44:10 Arbeits-PC kernel: [    6.972185] type=1400
audit(1378716250.490:29): apparmor="STATUS" operation="profile_load"
name="/usr/bin/evince-previewer//sanitized_helper" pid=1084
comm="apparmor_parser"
Sep  9 10:44:10 Arbeits-PC kernel: [    6.972413] type=1400
audit(1378716250.490:30): apparmor="STATUS" operation="profile_load"
name="/usr/bin/evince-thumbnailer" pid=1084 comm="apparmor_parser"
Sep  9 10:44:10 Arbeits-PC kernel: [    6.972577] type=1400
audit(1378716250.490:31): apparmor="STATUS" operation="profile_load"
name="/usr/bin/evince-thumbnailer//sanitized_helper" pid=1084
comm="apparmor_parser"
Sep  9 10:44:10 Arbeits-PC anacron[1374]: Anacron 2.3 started on 2013-09-09
Sep  9 10:44:10 Arbeits-PC anacron[1374]: Normal exit (0 jobs run)
Sep  9 10:44:10 Arbeits-PC cron[1330]: (CRON) INFO (pidfile fd = 3)
Sep  9 10:44:10 Arbeits-PC cron[1380]: (CRON) STARTUP (fork ok)
Sep  9 10:44:10 Arbeits-PC cron[1380]: (CRON) INFO (Running @reboot jobs)
Sep  9 10:44:10 Arbeits-PC acpid: starting up with proc fs
Sep  9 10:44:10 Arbeits-PC nvidia-persistenced: Started (1383)
Sep  9 10:44:10 Arbeits-PC nvidia-persistenced: Failed to query NVIDIA
devices. Please ensure that the NVIDIA device files (/dev/nvidia*)
exist, and that user 999 has read and write permissions for those
files.
Sep  9 10:44:10 Arbeits-PC nvidia-persistenced: The daemon no longer
has permission to remove its runtime data directory
/var/run/nvidia-persistenced
Sep  9 10:44:10 Arbeits-PC nvidia-persistenced: Shutdown (1383)
Sep  9 10:44:10 Arbeits-PC acpid: 33 rules loaded
Sep  9 10:44:10 Arbeits-PC acpid: waiting for events: event logging is off
Sep  9 10:44:10 Arbeits-PC anacron[1436]: Anacron 2.3 started on 2013-09-09
Sep  9 10:44:10 Arbeits-PC anacron[1436]: Normal exit (0 jobs run)
Sep  9 10:44:10 Arbeits-PC acpid: client connected from 1465[0:0]
Sep  9 10:44:10 Arbeits-PC acpid: 1 client rule loaded
Sep  9 10:44:10 Arbeits-PC kernel: [    7.129473] nvidia 0000:01:00.0:
irq 55 for MSI/MSI-X
Sep  9 10:44:11 Arbeits-PC kernel: [    7.769674] NVRM: Your system is
not currently configured to drive a VGA console
Sep  9 10:44:11 Arbeits-PC kernel: [    7.769677] NVRM: on the primary
VGA device. The NVIDIA Linux graphics driver
Sep  9 10:44:11 Arbeits-PC kernel: [    7.769678] NVRM: requires the
use of a text-mode VGA console. Use of other console
Sep  9 10:44:11 Arbeits-PC kernel: [    7.769680] NVRM: drivers
including, but not limited to, vesafb, may result in
Sep  9 10:44:11 Arbeits-PC kernel: [    7.769681] NVRM: corruption and
stability problems, and is not supported.
Sep  9 10:44:11 Arbeits-PC acpid: client connected from 1465[0:0]
Sep  9 10:44:11 Arbeits-PC acpid: 1 client rule loaded
Sep  9 10:44:11 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.Accounts' (using servicehelper)
Sep  9 10:44:11 Arbeits-PC accounts-daemon[1566]: started daemon version 0.6.29
Sep  9 10:44:11 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.Accounts'
Sep  9 10:44:11 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.ConsoleKit' (using servicehelper)
Sep  9 10:44:11 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.ConsoleKit'
Sep  9 10:44:11 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.UPower' (using servicehelper)
Sep  9 10:44:11 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.UPower'
Sep  9 10:44:11 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.systemd1' (using servicehelper)
Sep  9 10:44:11 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.systemd1'
Sep  9 10:44:11 Arbeits-PC anacron[1797]: Anacron 2.3 started on 2013-09-09
Sep  9 10:44:11 Arbeits-PC anacron[1797]: Normal exit (0 jobs run)
Sep  9 10:44:11 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.RealtimeKit1' (using servicehelper)
Sep  9 10:44:11 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.RealtimeKit1'
Sep  9 10:44:11 Arbeits-PC rtkit-daemon[1852]: Successfully called chroot.
Sep  9 10:44:11 Arbeits-PC rtkit-daemon[1852]: Successfully dropped privileges.
Sep  9 10:44:11 Arbeits-PC rtkit-daemon[1852]: Successfully limited resources.
Sep  9 10:44:11 Arbeits-PC rtkit-daemon[1852]: Running.
Sep  9 10:44:11 Arbeits-PC rtkit-daemon[1852]: Canary thread running.
Sep  9 10:44:11 Arbeits-PC rtkit-daemon[1852]: Watchdog thread running.
Sep  9 10:44:11 Arbeits-PC rtkit-daemon[1852]: Successfully made
thread 1849 of process 1849 (n/a) owned by '110' high priority at nice
level -11.
Sep  9 10:44:11 Arbeits-PC rtkit-daemon[1852]: Supervising 1 threads
of 1 processes of 1 users.
Sep  9 10:44:11 Arbeits-PC colord: Device added: xrandr-Samsung
Electric Company-SMS27A550H-808465713
Sep  9 10:44:11 Arbeits-PC colord: Profile added:
icc-43452068d98938efc2ed29a6d513fbc0
Sep  9 10:44:12 Arbeits-PC rtkit-daemon[1852]: Successfully made
thread 1945 of process 1849 (n/a) owned by '110' RT at priority 5.
Sep  9 10:44:12 Arbeits-PC rtkit-daemon[1852]: Supervising 2 threads
of 1 processes of 1 users.
Sep  9 10:44:12 Arbeits-PC kernel: [    8.780684] hda-intel: IRQ
timing workaround is activated for card #1. Suggest a bigger
bdl_pos_adj.
Sep  9 10:44:12 Arbeits-PC rtkit-daemon[1852]: Successfully made
thread 1946 of process 1849 (n/a) owned by '110' RT at priority 5.
Sep  9 10:44:12 Arbeits-PC rtkit-daemon[1852]: Supervising 3 threads
of 1 processes of 1 users.
Sep  9 10:44:12 Arbeits-PC rtkit-daemon[1852]: Successfully made
thread 1947 of process 1849 (n/a) owned by '110' RT at priority 5.
Sep  9 10:44:12 Arbeits-PC rtkit-daemon[1852]: Supervising 4 threads
of 1 processes of 1 users.
Sep  9 10:44:12 Arbeits-PC rtkit-daemon[1852]: Successfully made
thread 1949 of process 1949 (n/a) owned by '110' high priority at nice
level -11.
Sep  9 10:44:12 Arbeits-PC rtkit-daemon[1852]: Supervising 5 threads
of 2 processes of 1 users.
Sep  9 10:44:12 Arbeits-PC pulseaudio[1949]: [pulseaudio] pid.c:
Daemon already running.
Sep  9 10:44:17 Arbeits-PC kernel: [   13.551561] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:44:17 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:44:17 Arbeits-PC kernel: [   13.594716] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:44:17 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:44:17 Arbeits-PC kernel: [   13.599036] cfg80211: World
regulatory domain updated:
Sep  9 10:44:17 Arbeits-PC kernel: [   13.599040] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:44:17 Arbeits-PC kernel: [   13.599043] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:17 Arbeits-PC kernel: [   13.599045] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:17 Arbeits-PC kernel: [   13.599047] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:17 Arbeits-PC kernel: [   13.599049] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:17 Arbeits-PC kernel: [   13.599050] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:17 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:44:17 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:17 Arbeits-PC kernel: [   14.387866] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:44:17 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:44:17 Arbeits-PC kernel: [   14.412082] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:18 Arbeits-PC kernel: [   14.515651] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:44:18 Arbeits-PC ntpdate[1274]: adjust time server
91.189.94.4 offset -0.334980 sec
Sep  9 10:44:18 Arbeits-PC kernel: [   14.619784] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:44:18 Arbeits-PC kernel: [   14.723924] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:44:18 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:44:18 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:44:24 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:24 Arbeits-PC kernel: [   21.271830] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:44:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:44:24 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:24 Arbeits-PC kernel: [   21.295935] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:24 Arbeits-PC kernel: [   21.299030] wlan0: authenticated
Sep  9 10:44:24 Arbeits-PC kernel: [   21.299449] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:44:24 Arbeits-PC kernel: [   21.311734] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:44:24 Arbeits-PC kernel: [   21.311777] wlan0: associated
Sep  9 10:44:24 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:44:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:44:24 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:44:24 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:44:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:44:28 Arbeits-PC NetworkManager[1051]: <info> (wlan0): IP6
addrconf timed out or failed.
Sep  9 10:44:28 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Sep  9 10:44:28 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Sep  9 10:44:28 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Sep  9 10:44:33 Arbeits-PC kernel: [   29.611645] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:44:33 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:44:33 Arbeits-PC kernel: [   29.634771] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:44:33 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:44:33 Arbeits-PC kernel: [   29.638973] cfg80211: World
regulatory domain updated:
Sep  9 10:44:33 Arbeits-PC kernel: [   29.638977] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:44:33 Arbeits-PC kernel: [   29.638979] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:33 Arbeits-PC kernel: [   29.638981] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:33 Arbeits-PC kernel: [   29.638983] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:33 Arbeits-PC kernel: [   29.638985] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:33 Arbeits-PC kernel: [   29.638986] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:33 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:44:33 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:33 Arbeits-PC kernel: [   30.436417] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:44:33 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:44:33 Arbeits-PC kernel: [   30.460264] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:34 Arbeits-PC kernel: [   30.564233] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:44:34 Arbeits-PC kernel: [   30.668420] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:44:34 Arbeits-PC kernel: [   30.772611] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:44:34 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:44:34 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:44:40 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:40 Arbeits-PC kernel: [   37.316832] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:44:40 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:44:40 Arbeits-PC kernel: [   37.340997] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:40 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:40 Arbeits-PC kernel: [   37.351381] wlan0: authenticated
Sep  9 10:44:40 Arbeits-PC kernel: [   37.352533] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:40 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:44:40 Arbeits-PC kernel: [   37.371061] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:44:40 Arbeits-PC kernel: [   37.371104] wlan0: associated
Sep  9 10:44:40 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:44:40 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:44:40 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:44:40 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:44:40 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:44:47 Arbeits-PC kernel: [   43.661345] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:44:47 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:44:47 Arbeits-PC kernel: [   43.692243] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:44:47 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:44:47 Arbeits-PC kernel: [   43.696467] cfg80211: World
regulatory domain updated:
Sep  9 10:44:47 Arbeits-PC kernel: [   43.696471] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:44:47 Arbeits-PC kernel: [   43.696473] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:47 Arbeits-PC kernel: [   43.696476] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:47 Arbeits-PC kernel: [   43.696477] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:47 Arbeits-PC kernel: [   43.696479] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:47 Arbeits-PC kernel: [   43.696481] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:44:47 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:44:47 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:47 Arbeits-PC kernel: [   44.489868] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:44:47 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:44:47 Arbeits-PC kernel: [   44.513724] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:48 Arbeits-PC kernel: [   44.617685] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:44:48 Arbeits-PC kernel: [   44.721879] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:44:48 Arbeits-PC kernel: [   44.826063] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:44:48 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:44:48 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:44:49 Arbeits-PC colord: device removed: xrandr-Samsung
Electric Company-SMS27A550H-808465713
Sep  9 10:44:49 Arbeits-PC colord: Profile removed:
icc-43452068d98938efc2ed29a6d513fbc0
Sep  9 10:44:50 Arbeits-PC rtkit-daemon[1852]: Successfully made
thread 2091 of process 2091 (n/a) owned by '1000' high priority at
nice level -11.
Sep  9 10:44:50 Arbeits-PC rtkit-daemon[1852]: Supervising 1 threads
of 1 processes of 1 users.
Sep  9 10:44:50 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.systemd1' (using servicehelper)
Sep  9 10:44:50 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.systemd1'
Sep  9 10:44:50 Arbeits-PC colord: Device added: xrandr-Samsung
Electric Company-SMS27A550H-808465713
Sep  9 10:44:50 Arbeits-PC rtkit-daemon[1852]: Successfully made
thread 2120 of process 2091 (n/a) owned by '1000' RT at priority 5.
Sep  9 10:44:50 Arbeits-PC rtkit-daemon[1852]: Supervising 2 threads
of 1 processes of 1 users.
Sep  9 10:44:51 Arbeits-PC rtkit-daemon[1852]: Successfully made
thread 2121 of process 2091 (n/a) owned by '1000' RT at priority 5.
Sep  9 10:44:51 Arbeits-PC rtkit-daemon[1852]: Supervising 3 threads
of 1 processes of 1 users.
Sep  9 10:44:51 Arbeits-PC rtkit-daemon[1852]: Successfully made
thread 2122 of process 2091 (n/a) owned by '1000' RT at priority 5.
Sep  9 10:44:51 Arbeits-PC rtkit-daemon[1852]: Supervising 4 threads
of 1 processes of 1 users.
Sep  9 10:44:51 Arbeits-PC rtkit-daemon[1852]: Successfully made
thread 2124 of process 2124 (n/a) owned by '1000' high priority at
nice level -11.
Sep  9 10:44:51 Arbeits-PC rtkit-daemon[1852]: Supervising 5 threads
of 2 processes of 1 users.
Sep  9 10:44:51 Arbeits-PC pulseaudio[2124]: [pulseaudio] pid.c:
Daemon already running.
Sep  9 10:44:51 Arbeits-PC colord: Profile added:
icc-d78f3944822b856ad4092fc58ca09547
Sep  9 10:44:51 Arbeits-PC colord: Profile added:
icc-51d0587849c3109e19cf97296ee1f39f
Sep  9 10:44:51 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.UDisks2' (using servicehelper)
Sep  9 10:44:51 Arbeits-PC udisksd[2164]: udisks daemon version 2.1.0 starting
Sep  9 10:44:51 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.UDisks2'
Sep  9 10:44:51 Arbeits-PC udisksd[2164]: Cleaning up mount point
/media/vincent/c08c4653-e319-4cce-8862-07874a4d20e7 (device 8:17 is
not mounted)
Sep  9 10:44:51 Arbeits-PC udisksd[2164]: Acquired the name
org.freedesktop.UDisks2 on the system message bus
Sep  9 10:44:54 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:54 Arbeits-PC kernel: [   51.374421] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:44:54 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:44:54 Arbeits-PC kernel: [   51.400818] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:54 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:44:54 Arbeits-PC kernel: [   51.414223] wlan0: authenticated
Sep  9 10:44:54 Arbeits-PC kernel: [   51.417993] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:44:54 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:44:54 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:44:54 Arbeits-PC kernel: [   51.426211] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:44:54 Arbeits-PC kernel: [   51.426239] wlan0: associated
Sep  9 10:44:54 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:44:54 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:44:54 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:44:54 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:44:55 Arbeits-PC ntfs-3g[2513]: Version 2013.1.13 external FUSE 29
Sep  9 10:44:55 Arbeits-PC ntfs-3g[2513]: Mounted /dev/sdc1
(Read-Write, label "Elements", NTFS 3.1)
Sep  9 10:44:55 Arbeits-PC ntfs-3g[2513]: Cmdline options:
rw,nosuid,nodev,uhelper=udisks2,uid=1000,gid=1000,dmask=0077,fmask=0177
Sep  9 10:44:55 Arbeits-PC ntfs-3g[2513]: Mount options:
rw,nosuid,nodev,uhelper=udisks2,allow_other,nonempty,relatime,default_permissions,fsname=/dev/sdc1,blkdev,blksize=4096
Sep  9 10:44:55 Arbeits-PC ntfs-3g[2513]: Global ownership and
permissions enforced, configuration type 7
Sep  9 10:44:55 Arbeits-PC udisksd[2164]: Mounted /dev/sdc1 at
/media/vincent/Elements on behalf of uid 1000
Sep  9 10:45:01 Arbeits-PC kernel: [   57.718538] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:45:01 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:45:01 Arbeits-PC kernel: [   57.797923] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:45:01 Arbeits-PC kernel: [   57.800681] cfg80211: World
regulatory domain updated:
Sep  9 10:45:01 Arbeits-PC kernel: [   57.800685] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:45:01 Arbeits-PC kernel: [   57.800686] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:01 Arbeits-PC kernel: [   57.800688] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:01 Arbeits-PC kernel: [   57.800689] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:01 Arbeits-PC kernel: [   57.800690] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:01 Arbeits-PC kernel: [   57.800691] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:01 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:45:01 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:45:02 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:02 Arbeits-PC kernel: [   58.587251] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:45:02 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:45:02 Arbeits-PC kernel: [   58.616483] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:02 Arbeits-PC kernel: [   58.719218] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:45:02 Arbeits-PC kernel: [   58.823403] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:45:02 Arbeits-PC kernel: [   58.927599] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:45:02 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:45:02 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:45:08 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:08 Arbeits-PC kernel: [   65.475772] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:45:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:45:08 Arbeits-PC kernel: [   65.499971] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:08 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:08 Arbeits-PC kernel: [   65.517331] wlan0: authenticated
Sep  9 10:45:08 Arbeits-PC kernel: [   65.519548] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:45:08 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:45:08 Arbeits-PC kernel: [   65.530400] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:45:08 Arbeits-PC kernel: [   65.530433] wlan0: associated
Sep  9 10:45:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:45:08 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:45:08 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:45:08 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:45:17 Arbeits-PC kernel: [   73.779773] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:45:17 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:45:17 Arbeits-PC kernel: [   73.814658] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:45:17 Arbeits-PC kernel: [   73.817406] cfg80211: World
regulatory domain updated:
Sep  9 10:45:17 Arbeits-PC kernel: [   73.817408] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:45:17 Arbeits-PC kernel: [   73.817409] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:17 Arbeits-PC kernel: [   73.817411] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:17 Arbeits-PC kernel: [   73.817412] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:17 Arbeits-PC kernel: [   73.817413] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:17 Arbeits-PC kernel: [   73.817414] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:17 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:45:17 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:45:18 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:18 Arbeits-PC kernel: [   74.604277] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:45:18 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:45:18 Arbeits-PC kernel: [   74.628503] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:18 Arbeits-PC kernel: [   74.732220] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:45:18 Arbeits-PC kernel: [   74.836402] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:45:18 Arbeits-PC kernel: [   74.940596] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:45:18 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:45:18 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:45:24 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:24 Arbeits-PC kernel: [   81.488788] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:45:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:45:24 Arbeits-PC kernel: [   81.512989] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:24 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:24 Arbeits-PC kernel: [   81.526894] wlan0: authenticated
Sep  9 10:45:24 Arbeits-PC kernel: [   81.528549] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:45:24 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:45:24 Arbeits-PC kernel: [   81.543037] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:45:24 Arbeits-PC kernel: [   81.543076] wlan0: associated
Sep  9 10:45:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:45:24 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:45:24 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:45:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:45:31 Arbeits-PC kernel: [   87.829335] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:45:31 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:45:31 Arbeits-PC kernel: [   87.864262] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:45:31 Arbeits-PC kernel: [   87.866994] cfg80211: World
regulatory domain updated:
Sep  9 10:45:31 Arbeits-PC kernel: [   87.866996] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:45:31 Arbeits-PC kernel: [   87.866998] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:31 Arbeits-PC kernel: [   87.866999] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:31 Arbeits-PC kernel: [   87.867000] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:31 Arbeits-PC kernel: [   87.867001] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:31 Arbeits-PC kernel: [   87.867002] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:31 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:45:31 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:45:32 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:32 Arbeits-PC kernel: [   88.657787] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:45:32 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:45:32 Arbeits-PC kernel: [   88.681844] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:32 Arbeits-PC kernel: [   88.785694] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:45:32 Arbeits-PC kernel: [   88.889882] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:45:32 Arbeits-PC kernel: [   88.994063] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:45:32 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:45:32 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:45:38 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:38 Arbeits-PC kernel: [   95.538186] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:45:38 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:45:38 Arbeits-PC kernel: [   95.562304] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:38 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:38 Arbeits-PC kernel: [   95.581860] wlan0: authenticated
Sep  9 10:45:38 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:45:38 Arbeits-PC kernel: [   95.585986] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:38 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:45:38 Arbeits-PC kernel: [   95.604761] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:45:38 Arbeits-PC kernel: [   95.604797] wlan0: associated
Sep  9 10:45:38 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:45:38 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:45:38 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:45:38 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:45:45 Arbeits-PC kernel: [  101.886577] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:45:45 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:45:45 Arbeits-PC kernel: [  101.921647] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:45:45 Arbeits-PC kernel: [  101.924368] cfg80211: World
regulatory domain updated:
Sep  9 10:45:45 Arbeits-PC kernel: [  101.924371] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:45:45 Arbeits-PC kernel: [  101.924372] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:45 Arbeits-PC kernel: [  101.924373] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:45 Arbeits-PC kernel: [  101.924375] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:45 Arbeits-PC kernel: [  101.924376] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:45 Arbeits-PC kernel: [  101.924377] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:45 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:45:45 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:45:46 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:46 Arbeits-PC kernel: [  102.723218] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:45:46 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:45:46 Arbeits-PC kernel: [  102.747186] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:46 Arbeits-PC kernel: [  102.851151] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:45:46 Arbeits-PC kernel: [  102.955338] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:45:46 Arbeits-PC kernel: [  103.059542] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:45:46 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:45:46 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:45:52 Arbeits-PC kernel: [  108.799941]
update-notifier[3124]: segfault at a7 ip 00007f0c67c1f1b1 sp
00007fffa55235c0 error 4 in
libgobject-2.0.so.0.3600.0[7f0c67c0a000+4d000]
Sep  9 10:45:52 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:52 Arbeits-PC kernel: [  109.607694] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:45:52 Arbeits-PC kernel: [  109.631785] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:52 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:45:52 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:45:52 Arbeits-PC kernel: [  109.642674] wlan0: authenticated
Sep  9 10:45:52 Arbeits-PC kernel: [  109.643452] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:45:52 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:45:53 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:45:53 Arbeits-PC kernel: [  109.660451] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:45:53 Arbeits-PC kernel: [  109.660478] wlan0: associated
Sep  9 10:45:53 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:45:53 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:45:53 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:45:53 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:45:59 Arbeits-PC kernel: [  115.936292] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:45:59 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:45:59 Arbeits-PC kernel: [  116.031113] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:45:59 Arbeits-PC kernel: [  116.034030] cfg80211: World
regulatory domain updated:
Sep  9 10:45:59 Arbeits-PC kernel: [  116.034034] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:45:59 Arbeits-PC kernel: [  116.034035] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:59 Arbeits-PC kernel: [  116.034037] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:59 Arbeits-PC kernel: [  116.034038] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:59 Arbeits-PC kernel: [  116.034039] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:59 Arbeits-PC kernel: [  116.034040] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:45:59 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:45:59 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:46:00 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:00 Arbeits-PC kernel: [  116.808777] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:46:00 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:46:00 Arbeits-PC kernel: [  116.832702] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:00 Arbeits-PC kernel: [  116.936680] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:46:00 Arbeits-PC kernel: [  117.040868] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:46:00 Arbeits-PC kernel: [  117.145059] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:46:00 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:46:00 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:46:07 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:07 Arbeits-PC kernel: [  123.693217] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:46:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:46:07 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:07 Arbeits-PC kernel: [  123.717550] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:07 Arbeits-PC kernel: [  123.720028] wlan0: authenticated
Sep  9 10:46:07 Arbeits-PC kernel: [  123.720986] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:46:07 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:46:07 Arbeits-PC kernel: [  123.725944] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:46:07 Arbeits-PC kernel: [  123.725974] wlan0: associated
Sep  9 10:46:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:46:07 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:46:07 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:46:07 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:46:13 Arbeits-PC kernel: [  129.993495] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:46:13 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:46:13 Arbeits-PC kernel: [  130.032592] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:46:13 Arbeits-PC kernel: [  130.035464] cfg80211: World
regulatory domain updated:
Sep  9 10:46:13 Arbeits-PC kernel: [  130.035466] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:46:13 Arbeits-PC kernel: [  130.035468] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:13 Arbeits-PC kernel: [  130.035469] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:13 Arbeits-PC kernel: [  130.035471] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:13 Arbeits-PC kernel: [  130.035472] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:13 Arbeits-PC kernel: [  130.035473] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:13 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:46:13 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:46:14 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:14 Arbeits-PC kernel: [  130.826157] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:46:14 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:46:14 Arbeits-PC kernel: [  130.850230] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:14 Arbeits-PC kernel: [  130.954070] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:46:14 Arbeits-PC kernel: [  131.058259] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:46:14 Arbeits-PC kernel: [  131.162442] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:46:14 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:46:14 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:46:20 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:20 Arbeits-PC kernel: [  137.706594] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:46:21 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:46:21 Arbeits-PC kernel: [  137.730828] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:21 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:21 Arbeits-PC kernel: [  137.752372] wlan0: authenticated
Sep  9 10:46:21 Arbeits-PC kernel: [  137.754389] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:21 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:46:21 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:46:21 Arbeits-PC kernel: [  137.762757] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:46:21 Arbeits-PC kernel: [  137.762792] wlan0: associated
Sep  9 10:46:21 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:46:21 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:46:21 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:46:21 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:46:27 Arbeits-PC kernel: [  144.043174] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:46:27 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:46:27 Arbeits-PC kernel: [  144.086033] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:46:27 Arbeits-PC kernel: [  144.088824] cfg80211: World
regulatory domain updated:
Sep  9 10:46:27 Arbeits-PC kernel: [  144.088826] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:46:27 Arbeits-PC kernel: [  144.088828] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:27 Arbeits-PC kernel: [  144.088829] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:27 Arbeits-PC kernel: [  144.088830] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:27 Arbeits-PC kernel: [  144.088832] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:27 Arbeits-PC kernel: [  144.088833] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:27 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:46:27 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:46:28 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:28 Arbeits-PC kernel: [  144.879576] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:46:28 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:46:28 Arbeits-PC kernel: [  144.903420] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:28 Arbeits-PC kernel: [  145.007509] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:46:28 Arbeits-PC kernel: [  145.111699] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:46:28 Arbeits-PC kernel: [  145.215887] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:46:28 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:46:28 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:46:35 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:35 Arbeits-PC kernel: [  151.764010] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:46:35 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:46:35 Arbeits-PC kernel: [  151.788278] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:35 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:35 Arbeits-PC kernel: [  151.795060] wlan0: authenticated
Sep  9 10:46:35 Arbeits-PC kernel: [  151.795811] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:35 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:46:35 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:46:35 Arbeits-PC kernel: [  151.810083] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:46:35 Arbeits-PC kernel: [  151.810114] wlan0: associated
Sep  9 10:46:35 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:46:35 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:46:35 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:46:35 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:46:41 Arbeits-PC kernel: [  158.206747] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:46:41 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:46:41 Arbeits-PC kernel: [  158.235638] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:46:41 Arbeits-PC kernel: [  158.238426] cfg80211: World
regulatory domain updated:
Sep  9 10:46:41 Arbeits-PC kernel: [  158.238428] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:46:41 Arbeits-PC kernel: [  158.238430] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:41 Arbeits-PC kernel: [  158.238431] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:41 Arbeits-PC kernel: [  158.238432] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:41 Arbeits-PC kernel: [  158.238434] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:41 Arbeits-PC kernel: [  158.238435] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:41 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:46:41 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:46:42 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:42 Arbeits-PC kernel: [  159.041271] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:46:42 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:46:42 Arbeits-PC kernel: [  159.065333] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:42 Arbeits-PC kernel: [  159.169180] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:46:42 Arbeits-PC kernel: [  159.273366] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:46:42 Arbeits-PC kernel: [  159.377568] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:46:42 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:46:42 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:46:49 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:49 Arbeits-PC kernel: [  165.921732] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:46:49 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:46:49 Arbeits-PC kernel: [  165.946147] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:49 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:49 Arbeits-PC kernel: [  165.954181] wlan0: authenticated
Sep  9 10:46:49 Arbeits-PC kernel: [  165.957476] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:49 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:46:49 Arbeits-PC kernel: [  165.961800] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:46:49 Arbeits-PC kernel: [  165.961838] wlan0: associated
Sep  9 10:46:49 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:46:49 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:46:49 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:46:49 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:46:49 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:46:55 Arbeits-PC kernel: [  172.150092] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:46:55 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:46:55 Arbeits-PC kernel: [  172.197023] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:46:55 Arbeits-PC kernel: [  172.199905] cfg80211: World
regulatory domain updated:
Sep  9 10:46:55 Arbeits-PC kernel: [  172.199907] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:46:55 Arbeits-PC kernel: [  172.199909] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:55 Arbeits-PC kernel: [  172.199910] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:55 Arbeits-PC kernel: [  172.199911] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:55 Arbeits-PC kernel: [  172.199913] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:55 Arbeits-PC kernel: [  172.199914] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:46:55 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:46:55 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:46:56 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:46:56 Arbeits-PC kernel: [  172.990453] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:46:56 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:46:56 Arbeits-PC kernel: [  173.014489] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:46:56 Arbeits-PC kernel: [  173.118444] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:46:56 Arbeits-PC kernel: [  173.222632] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:46:56 Arbeits-PC kernel: [  173.326839] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:46:56 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:46:56 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:47:03 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:03 Arbeits-PC kernel: [  179.870993] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:47:03 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:47:03 Arbeits-PC kernel: [  179.895344] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:03 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:03 Arbeits-PC kernel: [  179.903706] wlan0: authenticated
Sep  9 10:47:03 Arbeits-PC kernel: [  179.906742] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:03 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:47:03 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:47:03 Arbeits-PC kernel: [  179.913249] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:47:03 Arbeits-PC kernel: [  179.913286] wlan0: associated
Sep  9 10:47:03 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:47:03 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:47:03 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:47:03 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:47:09 Arbeits-PC kernel: [  186.207332] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:47:09 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:47:09 Arbeits-PC kernel: [  186.234852] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:47:09 Arbeits-PC kernel: [  186.237953] cfg80211: World
regulatory domain updated:
Sep  9 10:47:09 Arbeits-PC kernel: [  186.237956] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:47:09 Arbeits-PC kernel: [  186.237958] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:09 Arbeits-PC kernel: [  186.237960] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:09 Arbeits-PC kernel: [  186.237962] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:09 Arbeits-PC kernel: [  186.237963] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:09 Arbeits-PC kernel: [  186.237964] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:09 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:47:09 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:47:10 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:10 Arbeits-PC kernel: [  187.043989] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:47:10 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:47:10 Arbeits-PC kernel: [  187.068123] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:10 Arbeits-PC kernel: [  187.171899] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:47:10 Arbeits-PC kernel: [  187.276074] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:47:10 Arbeits-PC kernel: [  187.380276] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:47:10 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:47:10 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:47:14 Arbeits-PC kernel: [  191.083035] usbcore:
deregistering interface driver rtl8192cu
Sep  9 10:47:14 Arbeits-PC avahi-daemon[954]: Interface wlan0.IPv6 no
longer relevant for mDNS.
Sep  9 10:47:14 Arbeits-PC avahi-daemon[954]: Leaving mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:47:14 Arbeits-PC avahi-daemon[954]: Interface wlan0.IPv4 no
longer relevant for mDNS.
Sep  9 10:47:14 Arbeits-PC avahi-daemon[954]: Leaving mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:47:14 Arbeits-PC dhclient: receive_packet failed on wlan0:
Network is down
Sep  9 10:47:14 Arbeits-PC avahi-daemon[954]: Withdrawing address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.
Sep  9 10:47:14 Arbeits-PC avahi-daemon[954]: Withdrawing address
record for 192.168.1.103 on wlan0.
Sep  9 10:47:14 Arbeits-PC avahi-daemon[954]: Withdrawing workstation
service for wlan0.
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
devices removed (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0)
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: activated -> unmanaged (reason 'removed') [100 10
36]
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
deactivating device (reason 'removed') [36]
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
canceled DHCP transaction, DHCP client pid 1140
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <warn> sysctl: failed
to open '/proc/sys/net/ipv6/conf/wlan0/accept_ra': (2) Datei oder
Verzeichnis nicht gefunden
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <warn> sysctl: failed
to open '/proc/sys/net/ipv6/conf/wlan0/use_tempaddr': (2) Datei oder
Verzeichnis nicht gefunden
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <warn> (3) failed to
find interface name for index
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]:
(nm-system.c:766):nm_system_iface_get_flags: runtime check failed:
(iface != NULL)
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <error>
[1378716434.553197] [nm-system.c:768] nm_system_iface_get_flags():
(unknown): failed to get interface link object
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <warn> (3) failed to
find interface name for index
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]:
(nm-system.c:766):nm_system_iface_get_flags: runtime check failed:
(iface != NULL)
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <error>
[1378716434.553266] [nm-system.c:768] nm_system_iface_get_flags():
(unknown): failed to get interface link object
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
bringing up device.
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <warn> (3) failed to
find interface name for index
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]:
nm_system_iface_flush_routes: assertion `iface != NULL' failed
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <warn> (3) failed to
find interface name for index
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <warn> DNS: plugin
dnsmasq update failed
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <info> Removing DNS
information from /sbin/resolvconf
Sep  9 10:47:14 Arbeits-PC dnsmasq[1145]: vorgelagerte Server von DBus gesetzt
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <info> (wlan0): cleaning up...
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <warn> (3) failed to
find interface name for index
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]:
(nm-system.c:766):nm_system_iface_get_flags: runtime check failed:
(iface != NULL)
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <error>
[1378716434.574944] [nm-system.c:768] nm_system_iface_get_flags():
(unknown): failed to get interface link object
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <info> Unmanaged
Device found; state CONNECTED forced. (see
http://bugs.launchpad.net/bugs/191889)
Sep  9 10:47:14 Arbeits-PC NetworkManager[1051]: <info> radio
killswitch /sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/ieee80211/phy0/rfkill0
disappeared
Sep  9 10:47:14 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:47:14 Arbeits-PC wpa_supplicant[1137]: Could not read
interface wlan0 flags: No such device
Sep  9 10:47:14 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:47:22 Arbeits-PC kernel: [  199.771370] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:47:22 Arbeits-PC kernel: [  199.778167] cfg80211: World
regulatory domain updated:
Sep  9 10:47:22 Arbeits-PC kernel: [  199.778170] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:47:22 Arbeits-PC kernel: [  199.778172] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:22 Arbeits-PC kernel: [  199.778173] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:22 Arbeits-PC kernel: [  199.778174] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:22 Arbeits-PC kernel: [  199.778175] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:22 Arbeits-PC kernel: [  199.778177] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:22 Arbeits-PC kernel: [  199.785744] rtl8192cu: Chip version 0x11
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> rfkill1: found
WiFi radio killswitch (at
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/ieee80211/phy0/rfkill1)
(driver rtl8192cu)
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
devices added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0)
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]:    SCPlugin-Ifupdown:
device added (path:
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/net/wlan0,
iface: wlan0): no ifupdown configuration found.
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0): using
nl80211 for WiFi device control
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
driver supports Access Point (AP) mode
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0): new
802.11 WiFi device (driver: 'rtl8192cu' ifindex: 4)
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
exported as /org/freedesktop/NetworkManager/Devices/2
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: unmanaged -> unavailable (reason 'managed') [10
20 2]
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
bringing up device.
Sep  9 10:47:23 Arbeits-PC kernel: [  199.862973] rtl8192cu: MAC
address: f8:1a:67:19:16:94
Sep  9 10:47:23 Arbeits-PC kernel: [  199.862986] rtl8192cu: Board Type 0
Sep  9 10:47:23 Arbeits-PC kernel: [  199.863221] rtl_usb: rx_max_size
15360, rx_urb_num 8, in_ep 1
Sep  9 10:47:23 Arbeits-PC kernel: [  199.863255] rtl8192cu: Loading
firmware rtlwifi/rtl8192cufw.bin
Sep  9 10:47:23 Arbeits-PC kernel: [  199.863401] ieee80211 phy0:
Selected rate control algorithm 'rtl_rc'
Sep  9 10:47:23 Arbeits-PC kernel: [  199.863597] usbcore: registered
new interface driver rtl8192cu
Sep  9 10:47:23 Arbeits-PC kernel: [  199.863720] rtlwifi: wireless switch is on
Sep  9 10:47:23 Arbeits-PC kernel: [  199.869114] rtl8192cu: MAC auto ON okay!
Sep  9 10:47:23 Arbeits-PC kernel: [  199.901900] rtl8192cu: Tx queue
select: 0x05
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
preparing device.
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
deactivating device (reason 'managed') [2]
Sep  9 10:47:23 Arbeits-PC kernel: [  200.273212] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0)
supports 4 scan SSIDs
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <warn> Trying to
remove a non-existant call id.
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: starting -> ready
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: unavailable -> disconnected (reason
'supplicant-available') [20 30 42]
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: ready -> inactive
Sep  9 10:47:23 Arbeits-PC NetworkManager[1051]: <info> (wlan0)
supports 4 scan SSIDs
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info>
Auto-activating connection 'WG-WLAN'.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) starting connection 'WG-WLAN'
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: disconnected -> prepare (reason 'none') [30 40 0]
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0/wireless): access point 'WG-WLAN' has security, but secrets are
required.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: config -> need-auth (reason 'none') [50 60 0]
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: need-auth -> prepare (reason 'none') [60 40 0]
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0/wireless): connection 'WG-WLAN' has security, and secrets
exist.  No new secrets needed.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Config: added
'ssid' value 'WG-WLAN'
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Config: added
'scan_ssid' value '1'
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Config: added
'auth_alg' value 'OPEN'
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Config: added
'psk' value '<omitted>'
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Config: set
interface ap_scan to 1
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: inactive -> scanning
Sep  9 10:47:24 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:24 Arbeits-PC kernel: [  201.730614] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:47:24 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:24 Arbeits-PC kernel: [  201.754737] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:24 Arbeits-PC kernel: [  201.757713] wlan0: authenticated
Sep  9 10:47:24 Arbeits-PC kernel: [  201.758328] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:47:24 Arbeits-PC kernel: [  201.770145] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:47:24 Arbeits-PC kernel: [  201.770176] wlan0: associated
Sep  9 10:47:24 Arbeits-PC kernel: [  201.770183] IPv6:
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sep  9 10:47:24 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:47:24 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:47:24 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(auth) [id=0 id_str=]
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'WG-WLAN'.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: config -> ip-config (reason 'none') [50 70 0]
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> dhclient
started with pid 3340
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Beginning IP6 addrconf.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Sep  9 10:47:24 Arbeits-PC dhclient: Internet Systems Consortium DHCP
Client 4.2.4
Sep  9 10:47:24 Arbeits-PC dhclient: Copyright 2004-2012 Internet
Systems Consortium.
Sep  9 10:47:24 Arbeits-PC dhclient: All rights reserved.
Sep  9 10:47:24 Arbeits-PC dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Sep  9 10:47:24 Arbeits-PC dhclient:
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
DHCPv4 state changed nbi -> preinit
Sep  9 10:47:24 Arbeits-PC dhclient: Listening on LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:47:24 Arbeits-PC dhclient: Sending on   LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:47:24 Arbeits-PC dhclient: Sending on   Socket/fallback
Sep  9 10:47:24 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 255.255.255.255 port 67 (xid=0x268e81e2)
Sep  9 10:47:24 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 10:47:24 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 3335 seconds.
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
DHCPv4 state changed preinit -> reboot
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info>   address 192.168.1.103
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info>   prefix 24
(255.255.255.0)
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info>   gateway 192.168.1.1
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info>   nameserver
'192.168.1.1'
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Sep  9 10:47:24 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Sep  9 10:47:24 Arbeits-PC avahi-daemon[954]: Joining mDNS multicast
group on interface wlan0.IPv4 with address 192.168.1.103.
Sep  9 10:47:24 Arbeits-PC avahi-daemon[954]: New relevant interface
wlan0.IPv4 for mDNS.
Sep  9 10:47:24 Arbeits-PC avahi-daemon[954]: Registering new address
record for 192.168.1.103 on wlan0.IPv4.
Sep  9 10:47:25 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: ip-config -> secondaries (reason 'none') [70 90
0]
Sep  9 10:47:25 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Sep  9 10:47:25 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: secondaries -> activated (reason 'none') [90 100
0]
Sep  9 10:47:25 Arbeits-PC NetworkManager[1051]: <info> Policy set
'WG-WLAN' (wlan0) as default for IPv4 routing and DNS.
Sep  9 10:47:25 Arbeits-PC NetworkManager[1051]: <info> Writing DNS
information to /sbin/resolvconf
Sep  9 10:47:25 Arbeits-PC dnsmasq[1145]: vorgelagerte Server von DBus gesetzt
Sep  9 10:47:25 Arbeits-PC dnsmasq[1145]: Benutze Namensserver 192.168.1.1#53
Sep  9 10:47:26 Arbeits-PC avahi-daemon[954]: Joining mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:47:26 Arbeits-PC avahi-daemon[954]: New relevant interface
wlan0.IPv6 for mDNS.
Sep  9 10:47:26 Arbeits-PC avahi-daemon[954]: Registering new address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.*.
Sep  9 10:47:31 Arbeits-PC kernel: [  208.291512] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:47:31 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:47:31 Arbeits-PC kernel: [  208.318408] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:47:31 Arbeits-PC kernel: [  208.321380] cfg80211: World
regulatory domain updated:
Sep  9 10:47:31 Arbeits-PC kernel: [  208.321383] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:47:31 Arbeits-PC kernel: [  208.321385] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:31 Arbeits-PC kernel: [  208.321386] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:31 Arbeits-PC kernel: [  208.321387] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:31 Arbeits-PC kernel: [  208.321388] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:31 Arbeits-PC kernel: [  208.321390] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:32 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:32 Arbeits-PC kernel: [  209.120037] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:47:32 Arbeits-PC kernel: [  209.144010] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:32 Arbeits-PC kernel: [  209.247887] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:47:32 Arbeits-PC kernel: [  209.352079] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:47:32 Arbeits-PC kernel: [  209.456277] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:47:36 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
roamed from BSSID A0:F3:C1:05:80:EC (WG-WLAN) to (none) ((none))
Sep  9 10:47:36 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) successful, device activated.
Sep  9 10:47:36 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:47:36 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:47:36 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:47:36 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:47:36 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:47:36 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:47:36 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:47:39 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:39 Arbeits-PC kernel: [  216.004458] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:47:39 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:47:39 Arbeits-PC kernel: [  216.028736] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:39 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:39 Arbeits-PC kernel: [  216.048402] wlan0: authenticated
Sep  9 10:47:39 Arbeits-PC kernel: [  216.052214] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:39 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:47:39 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:47:39 Arbeits-PC kernel: [  216.064312] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:47:39 Arbeits-PC kernel: [  216.064349] wlan0: associated
Sep  9 10:47:39 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:47:39 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:47:39 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:47:39 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:47:39 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
roamed from BSSID (none) ((none)) to A0:F3:C1:05:80:EC (WG-WLAN)
Sep  9 10:47:39 Arbeits-PC nm-dispatcher.action: Script
'/etc/NetworkManager/dispatcher.d/01ifupdown' took too long; killing
it.
Sep  9 10:47:39 Arbeits-PC NetworkManager[1051]: <warn> Dispatcher
script timed out: Script '/etc/NetworkManager/dispatcher.d/01ifupdown'
timed out.
Sep  9 10:47:44 Arbeits-PC NetworkManager[1051]: <info> (wlan0): IP6
addrconf timed out or failed.
Sep  9 10:47:44 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Sep  9 10:47:44 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Sep  9 10:47:44 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Sep  9 10:47:45 Arbeits-PC kernel: [  222.348702] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:47:45 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:47:45 Arbeits-PC kernel: [  222.371873] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:47:45 Arbeits-PC kernel: [  222.374743] cfg80211: World
regulatory domain updated:
Sep  9 10:47:45 Arbeits-PC kernel: [  222.374746] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:47:45 Arbeits-PC kernel: [  222.374747] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:45 Arbeits-PC kernel: [  222.374749] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:45 Arbeits-PC kernel: [  222.374750] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:45 Arbeits-PC kernel: [  222.374751] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:45 Arbeits-PC kernel: [  222.374752] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:47:45 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:47:45 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:47:46 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:46 Arbeits-PC kernel: [  223.169426] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:47:46 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:47:46 Arbeits-PC kernel: [  223.193456] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:46 Arbeits-PC kernel: [  223.297320] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:47:46 Arbeits-PC kernel: [  223.401529] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:47:46 Arbeits-PC kernel: [  223.505712] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:47:46 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:47:46 Arbeits-PC wpa_supplicant[1137]: wlan0: Failed to
initiate AP scan
Sep  9 10:47:47 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:47:48 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:48 Arbeits-PC kernel: [  225.337349] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:47:48 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:47:48 Arbeits-PC kernel: [  225.361659] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:48 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:47:48 Arbeits-PC kernel: [  225.374171] wlan0: authenticated
Sep  9 10:47:48 Arbeits-PC kernel: [  225.377091] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:47:48 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:47:48 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:47:48 Arbeits-PC kernel: [  225.395861] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:47:48 Arbeits-PC kernel: [  225.395897] wlan0: associated
Sep  9 10:47:48 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:47:48 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:47:48 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:47:48 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:48:01 Arbeits-PC kernel: [  238.409794] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:48:01 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:48:01 Arbeits-PC kernel: [  238.452957] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:48:01 Arbeits-PC kernel: [  238.455755] cfg80211: World
regulatory domain updated:
Sep  9 10:48:01 Arbeits-PC kernel: [  238.455757] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:48:01 Arbeits-PC kernel: [  238.455759] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:01 Arbeits-PC kernel: [  238.455760] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:01 Arbeits-PC kernel: [  238.455762] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:01 Arbeits-PC kernel: [  238.455763] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:01 Arbeits-PC kernel: [  238.455764] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:01 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:48:01 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:48:02 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:02 Arbeits-PC kernel: [  239.250560] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:48:02 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:48:02 Arbeits-PC kernel: [  239.274687] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:02 Arbeits-PC kernel: [  239.378450] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:48:02 Arbeits-PC kernel: [  239.482653] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:48:02 Arbeits-PC kernel: [  239.586841] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:48:02 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:48:02 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:48:09 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:09 Arbeits-PC kernel: [  246.135020] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:48:09 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:48:09 Arbeits-PC kernel: [  246.159149] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:09 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:09 Arbeits-PC kernel: [  246.172189] wlan0: authenticated
Sep  9 10:48:09 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:48:09 Arbeits-PC kernel: [  246.174779] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:09 Arbeits-PC kernel: [  246.195848] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:48:09 Arbeits-PC kernel: [  246.195876] wlan0: associated
Sep  9 10:48:09 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:48:09 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:48:15 Arbeits-PC kernel: [  252.459472] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:48:15 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: 4-Way
Handshake failed - pre-shared key may be incorrect
Sep  9 10:48:15 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:48:15 Arbeits-PC kernel: [  252.474510] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:48:15 Arbeits-PC kernel: [  252.477298] cfg80211: World
regulatory domain updated:
Sep  9 10:48:15 Arbeits-PC kernel: [  252.477300] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:48:15 Arbeits-PC kernel: [  252.477302] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:15 Arbeits-PC kernel: [  252.477303] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:15 Arbeits-PC kernel: [  252.477304] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:15 Arbeits-PC kernel: [  252.477306] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:15 Arbeits-PC kernel: [  252.477307] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:15 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> disconnected
Sep  9 10:48:15 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0/wireless): disconnected during association, asking for new key.
Sep  9 10:48:15 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: activated -> need-auth (reason
'supplicant-disconnect') [100 60 8]
Sep  9 10:48:15 Arbeits-PC dbus[891]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Sep  9 10:48:15 Arbeits-PC dbus[891]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Sep  9 10:48:15 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> inactive
Sep  9 10:48:18 Arbeits-PC nm-dispatcher.action: Script
'/etc/NetworkManager/dispatcher.d/01ifupdown' took too long; killing
it.
Sep  9 10:48:18 Arbeits-PC NetworkManager[1051]: <warn> Dispatcher
script timed out: Script '/etc/NetworkManager/dispatcher.d/01ifupdown'
timed out.
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: get_secret_flags:
assertion `is_secret_prop (setting, secret_name, error)' failed
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) started...
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: need-auth -> prepare (reason 'none') [60 40 0]
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) scheduled...
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 1 of 5 (Device Prepare) complete.
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) starting...
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: prepare -> config (reason 'none') [40 50 0]
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0/wireless): connection 'WG-WLAN' has security, and secrets
exist.  No new secrets needed.
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Config: added
'ssid' value 'WG-WLAN'
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Config: added
'scan_ssid' value '1'
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Config: added
'auth_alg' value 'OPEN'
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Config: added
'psk' value '<omitted>'
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 2 of 5 (Device Configure) complete.
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Config: set
interface ap_scan to 1
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: inactive -> scanning
Sep  9 10:48:19 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:19 Arbeits-PC kernel: [  256.758302] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:48:19 Arbeits-PC kernel: [  256.782523] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:19 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:19 Arbeits-PC kernel: [  256.787754] wlan0: authenticated
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:48:19 Arbeits-PC kernel: [  256.790088] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:19 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:48:19 Arbeits-PC kernel: [  256.799408] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:48:19 Arbeits-PC kernel: [  256.799441] wlan0: associated
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:48:19 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:48:19 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'WG-WLAN'.
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) scheduled.
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) started...
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: config -> ip-config (reason 'none') [50 70 0]
Sep  9 10:48:19 Arbeits-PC NetworkManager[1051]:
(nm-device.c:2045):dhcp4_start: runtime check failed:
(priv->dhcp4_client == NULL)
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
canceled DHCP transaction, DHCP client pid 3340
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> dhclient
started with pid 3453
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Beginning IP6 addrconf.
Sep  9 10:48:20 Arbeits-PC avahi-daemon[954]: Withdrawing address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.
Sep  9 10:48:20 Arbeits-PC avahi-daemon[954]: Leaving mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:48:20 Arbeits-PC avahi-daemon[954]: Interface wlan0.IPv6 no
longer relevant for mDNS.
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 3 of 5 (IP Configure Start) complete.
Sep  9 10:48:20 Arbeits-PC dhclient: Internet Systems Consortium DHCP
Client 4.2.4
Sep  9 10:48:20 Arbeits-PC dhclient: Copyright 2004-2012 Internet
Systems Consortium.
Sep  9 10:48:20 Arbeits-PC dhclient: All rights reserved.
Sep  9 10:48:20 Arbeits-PC dhclient: For info, please visit
https://www.isc.org/software/dhcp/
Sep  9 10:48:20 Arbeits-PC dhclient:
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
DHCPv4 state changed nbi -> preinit
Sep  9 10:48:20 Arbeits-PC dhclient: Listening on LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:48:20 Arbeits-PC dhclient: Sending on   LPF/wlan0/f8:1a:67:19:16:94
Sep  9 10:48:20 Arbeits-PC dhclient: Sending on   Socket/fallback
Sep  9 10:48:20 Arbeits-PC dhclient: DHCPREQUEST of 192.168.1.103 on
wlan0 to 255.255.255.255 port 67 (xid=0x6f1dd34a)
Sep  9 10:48:20 Arbeits-PC dhclient: DHCPACK of 192.168.1.103 from 192.168.1.1
Sep  9 10:48:20 Arbeits-PC dhclient: bound to 192.168.1.103 -- renewal
in 3474 seconds.
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
DHCPv4 state changed preinit -> reboot
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info>   address 192.168.1.103
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info>   prefix 24
(255.255.255.0)
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info>   gateway 192.168.1.1
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info>   nameserver
'192.168.1.1'
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) started...
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: ip-config -> secondaries (reason 'none') [70 90
0]
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 5 of 5 (IPv4 Commit) complete.
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
device state change: secondaries -> activated (reason 'none') [90 100
0]
Sep  9 10:48:20 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) successful, device activated.
Sep  9 10:48:21 Arbeits-PC avahi-daemon[954]: Joining mDNS multicast
group on interface wlan0.IPv6 with address fe80::fa1a:67ff:fe19:1694.
Sep  9 10:48:21 Arbeits-PC avahi-daemon[954]: New relevant interface
wlan0.IPv6 for mDNS.
Sep  9 10:48:21 Arbeits-PC avahi-daemon[954]: Registering new address
record for fe80::fa1a:67ff:fe19:1694 on wlan0.*.
Sep  9 10:48:28 Arbeits-PC ntpdate[3491]: adjust time server
91.189.89.199 offset -0.213312 sec
Sep  9 10:48:29 Arbeits-PC kernel: [  266.516718] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:48:29 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:48:29 Arbeits-PC kernel: [  266.555851] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:48:29 Arbeits-PC kernel: [  266.558649] cfg80211: World
regulatory domain updated:
Sep  9 10:48:29 Arbeits-PC kernel: [  266.558652] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:48:29 Arbeits-PC kernel: [  266.558653] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:29 Arbeits-PC kernel: [  266.558655] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:29 Arbeits-PC kernel: [  266.558656] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:29 Arbeits-PC kernel: [  266.558657] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:29 Arbeits-PC kernel: [  266.558658] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:29 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:48:29 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:48:30 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:30 Arbeits-PC kernel: [  267.353419] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:48:30 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:48:30 Arbeits-PC kernel: [  267.377706] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:30 Arbeits-PC kernel: [  267.481353] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:48:30 Arbeits-PC kernel: [  267.585557] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:48:30 Arbeits-PC kernel: [  267.689750] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:48:30 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
roamed from BSSID A0:F3:C1:05:80:EC (WG-WLAN) to (none) ((none))
Sep  9 10:48:30 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:48:30 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:48:37 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:37 Arbeits-PC kernel: [  274.233875] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:48:37 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:48:37 Arbeits-PC kernel: [  274.258197] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:37 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:37 Arbeits-PC kernel: [  274.272371] wlan0: authenticated
Sep  9 10:48:37 Arbeits-PC kernel: [  274.273674] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:37 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:48:37 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:48:37 Arbeits-PC kernel: [  274.291628] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:48:37 Arbeits-PC kernel: [  274.291660] wlan0: associated
Sep  9 10:48:37 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:48:37 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:48:37 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:48:37 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
Sep  9 10:48:37 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
roamed from BSSID (none) ((none)) to A0:F3:C1:05:80:EC (WG-WLAN)
Sep  9 10:48:40 Arbeits-PC NetworkManager[1051]: <info> (wlan0): IP6
addrconf timed out or failed.
Sep  9 10:48:40 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Sep  9 10:48:40 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Sep  9 10:48:40 Arbeits-PC NetworkManager[1051]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Sep  9 10:48:43 Arbeits-PC kernel: [  280.566425] wlan0: Connection to
AP a0:f3:c1:05:80:ec lost
Sep  9 10:48:43 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=a0:f3:c1:05:80:ec reason=4
Sep  9 10:48:43 Arbeits-PC kernel: [  280.601329] cfg80211: Calling
CRDA to update world regulatory domain
Sep  9 10:48:43 Arbeits-PC kernel: [  280.604141] cfg80211: World
regulatory domain updated:
Sep  9 10:48:43 Arbeits-PC kernel: [  280.604144] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  9 10:48:43 Arbeits-PC kernel: [  280.604146] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:43 Arbeits-PC kernel: [  280.604147] cfg80211:   (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:43 Arbeits-PC kernel: [  280.604148] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:43 Arbeits-PC kernel: [  280.604149] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:43 Arbeits-PC kernel: [  280.604150] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  9 10:48:43 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: completed -> disconnected
Sep  9 10:48:43 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:48:44 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:44 Arbeits-PC kernel: [  281.398896] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:48:44 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:48:44 Arbeits-PC kernel: [  281.422923] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:44 Arbeits-PC kernel: [  281.526833] wlan0: send auth to
a0:f3:c1:05:80:ec (try 2/3)
Sep  9 10:48:44 Arbeits-PC kernel: [  281.631008] wlan0: send auth to
a0:f3:c1:05:80:ec (try 3/3)
Sep  9 10:48:44 Arbeits-PC kernel: [  281.735202] wlan0:
authentication with a0:f3:c1:05:80:ec timed out
Sep  9 10:48:44 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> disconnected
Sep  9 10:48:44 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: disconnected -> scanning
Sep  9 10:48:51 Arbeits-PC wpa_supplicant[1137]: wlan0: SME: Trying to
authenticate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:51 Arbeits-PC kernel: [  288.283340] wlan0: authenticate
with a0:f3:c1:05:80:ec
Sep  9 10:48:51 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: scanning -> authenticating
Sep  9 10:48:51 Arbeits-PC wpa_supplicant[1137]: wlan0: Trying to
associate with a0:f3:c1:05:80:ec (SSID='WG-WLAN' freq=2427 MHz)
Sep  9 10:48:51 Arbeits-PC kernel: [  288.307651] wlan0: send auth to
a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:51 Arbeits-PC kernel: [  288.310133] wlan0: authenticated
Sep  9 10:48:51 Arbeits-PC kernel: [  288.311113] wlan0: associate
with a0:f3:c1:05:80:ec (try 1/3)
Sep  9 10:48:51 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: authenticating -> associating
Sep  9 10:48:51 Arbeits-PC kernel: [  288.319049] wlan0: RX AssocResp
from a0:f3:c1:05:80:ec (capab=0x431 status=0 aid=2)
Sep  9 10:48:51 Arbeits-PC kernel: [  288.319079] wlan0: associated
Sep  9 10:48:51 Arbeits-PC wpa_supplicant[1137]: wlan0: Associated
with a0:f3:c1:05:80:ec
Sep  9 10:48:51 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: associating -> 4-way handshake
Sep  9 10:48:51 Arbeits-PC wpa_supplicant[1137]: wlan0: WPA: Key
negotiation completed with a0:f3:c1:05:80:ec [PTK=CCMP GTK=CCMP]
Sep  9 10:48:51 Arbeits-PC wpa_supplicant[1137]: wlan0:
CTRL-EVENT-CONNECTED - Connection to a0:f3:c1:05:80:ec completed
(reauth) [id=0 id_str=]
Sep  9 10:48:51 Arbeits-PC NetworkManager[1051]: <info> (wlan0):
supplicant interface state: 4-way handshake -> completed
