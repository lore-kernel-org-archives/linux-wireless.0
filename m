Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4656 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966803AbXHMG3c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:32 -0400
Date: Sun, 12 Aug 2007 23:28:47 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, j@w1.fi, akpm@linux-foundation.org
Subject: [PATCH] [223/2many] MAINTAINERS - HOST AP DRIVER
Message-ID: <46bffa1f.AhWwxXaebSiVEtFu%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 76bacfd..3efcecf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2138,6 +2138,7 @@ L:	hostap@shmoo.com (subscribers-only)
 L:	linux-wireless@vger.kernel.org
 W:	http://hostap.epitest.fi/
 S:	Maintained
+F:	drivers/net/wireless/hostap/
 
 HP100:	Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
 P:	Jaroslav Kysela
