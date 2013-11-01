Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42475 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3KAOEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:33 -0400
Received: by mail-wi0-f177.google.com with SMTP id f4so1115837wiw.10
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:32 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 22/23] wireless-regdb: update TW's regulatory rules
Date: Fri,  1 Nov 2013 15:03:17 +0100
Message-Id: <1383314598-21240-23-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150810_699294_1130987A)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o Increases the max EIRP for the 2.4 GHz band from
    27 dBm to 30 dBm

  o Splits up the 5 GHz DFS band into two DFS bands,
    one with VHT80 support, another only with HT40
    support

  o Extends the last 5 GHz frequency range by 20 MHz

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index 97165ed..e45991f 100644
--- a/db.txt
+++ b/db.txt
@@ -744,10 +744,11 @@ country SY:
 	(2402 - 2482 @ 40), (20)
 
 country TW: DFS-JP
-	(2402 - 2472 @ 40), (27)
+	(2402 - 2472 @ 40), (30)
 	(5270 - 5330 @ 40), (17), DFS
-	(5490 - 5710 @ 80), (30), DFS
-	(5735 - 5815 @ 80), (30)
+	(5490 - 5590 @ 80), (30), DFS
+	(5650 - 5710 @ 40), (30), DFS
+	(5735 - 5835 @ 80), (30)
 
 country TH: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

