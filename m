Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:52894 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1DUNDR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 09:03:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 06:02:51 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] ath9k: Fix warning: symbol 'ath9k_platform_id_table' was not declared. Should it be static?
Date: Thu, 21 Apr 2011 18:33:28 +0530
Message-ID: <1303391008-4794-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1303391008-4794-1-git-send-email-vasanth@atheros.com>
References: <1303391008-4794-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 090f314..6195639 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -21,7 +21,7 @@
 #include <linux/ath9k_platform.h>
 #include "ath9k.h"
 
-const struct platform_device_id ath9k_platform_id_table[] = {
+static const struct platform_device_id ath9k_platform_id_table[] = {
 	{
 		.name = "ath9k",
 		.driver_data = AR5416_AR9100_DEVID,
-- 
1.7.0.4

