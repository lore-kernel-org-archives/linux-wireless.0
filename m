Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:39008 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811Ab1INIiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 04:38:21 -0400
Received: by mail-bw0-f53.google.com with SMTP id zt12so1437911bkb.26
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 01:38:20 -0700 (PDT)
Subject: pull request: wl12xx 2011-09-14
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 11:38:12 +0300
Message-ID: <1315989492.2498.59.camel@cumari> (sfid-20110914_103825_604715_A8DDC5C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Another batch of wl12xx patches intended for 3.2.  There are just a few
bugfixes and some small improvements in the scheduled scan
implementation.

Please pull or let me know if there's any problem. This tree is based
on wireless-next/master.

Thanks!

The following changes since commit 56e6786e59cba2c714091ed53deffa6001a32841:

  cfg80211: print bandwidth in chan_reg_rule_print_dbg() (2011-09-13 15:53:46 -0400)

are available in the git repository at:
  git://github.com/lucacoelho/wl12xx.git for-linville

Arik Nemtsov (1):
      wl12xx: allow 11a AP-mode for wl127x devices

Eliad Peller (3):
      wl12xx: initialize rate_set on band rates initialization
      wl12xx: increase psm_entry_retries
      wl12xx: enter psm only after station role was started

Guy Eilam (1):
      wl12xx: use 2 spare TX blocks for GEM cipher

Luciano Coelho (3):
      wl12xx: add support for multiple SSIDs in sched_scan
      wl12xx: use SCAN_SSID_TYPE_PUBLIC when using the wildcard in sched_scan
      Merge branch 'wl12xx-next' into for-linville

 drivers/net/wireless/wl12xx/boot.c   |    4 +--
 drivers/net/wireless/wl12xx/main.c   |   50 +++++++++++++++++--------
 drivers/net/wireless/wl12xx/scan.c   |   66 ++++++++++++++++++++++++++++++----
 drivers/net/wireless/wl12xx/tx.c     |    8 +++--
 drivers/net/wireless/wl12xx/tx.h     |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h |    3 ++
 6 files changed, 103 insertions(+), 29 deletions(-)

-- 
Cheers,
Luca.

