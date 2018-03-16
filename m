Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0094.outbound.protection.outlook.com ([104.47.40.94]:20949
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753299AbeCPKSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:18:47 -0400
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
Subject: [PATCH V2 0/6] Update brcm firmware files
Date: Fri, 16 Mar 2018 05:18:01 -0500
Message-Id: <1521195487-176486-1-git-send-email-chi-hsien.lin@cypress.com> (sfid-20180316_111851_709359_EAFEA68C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update brcm firmware files and WHENCE accordingly.

Chi-Hsien Lin (6):
  brcm: update firmware for bcm43340
  brcm: update firmware for bcm43362
  brcm: update firmware for bcm43430
  brcm: update firmware for bcm4354
  brcm: update firmware for bcm4356 pcie
  Update license for brcm firmware

 WHENCE                      |  10 +++++-----
 brcm/brcmfmac43340-sdio.bin | Bin 402210 -> 400864 bytes
 brcm/brcmfmac43362-sdio.bin | Bin 219557 -> 200801 bytes
 brcm/brcmfmac43430-sdio.bin | Bin 369577 -> 388739 bytes
 brcm/brcmfmac4354-sdio.bin  | Bin 626589 -> 605388 bytes
 brcm/brcmfmac4356-pcie.bin  | Bin 661999 -> 648770 bytes
 6 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.1.0
