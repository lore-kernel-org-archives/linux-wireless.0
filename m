Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:36592 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab1FHLyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 07:54:16 -0400
Subject: [PATCH 0/5] ath6kl: staging fixes
To: gregkh@suse.de
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Wed, 08 Jun 2011 14:54:07 +0300
Message-ID: <20110608114240.32208.31805.stgit@localhost6.localdomain6> (sfid-20110608_135419_096671_4DA081CC)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

here are few pending fixes and two new ones which haven't been sent before. The
new patches are:

ath6kl: cache firmware
ath6kl: fix crash when interface is closed but scan is ongoing

Please take a look at them and if they are ok consider applying them to your
staging tree.

Thanks.

---

Kalle Valo (4):
      ath6kl: export firmware version to user space
      ath6kl: testmode support
      ath6kl: cache firmware
      ath6kl: fix crash when interface is closed but scan is ongoing

Vasanthakumar Thiagarajan (1):
      ath6kl: Fix a kernel panic furing suspend/resume


 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   60 ++++++++++----
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   88 +++++++++++++++++---
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    9 ++
 3 files changed, 130 insertions(+), 27 deletions(-)

