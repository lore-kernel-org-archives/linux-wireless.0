Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33952 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932276AbdETPtM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 11:49:12 -0400
Received: by mail-oi0-f66.google.com with SMTP id w10so16697212oif.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 May 2017 08:49:12 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/10] rtlwifi: btcoex: More fixes for halbtc8723b1ant.c
Date: Sat, 20 May 2017 10:48:57 -0500
Message-Id: <20170520154907.15590-1-Larry.Finger@lwfinger.net> (sfid-20170520_174917_299762_33DAEE18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set is the third for file halbtc8723b1ant.c.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by:: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>


Ping-Ke Shih (9):
  rtlwifi: btcoex: 23b 1ant: Special packets statistic in notification
  rtlwifi: btcoex: 23b 1ant: define wifi in high priority task.
  rtlwifi: btcoex: 23b 1ant: check more cases when bt is queing
  rtlwifi: btcoex: 23b 1ant: remove verbose log from periodic function
  rtlwifi: btcoex: 23b 1ant: Add coex_table_type to log
  rtlwifi: btcoex: 23b 1ant: coex table fine tune
  rtlwifi: btcoex: 23b 1ant: fine tune for wifi connected
  rtlwifi: btcoex: 23b 1ant: fine tune for wifi not connected
  rtlwifi: btcoex: 23b 1ant: fine tune for bt_sco_hid busy

Yan-Hsuan Chuang (1):
  rtlwifi: btcoex: 23b 1ant: turn off ps and tdma mechanism when
    concurrent mode

 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 446 ++++++++++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |   6 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  19 +
 3 files changed, 333 insertions(+), 138 deletions(-)

-- 
2.12.0
