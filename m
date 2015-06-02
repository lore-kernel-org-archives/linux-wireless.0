Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24748 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbbFBPX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 11:23:59 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
To: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 2/2] wireless-regdb: Add 60GHz regulatory rules for Russia (RU)
Date: Tue,  2 Jun 2015 18:23:48 +0300
Message-Id: <1433258628-7047-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150602_172411_288142_4760C19E)
In-Reply-To: <1433258628-7047-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <20150602144231.GA31648@ubuntu-hedt>
 <1433258628-7047-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
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
index af3aaca..809cd3c 100644
--- a/db.txt
+++ b/db.txt
@@ -998,6 +998,8 @@ country RU: DFS-ETSI
 	(5250 - 5330 @ 40), (20), DFS
 	(5650 - 5730 @ 40), (30), DFS
 	(5735 - 5835 @ 40), (30)
+	# 60 GHz band channels 1-4, ref: Changes to NLA 124_Order №129_22042015.pdf
+	(57000 - 66000 @ 2160), (40)
 
 country RW: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
2.1.4

