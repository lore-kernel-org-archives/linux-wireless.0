Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43853 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3KGAQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 19:16:57 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/13] ath9k: Update MAINTAINERS
Date: Thu,  7 Nov 2013 05:42:00 +0530
Message-Id: <1383783120-22435-14-git-send-email-sujith@msujith.org> (sfid-20131107_013807_514056_2562E99E)
In-Reply-To: <1383783120-22435-1-git-send-email-sujith@msujith.org>
References: <1383783120-22435-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 MAINTAINERS | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d59670..a137b3f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1444,17 +1444,6 @@ T:	git git://github.com/kvalo/ath.git
 S:	Supported
 F:	drivers/net/wireless/ath/ath6kl/
 
-ATHEROS ATH9K WIRELESS DRIVER
-M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
-M:	Jouni Malinen <jouni@qca.qualcomm.com>
-M:	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
-M:	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
-L:	linux-wireless@vger.kernel.org
-L:	ath9k-devel@lists.ath9k.org
-W:	http://wireless.kernel.org/en/users/Drivers/ath9k
-S:	Supported
-F:	drivers/net/wireless/ath/ath9k/
-
 WILOCITY WIL6210 WIRELESS DRIVER
 M:	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
 L:	linux-wireless@vger.kernel.org
@@ -6849,6 +6838,14 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/qt1010*
 
+QUALCOMM ATHEROS ATH9K WIRELESS DRIVER
+M:	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
+L:	linux-wireless@vger.kernel.org
+L:	ath9k-devel@lists.ath9k.org
+W:	http://wireless.kernel.org/en/users/Drivers/ath9k
+S:	Supported
+F:	drivers/net/wireless/ath/ath9k/
+
 QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
 M:	Kalle Valo <kvalo@qca.qualcomm.com>
 L:	ath10k@lists.infradead.org
-- 
1.8.4.2

