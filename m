Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0139.outbound.protection.outlook.com ([104.47.32.139]:58000
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726195AbeHOMMC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 08:12:02 -0400
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jia-Shyr Chuang <saint.chuang@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Subject: [PATCH v2] brcmfmac: add CYW89342 mini-PCIe device
Date: Wed, 15 Aug 2018 04:20:09 -0500
Message-Id: <1534324809-57218-1-git-send-email-chi-hsien.lin@cypress.com> (sfid-20180815_112108_634231_C4DD7108)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jia-Shyr Chuang <saint.chuang@cypress.com>

CYW89342 is a 2x2 MIMO, 802.11a/b/g/n/ac, SDIO 3.0 and PCIe 3.0 for
WLAN. It is a member of 4355/4359 family.

Signed-off-by: Jia-Shyr Chuang <saint.chuang@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 45928b5b8d97..f787ee5a6b6a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2016,6 +2016,7 @@ static const struct dev_pm_ops brcmf_pciedrvr_pm = {
 
 static const struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4350_DEVICE_ID),
+	BRCMF_PCIE_DEVICE_SUB(0x4355, BRCM_PCIE_VENDOR_ID_BROADCOM, 0x4355),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4356_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID),
-- 
2.1.0
