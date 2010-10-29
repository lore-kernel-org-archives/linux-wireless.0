Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37365 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0J2Xfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 19:35:41 -0400
Received: by bwz11 with SMTP id 11so3037811bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 16:35:40 -0700 (PDT)
Message-Id: <cover.1288393804.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 30 Oct 2010 01:10:04 +0200
Subject: [PATCH 0/6] carl9170: 2.6.38 patches
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I haven't heard of any serious complains yet?
So I'm moving on with the next batch for the
next -next cycle.

Christian Lamparter (7):
  carl9170: import hw/fw header updates
  carl9170: use generic sign_extend32
  carl9170: initialize HW aMPDU parameters properly
  carl9170: fix spurious restart due to high latency
  carl9170: stop stale uplink BA sessions
  carl9170: configurable beacon rates
  carl9170: improve rx ampdu software deaggregation

 drivers/net/wireless/ath/carl9170/carl9170.h |    6 +-
 drivers/net/wireless/ath/carl9170/fwcmd.h    |   13 ++-
 drivers/net/wireless/ath/carl9170/hw.h       |    7 ++-
 drivers/net/wireless/ath/carl9170/mac.c      |   56 ++++++++-----
 drivers/net/wireless/ath/carl9170/main.c     |   18 ++++
 drivers/net/wireless/ath/carl9170/phy.c      |   17 +---
 drivers/net/wireless/ath/carl9170/phy.h      |   24 +++---
 drivers/net/wireless/ath/carl9170/rx.c       |  117 +++++++++++++++++++++-----
 drivers/net/wireless/ath/carl9170/tx.c       |   54 ++++++++++++
 drivers/net/wireless/ath/carl9170/usb.c      |    2 +-
 drivers/net/wireless/ath/carl9170/version.h  |    6 +-
 11 files changed, 243 insertions(+), 77 deletions(-)

-- 
1.7.2.3

