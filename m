Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36760 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1BJP0u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 10:26:50 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] compat-wireless: some fixes
Date: Thu, 10 Feb 2011 16:26:26 +0100
Message-Id: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series replaces the old one send on Tuesday.
Now brcm80211 builds without debugging activated and all patches in the 
patches directory are applying onto todays linux-next.

Hauke Mehrtens (4):
  compat-wireless: make patches apply again
  compat-wireless: brcm80211 adapt changes in mac80211
  compat-wireless: build zd1211rw only for kernel >= 2.6.29
  compat-wireless: activate BRCMFMAC

 config.mk                                    |    8 ++++--
 patches/16-bluetooth.patch                   |   32 +++++++++++++-------------
 patches/31-backport-sk_add_backlog.patch     |    6 ++--
 patches/35-fix-makefile-includes.patch       |   14 +++++-----
 patches/38-brcm80211-mac80211-backport.patch |   14 +++++++++++
 5 files changed, 45 insertions(+), 29 deletions(-)
 create mode 100644 patches/38-brcm80211-mac80211-backport.patch

