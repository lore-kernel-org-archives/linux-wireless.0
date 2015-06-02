Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24748 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223AbbFBPX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 11:23:57 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
To: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 1/2] wireless-regdb: Add 60GHz regulatory rules for Japan (JP)
Date: Tue,  2 Jun 2015 18:23:47 +0300
Message-Id: <1433258628-7047-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150602_172409_560020_B4CC133A)
In-Reply-To: <1433258628-7047-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <20150602144231.GA31648@ubuntu-hedt>
 <1433258628-7047-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is ARIB STD-T74, available at:
http://www.arib.or.jp/english/html/overview/doc/1-STD-T74v1_1.pdf

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 db.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/db.txt b/db.txt
index 37b6c39..af3aaca 100644
--- a/db.txt
+++ b/db.txt
@@ -590,6 +590,9 @@ country JP: DFS-JP
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (23), DFS
+	# 60 GHz band channels 2-4 at 10mW,
+	# ref: http://www.arib.or.jp/english/html/overview/doc/1-STD-T74v1_1.pdf
+	(59000 - 66000 @ 2160), (10 mW)
 
 country KE: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
2.1.4

