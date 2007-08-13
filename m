Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:2509 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967440AbXHMGkT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:19 -0400
Date: Sun, 12 Aug 2007 23:40:02 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, kune@deine-taler.de, dsd@gentoo.org,
	akpm@linux-foundation.org
Subject: [PATCH] [552/2many] MAINTAINERS - ZD1211RW WIRELESS DRIVER
Message-ID: <46bffcc2.vfsLzqOFkf2EHmEW%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index cd5856d..937df70 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5229,6 +5229,7 @@ W:	http://zd1211.ath.cx/wiki/DriverRewrite
 L:	linux-wireless@vger.kernel.org
 L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/net/wireless/zd1211rw/
 
 ZF MACHZ WATCHDOG
 P:	Fernando Fuganti
