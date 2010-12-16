Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34470 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab0LPPNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 10:13:24 -0500
Date: Thu, 16 Dec 2010 09:13:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8192ce: Update MAINTAINERS
Message-ID: <4d0a2c91.Nuemy+kBaD1fOuX+%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/MAINTAINERS
===================================================================
--- wireless-testing.orig/MAINTAINERS
+++ wireless-testing/MAINTAINERS
@@ -5055,6 +5055,16 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/net/wireless/rtl818x/rtl8187*
 
+RTL8192CE WIRELESS DRIVER
+M:	Larry Finger <Larry.Finger@lwfinger.net>
+M:	Chaoming Li <chaoming_li@realsil.com.cn>
+L:	linux-wireless@vger.kernel.org
+W:	http://linuxwireless.org/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
+S:	Maintained
+F:	drivers/net/wireless/rtlwifi/
+F:	drivers/net/wireless/rtl8192ce/
+
 S3 SAVAGE FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
 L:	linux-fbdev@vger.kernel.org
