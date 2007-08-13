Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1266 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967070AbXHMGc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:59 -0400
Date: Sun, 12 Aug 2007 23:32:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH] [341/2many] MAINTAINERS - NETWORKING [WIRELESS]
Message-ID: <46bffb0c.3YkIm4YVqMV/xU9v%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 91cdf28..fd59b3d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3280,6 +3280,8 @@ M:	linville@tuxdriver.com
 L:	linux-wireless@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
+F:	net/ieee80211/
+F:	include/net/ieee80211*
 
 NETXEN (1/10) GbE SUPPORT
 P:	Amit S. Kale
