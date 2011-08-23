Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:35902 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab1HWUhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 16:37:11 -0400
Received: by iye16 with SMTP id 16so726166iye.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 13:37:10 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	florian@openwrt.org, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 0/2] ath9k: AR9580 support
Date: Tue, 23 Aug 2011 13:37:05 -0700
Message-Id: <1314131827-29565-1-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110823_223715_448923_F3B89FA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

This adds AR9580 support to ath9k. Thanks to Florian for the
help with testing.

Luis R. Rodriguez (2):
  ath9k_hw: add AR9580 support
  ath9k: add AR9580 support

 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   81 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    3 +-
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   | 1673 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c                |    1 +
 drivers/net/wireless/ath/ath9k/hw.h                |    1 +
 drivers/net/wireless/ath/ath9k/pci.c               |    1 +
 drivers/net/wireless/ath/ath9k/reg.h               |   14 +
 7 files changed, 1773 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h

-- 
1.7.4.15.g7811d

