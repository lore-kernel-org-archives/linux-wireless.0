Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35295 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdEEQRV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 12:17:21 -0400
Received: by mail-io0-f196.google.com with SMTP id v34so2443708iov.2
        for <linux-wireless@vger.kernel.org>; Fri, 05 May 2017 09:17:21 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 00/10] rtlwifi: btcoex: Third set of changes for rtl8821ae 2ant
Date: Fri,  5 May 2017 11:17:02 -0500
Message-Id: <20170505161712.8685-1-Larry.Finger@lwfinger.net> (sfid-20170505_181913_851580_20011A01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches are the third set of patches for file
btcoexist/halbtc8821a2ant.c.

v2 - resubmit after removal of BT_AUTO_REPORT_XXXX symbols.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Yan-Hsuan Chuang (10):
  rtlwifi: btcoex: 21a 2ant: set tdma with rssi states
  rtlwifi: btcoex: 21a 2ant: refine btc8821a2ant_action_hid_a2dp
  rtlwifi: btcoex: 21a 2ant: set wifi standby when halting of entering
    ips
  rtlwifi: btcoex: 21a 2ant: settings before wifi firmware is ready
  rtlwifi: btcoex: 21a 2ant: add pnp notidy to avoid LPS/IPS mismatch
  rtlwifi: btcoex: 21a 2ant: run mechanism if status changes or auto
    adjust is set
  rtlwifi: btcoex: 21a 2ant: init wlan when leave ips
  rtlwifi: btcoex: 21a 2ant: refine bt info notify to have more
    profilings
  rtlwifi: btcoex: 21a 2ant: fix PTA unstable problem when hw init
  rtlwifi: btcoex: 21a 2ant: remove unused antenna detection variables

 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 509 ++++++++++++---------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  10 +-
 2 files changed, 298 insertions(+), 221 deletions(-)

-- 
2.12.0
