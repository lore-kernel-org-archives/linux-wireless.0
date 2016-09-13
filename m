Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932460AbcIMTDR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 15:03:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/1] Fix problem with rtl8192eu firmware reload
Date: Tue, 13 Sep 2016 15:03:14 -0400
Message-Id: <1473793395-28927-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160913_210321_294092_07C57B7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This one goes on top of my previous patches, albeit it probably
applies out of order.

It resolves the issue where firmware wouldn't load correctly if
reloading the driver module.

Cheers,
Jes


Jes Sorensen (1):
  rtl8xxxu: Implment 8192e specific power down sequence

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 144 ++++++++++++++++++++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |   1 +
 2 files changed, 144 insertions(+), 1 deletion(-)

-- 
2.7.4
