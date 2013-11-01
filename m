Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:36215 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAOEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:00 -0400
Received: by mail-we0-f177.google.com with SMTP id x55so3977861wes.36
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:59 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 12/23] wireless-regdb: update SA's 5 GHz rules
Date: Fri,  1 Nov 2013 15:03:07 +0100
Message-Id: <1383314598-21240-13-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150810_040323_08ABDA6E)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o increases the max EIRP from 17 dBm to 20 dBm
    on its first 5 GHz frequency range

  o reduces the max EIRP on its first DFS frequency
    range from 24 dBm to 20 dBm

  o increases the max EIRP on its second DFS frequency
    range from 24 dBm to 27 dBm

  o removes the last 5 GHz frequency range

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 983fdf9..bd5994d 100644
--- a/db.txt
+++ b/db.txt
@@ -698,10 +698,9 @@ country RW: DFS-FCC
 
 country SA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5710 @ 80), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
 country SE: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

