Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2199 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab1DUSal (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 14:30:41 -0400
From: "Henry Ptasinski" <henryp@broadcom.com>
To: dwmw2@infradead.org
cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	henryp@broadcom.com, brudley@broadcom.com, rvossen@broadcom.com,
	arend@broadcom.com, "Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 0/3] linux-firmware: brcm firmware fixes
Date: Thu, 21 Apr 2011 11:30:21 -0700
Message-ID: <1303410624-10560-1-git-send-email-henryp@broadcom.com>
In-Reply-To: <1302015522-20601-4-git-send-email-henryp@broadcom.com>
References: <1302015522-20601-4-git-send-email-henryp@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resending this series, as patch 2 wasn't complete (older version of git only
caught 1 of 4 file renames), causing patch 3 to fail to apply.

- Henry

Henry Ptasinski (3):
  linux-firmware: Simplified license file for brcm firmware
  linux-firmware: Removed codeversion from brcm firmware filenames.
  linux-firmware: updated firmware for BCM4313, BCM43224, and BCM43225
    chips

 LICENCE.broadcom_bcm43xx                           |  270 +++++---------------
 WHENCE                                             |   12 +-
 ...llmac-4-218-248-5.bin => bcm4329-fullmac-4.bin} |  Bin 269595 -> 269595 bytes
 ...llmac-4-218-248-5.txt => bcm4329-fullmac-4.txt} |    0
 brcm/{bcm43xx-0-610-809-0.fw => bcm43xx-0.fw}      |  Bin 97376 -> 97344 bytes
 brcm/bcm43xx_hdr-0-610-809-0.fw                    |  Bin 180 -> 0 bytes
 brcm/bcm43xx_hdr-0.fw                              |  Bin 0 -> 180 bytes
 7 files changed, 71 insertions(+), 211 deletions(-)
 rewrite LICENCE.broadcom_bcm43xx (99%)
 rename brcm/{bcm4329-fullmac-4-218-248-5.bin => bcm4329-fullmac-4.bin} (100%)
 rename brcm/{bcm4329-fullmac-4-218-248-5.txt => bcm4329-fullmac-4.txt} (100%)
 rename brcm/{bcm43xx-0-610-809-0.fw => bcm43xx-0.fw} (74%)
 delete mode 100644 brcm/bcm43xx_hdr-0-610-809-0.fw
 create mode 100644 brcm/bcm43xx_hdr-0.fw

-- 
1.7.4.5


