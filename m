Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13414 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbYHDHQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 03:16:48 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 00:16:48 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/4] ath5k: remove Atheros 11n devices from supported list
Date: Mon, 4 Aug 2008 00:16:40 -0700
Message-ID: <1217834201-14680-4-git-send-email-lrodriguez@atheros.com> (sfid-20080804_091651_333677_2E090AA9)
In-Reply-To: <1217834201-14680-3-git-send-email-lrodriguez@atheros.com>
References: <1217834201-14680-1-git-send-email-lrodriguez@atheros.com>
 <1217834201-14680-2-git-send-email-lrodriguez@atheros.com>
 <1217834201-14680-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove Atheros 11n devices from being claimed by ath5k as its
now handled by ath9k.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath5k/base.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 0c948ca..b362c48 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -95,8 +95,6 @@ static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x001a), .driver_data = AR5K_AR5212 }, /* 2413 Griffin-lite */
 	{ PCI_VDEVICE(ATHEROS, 0x001b), .driver_data = AR5K_AR5212 }, /* 5413 Eagle */
 	{ PCI_VDEVICE(ATHEROS, 0x001c), .driver_data = AR5K_AR5212 }, /* 5424 Condor (PCI-E)*/
-	{ PCI_VDEVICE(ATHEROS, 0x0023), .driver_data = AR5K_AR5212 }, /* 5416 */
-	{ PCI_VDEVICE(ATHEROS, 0x0024), .driver_data = AR5K_AR5212 }, /* 5418 */
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
-- 
1.5.6.rc2.15.g457bb.dirty

