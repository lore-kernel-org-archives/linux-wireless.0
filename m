Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33538 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAOEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:12 -0400
Received: by mail-wg0-f52.google.com with SMTP id k14so4069033wgh.31
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:12 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 16/23] wireless-regdb: update CO's regulatory rules
Date: Fri,  1 Nov 2013 15:03:11 +0100
Message-Id: <1383314598-21240-17-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150809_779160_F7406826)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends CO's coverage by 10 MHz but reduces its
max EIRP from 27 dBm to 20 dBm. This also increases
the 5 GHz DFS frequency range.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index f26fd1d..50c81ce 100644
--- a/db.txt
+++ b/db.txt
@@ -180,10 +180,10 @@ country CN: DFS-FCC
 	(63720 - 65880 @ 2160), (28)
 
 country CO: DFS-FCC
-	(2402 - 2472 @ 40), (27)
+	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5710 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
 country CR: DFS-FCC
-- 
1.8.4.rc3

