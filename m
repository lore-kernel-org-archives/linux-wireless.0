Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:37078 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaDNJvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 05:51:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/3] brcm: add brcmfmac firmware files
Date: Mon, 14 Apr 2014 11:51:05 +0200
Message-ID: <1397469068-19083-1-git-send-email-arend@broadcom.com> (sfid-20140414_115115_943185_51A06E12)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmfmac driver added support for new devices. This patch
contains firmware files to be used for those devices.

These apply to the master branch of the linux-firmware
repository.

Arend van Spriel (3):
  brcm: add firmware for BCM43143 2.4G 11n USB device
  brcm: add firmware for BCM43143 2.4G 11n SDIO device
  brcm: add firmware for BCM4354 2x2 11ac SDIO device

 WHENCE                      |   3 +++
 brcm/brcmfmac43143-sdio.bin | Bin 0 -> 385067 bytes
 brcm/brcmfmac43143.bin      | Bin 0 -> 397312 bytes
 brcm/brcmfmac4354-sdio.bin  | Bin 0 -> 507752 bytes
 4 files changed, 3 insertions(+)
 create mode 100755 brcm/brcmfmac43143-sdio.bin
 create mode 100644 brcm/brcmfmac43143.bin
 create mode 100644 brcm/brcmfmac4354-sdio.bin

-- 
1.8.1.3

