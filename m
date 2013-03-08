Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:43864 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab3CHK0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 05:26:52 -0500
Subject: [PATCH 0/3] ath6kl: fix usb warm reboot and cleanups
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Fri, 08 Mar 2013 12:26:46 +0200
Message-ID: <20130308102539.23245.55176.stgit@localhost6.localdomain6> (sfid-20130308_112655_973965_F6201CE8)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While looking at the usb warm reboot I had to some cleanup, especially with error
handling.

---

Kalle Valo (3):
      ath6kl: cleanup ath6kl_reset_device()
      ath6kl: fix usb related error handling and warnings
      ath6kl: cold reset target after host warm boot


 drivers/net/wireless/ath/ath6kl/core.h     |    2 --
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   12 +++++----
 drivers/net/wireless/ath/ath6kl/init.c     |   37 +++++++++++++++++++---------
 drivers/net/wireless/ath/ath6kl/main.c     |   33 -------------------------
 drivers/net/wireless/ath/ath6kl/target.h   |    2 +-
 drivers/net/wireless/ath/ath6kl/usb.c      |   34 +++++++++++++++++---------
 6 files changed, 54 insertions(+), 66 deletions(-)

