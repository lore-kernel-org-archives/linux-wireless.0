Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50139 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:52 -0400
Received: by mail-wi0-f180.google.com with SMTP id ey11so1116829wid.13
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:52 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 09/23] wireless-regdb: update PG's 5 GHz rules
Date: Fri,  1 Nov 2013 15:03:04 +0100
Message-Id: <1383314598-21240-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150356_057860_41F6062E)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o enables VHT80 on all 5 GHz frequency rules
  o adds a new DFS 5 GHz frequency range
  o increases max EIRP on the 5 GHZ DFS frequency
    range from 23 dBm to 24 dBm

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index 8366b3b..a1eafa4 100644
--- a/db.txt
+++ b/db.txt
@@ -621,9 +621,10 @@ country PE: DFS-FCC
 
 country PG: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (17)
-	(5250 - 5330 @ 40), (23), DFS
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
 
 country PH: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

