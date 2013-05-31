Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53453 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3EaCJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:09:59 -0400
Received: by mail-pd0-f175.google.com with SMTP id 6so1376010pdd.6
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:09:58 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 05/40] crda: remove unused BUG_ON() from intersect.c
Date: Thu, 30 May 2013 19:08:54 -0700
Message-Id: <1369966169-23640-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_041001_719114_EE0050B8)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/intersect.c b/intersect.c
index 59fd007..7352e73 100644
--- a/intersect.c
+++ b/intersect.c
@@ -9,13 +9,6 @@
 /* Intersects regulatory domains, this will skip any regulatory marked with
  * an alpha2 of '00', which is used to indicate a regulatory domain */
 
-#define BUG_ON(foo) do { \
-	if (foo) { \
-		printf("BUG\n"); \
-		exit(-1); \
-	} \
-	} while (0)
-
 /* Sanity check on a regulatory rule */
 static int is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 {
-- 
1.7.10.4

