Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:51178 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab1FMJIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 05:08:24 -0400
Subject: [PATCH 0/2] ath6kl: testmode and fw version for 3.1
To: gregkh@suse.de
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Mon, 13 Jun 2011 12:08:19 +0300
Message-ID: <20110613090350.15210.74545.stgit@localhost6.localdomain6> (sfid-20110613_110828_357652_E7860734)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

here are two new ath6kl features for 3.1. Someone asked me to export
firmware version to user space, thanks to cfg80211 that's easy to do. The
testmode is a regression from older patches which removed all the ioctl
interfaces. I decided to implement this properly using nl80211 testmode
commands.

Please consider these patches to your staging-next branch and let me
know if there are any problems.

Kalle

---

Kalle Valo (2):
      ath6kl: export firmware version to user space
      ath6kl: testmode support


 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    7 +++
 drivers/staging/ath6kl/os/linux/cfg80211.c   |   58 ++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 0 deletions(-)

