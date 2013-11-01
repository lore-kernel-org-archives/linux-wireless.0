Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:39115 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:44 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so4064717wes.14
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:43 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 05/23] wireless-regdb: update MC's 5 GHz rules
Date: Fri,  1 Nov 2013 15:03:00 +0100
Message-Id: <1383314598-21240-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150347_457825_77D98B34)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o increase the max EIRP from 18 dBm to 20 dBm
    on the existing 5 GHz frequency ranges
  o enables VHT80
  o adds a new 5 GHz DFS frequency range

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index c788681..b8aa9d9 100644
--- a/db.txt
+++ b/db.txt
@@ -528,8 +528,9 @@ country LV: DFS-ETSI
 
 country MC: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (18)
-	(5250 - 5330 @ 40), (18), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
 country MA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

