Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0121.outbound.protection.outlook.com ([104.47.40.121]:22688
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753115AbeCPKTZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:19:25 -0400
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Subject: [PATCH V2 6/6] Update license for brcm firmware
Date: Fri, 16 Mar 2018 05:18:07 -0500
Message-Id: <1521195487-176486-7-git-send-email-chi-hsien.lin@cypress.com> (sfid-20180316_112006_158509_125DEB85)
In-Reply-To: <1521195487-176486-1-git-send-email-chi-hsien.lin@cypress.com>
References: <1521195487-176486-1-git-send-email-chi-hsien.lin@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upload a Cypress version of below firmware and hence update the
license:

brcm/brcmfmac43340-sdio.bin
brcm/brcmfmac43362-sdio.bin
brcm/brcmfmac43430-sdio.bin
brcm/brcmfmac4354-sdio.bin
brcm/brcmfmac4356-pcie.bin

Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 WHENCE | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/WHENCE b/WHENCE
index 2fb6048..e9ca599 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2226,9 +2226,7 @@ File: brcm/brcmfmac43236b.bin
 File: brcm/brcmfmac4329-sdio.bin
 File: brcm/brcmfmac4330-sdio.bin
 File: brcm/brcmfmac4334-sdio.bin
-File: brcm/brcmfmac43340-sdio.bin
 File: brcm/brcmfmac4335-sdio.bin
-File: brcm/brcmfmac43362-sdio.bin
 File: brcm/brcmfmac4339-sdio.bin
 File: brcm/brcmfmac43241b0-sdio.bin
 File: brcm/brcmfmac43241b4-sdio.bin
@@ -2236,13 +2234,10 @@ File: brcm/brcmfmac43241b5-sdio.bin
 File: brcm/brcmfmac43242a.bin
 File: brcm/brcmfmac43143.bin
 File: brcm/brcmfmac43143-sdio.bin
-File: brcm/brcmfmac43430-sdio.bin
 File: brcm/brcmfmac43430a0-sdio.bin
 File: brcm/brcmfmac43455-sdio.bin
 File: brcm/brcmfmac4350c2-pcie.bin
 File: brcm/brcmfmac4350-pcie.bin
-File: brcm/brcmfmac4354-sdio.bin
-File: brcm/brcmfmac4356-pcie.bin
 File: brcm/brcmfmac4356-sdio.bin
 File: brcm/brcmfmac43569.bin
 File: brcm/brcmfmac43570-pcie.bin
@@ -2254,6 +2249,11 @@ File: brcm/brcmfmac4371-pcie.bin
 
 Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
 
+File: brcm/brcmfmac43340-sdio.bin
+File: brcm/brcmfmac43362-sdio.bin
+File: brcm/brcmfmac43430-sdio.bin
+File: brcm/brcmfmac4354-sdio.bin
+File: brcm/brcmfmac4356-pcie.bin
 File: brcm/brcmfmac4373-sdio.bin
 File: brcm/brcmfmac4373.bin
 
-- 
2.1.0
