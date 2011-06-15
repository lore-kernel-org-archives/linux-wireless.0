Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48796 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab1FOXXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 19:23:06 -0400
Received: by pzk9 with SMTP id 9so673021pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 16:23:06 -0700 (PDT)
Message-ID: <4DF93EAC.2030203@ring3k.org> (sfid-20110616_012310_882224_7128E971)
Date: Thu, 16 Jun 2011 08:22:20 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] rtlwifi: Various cleanups
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

The following series is a bunch of cleanups.

thanks,

Mike


Mike McCormack (4):
  rtlwifi: rtl8192{ce,cu,se}: Remove irq_enabled flag
  rtlwifi: Fix typo in variable name
  rtlwifi: rtl8192cu: Remove unused parameter
  rtlwifi: rtl8192{c,ce,cu,se}: Remove comparisons of booleans with
    true

 drivers/net/wireless/rtlwifi/base.c               |    2 +-
 drivers/net/wireless/rtlwifi/core.c               |    8 +-
 drivers/net/wireless/rtlwifi/efuse.c              |    8 +-
 drivers/net/wireless/rtlwifi/pci.c                |    6 +--
 drivers/net/wireless/rtlwifi/pci.h                |    1 -
 drivers/net/wireless/rtlwifi/ps.c                 |   65 ++-------------------
 drivers/net/wireless/rtlwifi/ps.h                 |    3 +-
 drivers/net/wireless/rtlwifi/rc.c                 |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       |   12 ++--
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c      |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/led.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c      |    9 ---
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c       |   13 ++---
 drivers/net/wireless/rtlwifi/rtl8192se/led.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c      |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c      |    6 +-
 drivers/net/wireless/rtlwifi/wifi.h               |    2 +-
 25 files changed, 49 insertions(+), 124 deletions(-)

-- 
1.7.4.1

