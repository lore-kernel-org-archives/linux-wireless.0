Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3079 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161475AbXEEPhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2007 11:37:10 -0400
Date: Sat, 5 May 2007 09:46:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/4 (resend)] mac80211: add maintainers entry for mac80211
Message-ID: <20070505134620.GD4155@tuxdriver.com>
References: <20070505031749.GA5308@tuxdriver.com> <20070505134255.GA4155@tuxdriver.com> <20070505134438.GB4155@tuxdriver.com> <20070505134528.GC4155@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070505134528.GC4155@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jiri Benc <jbenc@suse.cz>

Add MAINTAINERS entry for mac80211.

Signed-off-by: Jiri Benc <jbenc@suse.cz>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index af1c792..5ba3d1d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2209,6 +2209,16 @@ M:	philb@gnu.org
 W:	http://www.tazenda.demon.co.uk/phil/linux-hp
 S:	Maintained
 
+MAC80211
+P:	Jiri Benc
+M:	jbenc@suse.cz
+P:	Michael Wu
+M:	flamingice@sourmilk.net
+L:	linux-wireless@vger.kernel.org
+W:	http://linuxwireless.org/
+T:	git kernel.org:/pub/scm/linux/kernel/git/jbenc/mac80211.git
+S:	Maintained
+
 MARVELL YUKON / SYSKONNECT DRIVER
 P:	Mirko Lindner
 M: 	mlindner@syskonnect.de
-- 
1.5.0.6

-- 
John W. Linville
linville@tuxdriver.com
