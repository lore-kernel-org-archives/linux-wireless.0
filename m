Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:33196 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3KAOEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:04:20 -0400
Received: by mail-we0-f177.google.com with SMTP id x55so3965948wes.22
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:04:19 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 18/23] wireless-regdb: update PR's regulatory rules
Date: Fri,  1 Nov 2013 15:03:13 +0100
Message-Id: <1383314598-21240-19-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150810_976887_6F82CB9C)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o Increases max EIRP from 27 dBm to 30 dBm on the
    2.4 GHz frequency range

  o Extends the 5 GHz DFS frequency range by 20 MHz

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index e9d1540..b54ebd8 100644
--- a/db.txt
+++ b/db.txt
@@ -654,10 +654,10 @@ country PT: DFS-ETSI
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
 country PR: DFS-FCC
-	(2402 - 2472 @ 40), (27)
+	(2402 - 2472 @ 40), (30)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5710 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
 country QA: DFS-JP
-- 
1.8.4.rc3

