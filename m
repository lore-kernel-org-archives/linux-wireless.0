Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0136.outbound.protection.outlook.com ([104.47.41.136]:34016
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751966AbeCPOKN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 10:10:13 -0400
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
Subject: [PATCH V3 0/5] Update brcm firmware files
Date: Fri, 16 Mar 2018 09:08:44 -0500
Message-Id: <1521209329-59441-1-git-send-email-chi-hsien.lin@cypress.com> (sfid-20180316_151059_530288_00FA9997)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update brcm firmware files and WHENCE accordingly.

Chi-Hsien Lin (5):
  brcm: update firmware for bcm43430
  brcm: update firmware for bcm43340
  brcm: update firmware for bcm43362
  brcm: update firmware for bcm4354
  brcm: update firmware for bcm4356 pcie

 WHENCE                      |  10 +++++-----
 brcm/brcmfmac43340-sdio.bin | Bin 402210 -> 400864 bytes
 brcm/brcmfmac43362-sdio.bin | Bin 219557 -> 200801 bytes
 brcm/brcmfmac43430-sdio.bin | Bin 369577 -> 388739 bytes
 brcm/brcmfmac4354-sdio.bin  | Bin 626589 -> 605388 bytes
 brcm/brcmfmac4356-pcie.bin  | Bin 661999 -> 648770 bytes
 6 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.1.0
