Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44547 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1AIPAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 10:00:55 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-stable-2.6.37
Date: Sun,  9 Jan 2011 16:00:33 +0100
Message-Id: <1294585234-9806-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch should go into compat stable linux-2.6.37.y as the function 
is also used in linux version 2.6.37. It is already included in compat-
wireless based on linux-next.

Hauke Mehrtens (1):
  compat: backport pci_wake_from_d3

 compat/compat-2.6.28.c        |   22 ++++++++++++++++++++++
 include/linux/compat-2.6.28.h |    2 ++
 2 files changed, 24 insertions(+), 0 deletions(-)

