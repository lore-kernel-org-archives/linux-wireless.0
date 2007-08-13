Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1561 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967193AbXHMGed (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:33 -0400
Date: Sun, 12 Aug 2007 23:34:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH] [389/2many] MAINTAINERS - PRISM54 WIRELESS DRIVER
Message-ID: <46bffb6b.ZUAsbjOXozOHlrbF%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 049c63b..f61f0a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3717,6 +3717,7 @@ M:	mcgrof@gmail.com
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
 S:	Maintained
+F:	drivers/net/wireless/prism54/
 
 PROMISE DC4030 CACHING DISK CONTROLLER DRIVER
 P:	Peter Denison
