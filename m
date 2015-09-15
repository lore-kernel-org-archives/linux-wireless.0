Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59721 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbbIOFeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:34:19 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/4] staging: wilc1000: remove unused variable g_flushing_in_progress
Date: Tue, 15 Sep 2015 14:33:57 +0900
Message-ID: <1442295237-12644-4-git-send-email-tony.cho@atmel.com> (sfid-20150915_073422_469430_F1A55BA1)
In-Reply-To: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
References: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

g_flushing_in_progress is never used so just delete it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8cdd1d5..4fdb980 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -132,7 +132,6 @@ struct wilc_wfi_key g_key_gtk_params;
 struct add_key_params g_add_ptk_key_params;
 struct wilc_wfi_key g_key_ptk_params;
 struct wilc_wfi_wep_key g_key_wep_params;
-u8 g_flushing_in_progress;
 bool g_ptk_keys_saved;
 bool g_gtk_keys_saved;
 bool g_wep_keys_saved;
-- 
1.9.1

