Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51938 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab0HGNcx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 09:32:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] compat: miscellaneous updates for compat
Date: Sat,  7 Aug 2010 15:32:17 +0200
Message-Id: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains miscellaneous updates for compat. They are compile
tested with kernel 2.6.26 to 2.6.35. ath9k and b43 were tested with
kernel 2.6.32.

Hauke Mehrtens (4):
  compat: backport n_tty_ioctl_helper
  compat: move va_format to compat-2.6.36.h
  compat: fix compiler warning
  compat: update compat_firmware_class.c

 compat/compat-2.6.28.c         |  128 ++++++++++++++++++
 compat/compat_firmware_class.c |  290 ++++++++++++++++++++-------------------
 include/linux/compat-2.6.27.h  |    2 +
 include/linux/compat-2.6.28.h  |    6 +
 include/linux/compat-2.6.35.h  |    5 -
 include/linux/compat-2.6.36.h  |    5 +
 6 files changed, 290 insertions(+), 146 deletions(-)

