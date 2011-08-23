Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45951 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab1HWAIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 20:08:52 -0400
Received: by gxk21 with SMTP id 21so3970825gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 17:08:51 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: florian@openwrt.org
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFT v2 0/2] ath9k: AR9580 support
Date: Mon, 22 Aug 2011 17:08:37 -0700
Message-Id: <1314058119-3441-1-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110823_020857_602574_5BFA4D94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

This v2 just corrects the license on the initvals, the
initval was now generated with -w on from the initvals tool [1].

./initvals -w -f ar9580-1p0 > ar9580_1p0_initvals.h

BTW I think we have some other hw families which we could use
being added into the initvals tool, if you added such family
I'd appreciate a respective patch :D

[1] git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/initvals-tool.git

Luis R. Rodriguez (2):
  ath9k_hw: add AR9580 support
  ath9k: add AR9580 support

 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   83 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    3 +-
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   | 1673 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/pci.c               |    1 +
 drivers/net/wireless/ath/ath9k/reg.h               |   14 +
 5 files changed, 1773 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h

-- 
1.7.4.15.g7811d

