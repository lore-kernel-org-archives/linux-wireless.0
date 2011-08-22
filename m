Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35304 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1HVXcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 19:32:24 -0400
Received: by yxj19 with SMTP id 19so3891612yxj.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 16:32:24 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: florian@openwrt.org
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: add AR9580 support
Date: Mon, 22 Aug 2011 16:31:27 -0700
Message-Id: <1314055887-12806-3-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110823_013226_859767_8FA136FA)
In-Reply-To: <1314055887-12806-1-git-send-email-lrodriguez@qca.qualcomm.com>
References: <1314055887-12806-1-git-send-email-lrodriguez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

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

