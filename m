Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51457 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab1FBQbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:31:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] Add support for kernel 3.XX
Date: Thu,  2 Jun 2011 18:31:00 +0200
Message-Id: <1307032264-14663-1-git-send-email-hauke@hauke-m.de> (sfid-20110602_183120_510794_824B5BAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series mostly add support for kernel 3.XX. It also fixes a 
bug. Patch 1 and 3 are needing some patches in compat-wireless and vice 
versa.

All these patches should so go into linux-3.0.0.y branch.

Hauke Mehrtens (4):
  compat: add support for kernel 3.0
  compat: add device name in register_netdevice(dev)
  compat: rename CONFIG_COMPAT_KERNEL_
  compat: add KEY_WPS_BUTTON

 compat/Makefile               |   38 +++++++++++++++++++-------------------
 include/linux/compat-2.6.34.h |    2 ++
 include/linux/compat-2.6.40.h |   29 -----------------------------
 include/linux/compat-2.6.h    |    3 ++-
 include/linux/compat-3.0.h    |   31 +++++++++++++++++++++++++++++++
 include/linux/compat-3.1.h    |   27 +++++++++++++++++++++++++++
 6 files changed, 81 insertions(+), 49 deletions(-)
 delete mode 100644 include/linux/compat-2.6.40.h
 create mode 100644 include/linux/compat-3.0.h
 create mode 100644 include/linux/compat-3.1.h

-- 
1.7.4.1

