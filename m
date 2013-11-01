Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:47416 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:39 -0400
Received: by mail-we0-f179.google.com with SMTP id w61so4064100wes.10
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:38 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 03/23] wireless-regdb: update KE's 5 GHz rules
Date: Fri,  1 Nov 2013 15:02:58 +0100
Message-Id: <1383314598-21240-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150342_967715_62492F53)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o Shrinks the existing 5 GHz band by 60 MHz
    and decreases its max EIRP from 30 dBm to
    23 dBm

  o Adds new 5 GHz frequency ranges with VHT80
    support

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 16c4865..80a394a 100644
--- a/db.txt
+++ b/db.txt
@@ -450,7 +450,9 @@ country JO: DFS-JP
 
 country KE: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (23)
+	(5490 - 5570 @ 80), (30), DFS
+	(5735 - 5775 @ 40), (23)
 
 country KH: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

