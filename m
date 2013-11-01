Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:43776 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3KAN6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:55 -0400
Received: by mail-we0-f171.google.com with SMTP id t60so4036957wes.30
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:58:54 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 25/65] wireless-regdb: enable VHT80 for JM
Date: Fri,  1 Nov 2013 14:57:15 +0100
Message-Id: <1383314275-20960-26-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150808_406848_82A2D9FF)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This also increases the max EIRP on DFS frequency
ranges from 20 dBm to 24 dBm. This also increases
the 5 GHz DFS frequency range by 20 MHz.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index accba4b..1d8c0b5 100644
--- a/db.txt
+++ b/db.txt
@@ -420,10 +420,10 @@ country IT: DFS-ETSI
 
 country JM: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (17)
-	(5250 - 5330 @ 40), (20), DFS
-	(5490 - 5710 @ 40), (20), DFS
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
 
 country JP: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

