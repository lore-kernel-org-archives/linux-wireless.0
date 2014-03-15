Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:36673 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbaCOR2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 13:28:51 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so2539340eek.11
        for <linux-wireless@vger.kernel.org>; Sat, 15 Mar 2014 10:28:50 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	andrea.merello@gmail.com
Subject: [PATCH 0/4] rtl8180: improvements from rtl8187se branch
Date: Sat, 15 Mar 2014 18:29:34 +0100
Message-Id: <1394904578-5279-1-git-send-email-andrea.merello@gmail.com> (sfid-20140315_182855_070235_B78F02DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is another patch-set that ports on current rtl8180 driver the
following four improvements from my rtl8187se local tree.

Andrea Merello (4):
  rtl8180: remove too-early-added rtl8187se enum value
  rtl8180: support for BSS_CHANGED_BASIC_RATES
  rtl8180: make *IFS and CW tunable by mac80211, and set them in the
    proper place
  rtl8180: move eeprom read stuff in a separate function

 drivers/net/wireless/rtl818x/rtl8180/dev.c     | 262 +++++++++++++++++++------
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h |   6 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c |  22 ---
 3 files changed, 201 insertions(+), 89 deletions(-)

-- 
1.8.3.2

