Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38867 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1DDHNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 03:13:46 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p347Dkur000637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 4 Apr 2011 02:13:46 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: Update Power Save Exit Retries Packets
Date: Mon,  4 Apr 2011 10:15:31 +0300
Message-Id: <1301901331-19394-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reducing the retries of sending PS exit packets to the peer AP

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85cb4da..22c917d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -256,7 +256,7 @@ static struct conf_drv_settings default_conf = {
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
 		.bet_max_consecutive         = 50,
 		.psm_entry_retries           = 5,
-		.psm_exit_retries            = 255,
+		.psm_exit_retries            = 16,
 		.psm_entry_nullfunc_retries  = 3,
 		.psm_entry_hangover_period   = 1,
 		.keep_alive_interval         = 55000,
-- 
1.7.0.4

