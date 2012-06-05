Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36765 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2FEMVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 08:21:16 -0400
Message-ID: <1338898874.4514.39.camel@jlt3.sipsolutions.net> (sfid-20120605_142120_048847_58788DE5)
Subject: [PATCH] wireless: update wireless URLs
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jun 2012 14:21:14 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The preferred URL is http://wireless.kernel.org/
rather than http://linuxwireless.org/, update all
URLs to point there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 MAINTAINERS                           |   18 +++++++++---------
 drivers/net/wireless/b43legacy/main.c |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55f0fda..c5fd905 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -329,7 +329,7 @@ F:	drivers/hwmon/adm1029.c
 
 ADM8211 WIRELESS DRIVER
 L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/
+W:	http://wireless.kernel.org/
 S:	Orphan
 F:	drivers/net/wireless/adm8211.*
 
@@ -1423,7 +1423,7 @@ B43 WIRELESS DRIVER
 M:	Stefano Brivio <stefano.brivio@polimi.it>
 L:	linux-wireless@vger.kernel.org
 L:	b43-dev@lists.infradead.org
-W:	http://linuxwireless.org/en/users/Drivers/b43
+W:	http://wireless.kernel.org/en/users/Drivers/b43
 S:	Maintained
 F:	drivers/net/wireless/b43/
 
@@ -1432,7 +1432,7 @@ M:	Larry Finger <Larry.Finger@lwfinger.net>
 M:	Stefano Brivio <stefano.brivio@polimi.it>
 L:	linux-wireless@vger.kernel.org
 L:	b43-dev@lists.infradead.org
-W:	http://linuxwireless.org/en/users/Drivers/b43
+W:	http://wireless.kernel.org/en/users/Drivers/b43
 S:	Maintained
 F:	drivers/net/wireless/b43legacy/
 
@@ -4339,7 +4339,7 @@ F:	arch/m68k/hp300/
 MAC80211
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/
+W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
 S:	Maintained
 F:	Documentation/networking/mac80211-injection.txt
@@ -4350,7 +4350,7 @@ MAC80211 PID RATE CONTROL
 M:	Stefano Brivio <stefano.brivio@polimi.it>
 M:	Mattias Nissler <mattias.nissler@gmx.de>
 L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/en/developers/Documentation/mac80211/RateControl/PID
+W:	http://wireless.kernel.org/en/developers/Documentation/mac80211/RateControl/PID
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
 S:	Maintained
 F:	net/mac80211/rc80211_pid*
@@ -5027,7 +5027,7 @@ F:	fs/ocfs2/
 
 ORINOCO DRIVER
 L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/en/users/Drivers/orinoco
+W:	http://wireless.kernel.org/en/users/Drivers/orinoco
 W:	http://www.nongnu.org/orinoco/
 S:	Orphan
 F:	drivers/net/wireless/orinoco/
@@ -5729,7 +5729,7 @@ F:	net/rose/
 RTL8180 WIRELESS DRIVER
 M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/
+W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/rtl818x/rtl8180/
@@ -5739,7 +5739,7 @@ M:	Herton Ronaldo Krzesinski <herton@canonical.com>
 M:	Hin-Tak Leung <htl10@users.sourceforge.net>
 M:	Larry Finger <Larry.Finger@lwfinger.net>
 L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/
+W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/rtl818x/rtl8187/
@@ -5748,7 +5748,7 @@ RTL8192CE WIRELESS DRIVER
 M:	Larry Finger <Larry.Finger@lwfinger.net>
 M:	Chaoming Li <chaoming_li@realsil.com.cn>
 L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/
+W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/rtlwifi/
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index cd9c9bc..8b06ca5 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1508,7 +1508,7 @@ static void b43legacy_release_firmware(struct b43legacy_wldev *dev)
 
 static void b43legacy_print_fw_helptext(struct b43legacy_wl *wl)
 {
-	b43legacyerr(wl, "You must go to http://linuxwireless.org/en/users/"
+	b43legacyerr(wl, "You must go to http://wireless.kernel.org/en/users/"
 		     "Drivers/b43#devicefirmware "
 		     "and download the correct firmware (version 3).\n");
 }
-- 
1.7.10



