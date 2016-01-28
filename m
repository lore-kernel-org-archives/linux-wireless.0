Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12137 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200AbcA1HQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 02:16:20 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/12] staging: wilc1000: renames u16TagParamOffset variable
Date: Thu, 28 Jan 2016 16:13:37 +0900
Message-ID: <1453965226-6158-3-git-send-email-leo.kim@atmel.com> (sfid-20160128_081632_298750_D08FF0D1)
In-Reply-To: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
References: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16TagParamOffset variable to tag_param_offset
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 9f85fff..b769d3c 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -241,11 +241,11 @@ static inline u16 get_asoc_id(u8 *data)
 	return asoc_id;
 }
 
-static u8 *get_tim_elm(u8 *pu8msa, u16 rx_len, u16 u16TagParamOffset)
+static u8 *get_tim_elm(u8 *pu8msa, u16 rx_len, u16 tag_param_offset)
 {
 	u16 u16index;
 
-	u16index = u16TagParamOffset;
+	u16index = tag_param_offset;
 
 	while (u16index < (rx_len - FCS_LEN)) {
 		if (pu8msa[u16index] == ITIM)
-- 
1.9.1

