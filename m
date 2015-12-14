Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:33319 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbbLNWcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 17:32:20 -0500
Received: by qkck189 with SMTP id k189so124576690qkc.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 14:32:20 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/8] Fixes for module parameters
Date: Mon, 14 Dec 2015 16:32:13 -0600
Message-Id: <1450132333-2331-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20151214_233228_649494_846604AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
    devel@driverdev.osuosl.org

Several of the rtlwifi-driver family have errors in the handling of
module parameters. These 8 patches for the -next repo contain fixes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry Finger (8):
  rtlwifi: rtl8723be: Fix module parameter initialization
  rtlwifi: rtl8723ae: Fix initialization of module parameters
  rtlwifi: rtl8821ae: Fix errors in parameter initialization
  rtlwifi: rtl8188ee: Fix module parameter initialization
  rtlwifi: rtl8192de: Fix incorrect module parameter descriptions
  rtlwifi: rtl8192se: Fix module parameter initialization
  rtlwifi: rtl8192ce: Fix handling of module parameters
  rtlwifi: rtl8192cu: Add missing parameter setup

 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c | 7 +++++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c | 6 ++++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c | 9 +++++++++
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 8 +++++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 9 +++++----
 8 files changed, 36 insertions(+), 11 deletions(-)

-- 
2.1.4

