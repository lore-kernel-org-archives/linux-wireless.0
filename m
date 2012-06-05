Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2FEMVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 08:21:41 -0400
Message-ID: <1338898901.4514.40.camel@jlt3.sipsolutions.net> (sfid-20120605_142144_001557_25E97BCA)
Subject: [PATCH] wireless: add my new trees to MAINTAINERS
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jun 2012 14:21:41 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add my new trees to the MAINTAINERS file
for the components that I maintain in the
new trees.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 MAINTAINERS |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c5fd905..c2d922d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1800,6 +1800,9 @@ F:	include/linux/cfag12864b.h
 CFG80211 and NL80211
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
 S:	Maintained
 F:	include/linux/nl80211.h
 F:	include/net/cfg80211.h
@@ -4340,7 +4343,8 @@ MAC80211
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
 S:	Maintained
 F:	Documentation/networking/mac80211-injection.txt
 F:	include/net/mac80211.h
@@ -4351,7 +4355,8 @@ M:	Stefano Brivio <stefano.brivio@polimi.it>
 M:	Mattias Nissler <mattias.nissler@gmx.de>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/developers/Documentation/mac80211/RateControl/PID
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
 S:	Maintained
 F:	net/mac80211/rc80211_pid*
 
@@ -5694,6 +5699,10 @@ F:	include/linux/remoteproc.h
 
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
+W:	http://wireless.kernel.org/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
+S:	Maintained
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	Documentation/rfkill.txt
-- 
1.7.10



