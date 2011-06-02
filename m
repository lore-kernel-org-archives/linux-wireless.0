Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60485 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab1FBQfl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:35:41 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/9] compat-wireless: Add support for kernel 3.XX
Date: Thu,  2 Jun 2011 18:35:16 +0200
Message-Id: <1307032525-18916-1-git-send-email-hauke@hauke-m.de> (sfid-20110602_183548_157728_492F13FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series mostly add support for kernel 3.XX.
Some of these patches are needing patches for compat.git.

The patches with "Add to compat-3.0-stable" should also be applied to 
linux-3.0.0.y.

Hauke Mehrtens (9):
  comapt-wireless: move doku to the correct place in config.mk
  compat-wireless: rename CONFIG_COMPAT_KERNEL_
  compat-wireless: add support for kernel 3.XX
  compat-wireless: make patches apply again
  compat-wireless: add missing header
  compat-wireless: activate CARL9170_WPC by default
  compat-wireless: activate CONFIG_RT2800{USB,PCI}_RT35XX by default.
  compat-wireless: sync atheros-debug.mk with config.mk
  compat-wireless: update enable-older-kernels patches

 config.mk                                |  122 ++++++++-------
 defconfigs/atheros-debug.mk              |  247 ++++++++++++++++++------------
 enable-older-kernels/enable-2.6.21.patch |   12 +-
 enable-older-kernels/enable-2.6.22.patch |   12 +-
 enable-older-kernels/enable-2.6.23.patch |   12 +-
 patches/09-threaded-irq.patch            |   20 ++--
 scripts/admin-update.sh                  |    2 +-
 scripts/gen-compat-autoconf.sh           |   19 ++-
 8 files changed, 263 insertions(+), 183 deletions(-)

-- 
1.7.4.1

