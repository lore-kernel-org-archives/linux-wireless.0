Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1624 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967216AbXHMGe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:56 -0400
Date: Sun, 12 Aug 2007 23:34:41 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, corey@world.std.com,
	akpm@linux-foundation.org
Subject: [PATCH] [400/2many] MAINTAINERS - RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
Message-ID: <46bffb81.3Y36j03eTK6yltNK%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index da61adc..e62a648 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3822,6 +3822,7 @@ P:	Corey Thomas
 M:	corey@world.std.com
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	drivers/net/wireless/ray*
 
 RANDOM NUMBER DRIVER
 P:	Matt Mackall
