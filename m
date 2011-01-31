Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57445 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623Ab1AaWHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 17:07:11 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/2] compat-wireless: make patches apply again.
Date: Mon, 31 Jan 2011 23:06:42 +0100
Message-Id: <1296511604-16921-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This just makes the patches apply again and builds with some kernels.
The patch in crap/0002-ath9k-Add-pktlog-support.patch does not apply 
any more and I do not have the time to make it apply again. It should 
be removed or someone else should fix it.

Hauke Mehrtens (2):
  compat-wireless: adapt chamhes in brcm80211
  compat-wireless: remove max_brightness

 config.mk                              |    4 +-
 patches/35-fix-makefile-includes.patch |   42 ++++++++++++++++----------------
 patches/37-led-max-brightness.patch    |   12 +++++++++
 3 files changed, 35 insertions(+), 23 deletions(-)
 create mode 100644 patches/37-led-max-brightness.patch

