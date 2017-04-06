Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35547 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbdDFUUD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:03 -0400
Received: by mail-oi0-f68.google.com with SMTP id d2so8884368oig.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:03 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/11] rtlwifi: btcoex: More update to btcoex 
Date: Thu,  6 Apr 2017 15:19:47 -0500
Message-Id: <20170406201958.25642-1-Larry.Finger@lwfinger.net> (sfid-20170406_222053_792209_90C85B80)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches completes the updates for btcoex for the RTL8723BE
device. These patches follow the 13-patch set previously submitted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>


Yan-Hsuan Chuang (11):
  btcoex: 23b 2ant: set coex table when wifi is idle
  btcoex: 23b 2ant: treat too many low prio packets as retry
  btcoex: 23b 2ant: remove debugging code for 0x948
  btcoex: 23b 2ant: need those information when scan
  btcoex: 23b 2ant: wifi is not actually off in mp mode
  btcoex: 23b 2ant: power on settings for coex
  btcoex: 23b 2ant: before firmware ready settings
  btcoex: 23b 2ant: fine tune for bt pan_edr_a2dp
  btcoex: 23b 2ant: fine tune for bt hid_a2dp
  rtlwifi: btcoex: 23b 2ant: notify more bt information
  rtlwifi: btcoex: 23b 2ant: some hi-prio pkt will cause hid_exist

 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 194 ++++++++++++++++++---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   4 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  19 ++
 3 files changed, 189 insertions(+), 28 deletions(-)

-- 
2.12.0
