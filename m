Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:47701 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3KAOEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:41 -0400
Received: by mail-we0-f179.google.com with SMTP id w61so3922502wes.24
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:40 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 23/23] wireless-regdb: update US'  regulatory rules
Date: Fri,  1 Nov 2013 15:03:18 +0100
Message-Id: <1383314598-21240-24-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150807_889301_2B913093)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o Increases the max EIRP on the 2.4 GHz band from
    27 dBm to 30 dBm

  o Decreases the max EIRP for the first DFS frequency
    range by 1 dBm

  o Removes the two lower 5 GHz DFS frequency ranges

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index e45991f..752dfc9 100644
--- a/db.txt
+++ b/db.txt
@@ -793,11 +793,9 @@ country UA: DFS-ETSI
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
 country US: DFS-FCC
-	(2402 - 2472 @ 40), (27)
+	(2402 - 2472 @ 40), (30)
 	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5600 @ 80), (24), DFS
-	(5650 - 5710 @ 40), (24), DFS
+	(5250 - 5330 @ 80), (23), DFS
 	(5735 - 5835 @ 80), (30)
 	# 60g band
 	# reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
-- 
1.8.4.rc3

