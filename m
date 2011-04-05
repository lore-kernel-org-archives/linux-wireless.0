Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4628 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab1DEO7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:06 -0400
From: "Henry Ptasinski" <henryp@broadcom.com>
To: dwmw2@infradead.org
cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	henryp@broadcom.com, brudley@broadcom.com, arend@broadcom.com,
	rvossen@broadcom.com
Subject: [PATCH 3/3] linux-firmware: updated firmware for BCM4313,
 BCM43224, and BCM43225 chips
Date: Tue, 5 Apr 2011 07:58:42 -0700
Message-ID: <1302015522-20601-4-git-send-email-henryp@broadcom.com>
In-Reply-To: <1302015522-20601-1-git-send-email-henryp@broadcom.com>
References: <1302015522-20601-1-git-send-email-henryp@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Updated firmware with stability fixes.  Firmware version is now 610.811.
---
 brcm/bcm43xx-0.fw     |  Bin 97376 -> 97344 bytes
 brcm/bcm43xx_hdr-0.fw |  Bin 180 -> 180 bytes
 2 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/brcm/bcm43xx-0.fw b/brcm/bcm43xx-0.fw
index e4ba3ad2ab1eee2cb286792336632203349d6f46..9f3951a137b93d8ecac7ac229ef1cdc5dad9829d 100644
GIT binary patch
delta 8991
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

delta 9116
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

diff --git a/brcm/bcm43xx_hdr-0.fw b/brcm/bcm43xx_hdr-0.fw
index 661b6bddea13f9c998e9e295c75db33f9bbebc5e..0e578f6f42169ee1e80e19008cfe8f3c2815d0f7 100644
GIT binary patch
delta 99
zcmdnOxP@^-M9hu(3=BLB3=9_jj0`M5niq&2fb1JU1{0925X;D*z{tP=L<|mb5OI(?
Wg&c@DGe|raBF+X9uZD=T0@(o1Hw$(E

delta 99
zcmdnOxP@^-M9h!*3=BLB3=9$ej0`M5niq%@fb1JU1{09&5X;D*z{tP=L<|XW5OI(?
Wha8AFGe|raBF+X9uZD=T0@(lr#te1<

-- 
1.7.1


