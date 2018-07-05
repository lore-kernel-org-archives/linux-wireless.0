Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:41786 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753926AbeGEM7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 08:59:40 -0400
Received: by mail-pf0-f178.google.com with SMTP id c21-v6so753355pfn.8
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 05:59:40 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sajay.konduri@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Subject: [PATCH 0/4] rsi driver common fixes
Date: Thu,  5 Jul 2018 18:08:18 +0530
Message-Id: <1530794302-8833-1-git-send-email-sushant2k1513@gmail.com> (sfid-20180705_145944_057595_D6A44279)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>

This patch series consists some code fixes related to Throughput,
40Mhz connection and wowlan issues.

Ganapathi Raju (1):
  rsi: fix for 40MHZ connection issue.

Siva Rebbagondla (3):
  rsi: fix for WoWLAN wakeup in security mode.
  rsi: optimize virtual interfaces
  rsi: fix for low throughput issue

 drivers/net/wireless/rsi/rsi_91x_hal.c      |  2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  3 ++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 20 +++++++-------------
 3 files changed, 10 insertions(+), 15 deletions(-)

-- 
2.5.5
