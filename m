Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45061 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab1HWUh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 16:37:26 -0400
Received: by ywf7 with SMTP id 7so388188ywf.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 13:37:25 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	florian@openwrt.org, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: add AR9580 support
Date: Tue, 23 Aug 2011 13:37:07 -0700
Message-Id: <1314131827-29565-3-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110823_223729_498030_4E1ADBF8)
In-Reply-To: <1314131827-29565-1-git-send-email-lrodriguez@qca.qualcomm.com>
References: <1314131827-29565-1-git-send-email-lrodriguez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

This has been tested in STA and AP mode by Florian.

Cc: David Quan <dquan@qca.qualcomm.com>
Cc: Kathy Giori <kgiori@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Tested-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index daa26b5..6cb90ee 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -32,6 +32,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
+	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
 	{ 0 }
 };
 
-- 
1.7.4.15.g7811d

