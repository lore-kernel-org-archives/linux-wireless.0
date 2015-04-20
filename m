Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:47230 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbbDTIam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 04:30:42 -0400
From: Arend van Spriel <arend@broadcom.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/4] brcm: firmware for brcmfmac driver
Date: Mon, 20 Apr 2015 10:30:22 +0200
Message-ID: <1429518626-15321-1-git-send-email-arend@broadcom.com> (sfid-20150420_103046_205373_A7E6F218)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Couple of new firmware files for devices added to brcmfmac and
replacing a firmware file that turned out to be not working on
the intended device.

This patch applies to the master branch of the linux-firmware
repository on top of commit ec89525b2ab6 ("firmware: WHENCE: note
nvidia xusb.bin firmware versions").

Arend van Spriel (4):
  brcm: add firmware for BCM43569 USB device
  brcm: add firmware for BCM43570 PCIe device
  brcm: replace non-working firmware for BCM4339
  brcm: add firmware for BCM4324(1) B5 chipset

 WHENCE                        |   2 ++
 brcm/brcmfmac43241b5-sdio.bin | Bin 0 -> 408682 bytes
 brcm/brcmfmac4339-sdio.bin    | Bin 569291 -> 493599 bytes
 brcm/brcmfmac43569.bin        | Bin 0 -> 557056 bytes
 brcm/brcmfmac43570-pcie.bin   | Bin 0 -> 550333 bytes
 5 files changed, 2 insertions(+)
 create mode 100644 brcm/brcmfmac43241b5-sdio.bin
 rewrite brcm/brcmfmac4339-sdio.bin (91%)
 create mode 100644 brcm/brcmfmac43569.bin
 create mode 100644 brcm/brcmfmac43570-pcie.bin

-- 
1.9.1

