Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53312 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab0IBNdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 09:33:09 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] compat-wireless: small fixes.
Date: Thu,  2 Sep 2010 15:32:53 +0200
Message-Id: <1283434377-26210-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Theses patches are mostly fixing some problems introduced in the last 
few days.

Including ath6kl causes problems. The Makefile wants to build ath6kl but 
it is not there. This causes errors when compiling. We should exclude 
ath6kl till it is integrated in linux-next.

Hauke Mehrtens (4):
  compat-wireless: convert ifndef for compat_autoconf.h
  compat-wireless: replace name CONFIG_IWLWIFI
  compat-wireless: fix generation of compat_autoconf.h
  compat-wireless: fix patch style

 config.mk                              |    2 +-
 patches/08-rename-iwl4965-config.patch |   13 ++++++++++++-
 patches/24-pcmcia.patch                |    2 +-
 scripts/gen-compat-autoconf.sh         |    6 +++++-
 4 files changed, 19 insertions(+), 4 deletions(-)

