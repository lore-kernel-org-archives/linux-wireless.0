Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:47555 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755788Ab1EJMDV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 08:03:21 -0400
Received: by ewy9 with SMTP id 9so2642241ewy.14
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 05:03:18 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/5] wl12xx: scheduled scan implementation
Date: Tue, 10 May 2011 15:03:05 +0300
Message-Id: <1305028990-14044-1-git-send-email-coelho@ti.com> (sfid-20110510_140324_829167_81636B49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patch set adds scheduled scan implementation in the wl12xx driver.  I'm
sending it as RFC because it depends on the cfg82011/mac80211 changes and can't
be integrated yet.

Cheers,
Luca.

Luciano Coelho (5):
  wl12xx: add configuration values for scheduled scan
  wl12xx: listen to scheduled scan events
  wl12xx: add scheduled scan structures and commands
  wl12xx: implement scheduled scan driver operations and reporting
  wl12xx: export scheduled scan state in debugfs

 drivers/net/wireless/wl12xx/boot.c    |    4 +-
 drivers/net/wireless/wl12xx/conf.h    |   21 +++
 drivers/net/wireless/wl12xx/debugfs.c |    1 +
 drivers/net/wireless/wl12xx/event.c   |   16 +++
 drivers/net/wireless/wl12xx/main.c    |   79 +++++++++++
 drivers/net/wireless/wl12xx/scan.c    |  237 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/scan.h    |  114 ++++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h  |    2 +
 8 files changed, 473 insertions(+), 1 deletions(-)

