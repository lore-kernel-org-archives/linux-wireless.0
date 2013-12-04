Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33807 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3LDCc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 21:32:27 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so21334379pdj.39
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 18:32:27 -0800 (PST)
Message-ID: <529E9437.7020305@lwfinger.net> (sfid-20131204_033231_120148_78F7E211)
Date: Tue, 03 Dec 2013 20:32:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Nikita N." <nikitan@operamail.com>, linux-wireless@vger.kernel.org
Subject: Re: RTL8187 bugs
References: <1385589961.19021.52907237.3EE33E5B@webmail.messagingengine.com> <52966D64.2030805@lwfinger.net> <1385593188.3627.52911717.4E0712D9@webmail.messagingengine.com> <52968893.6060405@lwfinger.net> <1385812990.14905.53777877.7646278B@webmail.messagingengine.com> <529A1B52.6040605@lwfinger.net> <1385835820.6559.53858669.5FD3F3A6@webmail.messagingengine.com> <529A36C5.4060209@lwfinger.net> <1386079140.19919.54929613.506DE0D0@webmail.messagingengine.com> <529E0166.90302@lwfinger.net> <1386105710.9442.55117909.7AF98FBC@webmail.messagingengine.com>
In-Reply-To: <1386105710.9442.55117909.7AF98FBC@webmail.messagingengine.com>
Content-Type: multipart/mixed;
 boundary="------------090609000909010009070804"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090609000909010009070804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/03/2013 03:21 PM, Nikita N. wrote:

After rewriting your patch a bit (see attached copy), I got the following:

usb 1-5: new high-speed USB device number 5 using ehci-pci
rtl8187: inconsistency between id with OEM info!
-- regulatory rules --
ieee80211 phy3: Selected rate control algorithm 'minstrel_ht'
ieee80211 phy3: hwaddr 00:11:6b:3e:c4:0a, RTL8187BvB(early) V0 + rtl8225z2, 
rfkill mask 2
rtl8187: Customer ID is 0x00
rtl8187: wireless switch is on
usbcore: registered new interface driver rtl8187
systemd-udevd[5366]: renamed network interface wlan1 to wlp0s2f1u5
rtl8187_configure_filter
IN>changed_flags=0x0 ,total_flags=0x80000000 ,multicast=0x1 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
rtl8187_configure_filter
IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x1 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u5: link is not ready
rtl8187_configure_filter
IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x2 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
rtl8187_configure_filter
IN>changed_flags=0x12 ,total_flags=0x80000010 ,multicast=0x2 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
rtl8187_configure_filter
IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x2 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
rtl8187_configure_filter
IN>changed_flags=0x12 ,total_flags=0x80000010 ,multicast=0x2 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
wlp0s2f1u5: authenticate with 20:e5:2a:01:f7:ea
rtl8187_configure_filter
IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x2 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
wlp0s2f1u5: send auth to 20:e5:2a:01:f7:ea (try 1/3)
wlp0s2f1u5: authenticated
wlp0s2f1u5: associate with 20:e5:2a:01:f7:ea (try 1/3)
wlp0s2f1u5: RX AssocResp from 20:e5:2a:01:f7:ea (capab=0x411 status=0 aid=7)
wlp0s2f1u5: associated
IPv6: ADDRCONF(NETDEV_CHANGE): wlp0s2f1u5: link becomes ready
rtl8187_configure_filter
IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x3 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
rtl8187_configure_filter
IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x4 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
rtl8187_configure_filter
IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x5 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
rtl8187_configure_filter
IN>changed_flags=0x12 ,total_flags=0x80000010 ,multicast=0x5 
,priv->rx_conf=0x9094fc0e
 >FIF_ALLMULTI
OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e

Some comments on your patch:

1. The routine can be gotten from ("%s\n", __func__). That is a lot easier than 
hand coding the routine name.

2. Every printk should be terminated with \n (new line).

3. You can print multi-byte values with 0x%x. No need to split out the bytes the 
way you did.

I do not have aircrack running on my system, thus I cannot issue exactly the 
same command that you did.

The "daemon" that keeps calling rtl8187_configure_filter() is the transmit 
packet process of the kernel. You get one call for every packet out.

Larry


--------------090609000909010009070804
Content-Type: text/x-patch;
 name="nikita8187.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nikita8187.patch"

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187/dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -1306,17 +1306,30 @@ static void rtl8187_configure_filter(str
 				     u64 multicast)
 {
 	struct rtl8187_priv *priv = dev->priv;
+//nikita
+	printk(KERN_WARNING "%s\n", __func__);
+	printk(KERN_WARNING "IN>changed_flags=0x%x ,total_flags=0x%x ,multicast=0x%x ,priv->rx_conf=0x%x\n",
+	       changed_flags, *total_flags, (unsigned int)multicast, priv->rx_conf);
 
-	if (changed_flags & FIF_FCSFAIL)
+	if (changed_flags & FIF_FCSFAIL) {
 		priv->rx_conf ^= RTL818X_RX_CONF_FCS;
-	if (changed_flags & FIF_CONTROL)
+		printk(KERN_WARNING ">FIF_FCSFAIL\n");
+	}
+	if (changed_flags & FIF_CONTROL) {
 		priv->rx_conf ^= RTL818X_RX_CONF_CTRL;
-	if (changed_flags & FIF_OTHER_BSS)
+		printk(KERN_WARNING ">FIF_CONTROL\n");
+	}
+	if (changed_flags & FIF_OTHER_BSS) {
 		priv->rx_conf ^= RTL818X_RX_CONF_MONITOR;
-	if (*total_flags & FIF_ALLMULTI || multicast > 0)
+		printk(KERN_WARNING ">FIF_OTHER_BSS\n");
+	}
+	if (*total_flags & FIF_ALLMULTI || multicast > 0) {
 		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
-	else
+		printk(KERN_WARNING ">FIF_ALLMULTI\n");
+	} else {
 		priv->rx_conf &= ~RTL818X_RX_CONF_MULTICAST;
+		printk(KERN_WARNING ">not FIF_ALLMULTI\n");
+	}
 
 	*total_flags = 0;
 
@@ -1330,6 +1343,8 @@ static void rtl8187_configure_filter(str
 		*total_flags |= FIF_ALLMULTI;
 
 	rtl818x_iowrite32_async(priv, &priv->map->RX_CONF, priv->rx_conf);
+//nikita
+	printk(KERN_WARNING "OUT>total_flags=0x%x ,priv->rx_conf=0x%x\n", *total_flags, priv->rx_conf);
 }
 
 static int rtl8187_conf_tx(struct ieee80211_hw *dev,

--------------090609000909010009070804--
