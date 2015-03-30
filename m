Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45627 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbbC3Kaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 06:30:35 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Update Macau (MO) rules
Date: Mon, 30 Mar 2015 13:30:22 +0300
Message-ID: <1427711422-4967-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20150330_123038_337481_C9EE0DC0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

source: http://www.dsrt.gov.mo/por/laws/198_2014.html
on July 30, 2014

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index dff2fba..317bfb1 100644
--- a/db.txt
+++ b/db.txt
@@ -751,11 +751,12 @@ country MN: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country MO:
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (23)
-	(5250 - 5330 @ 40), (23), DFS
-	(5735 - 5835 @ 40), (30)
+country MO: DFS-FCC
+	(2402 - 2482 @ 40), (23)
+	(5170 - 5250 @ 80), (23), AUTO-BW
+	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
+	(5490 - 5730 @ 160), (30), DFS
+	(5735 - 5835 @ 80), (30)
 
 country MP: DFS-FCC
 	(2402 - 2472 @ 40), (30)
-- 
1.9.1

