Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51888 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752097AbXEAPkx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 11:40:53 -0400
Date: Tue, 1 May 2007 17:40:44 +0200
From: Jiri Benc <jbenc@suse.cz>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-dev: remove duplicate inclusion of wireless/ in  Makefile
Message-ID: <20070501174044.231074ea@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wireless/ directory is included two times in net/Makefile.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 net/Makefile |    2 --
 1 files changed, 2 deletions(-)

--- mac80211.orig/net/Makefile
+++ mac80211/net/Makefile
@@ -55,5 +55,3 @@ obj-$(CONFIG_IUCV)		+= iucv/
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_SYSCTL)		+= sysctl_net.o
 endif
-
-obj-y				+= wireless/


-- 
Jiri Benc
SUSE Labs
