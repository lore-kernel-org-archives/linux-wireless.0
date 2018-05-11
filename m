Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f54.google.com ([209.85.160.54]:41381 "EHLO
        mail-pl0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752017AbeEKOyv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 10:54:51 -0400
Received: by mail-pl0-f54.google.com with SMTP id az12-v6so3433244plb.8
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 07:54:51 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Subject: 
Date: Fri, 11 May 2018 20:27:50 +0530
Message-Id: <1526050673-7026-1-git-send-email-sushant2k1513@gmail.com> (sfid-20180511_165455_292481_8530DEF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>

Date: Fri, 11 May 2018 19:27:48 +0530
Subject: [PATCH 0/3] rsi: wowlan fixes 

This patch series will fix wowlan issues found in verification.

Sanjay Kumar Konduri (1):
  rsi: Add null check for virtual interfaces in wowlan config

Siva Rebbagondla (2):
  rsi: reset hibernate_resume flag to work hibernate resume in coex
    mode.
  rsi: Set wowlan flag while writing wowlan config parameters

 drivers/net/wireless/rsi/rsi_91x_coex.c     | 1 +
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.5.5
