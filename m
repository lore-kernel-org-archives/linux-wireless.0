Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:35554 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab3KAN7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:41 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so4054283wes.28
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:40 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 45/65] wireless-regdb: enable VHT80 for UY
Date: Fri,  1 Nov 2013 14:57:35 +0100
Message-Id: <1383314275-20960-46-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145950_344078_C0D71809)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o Enables VHT80 on all 5 GHz frequency ranges

  o Increases max EIRP from 20 dBm to 24 dBm for
    the 5 GHz DFS frequency ranges

  o Extends the second 5 GHz DFS frequency range
    by 20 MHz

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index cbbbe18..50307eb 100644
--- a/db.txt
+++ b/db.txt
@@ -782,10 +782,10 @@ country US: DFS-FCC
 
 country UY: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (17)
-	(5250 - 5330 @ 40), (20), DFS
-	(5490 - 5710 @ 40), (20), DFS
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
 
 country UZ: DFS-FCC
 	(2402 - 2472 @ 40), (30)
-- 
1.8.4.rc3

