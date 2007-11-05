Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbXKEOuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 09:50:20 -0500
Subject: [PATCH] softmac: MAINTAINERS update
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Daniel Drake <dsd@gentoo.org>, Joseph Jezak <josejx@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 14:32:35 +0100
Message-Id: <1194269555.4567.4.camel@johannes.berg> (sfid-20071105_145031_118952_02045E54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch marks softmac as obsolete in MAINTAINERS and removes Joe and
myself as maintainers, we're no longer using it nor interested in the
code in any way. Also remove the website reference because I took it
offline. Hopefully the code will go away in 2.6.25.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 MAINTAINERS |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- linux-2.6.orig/MAINTAINERS	2007-11-05 14:27:07.323066514 +0100
+++ linux-2.6/MAINTAINERS	2007-11-05 14:28:14.433057291 +0100
@@ -3450,15 +3450,10 @@ L:	lm-sensors@lm-sensors.org
 S:	Maintained
 
 SOFTMAC LAYER (IEEE 802.11)
-P:	Johannes Berg
-M:	johannes@sipsolutions.net
-P:	Joe Jezak
-M:	josejx@gentoo.org
 P:	Daniel Drake
 M:	dsd@gentoo.org
-W:	http://softmac.sipsolutions.net/
 L:	linux-wireless@vger.kernel.org
-S:	Maintained
+S:	Obsolete
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 P:	Ingo Molnar


