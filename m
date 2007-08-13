Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1982 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967314AbXHMGhB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:01 -0400
Date: Sun, 12 Aug 2007 23:35:59 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, josejx@gentoo.org,
	johannes@sipsolutions.net, dsd@gentoo.org,
	akpm@linux-foundation.org
Subject: [PATCH] [441/2many] MAINTAINERS - SOFTMAC LAYER (IEEE 802.11)
Message-ID: <46bffbcf.xlboi9FGEwHN78S0%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2bda79d..d17ae3d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4195,6 +4195,8 @@ M:	dsd@gentoo.org
 W:	http://softmac.sipsolutions.net/
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	include/net/ieee80211softmac*
+F:	net/ieee80211/softmac/
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 P:	Ingo Molnar
