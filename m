Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:44342 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752057AbdKXIZn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Nov 2017 03:25:43 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/5] brcm: firmware addressing security issues
Date: Thu, 23 Nov 2017 20:58:20 +0100
Message-Id: <1511467106-21175-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171124_092547_041373_6DF9AD07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of firmware patches address a number of security
issues as listed in the individual commit messages. It also
adds new firmware for bcm43430 rev 0.

The series applies to the master branch of the linux-firmware
repository.

Arend van Spriel (5):
  brcm: update firmware for bcm4339
  brcm: introduce firmware for bcm43430 revision 0
  brcm: update firmware for bcm4354
  brcm: update firmware for bcm4356
  brcm: update firmware for bcm4358

 WHENCE                        |   1 +
 brcm/brcmfmac4339-sdio.bin    | Bin 493599 -> 562183 bytes
 brcm/brcmfmac43430a0-sdio.bin | Bin 0 -> 382455 bytes
 brcm/brcmfmac4354-sdio.bin    | Bin 591837 -> 626589 bytes
 brcm/brcmfmac4356-pcie.bin    | Bin 623012 -> 661999 bytes
 brcm/brcmfmac4358-pcie.bin    | Bin 629040 -> 633817 bytes
 6 files changed, 1 insertion(+)
 create mode 100644 brcm/brcmfmac43430a0-sdio.bin

-- 
1.9.1
