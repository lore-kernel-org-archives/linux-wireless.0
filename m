Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4096 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbXKUORB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 09:17:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: rjw@sisk.pl, larry.finger@lwfinger.net, stefano.brivio@polimi.it,
	mb@bu3sch.de, bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] bcm43xx: mark as obsolete and schedule for removal
Date: Wed, 21 Nov 2007 09:16:11 -0500
Message-Id: <1195654571-10506-1-git-send-email-linville@tuxdriver.com> (sfid-20071121_141706_705498_1004077B)
In-Reply-To: <20071121135927.GC8792@tuxdriver.com>
References: <20071121135927.GC8792@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 MAINTAINERS                                |    2 +-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 20c4c8b..c057e36 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -333,3 +333,12 @@ Why:	This driver has been marked obsolete for many years.
 Who:	Stephen Hemminger <shemminger@linux-foundation.org>
 
 ---------------------------
+
+What:	bcm43xx wireless network driver
+When:	2.6.26
+Files:	drivers/net/wireless/bcm43xx
+Why:	This driver's functionality has been replaced by the
+	mac80211-based b43 and b43legacy drivers.
+Who:	John W. Linville <linville@tuxdriver.com>
+
+---------------------------
diff --git a/MAINTAINERS b/MAINTAINERS
index 18b7c8e..2bfc23f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -828,7 +828,7 @@ P:	Stefano Brivio
 M:	stefano.brivio@polimi.it
 L:	linux-wireless@vger.kernel.org
 W:	http://bcm43xx.berlios.de/
-S:	Maintained
+S:	Obsolete
 
 BEFS FILE SYSTEM
 P:	Sergey S. Kostyliov
-- 
1.5.3.3

