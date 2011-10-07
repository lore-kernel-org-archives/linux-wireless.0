Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64233 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1JGQnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 12:43:55 -0400
Received: by yxl31 with SMTP id 31so3804061yxl.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 09:43:55 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] Updates to match latest Realtek version and new PM framework
Date: Fri,  7 Oct 2011 11:43:17 -0500
Message-Id: <1318005802-29057-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111007_184359_368437_5B2747F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest Realtek driver for rtl8192ce, rtl8192se, and rtl8192de incorporates
some changes. With these patches, the changes are added to the mainline
drivers. In addition, the drivers are changed to the new PM framework.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


Chaoming Li (1):
  rtlwifi: Update to new Realtek version - Part I

Larry Finger (4):
  rtlwifi: Change PCI drivers to use the new PM framework
  rtlwifi: rtl8192ce: Add new chip revisions
  rtlwifi: rtl8192se: Updates from latest Realtek driver version - Part
    II
  rtlwifi: rtl8192de: Updates from latest Reaktek driver - Part III

 drivers/net/wireless/rtlwifi/base.c          |    6 +-
 drivers/net/wireless/rtlwifi/pci.c           |   19 +---
 drivers/net/wireless/rtlwifi/pci.h           |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h |   14 +++
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |   30 +++++--
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h |    4 -
 drivers/net/wireless/rtlwifi/rtl8192de/def.h |  124 ++++++++++++++++----------
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |   19 ++---
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c  |   16 ++--
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |   22 +++---
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c  |   17 +++--
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |   53 +++++++-----
 drivers/net/wireless/rtlwifi/wifi.h          |    1 +
 14 files changed, 196 insertions(+), 134 deletions(-)

-- 
1.7.6.4

