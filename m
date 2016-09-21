Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755153AbcIUBTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 21:19:31 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/4] rtl8xxxu - four patches for 4.9
Date: Tue, 20 Sep 2016 21:19:25 -0400
Message-Id: <1474420769-20086-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160921_031937_410641_83B4F6E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This is a small set of patches, all but one are preparatory for the
8188eu support I am working on. The last is Larry's patch to reduce
debug messages.

It would be great to get in for 4.9.

Cheers,
Jes


Jes Sorensen (3):
  rtl8xxxu: Fix off by one error calculating pubq
  rtl8xxxu: Clean up llt_init() API
  rtl8xxxu: Use a struct rtl8xxxu_fileops * in rtl8xxxu_init_device()

Larry Finger (1):
  rtl8xxxu: Stop log spam from each successful interrupt

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  7 ++--
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 49 ++++++++++++----------
 2 files changed, 31 insertions(+), 25 deletions(-)

-- 
2.7.4
