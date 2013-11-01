Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:64024 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:46 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so4059225wes.28
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:45 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 06/23] wireless-regdb: update MA's 5 GHz rules
Date: Fri,  1 Nov 2013 15:03:01 +0100
Message-Id: <1383314598-21240-7-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150349_190356_0F4BED55)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

  o removes the edge 5 GHz DFS frequency range
  o reduces the max EIRP from 23 dBm to 20 dBm on 5 GHz
  o adds a new 5 GHz DFS frequency range

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index b8aa9d9..db20fd0 100644
--- a/db.txt
+++ b/db.txt
@@ -534,8 +534,8 @@ country MC: DFS-ETSI
 
 country MA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (23)
-	(5735 - 5835 @ 80), (23)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
 
 country MO:
 	(2402 - 2482 @ 40), (20)
-- 
1.8.4.rc3

