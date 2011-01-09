Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54106 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1AIPcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 10:32:31 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/3] compat-wireless: some updates to scripts
Date: Sun,  9 Jan 2011 16:32:18 +0100
Message-Id: <1294587141-11353-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commit should also go into stable comat-wireless:
	184c55e4c41b95c01ea5e4152c613b5c79e44466
	[PATCH 1/3] compat-wireless: make NEXT_TREE configurable.

Hauke Mehrtens (3):
  compat-wireless: make NEXT_TREE configurable.
  compat-wireless: update patches in enable-older-kernels
  compat-wireless: do not write git-clone

 enable-older-kernels/enable-2.6.21.patch |   26 +++++++++++++-------------
 enable-older-kernels/enable-2.6.22.patch |   26 +++++++++++++-------------
 enable-older-kernels/enable-2.6.23.patch |   20 +++++++++-----------
 enable-older-kernels/enable-2.6.24.patch |   28 ----------------------------
 scripts/admin-update.sh                  |   26 +++++++++++++++++++-------
 5 files changed, 54 insertions(+), 72 deletions(-)
 delete mode 100644 enable-older-kernels/enable-2.6.24.patch

