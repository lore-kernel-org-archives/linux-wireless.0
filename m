Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37279 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3KAOE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:29 -0400
Received: by mail-wg0-f45.google.com with SMTP id z12so4141377wgg.24
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:28 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 20/23] wireless-regdb: update MX's regulatory rules
Date: Fri,  1 Nov 2013 15:03:15 +0100
Message-Id: <1383314598-21240-21-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150812_099991_71FC89F0)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o increases the 2.4 GHz frequency range but with the
    compromise of reducing the max EIRP from 27 dBm to
    20 dBm

  o extends the second 5 GHz DFS frequency range

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 9158448..40a64d7 100644
--- a/db.txt
+++ b/db.txt
@@ -567,10 +567,10 @@ country MY: DFS-FCC
 	(5735 - 5835 @ 80), (30)
 
 country MX: DFS-FCC
-	(2402 - 2472 @ 40), (27)
+	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5710 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
 country NL: DFS-ETSI
-- 
1.8.4.rc3

