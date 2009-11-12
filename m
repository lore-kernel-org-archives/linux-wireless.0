Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760073AbZKLEeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 23:34:12 -0500
Date: Wed, 11 Nov 2009 22:34:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, bzolnier@gmail.com
Cc: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Subject: [RFC/RFT 5/6 V2] rtl8187se: Modify rtl818x.h
Message-ID: <4afb9049.cQMhmIsnGv7eygmA%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify the general header file for new rtl8187se definition.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl818x.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl818x.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl818x.h
@@ -79,6 +79,7 @@ struct rtl818x_csr {
 #define RTL818X_RX_CONF_MULTICAST	(1 <<  2)
 #define RTL818X_RX_CONF_BROADCAST	(1 <<  3)
 #define RTL818X_RX_CONF_FCS		(1 <<  5)
+#define RTL818x_RX_CONF_MAXDMA		(7 <<  8)
 #define RTL818X_RX_CONF_DATA		(1 << 18)
 #define RTL818X_RX_CONF_CTRL		(1 << 19)
 #define RTL818X_RX_CONF_MGMT		(1 << 20)
