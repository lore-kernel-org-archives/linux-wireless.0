Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbZKIXag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:30:36 -0500
Date: Mon, 09 Nov 2009 17:30:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: bzolnier@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-wireless@vger.kernel.org
Subject: [RFT 5/6] rtl8187se: Modify rtl818x.h
Message-ID: <4af8a620.dg8pt7VFvPdjmtQU%Larry.Finger@lwfinger.net>
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
