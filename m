Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58280 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2GIRdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 13:33:37 -0400
Received: by wgbdr13 with SMTP id dr13so11657157wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 10:33:36 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	xose.vazquez@gmail.com
Subject: [PATCH V2] MAINTAINERS: realtek drivers
Date: Mon,  9 Jul 2012 19:33:32 +0200
Message-Id: <1341855212-7151-1-git-send-email-xose.vazquez@gmail.com> (sfid-20120709_193341_811112_405BD5DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s/RTL8192CE/RTLWIFI , add wiki pages and delete
"F:     drivers/net/wireless/rtlwifi/rtl8192ce/", it's redundant.

v2 s/RTL8192CE/RTLWIFI: RTL8192CE, RTL8192CU, RT8192SE AND RTL8192DE


Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>
Cc: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 03df1d1..27de053 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5753,7 +5753,7 @@ F:	net/rose/
 RTL8180 WIRELESS DRIVER
 M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/
+W:	http://linuxwireless.org/en/users/Drivers/rtl8187
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/rtl818x/rtl8180/
@@ -5763,20 +5763,19 @@ M:	Herton Ronaldo Krzesinski <herton@canonical.com>
 M:	Hin-Tak Leung <htl10@users.sourceforge.net>
 M:	Larry Finger <Larry.Finger@lwfinger.net>
 L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/
+W:	http://linuxwireless.org/en/users/Drivers/rtl8187
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/rtl818x/rtl8187/
 
-RTL8192CE WIRELESS DRIVER
+RTLWIFI: RTL8192CE, RTL8192CU, RT8192SE AND RTL8192DE WIRELESS DRIVERS
 M:	Larry Finger <Larry.Finger@lwfinger.net>
 M:	Chaoming Li <chaoming_li@realsil.com.cn>
 L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/
+W:	http://linuxwireless.org/en/users/Drivers/rtl819x
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/rtlwifi/
-F:	drivers/net/wireless/rtlwifi/rtl8192ce/
 
 S3 SAVAGE FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
-- 
1.7.10.4

