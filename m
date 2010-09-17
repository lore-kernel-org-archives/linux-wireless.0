Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56365 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab0IQXI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:08:28 -0400
Received: by bwz11 with SMTP id 11so3128510bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 16:08:27 -0700 (PDT)
Message-Id: <cover.1284763834.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 18 Sep 2010 00:50:34 +0200
Subject: [PATCH 0/7] carl9170: PHY updates + hang fix
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter (7):
  carl9170: use rx chainmask from eeprom
  carl9170: fix noise dBm conversion
  carl9170: don't load bogus nf of chain 1
  carl9170: abort tasklet during usb reset
  carl9170: fix state downgrade during reset
  carl9170: reinit phy after HT settings have changed
  carl9170: fix hang in AP mode when HT STA does PSM

 drivers/net/wireless/ath/carl9170/carl9170.h |    3 +-
 drivers/net/wireless/ath/carl9170/debug.c    |    8 ++---
 drivers/net/wireless/ath/carl9170/main.c     |    4 +-
 drivers/net/wireless/ath/carl9170/phy.c      |   45 ++++++++++++++------------
 drivers/net/wireless/ath/carl9170/usb.c      |    5 ++-
 5 files changed, 34 insertions(+), 31 deletions(-)

