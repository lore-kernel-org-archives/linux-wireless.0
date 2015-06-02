Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48779 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbbFBOEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 10:04:32 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless-regdb: Add 60GHz regulatory rules for Russia (RU)
Date: Tue,  2 Jun 2015 17:04:09 +0300
Message-Id: <1433253849-5494-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150602_160436_111985_834B41D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is document named
Changes to NLA 124_Order №129_22042015.pdf

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 db.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index f361030..79dac92 100644
--- a/db.txt
+++ b/db.txt
@@ -978,6 +978,8 @@ country RU: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5650 - 5730 @ 80), (30), DFS
 	(5735 - 5835 @ 80), (30)
+	# 60 GHz band channels 1-4, ref: Changes to NLA 124_Order №129_22042015.pdf
+	(57000 - 66000 @ 2160), (40)
 
 country RW: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
2.1.4

