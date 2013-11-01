Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:46044 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:50 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so4041852wes.15
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:49 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 08/23] wireless-regdb: update OM's 5 GHz rules
Date: Fri,  1 Nov 2013 15:03:03 +0100
Message-Id: <1383314598-21240-9-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150353_541671_44A36BE4)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o removes the last 5 GHz frequency range
  o increases the max EIRP on the first 5 GHz
    frequency range from 17 dBm to 20 dBm
  o enables VHT80 for all 5 GHz frequency ranges

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index e2740a6..8366b3b 100644
--- a/db.txt
+++ b/db.txt
@@ -602,10 +602,9 @@ country NZ: DFS-FCC
 
 country OM: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (17)
-	(5250 - 5330 @ 40), (20), DFS
-	(5490 - 5710 @ 40), (20), DFS
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
 country PA: DFS-FCC
 	(2402 - 2472 @ 40), (27)
-- 
1.8.4.rc3

