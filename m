Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2721 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab2KHIrx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 03:47:53 -0500
From: "Piotr Haber" <phaber@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org, m@bues.ch,
	"Piotr Haber" <phaber@broadcom.com>
Subject: [PATCH] ssb: fix SPROM offset
Date: Thu, 8 Nov 2012 09:47:27 +0100
Message-ID: <1352364447-25226-1-git-send-email-phaber@broadcom.com> (sfid-20121108_094808_180696_AFFE6615)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Offset for temperature compensation
values is wrong in ssb SPROMv8 map.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
---
 include/linux/ssb/ssb_regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index a052501..6ecfa02 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -485,7 +485,7 @@
 #define  SSB_SPROM8_HWIQ_IQSWP_IQCAL_SWP_SHIFT	4
 #define  SSB_SPROM8_HWIQ_IQSWP_HW_IQCAL	0x0020
 #define  SSB_SPROM8_HWIQ_IQSWP_HW_IQCAL_SHIFT	5
-#define SSB_SPROM8_TEMPDELTA		0x00BA
+#define SSB_SPROM8_TEMPDELTA		0x00BC
 #define  SSB_SPROM8_TEMPDELTA_PHYCAL	0x00ff
 #define  SSB_SPROM8_TEMPDELTA_PHYCAL_SHIFT	0
 #define  SSB_SPROM8_TEMPDELTA_PERIOD	0x0f00
-- 
1.7.9.5


