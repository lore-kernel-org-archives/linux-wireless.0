Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43680 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab0DRNiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 09:38:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/2] compat-wireless: compile fixes
Date: Sun, 18 Apr 2010 15:37:55 +0200
Message-Id: <1271597877-4878-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains mostly compile fixes.
It was compile tested on kernel 2.6.25 to 2.6.34 and ath9k is working in
Ubuntu 9.04.

Hauke Mehrtens (2):
  compat: Add definitions needed for libertas sdio driver.
  compat: Add linux/version.h include before using it.

 include/linux/compat-2.6.35.h |    3 +++
 include/linux/tracepoint.h    |    2 ++
 include/net/net_namespace.h   |    2 ++
 include/trace/define_trace.h  |    2 ++
 4 files changed, 9 insertions(+), 0 deletions(-)

