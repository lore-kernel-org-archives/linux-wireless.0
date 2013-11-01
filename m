Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52019 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:35 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so3988569wgh.34
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:34 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 01/23] wireless-regdb: update BN's 5 GHz rules
Date: Fri,  1 Nov 2013 15:02:56 +0100
Message-Id: <1383314598-21240-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150338_508709_42CFCFA1)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enables VHT80 but reduces the max EIRP on the last
5 GHz band from 30 dBm to 20 dBm.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index 591bdab..3c03886 100644
--- a/db.txt
+++ b/db.txt
@@ -122,9 +122,9 @@ country BL:
 
 country BN: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (20)
-	(5250 - 5330 @ 40), (20), DFS
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
 
 country BO: DFS-JP
 	(2402 - 2482 @ 40), (30)
-- 
1.8.4.rc3

