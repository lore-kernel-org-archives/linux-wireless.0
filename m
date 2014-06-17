Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:46542 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbaFQJkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 05:40:49 -0400
Subject: [PATCH 0/6] ath6kl: add ar6004 hw3.0
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Jun 2014 12:40:45 +0300
Message-ID: <20140617093836.22040.99081.stgit@potku.adurom.net> (sfid-20140617_114053_175345_F7317125)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for frequently requested ar6004 hw3.0 version. 

Kalle

---

Jessica Wu (3):
      ath6kl: implement rx flush for htc pipe
      ath6kl: add support wmi rate tables with mcs15
      ath6kl: add support for ar6004 hw3.0

Kalle Valo (3):
      ath6kl: convert ar6004 hardware flags to firmware feature flags
      ath6kl: don't set hi_refclk_hz if hardware version doesn't need it
      ath6kl: properly null terminate the firmware string


 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +-
 drivers/net/wireless/ath/ath6kl/core.c     |   16 +++++
 drivers/net/wireless/ath/ath6kl/core.h     |   36 ++++++++++--
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   32 +++++++++-
 drivers/net/wireless/ath/ath6kl/init.c     |   86 ++++++++++++++++++++++------
 drivers/net/wireless/ath/ath6kl/main.c     |   17 ++++--
 drivers/net/wireless/ath/ath6kl/usb.c      |    7 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   72 ++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |    2 -
 9 files changed, 232 insertions(+), 42 deletions(-)

