Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43998 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2E2Wl6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:41:58 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] compat: misc patches to make it compile again
Date: Wed, 30 May 2012 00:41:44 +0200
Message-Id: <1338331308-29732-1-git-send-email-hauke@hauke-m.de> (sfid-20120530_004201_315730_6D6DE5CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series in combination with the series for compat-wireless makes 
compat-wireless compile again for me on all supported kernel versions.

Hauke Mehrtens (4):
  compat: do not include qdisc_cb_private_validate with every kernel
  comapt: add skb_queue_walk_from
  compat: remove hci_mon.h
  compat: add ida_simple_{get,remove}

 compat/Makefile                 |    1 +
 compat/compat-3.1.c             |   83 +++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.28.h   |    4 ++
 include/linux/compat-3.1.h      |    5 +++
 include/linux/compat-3.3.h      |    2 +
 include/net/bluetooth/hci_mon.h |   51 ------------------------
 6 files changed, 95 insertions(+), 51 deletions(-)
 create mode 100644 compat/compat-3.1.c
 delete mode 100644 include/net/bluetooth/hci_mon.h

-- 
1.7.9.5

