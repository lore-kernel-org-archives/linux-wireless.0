Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:36154 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbbGWDdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 23:33:13 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: seth.forshee@canonical.com
Cc: Chen-Yu Tsai <wens@csie.org>, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 5/5] wireless-regdb: Update 5 GHz rules for Taiwan (TW) to follow US
Date: Thu, 23 Jul 2015 11:33:00 +0800
Message-Id: <1437622380-4154-6-git-send-email-wens@csie.org> (sfid-20150723_053322_655751_991CD08B)
In-Reply-To: <1437622380-4154-1-git-send-email-wens@csie.org>
References: <1437622380-4154-1-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following the amendment of FCC part 15E and U-NII regulations effective
2014/06/02, and the opening up of 5150 ~ 5250 MHz and 5600 ~ 5650 MHz
spectrum in Taiwan, vendors have asked whether Taiwan's regulations
would be updated to match the new FCC rules, when this would happen,
and what to do in the interim.

The NCC, Taiwan's regulatory body has officially replied that new
amendments are under way, and the goal is to match the FCC rules.
Until the amendments come through, vendors are free to test and
submit applications using the new FCC rules for transmission power
limits and DFS requirements, though unintended / unwanted emissions
must still conform to the current standard, LP0002. [1][2]

This has been confirmed via a phone call to the NCC.

[1] http://www.rheintech.com/our-blog/item/585-taiwan-ncc-opens-5150-5250-mhz-for-wireless-devices
[2] Proposal #10312260 (p.6, Chinese),
    http://www.etc.org.tw/_library/K00/%E9%9B%BB%E4%BF%A1%E7%B5%82%E7%AB%AF%E8%A8%AD%E5%82%99%E5%AF%A9%E9%A9%97/1031223_nccqa56.pdf

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 29ba4b6..56fbba3 100644
--- a/db.txt
+++ b/db.txt
@@ -1125,10 +1125,10 @@ country TT: DFS-FCC
 # LP0002 Low-power Radio-frequency Devices Technical Regulations / 28 Jun 2011:
 #   http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
 #   (section 3.10.1, 4.7)
-country TW: DFS-JP
+country TW: DFS-FCC
 	(2400 - 2483.5 @ 40), (30)
 	(5150 - 5250 @ 80), (30), AUTO-BW
-	(5250 - 5350 @ 80), (17), DFS, AUTO-BW
+	(5250 - 5350 @ 80), (23), DFS, AUTO-BW
 	(5470 - 5725 @ 160), (23), DFS
 	(5725 - 5850 @ 80), (30)
  
-- 
2.1.4

