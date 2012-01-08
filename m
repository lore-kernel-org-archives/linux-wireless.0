Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33392 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2AHCrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 21:47:04 -0500
Received: by iaeh11 with SMTP id h11so4842716iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2012 18:47:02 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] Misc. cleanups for rtlwifi family
Date: Sat,  7 Jan 2012 20:46:39 -0600
Message-Id: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120108_034708_982884_46AE753F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This collection of patches does additional cleanups on the rtlwifi family.
Included are some new checks for allocation failures, removal of some
dead code, and updating of the copyright date.

These patches should be applied after the two series of cleanups by Joe Perches
(http://marc.info/?l=linux-wireless&m=132573516421817&w=2 and
http://marc.info/?l=linux-wireless&m=132588359201755&w=2)

and the fix for crashes in rtl8192se caused by memory allocation failures
(http://marc.info/?l=linux-wireless&m=132573199321141&w=2).

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Larry Finger (8):
  rtlwifi: rtl8192c_common: rtl8192de: Check for allocation failures
  rtl8192cu: Remove dead code never selected
  rtlwifi: Update copyright dates
  rtl8192c_common: Update copyright dates
  rtl8192ce: Update copyright dates
  rtl8192cu: Update copyright dates
  rtl8192de: Update copyright dates
  rtl8192se: Update copyright dates

 drivers/net/wireless/rtlwifi/base.c                |    2 +-
 drivers/net/wireless/rtlwifi/base.h                |    2 +-
 drivers/net/wireless/rtlwifi/cam.c                 |    2 +-
 drivers/net/wireless/rtlwifi/cam.h                 |    2 +-
 drivers/net/wireless/rtlwifi/core.c                |    2 +-
 drivers/net/wireless/rtlwifi/core.h                |    2 +-
 drivers/net/wireless/rtlwifi/debug.c               |    2 +-
 drivers/net/wireless/rtlwifi/debug.h               |    2 +-
 drivers/net/wireless/rtlwifi/efuse.c               |    2 +-
 drivers/net/wireless/rtlwifi/efuse.h               |    2 +-
 drivers/net/wireless/rtlwifi/pci.c                 |    4 +-
 drivers/net/wireless/rtlwifi/pci.h                 |    2 +-
 drivers/net/wireless/rtlwifi/ps.c                  |    2 +-
 drivers/net/wireless/rtlwifi/ps.h                  |    2 +-
 drivers/net/wireless/rtlwifi/rc.c                  |    2 +-
 drivers/net/wireless/rtlwifi/rc.h                  |    2 +-
 drivers/net/wireless/rtlwifi/regd.c                |    2 +-
 drivers/net/wireless/rtlwifi/regd.h                |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c  |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/main.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/led.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/table.c     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/table.h     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |  172 +-------------------
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/led.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/led.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/reg.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/table.c     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/table.h     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/def.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c        |   16 ++-
 drivers/net/wireless/rtlwifi/rtl8192de/fw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/led.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/led.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/rf.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/table.c     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/table.h     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/def.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/fw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/led.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/led.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/table.c     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/table.h     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.h       |    2 +-
 drivers/net/wireless/rtlwifi/usb.c                 |   14 +-
 drivers/net/wireless/rtlwifi/usb.h                 |    2 +-
 drivers/net/wireless/rtlwifi/wifi.h                |    2 +-
 106 files changed, 126 insertions(+), 286 deletions(-)

-- 
1.7.7

