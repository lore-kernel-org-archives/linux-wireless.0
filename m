Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:62444 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3KAOEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:05 -0400
Received: by mail-we0-f178.google.com with SMTP id q59so3944936wes.23
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:04 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 14/23] wireless-regdb: update ZA's 5 GHz rules
Date: Fri,  1 Nov 2013 15:03:09 +0100
Message-Id: <1383314598-21240-15-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150807_783140_9842242A)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o Increases the max EIRP on the first 5 GHz frequency
    range from 17 dBm to 20 dBm

  o Reduces the max EIRP on the first 5 GHz DFS frequency
    range from 24 dBm to 20 dBm

  o Increases the max EIRP on the second 5 GHz DFS frequency
    range from 24 dBm to 27 dBm

  o Removes the last 5 GHz frequency range

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 1d23fa1..de2e94e 100644
--- a/db.txt
+++ b/db.txt
@@ -834,10 +834,9 @@ country YE:
 
 country ZA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5710 @ 80), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
 country ZW: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

