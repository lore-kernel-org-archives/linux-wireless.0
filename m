Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58543 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934124Ab0EZGtn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 02:49:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Subject: [RFC] wireless-regdb: Add A band in IL
Date: Wed, 26 May 2010 09:49:29 +0300
Message-Id: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A band in allowed in IL, according to official document issued by the Ministry
of Communications: http://www.moc.gov.il/sip_storage/FILES/1/1061.pdf.

5150 - 5250 200mW e.i.r.p. OUTDOOR forbidden
5250 - 5350 200mW e.i.r.p. OUTDOOR forbidden DFS mandatory

40Mhz is allowed in A band for every WiFi-Alliance certified equipment.

***************************************************************
Not to be merged for the moment
***************************************************************

CC: Michael Green <Michael.Green@atheros.com>
CC: David Quan <David.Quan@atheros.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 db.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/db.txt b/db.txt
index e63a43e..d49c397 100644
--- a/db.txt
+++ b/db.txt
@@ -319,6 +319,8 @@ country IE:
 
 country IL:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
+	(5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS
 
 country IN:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

