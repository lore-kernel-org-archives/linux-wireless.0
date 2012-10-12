Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64620 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab2JLPwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 11:52:25 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so4973181iea.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2012 08:52:24 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 0/2] rtlwifi: Add support for B-CUT RTL8188CE and shorten some variable names
Date: Fri, 12 Oct 2012 10:52:06 -0500
Message-Id: <1350057128-16969-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20121012_175230_492283_B1E9DAF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first of these two patches is a new version of the patch to add the
B-CUT version of the RTL8188CE. The second shortens some variable names.

These patches are for wireless-next.

Larry
---

Larry Finger (2):
  rtlwifi: rtl8192c: rtl8192ce: Add support for B-CUT version of
    RTL8188CE
  rtlwifi: rtl8192c: rtl8192ce: rtl8192cu: rtl8192se: rtl8192de:
    Shorten some variable names

 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |  171 +++++++++-----------
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |   88 +++++-----
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h       |    3 +
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.c        |   30 ++--
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |   80 ++++++---
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |    2 +
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c        |   23 +--
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |   46 +++---
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c        |   30 ++--
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c       |   25 ++-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |   22 +--
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |   44 ++---
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |   65 +++-----
 drivers/net/wireless/rtlwifi/rtl8192de/rf.c        |   18 +--
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |   39 ++---
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c        |   43 +++--
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |   64 +++-----
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c        |   11 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |   21 ++-
 drivers/net/wireless/rtlwifi/wifi.h                |   33 ++--
 22 files changed, 408 insertions(+), 466 deletions(-)

-- 
1.7.10.4

