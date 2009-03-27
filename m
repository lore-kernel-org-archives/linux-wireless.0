Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33307 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZC0EU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 00:20:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, pabs@debian.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/4] wireless-regdb: fix a couple of comment typos
Date: Fri, 27 Mar 2009 00:20:55 -0400
Message-Id: <1238127656-1226-4-git-send-email-lrodriguez@atheros.com> (sfid-20090327_052119_001058_B8831937)
In-Reply-To: <1238127656-1226-1-git-send-email-lrodriguez@atheros.com>
References: <1238127656-1226-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 6f29be9..139699a 100644
--- a/db.txt
+++ b/db.txt
@@ -1,7 +1,7 @@
-# This is the word regulatory domain
+# This is the world regulatory domain
 country 00:
 	(2402 - 2472 @ 40), (3, 20)
-        # Channel 12 - 14. No HT40 channel fits here
+        # Channel 12 - 13. No HT40 channel fits here
         (2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
         # Channel 14. Only JP enables this and for 802.11b only
         (2474 - 2494 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS, NO-OFDM
-- 
1.6.0.6

