Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43538 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:42 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so1124722wid.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:41 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 04/23] wireless-regdb: update KP's 5 GHz rules
Date: Fri,  1 Nov 2013 15:02:59 +0100
Message-Id: <1383314598-21240-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150344_816611_03970EBF)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o splits the first 5 GHz frequency ranges into
    two frequency ranges, one with DFS requirement and
    one without
  o enables VHT80 for all 5 GHz frequency ranges

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 80a394a..c788681 100644
--- a/db.txt
+++ b/db.txt
@@ -462,10 +462,10 @@ country KH: DFS-ETSI
 
 country KP: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5330 @ 40), (20)
-	(5160 - 5250 @ 40), (20), DFS
-	(5490 - 5630 @ 40), (30), DFS
-	(5735 - 5815 @ 40), (30)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5630 @ 80), (30), DFS
+	(5735 - 5815 @ 80), (30)
 
 country KR: DFS-JP
 	(2402 - 2482 @ 20), (20)
-- 
1.8.4.rc3

