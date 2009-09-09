Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12897 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZIIKEW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 06:04:22 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 03:04:25 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/4] ath9k: Get rid of the modparam btcoex_enable
Date: Wed, 9 Sep 2009 15:25:51 +0530
Message-ID: <1252490152-19284-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1252490152-19284-2-git-send-email-vasanth@atheros.com>
References: <1252490152-19284-1-git-send-email-vasanth@atheros.com>
 <1252490152-19284-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8d77817..c39693b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -21,10 +21,6 @@
 #include "ath9k.h"
 #include "initvals.h"
 
-static int btcoex_enable;
-module_param(btcoex_enable, bool, 0);
-MODULE_PARM_DESC(btcoex_enable, "Enable Bluetooth coexistence support");
-
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
-- 
1.5.5.1

