Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44418 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbFAHhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 03:37:37 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless-regdb: Add 60GHz regulatory rules for Japan (JP)
Date: Mon,  1 Jun 2015 10:37:26 +0300
Message-Id: <1433144246-18214-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150601_093744_057942_C54F8D21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is ARIB STD-T74, available at:
http://www.arib.or.jp/english/html/overview/doc/1-STD-T74v1_1.pdf

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 db.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/db.txt b/db.txt
index df7f7b1..7157ae8 100644
--- a/db.txt
+++ b/db.txt
@@ -584,6 +584,9 @@ country JP: DFS-JP
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (23), DFS
+	# 60 gHz band channels 2-4 at 10mW,
+	# ref: http://www.arib.or.jp/english/html/overview/doc/1-STD-T74v1_1.pdf
+	(59000 - 66000 @ 2160), (10 mW)
 
 country KE: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
2.1.4

