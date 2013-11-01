Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41385 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3KANzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:55:51 -0400
Received: by mail-wi0-f179.google.com with SMTP id hm4so1106576wib.6
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:55:50 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 7/8] wireless-regdb: optimize two of IL's rules
Date: Fri,  1 Nov 2013 14:55:30 +0100
Message-Id: <1383314131-20774-8-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145554_696615_E2EF1844)
In-Reply-To: <1383314131-20774-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314131-20774-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no reason not to merge these two rules.
This as picked up by the new CRDA optimizer.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 22b6561..ddfbc04 100644
--- a/db.txt
+++ b/db.txt
@@ -390,8 +390,7 @@ country IE: DFS-ETSI
 
 country IL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR
-	(5250 - 5350 @ 80), (200 mW), NO-OUTDOOR
+	(5150 - 5350 @ 80), (200 mW), NO-OUTDOOR
 
 country IN: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

