Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:40854 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3KAOEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:31 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so4060314wes.28
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:30 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 21/23] wireless-regdb: update PA's regulatory rules
Date: Fri,  1 Nov 2013 15:03:16 +0100
Message-Id: <1383314598-21240-22-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150809_068881_68CEA467)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o increases the max EIRP on the 2.4 GHz frequency
    range from 27 dBm to 30 dBm
  o enables VHT80 on all the 5 GHz frequency ranges

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 40a64d7..97165ed 100644
--- a/db.txt
+++ b/db.txt
@@ -608,10 +608,10 @@ country OM: DFS-ETSI
 	(5490 - 5710 @ 80), (27), DFS
 
 country PA: DFS-FCC
-	(2402 - 2472 @ 40), (27)
-	(5170 - 5250 @ 40), (17)
-	(5250 - 5330 @ 40), (23), DFS
-	(5735 - 5835 @ 40), (30)
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
 
 country PE: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

