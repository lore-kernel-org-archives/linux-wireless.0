Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41060 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0DTW2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 18:28:37 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] ath9k_hw: make two initvals consto for the AR9001 family
Date: Tue, 20 Apr 2010 18:28:35 -0400
Message-Id: <1271802516-15195-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271802516-15195-1-git-send-email-lrodriguez@atheros.com>
References: <1271802516-15195-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes ar5416Addac_9160 and ar5416Addac_9160 const
I guess we skipped them long ago.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
index 20abffe..0b94bd3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
@@ -1182,7 +1182,7 @@ static const u32 ar5416Bank7_9160[][2] = {
     { 0x000098cc, 0x0000000e },
 };
 
-static u32 ar5416Addac_9160[][2] = {
+static const u32 ar5416Addac_9160[][2] = {
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
@@ -1217,7 +1217,7 @@ static u32 ar5416Addac_9160[][2] = {
     {0x000098cc,  0x00000000 },
 };
 
-static u32 ar5416Addac_91601_1[][2] = {
+static const u32 ar5416Addac_91601_1[][2] = {
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
-- 
1.6.3.3

