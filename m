Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:49542 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3KAOES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:18 -0400
Received: by mail-we0-f172.google.com with SMTP id q58so4036752wes.31
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:17 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 17/23] wireless-regdb: update GE's regulatory rules
Date: Fri,  1 Nov 2013 15:03:12 +0100
Message-Id: <1383314598-21240-18-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150812_609525_94D84607)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o increases the max EIRP for 2.4 GHz from 27 dBm to 30 dBm.
  o Enables VHT80 on 5 GHz
  o Increases max EIRP from 20 dBm to 24 dBm on 5 GHz DFS freqs

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index 50c81ce..e9d1540 100644
--- a/db.txt
+++ b/db.txt
@@ -315,11 +315,11 @@ country GB: DFS-ETSI
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
 country GD: DFS-FCC
-	(2402 - 2472 @ 40), (27)
-	(5170 - 5250 @ 40), (17)
-	(5250 - 5330 @ 40), (20), DFS
-	(5490 - 5710 @ 40), (20), DFS
-	(5735 - 5835 @ 40), (30)
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
 
 country GR: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

