Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3718 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab1GJJ2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2011 05:28:32 -0400
From: Joe Perches <joe@perches.com>
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH 0/5] treewide: Add missing breaks in switch/case
Date: Sun, 10 Jul 2011 02:28:23 -0700
Message-Id: <cover.1310289795.git.joe@perches.com> (sfid-20110710_112939_941150_F3621486)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Found by grep.  Uncompiled/untested.

Joe Perches (5):
  gpio-tps65910.c: Add missing breaks in switch/case
  tps65910-irq: Add missing breaks in switch/case
  ath5k: Add missing breaks in switch/case
  fusb300_udc: Add missing breaks in switch/case
  dbri: Add missing breaks in switch/case

 drivers/gpio/gpio-tps65910.c          |    2 ++
 drivers/mfd/tps65910-irq.c            |    2 ++
 drivers/net/wireless/ath/ath5k/desc.c |    3 +++
 drivers/usb/gadget/fusb300_udc.c      |    3 +++
 sound/sparc/dbri.c                    |    5 +++++
 5 files changed, 15 insertions(+), 0 deletions(-)

-- 
1.7.6.131.g99019

