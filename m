Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55942 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0DRNgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 09:36:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/3] compat-wireless: compile fixes
Date: Sun, 18 Apr 2010 15:36:21 +0200
Message-Id: <1271597784-4811-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains mostly compile fixes.
It was compile tested on kernel 2.6.25 to 2.6.34 and ath9k is working in
Ubuntu 9.04.

Hauke Mehrtens (3):
  compat-wireless: backport convert multicast list to list_head.
  compat-wireless: Remove use of sdio quirks attribute
  compat-wireless: include net and trace includes form compat.

 patches/25-multicast-list_head.patch |  813 ++++++++++++++++++++++++++++++++++
 patches/26-sdio-quirks.patch         |   20 +
 scripts/admin-update.sh              |    3 +
 3 files changed, 836 insertions(+), 0 deletions(-)
 create mode 100644 patches/25-multicast-list_head.patch
 create mode 100644 patches/26-sdio-quirks.patch

