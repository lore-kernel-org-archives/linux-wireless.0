Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56184 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2CSKHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:07:33 -0400
Received: by wejx9 with SMTP id x9so5669979wej.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 03:07:32 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] wl12xx: various bug fixes for 3.4
Date: Mon, 19 Mar 2012 12:06:25 +0200
Message-Id: <1332151589-27272-1-git-send-email-eyal@wizery.com> (sfid-20120319_110736_587208_78B8249D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some recent bug fixes fixing a panic and a memory leak
related to FW recovery as well as some scan issues.

Eyal Shapira (4):
  wl12xx: fix race between suspend/resume and recovery
  wl12xx: fix a memory leak of probereq template upon recovery
  wl12xx: adaptive sched scan dwell times
  wl12xx: increase scan timeout to 30s

 drivers/net/wireless/wl12xx/conf.h |   28 ++++++++++++++----
 drivers/net/wireless/wl12xx/main.c |   54 +++++++++++++++++++----------------
 drivers/net/wireless/wl12xx/scan.c |   29 ++++++++++++++++--
 drivers/net/wireless/wl12xx/scan.h |    2 +-
 4 files changed, 77 insertions(+), 36 deletions(-)

-- 
1.7.4.1

