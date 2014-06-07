Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64584 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaFGQAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 12:00:53 -0400
Received: by mail-pd0-f176.google.com with SMTP id p10so3630994pdj.35
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jun 2014 09:00:53 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: <jahnavi.meher@redpinesignals.com>,
	Jahnavi Meher <jahnavi.meher@gmail.com>
Subject: [PATCH 0/4] rsi: Code fixes and adding support for 5GHz and bgscan.
Date: Sun,  8 Jun 2014 03:00:13 +0530
Message-Id: <1402176613-8741-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140607_180056_810511_8C020662)
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

