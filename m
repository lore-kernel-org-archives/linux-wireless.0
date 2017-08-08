Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:45594 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751913AbdHHDiQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 23:38:16 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wireless-regdb: Add 60 GHz rule for Taiwan (TW)
Date: Tue,  8 Aug 2017 11:38:04 +0800
Message-Id: <20170808033804.6053-2-wens@csie.org> (sfid-20170808_054017_171681_306E90DC)
In-Reply-To: <20170808033804.6053-1-wens@csie.org>
References: <20170808033804.6053-1-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest low power radio frequency devices technical regulations [1]
released by Taiwan's regulatory body, NCC, opens up 57 GHz ~ 66 GHz to
most devices, including WiGig.

[1] LP0002 Low-power Radio-frequency Devices Technical Regulations 2016/8/23
    http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 db.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index d96f00e..e48f9a6 100644
--- a/db.txt
+++ b/db.txt
@@ -1188,6 +1188,8 @@ country TW: DFS-FCC
 	(5250 - 5350 @ 80), (23), DFS, AUTO-BW
 	(5470 - 5725 @ 160), (23), DFS
 	(5725 - 5850 @ 80), (30)
+	# 60g band, LP0002 section 3.13.1.1 (3)(C), EIRP=40dBm(43dBm peak)
+	(57000 - 66000 @ 2160), (40)
  
 country TZ:
 	(2402 - 2482 @ 40), (20)
-- 
2.13.3
