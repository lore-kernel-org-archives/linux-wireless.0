Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34349 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1AIPGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 10:06:34 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/2] compat-wireless-stable-2.6.37
Date: Sun,  9 Jan 2011 16:06:19 +0100
Message-Id: <1294585581-9991-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches should be backported form compat-wireless based on 
linux-next to the stable version 2.6.37 as they are fixing some build 
issues with some kernel version.

Hauke Mehrtens (1):
  compat-wireless: backport power api in atl1c

Luis R. Rodriguez (1):
  compat-wireless: remove 28-pm-qos-params.patch

 patches/11-dev-pm-ops.patch    |   50 +++++++++++++++++
 patches/28-pm-qos-params.patch |  118 ----------------------------------------
 2 files changed, 50 insertions(+), 118 deletions(-)
 delete mode 100644 patches/28-pm-qos-params.patch

