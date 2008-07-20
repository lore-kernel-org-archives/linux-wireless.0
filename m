Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:47698 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbYGTCp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 22:45:59 -0400
Date: Sat, 19 Jul 2008 22:45:54 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Subject: [PATCH] [PATCH 2/4] Remove Atheros 11n devices from ath5k
Message-ID: <20080720024554.GS17936@ruslug.rutgers.edu> (sfid-20080720_044601_623955_084F5868)
References: <20080720024341.GQ17936@ruslug.rutgers.edu> <20080720024500.GR17936@ruslug.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080720024500.GR17936@ruslug.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove Atheros 11n devices from being claimed by ath5k as its
now handled by ath9k.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath5k/base.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 217d506..99f0cd3 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -93,8 +93,6 @@ static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x001a), .driver_data = AR5K_AR5212 }, /* 2413 Griffin-lite */
 	{ PCI_VDEVICE(ATHEROS, 0x001b), .driver_data = AR5K_AR5212 }, /* 5413 Eagle */
 	{ PCI_VDEVICE(ATHEROS, 0x001c), .driver_data = AR5K_AR5212 }, /* 5424 Condor (PCI-E)*/
-	{ PCI_VDEVICE(ATHEROS, 0x0023), .driver_data = AR5K_AR5212 }, /* 5416 */
-	{ PCI_VDEVICE(ATHEROS, 0x0024), .driver_data = AR5K_AR5212 }, /* 5418 */
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
-- 
1.5.4.3

