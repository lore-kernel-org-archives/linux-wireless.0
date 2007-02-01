Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422892AbXBANzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Feb 2007 08:55:08 -0500
Subject: [PATCH] maintainers: update all wireless entries
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 14:45:18 +0100
Message-Id: <1170337518.22420.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates the MAINTAINERS file putting the new list into place
wherever appropriate. For some entries, I replaced netdev, for others I
just added this one.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- mb-wireless.orig/MAINTAINERS	2007-02-01 11:51:45.356144295 +0100
+++ mb-wireless/MAINTAINERS	2007-02-01 12:03:06.716144295 +0100
@@ -242,7 +242,7 @@ S:	Maintained
 ADM8211 WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
-L:	netdev@vger.kernel.org
+L:	linux-wireless@vger.kernel.org
 W:	http://aluminum.sourmilk.net/adm8211/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/d80211-drivers.git
 S:	Maintained
@@ -572,6 +572,7 @@ S:	Supported
 ATMEL WIRELESS DRIVER
 P:	Simon Kelley
 M:	simon@thekelleys.org.uk
+L:	linux-wireless@vger.kernel.org
 W:	http://www.thekelleys.org.uk/atmel
 W:	http://atmelwlandriver.sourceforge.net/
 S:	Maintained
@@ -620,6 +621,7 @@ P:	Michael Buesch
 M:	mb@bu3sch.de
 P:	Stefano Brivio
 M:	st3@riseup.net
+L:	linux-wireless@vger.kernel.org
 W:	http://bcm43xx.berlios.de/
 S:	Maintained
 
@@ -628,6 +630,7 @@ P:	Larry Finger
 M:	Larry.Finger@lwfinger.net
 P:	Stefano Brivio
 M:	st3@riseup.net
+L:	linux-wireless@vger.kernel.org
 W:	http://bcm43xx.berlios.de/
 S:	Maintained
 
@@ -1456,6 +1459,7 @@ S:	Supported
 HOST AP DRIVER
 P:	Jouni Malinen
 M:	jkmaline@cc.hut.fi
+L:	linux-wireless@vger.kernel.org
 L:	hostap@shmoo.com
 W:	http://hostap.epitest.fi/
 S:	Maintained
@@ -1750,6 +1754,7 @@ P:	Yi Zhu
 M:	yi.zhu@intel.com
 P:	James Ketrenos
 M:	jketreno@linux.intel.com
+L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
 L:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2100.sourceforge.net
@@ -1760,6 +1765,7 @@ P:	Yi Zhu
 M:	yi.zhu@intel.com
 P:	James Ketrenos
 M:	jketreno@linux.intel.com
+L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
 L:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2200.sourceforge.net
@@ -2325,7 +2331,7 @@ S:	Maintained
 NETWORKING [WIRELESS]
 P:	John W. Linville
 M:	linville@tuxdriver.com
-L:	netdev@vger.kernel.org
+L:	linux-wireless@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 
@@ -2454,6 +2460,7 @@ P:	Pavel Roskin
 M:	proski@gnu.org
 P:	David Gibson
 M:	hermes@gibson.dropbear.id.au
+L:	linux-wireless@vger.kernel.org
 L:	orinoco-users@lists.sourceforge.net
 L:	orinoco-devel@lists.sourceforge.net
 W:	http://www.nongnu.org/orinoco/
@@ -2623,7 +2630,7 @@ S:	Supported
 P54 WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
-L:	netdev@vger.kernel.org
+L:	linux-wireless@vger.kernel.org
 L:	developers@islsm.org
 W:	http://prism54.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/d80211-drivers.git
@@ -2632,7 +2639,7 @@ S:	Maintained
 PRISM54 WIRELESS DRIVER
 P:	Prism54 Development Team
 M:	prism54-private@prism54.org
-L:	netdev@vger.kernel.org
+L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
 S:	Maintained
 
@@ -2697,12 +2704,12 @@ S:	Maintained
 RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
 P:	Corey Thomas
 M:	corey@world.std.com
-L:	linux-kernel@vger.kernel.org
+L:	linux-wireless@vger.kernel.org
 S:	Maintained
 
 Ralink rt2x00 WLAN driver
 P:	rt2x00 project
-M:	rt2400-devel@lists.sourceforge.net
+L:	linux-wireless@vger.kernel.org
 L:	rt2400-devel@lists.sourceforge.net
 W:	http://rt2x00.serialmonkey.com/
 S:	Maintained
@@ -2964,7 +2971,7 @@ M:	josejx@gentoo.org
 P:	Daniel Drake
 M:	dsd@gentoo.org
 W:	http://softmac.sipsolutions.net/
-L:	netdev@vger.kernel.org
+L:	linux-wireless@vger.kernel.org
 S:	Maintained
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
@@ -3641,6 +3648,7 @@ S:	Maintained
 WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
 P:	Jean Tourrilhes
 M:	jt@hpl.hp.com
+L:	linux-wireless@vger.kernel.org
 W:	http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
 S:	Maintained
 
@@ -3658,6 +3666,7 @@ S:	Maintained
 WL3501 WIRELESS PCMCIA CARD DRIVER
 P:	Arnaldo Carvalho de Melo
 M:	acme@conectiva.com.br
+L:	linux-wireless@vger.kernel.org
 W:	http://advogato.org/person/acme
 S:	Maintained
 
@@ -3720,6 +3729,7 @@ M:	dsd@gentoo.org
 P:	Ulrich Kunitz
 M:	kune@deine-taler.de
 W:	http://zd1211.ath.cx/wiki/DriverRewrite
+L:	linux-wireless@vger.kernel.org
 L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 


