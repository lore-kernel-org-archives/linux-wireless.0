Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab0CEDoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 22:44:39 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: kevin@atheros.com, doug.dahlby@atheros.com,
	cliff.holden@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 3/3] ath9k: rename initvals.h to ar9200_initvals.h
Date: Thu,  4 Mar 2010 22:44:38 -0500
Message-Id: <1267760678-5421-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1267760678-5421-1-git-send-email-lrodriguez@atheros.com>
References: <1267760678-5421-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The register initialization values we have so far are
only for the AR5008, AR9002 and AR9002 hardware families
and we've managed to get ar90002_hw.c to be its only user
so clarify this by renaming the initvals.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |    2 +-
 .../ath/ath9k/{initvals.h => ar9200_initvals.h}    |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/net/wireless/ath/ath9k/{initvals.h => ar9200_initvals.h} (100%)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 9e9247f..902d239 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -17,7 +17,7 @@
 #include "hw.h"
 #include "hw-ops.h"
 #include "rc.h"
-#include "initvals.h"
+#include "ar9200_initvals.h"
 
 static void ar9002_hw_disablepcie(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/ar9200_initvals.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/initvals.h
rename to drivers/net/wireless/ath/ath9k/ar9200_initvals.h
-- 
1.6.3.3

