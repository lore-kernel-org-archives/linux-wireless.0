Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45913 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:48 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so4090201wgh.27
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:47 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 07/23] wireless-regdb: update NP's 5 GHz rules
Date: Fri,  1 Nov 2013 15:03:02 +0100
Message-Id: <1383314598-21240-8-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150351_589000_DC4B1FD1)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o enables VHT80 on its existing 5 GHz frequency range
    but makes a compromise and reduces the max EIRP from
    30 dBm to 20 dBm

  o adds two new VHT80 capable frequency ranges

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index db20fd0..e2740a6 100644
--- a/db.txt
+++ b/db.txt
@@ -589,7 +589,9 @@ country NO: DFS-ETSI
 
 country NP: DFS-JP
 	(2402 - 2482 @ 40), (20)
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
 
 country NZ: DFS-FCC
 	(2402 - 2482 @ 40), (30)
-- 
1.8.4.rc3

