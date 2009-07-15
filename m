Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbZGOAO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 11/21] ath9k: remap ATH9K_MODE_*
Date: Tue, 14 Jul 2009 20:14:03 -0400
Message-Id: <1247616853-11221-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a lot of gaps here.

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5e40223..9a4570d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -113,14 +113,14 @@
 
 enum wireless_mode {
 	ATH9K_MODE_11A = 0,
-	ATH9K_MODE_11G = 3,
-	ATH9K_MODE_11NA_HT20 = 6,
-	ATH9K_MODE_11NG_HT20 = 7,
-	ATH9K_MODE_11NA_HT40PLUS = 8,
-	ATH9K_MODE_11NA_HT40MINUS = 9,
-	ATH9K_MODE_11NG_HT40PLUS = 10,
-	ATH9K_MODE_11NG_HT40MINUS = 11,
-	ATH9K_MODE_MAX
+	ATH9K_MODE_11G,
+	ATH9K_MODE_11NA_HT20,
+	ATH9K_MODE_11NG_HT20,
+	ATH9K_MODE_11NA_HT40PLUS,
+	ATH9K_MODE_11NA_HT40MINUS,
+	ATH9K_MODE_11NG_HT40PLUS,
+	ATH9K_MODE_11NG_HT40MINUS,
+	ATH9K_MODE_MAX,
 };
 
 enum ath9k_hw_caps {
-- 
1.6.0.6

