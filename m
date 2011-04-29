Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52268 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759771Ab1D2RNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 13:13:07 -0400
Subject: [PATCH 0/2] ath6kl: two fixes
To: gregkh@suse.de
From: Kalle Valo <kvalo@adurom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Fri, 29 Apr 2011 20:02:09 +0300
Message-ID: <20110429165934.26819.76573.stgit@x201> (sfid-20110429_191310_316719_22BE7601)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

here are two fixes to ath6kl. checkpatch complains about indenting, but
that's because indenting is already wrong in the original files. That will
be fixed separately.

---

Naveen Singh (2):
      staging: ath6kl: cfg80211_roam issue; driver wedge
      staging: ath6kl: open/shared auth implementation


 drivers/staging/ath6kl/include/common/wmi.h        |    5 +
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    1 
 drivers/staging/ath6kl/os/linux/cfg80211.c         |  183 ++++++++++++++------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    1 
 4 files changed, 131 insertions(+), 59 deletions(-)

