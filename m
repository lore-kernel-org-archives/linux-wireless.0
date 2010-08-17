Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50189 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935437Ab0HQScm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 14:32:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/3] compat: miscellaneous fixes
Date: Tue, 17 Aug 2010 20:32:30 +0200
Message-Id: <1282069953-22360-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was build tested in combination with the patches to compat-wireless.

Hauke Mehrtens (3):
  compat: backport init_dummy_netdev
  compat: backport net_ns_type_operations
  compat: fix warning in device_rename

 compat/Makefile               |    1 +
 compat/compat-2.6.29.c        |   40 ++++++++++++++++++++++++++++++++++++
 compat/compat-2.6.37.c        |   45 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.29.h |    2 +
 include/linux/compat-2.6.36.h |    2 +
 include/linux/compat-2.6.37.h |    2 +
 6 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 compat/compat-2.6.37.c

