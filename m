Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36948 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729756AbeIFSfY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 14:35:24 -0400
Received: by mail-lj1-f193.google.com with SMTP id v9-v6so9424481ljk.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 06:59:42 -0700 (PDT)
From: Jukka Pirinen <jukka.pirinen@gmail.com>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        Jukka Pirinen <jukka.pirinen@gmail.com>
Subject: [PATCH] Update regulatory rules for Finland (FI) on 5GHz (SRD devices)
Date: Thu,  6 Sep 2018 16:59:15 +0300
Message-Id: <20180906135915.8365-1-jukka.pirinen@gmail.com> (sfid-20180906_155946_241834_DE710F9A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Viestintävirasto 15 AM/2018 M
Section 10 Non-specific short range devices
https://www.finlex.fi/data/normit/32670/Regulation_15AM.pdf

Signed-off-by: Jukka Pirinen <jukka.pirinen@gmail.com>
---
 db.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index 8cf7dee..b168f59 100644
--- a/db.txt
+++ b/db.txt
@@ -460,6 +460,8 @@ country FI: DFS-ETSI
 	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
 	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
 	(5470 - 5725 @ 160), (27), DFS, wmmrule=ETSI
+	# short range devices (ETSI EN 300 440-1)
+	(5725 - 5875 @ 80), (25 mW)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-- 
2.17.1
