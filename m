Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45433 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbYKLUBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 15:01:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] MAINTAINERS: claim maintenance over rtl818x drivers
Date: Wed, 12 Nov 2008 14:56:30 -0500
Message-Id: <1226519790-14594-1-git-send-email-linville@tuxdriver.com> (sfid-20081112_210114_241568_D026C8D0)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael and Andrea have moved-on, so we shouldn't be bothering them
about these drivers anymore.

Actually, Herton Ronaldo Krzesinski, Hin-Tak Leung, and Larry Finger
have been handling the rtl8187 stuff for a while.  So, I would welcome a
patch from one of them changing this to just RTL8180 and adding an
RTL8187 entry with their names...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cf256d6..16bceef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3569,13 +3569,11 @@ W:	http://www.linux-ax25.org/
 S:	Maintained
 
 RTL818X WIRELESS DRIVER
-P:	Michael Wu
-M:	flamingice@sourmilk.net
-P:	Andrea Merello
-M:	andreamrl@tiscali.it
+P:	John W. Linville
+M:	linville@tuxdriver.com
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 
 S3 SAVAGE FRAMEBUFFER DRIVER
-- 
1.5.4.3

