Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:52742 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbYKLXNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 18:13:12 -0500
Message-ID: <491B6305.1090606@lwfinger.net> (sfid-20081113_001315_998295_31847470)
Date: Wed, 12 Nov 2008 17:13:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Update of MAINTAINERS for RTL8187
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As noted by John Linville, the RTL818X maintainers have "moved on", and the
responsibilities for RTL8180 and RTL8187 have been split. This is the
corresponding update of MAINTAINERS.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---

Index: wireless-testing/MAINTAINERS
===================================================================
--- wireless-testing.orig/MAINTAINERS
+++ wireless-testing/MAINTAINERS
@@ -3568,7 +3568,7 @@ L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained

-RTL818X WIRELESS DRIVER
+RTL8180 WIRELESS DRIVER
 P:	John W. Linville
 M:	linville@tuxdriver.com
 L:	linux-wireless@vger.kernel.org
@@ -3576,6 +3576,18 @@ W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained

+RTL8187 WIRELESS DRIVER
+P:	 Herton Ronaldo Krzesinski
+M:      herton@mandriva.com.br
+P:      Hin-Tak Leung
+M       htl10@users.sourceforge.net
+P:      Larry Finger
+M:      Larry.Finger@lwfinger.net
+L:      linux-wireless@vger.kernel.org
+W:      http://linuxwireless.org/
+T:      git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-testing.git
+S:      Maintained
+
 S3 SAVAGE FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com


