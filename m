Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44593 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbZGVRlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 13:41:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 10:41:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	David Quan <david.quan@atheros.com>,
	Michael Green <michael.green@atheros.com>
Subject: [PATCH] ath: map TH to FCC3_WORLD
Date: Wed, 22 Jul 2009 10:41:14 -0700
Message-ID: <1248284474-9042-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TH gets 5 GHz.

Cc: David Quan <david.quan@atheros.com>
Cc: Michael Green <michael.green@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/regd_common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 4d0e298..ad6d938 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -450,7 +450,7 @@ static struct country_code_to_enum_rd allCountries[] = {
 	{CTRY_SWITZERLAND, ETSI1_WORLD, "CH"},
 	{CTRY_SYRIA, NULL1_WORLD, "SY"},
 	{CTRY_TAIWAN, APL3_FCCA, "TW"},
-	{CTRY_THAILAND, NULL1_WORLD, "TH"},
+	{CTRY_THAILAND, FCC3_WORLD, "TH"},
 	{CTRY_TRINIDAD_Y_TOBAGO, ETSI4_WORLD, "TT"},
 	{CTRY_TUNISIA, ETSI3_WORLD, "TN"},
 	{CTRY_TURKEY, ETSI3_WORLD, "TR"},
-- 
1.6.3.3

