Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34853 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbbJEOCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:02:46 -0400
Received: by ioiz6 with SMTP id z6so185877424ioi.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 07:02:45 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Seth Forshee <seth.forshee@canonical.com>,
	=?UTF-8?q?Karl=20M=C3=B6ller?= <karl@excors.net>
Subject: [PATCH] wireless-regdb: Update ZA rules for 5490-5710 MHz
Date: Mon,  5 Oct 2015 09:02:02 -0500
Message-Id: <1444053722-33852-1-git-send-email-seth.forshee@canonical.com> (sfid-20151005_160249_377327_533ABCCF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Radio Frequency Spectrum Regulations 2015 [1] drops the
requirement for DFS and TPC in the 5490-5710 MHz range. Update
the database to remove DFS for this range and remove the 3dB drop
in the transmit power limit for TPC.

[1] http://www.ellipsis.co.za/wp-content/uploads/2014/12/Radio-Frequency-Spectrum-Regulations-2015.pdf

Cc: Karl Möller <karl@excors.net>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 db.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index d57ea84..721b081 100644
--- a/db.txt
+++ b/db.txt
@@ -1242,7 +1242,7 @@ country ZA: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5490 - 5710 @ 160), (27), DFS
+	(5490 - 5710 @ 160), (30)
 
 country ZW: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.9.1

