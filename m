Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62881 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1HVXbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 19:31:41 -0400
Received: by gya6 with SMTP id 6so3951715gya.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 16:31:41 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: florian@openwrt.org
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 0/2] RFT: AR580 support
Date: Mon, 22 Aug 2011 16:31:25 -0700
Message-Id: <1314055887-12806-1-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110823_013145_230471_F347FF95)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Please test as I don't have the AR9580 hardware with me. If it works then
we can push it in.

Luis R. Rodriguez (2):
  ath9k_hw: add AR9580 support
  ath9k: add AR9580 support

 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   83 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    3 +-
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   | 1651 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/pci.c               |    1 +
 drivers/net/wireless/ath/ath9k/reg.h               |   14 +
 5 files changed, 1751 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h

-- 
1.7.4.15.g7811d

