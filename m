Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4514 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab1KQXDo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 18:03:44 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: dwmw2@infradead.org
cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCH v2 0/3] linux-firmware: new firmware for brcmfmac and
 nvram removal
Date: Thu, 17 Nov 2011 15:03:22 -0800
Message-ID: <1321571005-22601-1-git-send-email-frankyl@broadcom.com> (sfid-20111118_000352_348262_E3DEF91B)
In-Reply-To: <1321569101-19568-1-git-send-email-frankyl@broadcom.com>
References: <1321569101-19568-1-git-send-email-frankyl@broadcom.com>
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

 WHENCE                     |    3 +-
 brcm/bcm4329-fullmac-4.txt |   94 --------------------------------------------
 brcm/brcmfmac4329.bin      |  Bin 0 -> 253748 bytes
 brcm/brcmfmac4330.bin      |  Bin 0 -> 222126 bytes
 4 files changed, 2 insertions(+), 95 deletions(-)
 delete mode 100644 brcm/bcm4329-fullmac-4.txt
 create mode 100755 brcm/brcmfmac4329.bin
 create mode 100755 brcm/brcmfmac4330.bin

-- 
1.7.5.4


