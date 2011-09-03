Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39734 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1ICP7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 11:59:14 -0400
Received: by iabu26 with SMTP id u26so4260222iab.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Sep 2011 08:59:14 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, george0505@realtek.com,
	chaoming_li@realsil.com.cn
Subject: [PATCH 0/2] rtlwifi: Various fixes
Date: Sat,  3 Sep 2011 10:58:46 -0500
Message-Id: <1315065528-23034-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110903_175928_000371_3CF00062)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes a couple of problems found recently.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Both are for 3.0 with Cc for stable.

Larry
---

Larry Finger (2):
  rtlwifi: rtl8192su: Fix problem connecting to HT-enabled AP
  rtlwifi: Fix problem when switching connections

 drivers/net/wireless/rtlwifi/core.c          |    8 ++++++++
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   11 ++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

-- 
1.7.6.1

