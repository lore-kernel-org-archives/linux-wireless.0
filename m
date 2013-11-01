Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:33070 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3KAN6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:38 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so4058205wes.14
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:37 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 17/65] wireless-regdb: enable VHT80 for HN
Date: Fri,  1 Nov 2013 14:57:07 +0100
Message-Id: <1383314275-20960-18-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150807_399043_FFB4BD1C)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This also increases the max EIRP from 20 dBm to 24 dBm for
the 5 GHz DFS frequency ranges. Also extend the 5 GHz
DFS frequency range by 20 MHz.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 2f43aa9..d020532 100644
--- a/db.txt
+++ b/db.txt
@@ -341,10 +341,10 @@ country GU: DFS-FCC
 
 country HN: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (17)
-	(5250 - 5330 @ 40), (20), DFS
-	(5490 - 5710 @ 40), (20), DFS
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
 
 country HK:
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

