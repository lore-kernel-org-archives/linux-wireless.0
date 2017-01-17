Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751426AbdAQX2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 18:28:16 -0500
From: Jes.Sorensen@gmail.com
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] Update USB IDs and email adress
Date: Tue, 17 Jan 2017 18:18:51 -0500
Message-Id: <20170117231856.5075-1-Jes.Sorensen@gmail.com> (sfid-20170118_002859_644221_A56A2DDC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@gmail.com>

Hi,

This patchset adds some additional USB IDs for rtl8192eu devices, as
well as updates the email address and the copyright.

I've been preoccupied with some other stuff the last little while, so
I am a little out of touch with whether or not the patch window is
open at the moment. Please yell at me if you want me to resubmit these later.

Cheers,
Jes


Axel Köllhofer (2):
  rtl8xxxu: Add USB ID for D-Link DWA-131 rev E1 (rtl8192eu)
  rtl8xxxu: Add additional USB IDs for rtl8192eu devices

Jes Sorensen (3):
  rtl8xxxu: Mark 8192eu device 0x0bda:0x818b as tested
  rtl8xxxu: Add another 8192eu device to the USB list
  rtl8xxxu: Update author/maintainer contact info

 MAINTAINERS                                            |  2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h       |  2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |  2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |  2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |  2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |  2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 18 ++++++++++++++++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  2 +-
 8 files changed, 23 insertions(+), 9 deletions(-)

-- 
2.7.4
