Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52420 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3KAN7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:59:52 -0400
Received: by mail-wg0-f45.google.com with SMTP id z12so4082593wgg.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:59:51 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 50/65] wireless-regdb: add VHT80 rules for UA
Date: Fri,  1 Nov 2013 14:57:40 +0100
Message-Id: <1383314275-20960-51-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145956_876649_B97D139B)
In-Reply-To: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index 4ce2017..aa92c37 100644
--- a/db.txt
+++ b/db.txt
@@ -774,6 +774,8 @@ country TR: DFS-ETSI
 country UA: DFS-ETSI
 	(2400 - 2483.5 @ 40), (20), NO-OUTDOOR
 	(5150 - 5350 @ 40), (20), NO-OUTDOOR
+	(5490 - 5670 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
-- 
1.8.4.rc3

