Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3827 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965288AbXHMGYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:30 -0400
Date: Sun, 12 Aug 2007 23:24:15 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, st3@riseup.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Larry.Finger@lwfinger.net
Subject: [PATCH] [91/2many] MAINTAINERS - BCM43XX WIRELESS DRIVER (SOFTMAC BASED VERSION)
Message-ID: <46bff90f.X8PWdq8AFutCqEl/%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 90689a0..3a7309a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -930,6 +930,7 @@ M:	st3@riseup.net
 L:	linux-wireless@vger.kernel.org
 W:	http://bcm43xx.berlios.de/
 S:	Maintained
+F:	drivers/net/wireless/bcm43xx/
 
 BEFS FILE SYSTEM
 P:	Sergey S. Kostyliov
