Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39002 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751861AbeAZHrG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 02:47:06 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/10] rtlwifi: add more materials for 8822be
Date: Fri, 26 Jan 2018 15:46:35 +0800
Message-ID: <20180126074645.27201-1-pkshih@realtek.com> (sfid-20180126_084712_049409_D0D78270)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

I continue to submit more materials needed by 8822be. A special patch is
"PATCH 10/10" that add new files to support 8822be btcoex in case wifi
only. In my plan, 8822be btcoex for combo card will be sumitted in next
patchset.

Ping-Ke Shih (10):
  rtlwifi: enable mac80211 fast-tx support
  rtlwifi: Add Support VHT to spec_ver
  rtlwifi: Use 6 bits as sequence number of TX report
  rtlwifi: Extend tx_power_by_rate_offset size for newer IC
  rtlwifi: Add rate section and its related definition and comment
  rtlwifi: Fix VHT NSS in RC
  rtlwifi: add definition radio_mask for RF and maximum bandwidth
  rtlwifi: add efuse ops for other components
  rtlwifi: btcoex: add routine to set default port id
  rtlwifi: btcoex: Add 8822be btcoex supported files for wifi only

 drivers/net/wireless/realtek/rtlwifi/base.c        | 34 ++++++++++---
 .../rtlwifi/btcoexist/halbtc8822bwifionly.c        | 55 ++++++++++++++++++++++
 .../rtlwifi/btcoexist/halbtc8822bwifionly.h        | 25 ++++++++++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 22 +++++++++
 drivers/net/wireless/realtek/rtlwifi/efuse.c       | 13 +++++
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |  2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  1 +
 drivers/net/wireless/realtek/rtlwifi/rc.c          | 49 +++++++++++++++----
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |  1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        | 39 +++++++++++++--
 10 files changed, 221 insertions(+), 20 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h

-- 
2.15.1
