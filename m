Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55209 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaFGPuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 11:50:21 -0400
Received: by mail-pb0-f54.google.com with SMTP id jt11so3673817pbb.41
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jun 2014 08:50:21 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Jahnavi Meher <jahnavi.meher@gmail.com>
Subject: [PATCH 0/4] rsi: Code fixes and adding support for 5GHz and bgscan.
Date: Sun,  8 Jun 2014 02:49:41 +0530
Message-Id: <1402175981-8414-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140607_175237_868022_299ADBEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches contains some fixes and adds support for 5GHz
and bgscan.

Jahnavi Meher (4):
  rsi: Fixes and clean up of code.
  rsi: Adding support for 5GHz
  rsi: Change the logic for dequeuing packets in hal.
  rsi: Adding support for host based bgscan

 drivers/net/wireless/rsi/rsi_91x_core.c     |   85 +++++++++++-----
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   10 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  141 +++++++++++++++++++++----
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  149 ++++++++++++++++++++-------
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    4 +-
 drivers/net/wireless/rsi/rsi_main.h         |   12 ++
 drivers/net/wireless/rsi/rsi_mgmt.h         |    4 +-
 drivers/net/wireless/rsi/rsi_sdio.h         |    4 +-
 8 files changed, 315 insertions(+), 94 deletions(-)

