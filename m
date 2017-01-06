Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033923AbdAFNKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:10:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH 0/9] rt2800 patches 06.01.2017
Date: Fri,  6 Jan 2017 14:05:09 +0100
Message-Id: <1483707918-31480-1-git-send-email-sgruszka@redhat.com> (sfid-20170106_141124_026657_68989747)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Random fixes for rt2800 driver.

Stanislaw Gruszka (9):
  rt2800usb: remove watchdog
  rt2800: increase TX timeout
  rt2x00: save conf settings before reset tuner
  rt2800: change default retry settings
  rt2800: tune TX_RTS_CFG config
  rt2800: fallback from mcs8 to mcs7
  rt2800usb: mark tx failure on timeout
  rt2x00: do not flush empty queue
  rt2800: set max_psdu to 3 on usb devices

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c    | 28 ++++++++-----
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c    | 49 ++---------------------
 drivers/net/wireless/ralink/rt2x00/rt2x00config.c | 32 +++++++--------
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c    |  3 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mmio.c   |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c    |  2 +-
 6 files changed, 41 insertions(+), 75 deletions(-)

-- 
2.7.4
