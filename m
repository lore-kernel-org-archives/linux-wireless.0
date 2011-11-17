Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3627 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1KQWbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:31:51 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: dwmw2@infradead.org
cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCH 0/3] linux-firmware: new firmware for brcmfmac and nvram
 removal
Date: Thu, 17 Nov 2011 14:31:38 -0800
Message-ID: <1321569101-19568-1-git-send-email-frankyl@broadcom.com> (sfid-20111117_233154_459786_40512EB4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds new firmware for bcm4329 and bcm4330 and removes
the nvram file from the repository as it is not useful for Linux users
and only used for internal development.

Franky Lin (3):
  linux-firmware: add new bcm4329 firmware for brcmfmac
  linux-firmware: add bcm4330 firmware for brcmfmac
  linux-firmware: remove nvram file for bcm4329 development board

 brcm/bcm4329-fullmac-4.txt |   94 --------------------------------------------
 brcm/brcmfmac4329.bin      |  Bin 0 -> 253748 bytes
 brcm/brcmfmac4330.bin      |  Bin 0 -> 222126 bytes
 3 files changed, 0 insertions(+), 94 deletions(-)
 delete mode 100644 brcm/bcm4329-fullmac-4.txt
 create mode 100755 brcm/brcmfmac4329.bin
 create mode 100755 brcm/brcmfmac4330.bin

-- 
1.7.5.4


