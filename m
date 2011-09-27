Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36719 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1I0Fsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 01:48:46 -0400
Received: by yib18 with SMTP id 18so4902085yib.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 22:48:46 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] rtlwifi: Remove unused routines from USB driver
Date: Tue, 27 Sep 2011 00:48:19 -0500
Message-Id: <1317102501-17387-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110927_074852_133176_8F5E694C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While checking for endian problems in the USB section of rtlwifi, three
unused routines were discovered.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is material for 3.2.

Larry
---

Larry Finger (2):
  rtlwifi: Remove unused routine _usb_readN_sync
  rtlwifi: Remove unused _usb_nbytes_read_write and _usb_writeN_sync

 drivers/net/wireless/rtlwifi/usb.c  |   40 -----------------------------------
 drivers/net/wireless/rtlwifi/wifi.h |    8 +-----
 2 files changed, 2 insertions(+), 46 deletions(-)

-- 
1.7.6.3

