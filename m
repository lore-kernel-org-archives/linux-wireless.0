Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:38364 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAOD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:57 -0400
Received: by mail-we0-f178.google.com with SMTP id q59so4075663wes.9
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:56 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 11/23] wireless-regdb: update RW's 5 GHz rules
Date: Fri,  1 Nov 2013 15:03:06 +0100
Message-Id: <1383314598-21240-12-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150810_832642_B3CF961F)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o updates its existing 5 GHz frequency range to enable
    VHT80

  o adds two new 5 GHz frequency ranges with VHT80 support

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 908a369..983fdf9 100644
--- a/db.txt
+++ b/db.txt
@@ -691,7 +691,10 @@ country RU: DFS-ETSI
 
 country RW: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
 
 country SA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

