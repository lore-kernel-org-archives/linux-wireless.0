Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4629 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab1DEO7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:06 -0400
From: "Henry Ptasinski" <henryp@broadcom.com>
To: dwmw2@infradead.org
cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	henryp@broadcom.com, brudley@broadcom.com, arend@broadcom.com,
	rvossen@broadcom.com
Subject: [PATCH 0/3] linux-firmware: Updated firmware and new license
 for brcm firmware
Date: Tue, 5 Apr 2011 07:58:39 -0700
Message-ID: <1302015522-20601-1-git-send-email-henryp@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David,

Here's a short patch series for the linux-firmware repo, including a much
shorter license, some file renaming to get the firmware repo in synch with the
firmware names expected by the drivers, and a new version of firmware which
should resolve a lot of the stability issues people are seeing with the
brcmsmac driver.  Please apply them to the linux-firmware repo.

Thanks,
---
Henry Ptasinski
henryp@broadcom.com

Henry Ptasinski (3):
  linux-firmware: Simplified license file for brcm firmware
  linux-firmware: Removed codeversion from brcm firmware filenames.
  linux-firmware: updated firmware for BCM4313, BCM43224, and BCM43225
    chips

 LICENCE.broadcom_bcm43xx                           |  262 +++++---------------
 WHENCE                                             |   12 +-
 ...llmac-4-218-248-5.bin => bcm4329-fullmac-4.bin} |  Bin 269595 -> 269595 bytes
 ...llmac-4-218-248-5.txt => bcm4329-fullmac-4.txt} |    0
 brcm/{bcm43xx-0-610-809-0.fw => bcm43xx-0.fw}      |  Bin 97376 -> 97344 bytes
 brcm/bcm43xx_hdr-0-610-809-0.fw                    |  Bin 180 -> 0 bytes
 brcm/bcm43xx_hdr-0.fw                              |  Bin 0 -> 180 bytes
 7 files changed, 67 insertions(+), 207 deletions(-)
 rename brcm/{bcm4329-fullmac-4-218-248-5.bin => bcm4329-fullmac-4.bin} (100%)
 rename brcm/{bcm4329-fullmac-4-218-248-5.txt => bcm4329-fullmac-4.txt} (100%)
 rename brcm/{bcm43xx-0-610-809-0.fw => bcm43xx-0.fw} (74%)
 delete mode 100644 brcm/bcm43xx_hdr-0-610-809-0.fw
 create mode 100644 brcm/bcm43xx_hdr-0.fw


