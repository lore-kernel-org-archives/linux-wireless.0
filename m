Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:2150 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbbJWJVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 05:21:52 -0400
From: Arend van Spriel <arend@broadcom.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/2] brcm: new firmware files
Date: Fri, 23 Oct 2015 11:21:46 +0200
Message-ID: <1445592108-16502-1-git-send-email-arend@broadcom.com> (sfid-20151023_112156_110873_F2C72ED1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One firmware file update and firmware for a new supported device.

The patches are for the master branch of the linux-firmware repository
and apply on top of commit 66d3d8d7607c ("Add FW binary used by mwlwifi
driver.").

Arend van Spriel (2):
  brcm: adding firmware for BCM4350 PCIe device
  brcm: update firmware for the BCM4356 PCIe device

 WHENCE                     |   1 +
 brcm/brcmfmac4350-pcie.bin | Bin 0 -> 626140 bytes
 brcm/brcmfmac4356-pcie.bin | Bin 593956 -> 623012 bytes
 3 files changed, 1 insertion(+)
 create mode 100755 brcm/brcmfmac4350-pcie.bin
 rewrite brcm/brcmfmac4356-pcie.bin (77%)

-- 
1.9.1

