Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0136.outbound.protection.outlook.com ([104.47.38.136]:43569
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935905AbeE3Gyl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 02:54:41 -0400
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Josh Boyer <jwboyer@kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Subject: [PATCH V4 0/6] Cypress license and firmware update
Date: Wed, 30 May 2018 01:54:21 -0500
Message-Id: <1527663267-71412-1-git-send-email-chi-hsien.lin@cypress.com> (sfid-20180530_085518_930581_D5AF7E55)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update Cypress license termination clause and several firmware files.

Chi-Hsien Lin (6):
  Update Cypress license termination clause
  brcm: update firmware for bcm43430 sdio
  brcm: update firmware for bcm43340 sdio
  brcm: update firmware for bcm43362 sdio
  brcm: update firmware for bcm4354 sdio
  brcm: update firmware for bcm4356 pcie

 LICENCE.cypress             |   5 ++---
 WHENCE                      |  10 +++++-----
 brcm/brcmfmac43340-sdio.bin | Bin 402210 -> 400864 bytes
 brcm/brcmfmac43362-sdio.bin | Bin 219557 -> 200801 bytes
 brcm/brcmfmac43430-sdio.bin | Bin 369577 -> 388739 bytes
 brcm/brcmfmac4354-sdio.bin  | Bin 626589 -> 605388 bytes
 brcm/brcmfmac4356-pcie.bin  | Bin 661999 -> 648770 bytes
 7 files changed, 7 insertions(+), 8 deletions(-)

-- 
2.1.0
