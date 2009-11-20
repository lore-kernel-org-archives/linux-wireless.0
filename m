Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54750 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbZKTWCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 17:02:10 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/3] [compat-2.6] Small fixes
Date: Fri, 20 Nov 2009 23:01:50 +0100
Message-Id: <1258754513-4546-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix build of compat-wireless and refresh some files.

compat-wireless does not build with kernel 2.6.26 and older, because
debugfs_remove_recursive is missing. This is not fixed by this patch.

Hauke Mehrtens (3):
  [compat-2.6] Add IFF_DONT_BRIDGE definition to compat
  [compat-2.6] Refresh config.mk
  [compat-2.6] Refresh patches

 compat/compat-2.6.33.c                             |   16 +++++++++++++
 compat/compat-2.6.33.h                             |   15 ++++++++++++
 compat/compat.h                                    |    1 +
 compat/patches/01-netdev.patch                     |   24 ++++++++++----------
 compat/patches/02-ksize.patch                      |    2 +-
 compat/patches/03-rfkill.patch                     |   20 ++++++++--------
 compat/patches/05-usb.patch                        |    2 +-
 compat/patches/06-header-changes.patch             |    2 +-
 compat/patches/08-rename-iwl4965-config.patch      |    2 +-
 .../patches/10-add-wext-handlers-to-netdev.patch   |    2 +-
 compat/patches/13-trace.patch                      |    2 +-
 compat/patches/14-device-type.patch                |    2 +-
 compat/patches/15-symbol-export-conflicts.patch    |    2 +-
 compat/patches/98-add-compat-wireless.patch        |    3 +-
 config.mk                                          |   17 ++++++-------
 15 files changed, 72 insertions(+), 40 deletions(-)
 create mode 100644 compat/compat-2.6.33.c
 create mode 100644 compat/compat-2.6.33.h

