Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:45404 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAOEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:02 -0400
Received: by mail-we0-f179.google.com with SMTP id w61so3961612wes.38
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:01 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 13/23] wireless-regdb: update TT's 5 GHz rules
Date: Fri,  1 Nov 2013 15:03:08 +0100
Message-Id: <1383314598-21240-14-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150810_180135_6D54C690)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o Enables VHT80 on the first 5 GHz frequency range

  o Enables VHT80 for the first 5 GHz DFS frequency
    range and increases the max EIRP from 20 dBm to
    24 dBm

  o Extends the second DFS frequency range by 20 MHz,
    enables VHT80 and increases the max EIRP from 20
    dBm to 24 dBm

  o Enables VHT80 on the last 5 GHz frequency range

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index bd5994d..1d23fa1 100644
--- a/db.txt
+++ b/db.txt
@@ -757,10 +757,10 @@ country TH: DFS-FCC
 
 country TT: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (17)
-	(5250 - 5330 @ 40), (20), DFS
-	(5490 - 5710 @ 40), (20), DFS
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
 
 country TN: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

