Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2875 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab3JAIx2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 04:53:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "Ben Hutchings" <ben@decadent.org.uk>
cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/4] brcm: rename firmware files and add new files
Date: Tue, 1 Oct 2013 10:53:06 +0200
Message-ID: <1380617590-5120-1-git-send-email-arend@broadcom.com> (sfid-20131001_105333_405343_C7899B9F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series renames the firmware files to match the required filenames in
the brcmfmac driver. Previously, these files needed to be copied/linked to
a generic name that was used in the driver. So for older kernels this is still
needed.

Also included are new firmware files for BCM43241 and BCM4335. The brcmfmac
driver lists some more firmware files, but firmware is not yet released for
those chips.

Arend van Spriel (4):
  brcm: rename firmware names expressing host interface type
  brcm: add firmware file for BCM43241 SDIO chipset
  brcm: add firmware for newer version of BCM43241 SDIO chipset
  brcm: add firmware file for the BCM4335 SDIO chipset

 WHENCE                                           |    9 ++++++---
 brcm/brcmfmac43241b0-sdio.bin                    |  Bin 0 -> 455745 bytes
 brcm/brcmfmac43241b4-sdio.bin                    |  Bin 0 -> 403855 bytes
 brcm/{brcmfmac4329.bin => brcmfmac4329-sdio.bin} |  Bin 253748 -> 253748 bytes
 brcm/{brcmfmac4330.bin => brcmfmac4330-sdio.bin} |  Bin 222126 -> 222126 bytes
 brcm/{brcmfmac4334.bin => brcmfmac4334-sdio.bin} |  Bin 451566 -> 451566 bytes
 brcm/brcmfmac4335-sdio.bin                       |  Bin 0 -> 569291 bytes
 7 files changed, 6 insertions(+), 3 deletions(-)
 create mode 100644 brcm/brcmfmac43241b0-sdio.bin
 create mode 100644 brcm/brcmfmac43241b4-sdio.bin
 rename brcm/{brcmfmac4329.bin => brcmfmac4329-sdio.bin} (100%)
 rename brcm/{brcmfmac4330.bin => brcmfmac4330-sdio.bin} (100%)
 rename brcm/{brcmfmac4334.bin => brcmfmac4334-sdio.bin} (100%)
 create mode 100644 brcm/brcmfmac4335-sdio.bin

-- 
1.7.10.4


