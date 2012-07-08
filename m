Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:56207 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238Ab2GHHXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 03:23:44 -0400
Received: by lboj14 with SMTP id j14so17297207lbo.35
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 00:23:40 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 0/8] wlcore/wl12xx/wl18xx: some updates for 3.6
Date: Sun,  8 Jul 2012 10:23:23 +0300
Message-Id: <1341732211-25871-1-git-send-email-coelho@ti.com> (sfid-20120708_092349_570704_926AC180)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

A few more updates intended for 3.6.  Mostly small bugfixes.

Please review.

Cheers,
Luca.

Arik Nemtsov (5):
  wlcore: don't set SDIO_FAILED flag when driver state is off
  wlcore: define number of supported bands internally
  wl12xx/wl18xx: use a dynamic PS timeout of 1.5sec
  wl18xx: don't send static global struct to FW
  wlcore: determine AP extra rates correctly

Eliad Peller (1):
  wlcore: check ssid length against the correct element

Ido Yariv (1):
  wlcore: Prevent processing of work items during op_stop

Yoni Divinsky (1):
  wlcore: change the wait for event mechanism

 drivers/net/wireless/ti/wl12xx/main.c     |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c     |   37 +++++++++++++++-----
 drivers/net/wireless/ti/wlcore/cmd.c      |    8 ++++-
 drivers/net/wireless/ti/wlcore/io.c       |    6 ++++
 drivers/net/wireless/ti/wlcore/io.h       |   13 ++++----
 drivers/net/wireless/ti/wlcore/main.c     |   52 ++++++++++++++---------------
 drivers/net/wireless/ti/wlcore/scan.c     |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |    4 +--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    7 ++--
 9 files changed, 84 insertions(+), 47 deletions(-)

-- 
1.7.10

