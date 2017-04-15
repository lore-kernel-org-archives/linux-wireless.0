Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33389 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdDOUcG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:06 -0400
Received: by mail-oi0-f67.google.com with SMTP id t63so22231222oih.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:06 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/14] rtlwifi: btcoex: Second set of changes for rtl8821ae 2ant
Date: Sat, 15 Apr 2017 15:31:46 -0500
Message-Id: <20170415203200.22979-1-Larry.Finger@lwfinger.net> (sfid-20170415_223220_247153_B742810A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches are the second set of patches for file
btcoexist/halbtc8821a2ant.c.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Yan-Hsuan Chuang (14):
  rtlwifi: btcoex: 21a 2ant: turn on sw dac swing and check if is
    sco_only
  rtlwifi: btcoex: 21a 2ant: add threshold to examine bt rssi
  rtlwifi: btcoex: 21a 2ant: force wifi to use RF path A
  rtlwifi: btcoex: 21a 2ant: more combinations of wifi/bt rssi state
  rtlwifi: btcoex: 21a 2ant: fix some coding style issues
  rtlwifi: btcoex: 21a 2ant: set tdma based on rssi state amd limit rx
    agg size
  rtlwifi: btcoex: 21a 2ant: add multiport action for p2p/miracast
  rtlwifi: btcoex: 21a 2ant: monitor extra wifi rssi to examine network
    status
  rtlwifi: btcoex: 21a 2ant: notify fw the number of APs
  rtlwifi: btcoex: 21a 2ant: dec bt power according to bt rssi and set
    tdma
  rtlwifi: btcoex: 21a 2ant: macro for bt rssi threshold
  rtlwifi: btcoex: 21a 2ant: do not limit rx agg size
  rtlwifi: btcoex: 21a 2ant: just return when wifi is under ips
  rtlwifi: btcoex: 21a 2ant: wifi is linking action

 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 487 +++++++++++----------
 1 file changed, 264 insertions(+), 223 deletions(-)

-- 
2.12.0
