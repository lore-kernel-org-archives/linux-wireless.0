Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:32883 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdBXFfD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 00:35:03 -0500
Date: Fri, 24 Feb 2017 00:35:00 -0500
From: Tahia Khan <tahia.khan@gmail.com>
To: outreachy-kernel@googlegroups.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] staging: wilc1000: Rename struct tstrRSSI to
 rssi_history_buffer
Message-ID: <da73d1aef379243ba94a5c1a4e1d6663160451fd.1487912400.git.tahia.khan@gmail.com> (sfid-20170224_063533_627415_65945D9A)
References: <cover.1487912400.git.tahia.khan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1487912400.git.tahia.khan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename struct tstrRSSI to rssi_history_buffer for clarity and to remove camel casing.

Signed-off-by: Tahia Khan <tahia.khan@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index cff1698..1c77529 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -70,7 +70,7 @@ enum connect_status {
 	CONNECT_STS_FORCE_16_BIT = 0xFFFF
 };
 
-struct tstrRSSI {
+struct rssi_history_buffer {
 	u8 u8Full;
 	u8 u8Index;
 	s8 as8RSSI[NUM_RSSI];
@@ -93,7 +93,7 @@ struct network_info {
 	u8 *ies;
 	u16 ies_len;
 	void *join_params;
-	struct tstrRSSI str_rssi;
+	struct rssi_history_buffer str_rssi;
 	u64 tsf_hi;
 };
 
-- 
2.7.4
