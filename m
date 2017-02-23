Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36269 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdBWRUH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 12:20:07 -0500
Received: by mail-oi0-f66.google.com with SMTP id l128so1767362oia.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 09:20:06 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/4] rtlwifi: Various updates
Date: Thu, 23 Feb 2017 11:19:53 -0600
Message-Id: <20170223171957.22500-1-Larry.Finger@lwfinger.net> (sfid-20170223_182204_731352_990BA079)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These changes implement new phy parameters for RTL8821AE and RTL8812AE
devices, and add some new pre-loaded packets to the reserved pages of
various devices.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry Finger (1):
  rtlwifi: Add code to read new versions of firmware

Ping-Ke Shih (3):
  rtlwifi: Update 8821ae new phy parameters and its parser.
  rtlwifi: Update 8812ae new phy parameters and its parser.
  rtlwifi: Add QoS-NULL and BT-QoS-NULL to reserved page.

 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |   64 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |    4 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |   69 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    |    4 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |   15 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  165 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |    2 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |    8 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |  385 ++--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   15 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c | 1858 ++++++--------------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.h |   28 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   18 +
 14 files changed, 1055 insertions(+), 1584 deletions(-)

-- 
2.10.2
