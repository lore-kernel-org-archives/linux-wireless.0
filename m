Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:5433 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbbK0KN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 05:13:58 -0500
From: Arend van Spriel <arend@broadcom.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 0/2] brcm: firmware for new device and update
Date: Fri, 27 Nov 2015 11:13:53 +0100
Message-ID: <1448619235-31323-1-git-send-email-arend@broadcom.com> (sfid-20151127_111411_685167_85724C56)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series add firmware for new BCM4371 device and an update
for the BCM43602 which solves hibernate issue.

The series applies to the master branch of the linux-firmware
repository.

Arend van Spriel (2):
  brcm: update firmware for bcm43602 device
  brcm: add initial firmware for bcm4371 11ac wifi device

 WHENCE                      |   1 +
 brcm/brcmfmac43602-pcie.bin | Bin 634267 -> 635449 bytes
 brcm/brcmfmac4371-pcie.bin  | Bin 0 -> 623448 bytes
 3 files changed, 1 insertion(+)
 create mode 100755 brcm/brcmfmac4371-pcie.bin

-- 
1.9.1

