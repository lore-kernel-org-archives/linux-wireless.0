Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63274 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3KAN7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:36 -0400
Received: by mail-wg0-f52.google.com with SMTP id k14so4110154wgh.7
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:35 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 43/65] wireless-regdb: enable VHT80 for UZ
Date: Fri,  1 Nov 2013 14:57:33 +0100
Message-Id: <1383314275-20960-44-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150810_567101_16EAC545)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o Increases max EIRP from 27 dBm to 30 dBm on the 2.4 GHz
    band

  o Enables VHT80 for all 5 GHz frequency ranges

  o Increase max EIRP from 20 dBm to 24 dBm on the 5 GHz
    DFS frequency ranges

  o Extends the second 5 GHz DFS frequency range by 20 MHz

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index 0c9dc2c..b423b77 100644
--- a/db.txt
+++ b/db.txt
@@ -788,11 +788,11 @@ country UY: DFS-FCC
 	(5735 - 5835 @ 40), (30)
 
 country UZ: DFS-FCC
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
 
 country VE: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

