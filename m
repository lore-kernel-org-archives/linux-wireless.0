Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3420 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757615Ab2BCU5O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 15:57:14 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "Ben Hutchings" <ben@decadent.org.uk>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/4] linux-firmware: brcm: new firmware files for
 brcmfmac and cleanup
Date: Fri, 3 Feb 2012 21:56:41 +0100
Message-ID: <1328302605-3382-1-git-send-email-arend@broadcom.com> (sfid-20120203_215811_353908_4D7646B0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds new firmware for bcm4329 and bcm4330 SDIO chipsets
and removes the nvram file from the repository as it is not useful for Linux
users and only used for internal development.

Also included is firmware for the bcm43236 USB chipset, which will be
supported by the brcmfmac driver.

This series applies to kernel/git/firmware/linux-firmware.git tree. These
files will be used by brcmfmac as of kernel v3.3.

Arend van Spriel (1):
  linux-firmware: brcm: add firmware for bcm43236 usb device

Franky Lin (3):
  linux-firmware: brcm: add new bcm4329 firmware for brcmfmac
  linux-firmware: brcm: add bcm4330 firmware for brcmfmac
  linux-firmware: brcm: remove nvram file for bcm4329 development board

 WHENCE                     |    4 +-
 brcm/bcm4329-fullmac-4.txt |   94 --------------------------------------------
 brcm/brcmfmac43236b.bin    |  Bin 0 -> 348160 bytes
 brcm/brcmfmac4329.bin      |  Bin 0 -> 253748 bytes
 brcm/brcmfmac4330.bin      |  Bin 0 -> 222126 bytes
 5 files changed, 3 insertions(+), 95 deletions(-)
 delete mode 100644 brcm/bcm4329-fullmac-4.txt
 create mode 100644 brcm/brcmfmac43236b.bin
 create mode 100755 brcm/brcmfmac4329.bin
 create mode 100755 brcm/brcmfmac4330.bin

-- 
1.7.5.4


