Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34950 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KAOEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:24 -0400
Received: by mail-wi0-f171.google.com with SMTP id f4so1111876wiw.16
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:23 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 19/23] wireless-regdb: update KR's regulatory rules
Date: Fri,  1 Nov 2013 15:03:14 +0100
Message-Id: <1383314598-21240-20-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150811_848615_B1C8B5BB)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o enables HT40 for the 2.4 GHz frequency range
  o extends the 5 GHz DFS frequency range

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index b54ebd8..9158448 100644
--- a/db.txt
+++ b/db.txt
@@ -469,9 +469,10 @@ country KP: DFS-JP
 
 country KR: DFS-JP
 	(2402 - 2482 @ 20), (20)
+	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20)
 	(5250 - 5330 @ 80), (20), DFS
-	(5490 - 5630 @ 80), (30), DFS
+	(5490 - 5710 @ 80), (30), DFS
 	(5735 - 5815 @ 80), (30)
 
 country KW: DFS-ETSI
-- 
1.8.4.rc3

