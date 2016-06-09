Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbcFISiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 14:38:52 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/4] rtl8xxxu bugfix and minor updates
Date: Thu,  9 Jun 2016 14:38:46 -0400
Message-Id: <1465497530-18510-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160609_203857_683794_F3D64CB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

A couple of simple patches from my current queue. The most important
one is from Colin Ian King fixing the use of a wrong variable. That
one should probably go into v4.7. The others are fine for the next
round.

Cheers,
Jes


Andy Shevchenko (1):
  rtl8xxxu: tuse %*ph to dump buffers

Colin Ian King (1):
  rtl8xxxu: fix typo on variable name, compare against correct variable

Jes Sorensen (2):
  rtl8xxxu: Add bit definitions for REG_USB_SPECIAL_OPTION
  rtl8xxxu: Add additional documentation for RX DMA registers

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |  9 ++-------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 11 +++--------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |  9 ++-------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  | 14 +++++++++++---
 4 files changed, 18 insertions(+), 25 deletions(-)

-- 
2.5.5

