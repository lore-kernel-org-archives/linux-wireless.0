Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48060 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbZKIWVS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:21:18 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] [compat-2.6] Some patches for compat-wireless
Date: Mon,  9 Nov 2009 23:20:56 +0100
Message-Id: <1257805260-13265-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some patches for compat-wireless
For kernel 2.6.26 and older debugfs_remove_recursive needs to be
backported. The problems with rt2800lib will be fixed in
wireless-testing.

v2: resend patches because of line-wrap.

Hauke Mehrtens (4):
  [compat-2.6] Fix build problem, missing get_unaligned_le16
  [compat-2.6] Fix two warnings
  [compat-2.6] refresh patches
  [compat-2.6] Add symbol CONFIG_RT2800_LIB

 compat/patches/01-netdev.patch                  |    2 +-
 compat/patches/06-header-changes.patch          |   12 ++++++++++++
 compat/patches/08-rename-iwl4965-config.patch   |    2 +-
 compat/patches/09-threaded-irq.patch            |    2 +-
 compat/patches/11-dev-pm-ops.patch              |    2 +-
 compat/patches/15-symbol-export-conflicts.patch |    2 +-
 config.mk                                       |    6 +++---
 7 files changed, 20 insertions(+), 8 deletions(-)

