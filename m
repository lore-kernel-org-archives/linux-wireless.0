Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47088 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab2BBLvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 06:51:05 -0500
Received: by werb13 with SMTP id b13so1738062wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 03:51:04 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] wl12xx: some scan patches 
Date: Thu,  2 Feb 2012 13:54:25 +0200
Message-Id: <1328183669-21059-1-git-send-email-eliad@wizery.com> (sfid-20120202_125109_484278_C0997830)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix some various scan issues

Eliad Peller (1):
  wl12xx: don't fail on AP scan

Eyal Shapira (2):
  wl12xx: use split scan for normal scan
  wl12xx: add split_scan_timeout debugfs file

Ido Reis (1):
  wl12xx: increase max probe-req template size to
    WL1271_CMD_TEMPL_MAX_SIZE

 drivers/net/wireless/wl12xx/conf.h    |    8 ++++++
 drivers/net/wireless/wl12xx/debugfs.c |   43 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/init.c    |    4 +-
 drivers/net/wireless/wl12xx/main.c    |    5 ++-
 drivers/net/wireless/wl12xx/scan.c    |   21 +++++++++-------
 drivers/net/wireless/wl12xx/scan.h    |    2 +-
 6 files changed, 69 insertions(+), 14 deletions(-)

-- 
1.7.6.401.g6a319

