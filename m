Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34135 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3FLSi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 14:38:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Pull request: ath6kl 20130612
Date: Wed, 12 Jun 2013 21:38:19 +0300
Message-ID: <87d2rrqin8.fsf@kamboji.qca.qualcomm.com> (sfid-20130612_203831_752070_55A40310)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here are few simple patches for ath6kl. We have a suspend crash fix for
USB from Shafi, use of mac_pton(), a compiler warning fix and a fix for
module initialisation error path.

Kalle

The following changes since commit 3e817f086f06069a23b797ee2279bbae638d5edc:

  cw1200: remove unused including <linux/version.h> (2013-05-30 14:45:25 -0400)

are available in the git repository at:

  git://github.com/kvalo/ath6kl.git for-linville

for you to fetch changes up to 37291fc61253cd34db40b7a60be4497db776db41:

  ath6kl: Unify sg_sz and buf_sz in ath6kl_sdio_alloc_prep_scat_req() (2013-06-01 15:16:33 +0300)

----------------------------------------------------------------
Andy Shevchenko (1):
      wireless: ath6kl: re-use native helper to parse MAC

Geert Uytterhoeven (1):
      ath6kl: Unify sg_sz and buf_sz in ath6kl_sdio_alloc_prep_scat_req()

Mohammed Shafi Shajakhan (2):
      ath6kl: Rename USB driver's suspend/resume/reset_resume
      ath6kl: Fix a suspend/resume crash in AR6004 USB

Raja Mani (1):
      ath6kl: Check wmi ready event status before validating abi version

 drivers/net/wireless/ath/ath6kl/debug.c |    8 +------
 drivers/net/wireless/ath/ath6kl/init.c  |   14 ++++++------
 drivers/net/wireless/ath/ath6kl/sdio.c  |   12 +++++------
 drivers/net/wireless/ath/ath6kl/usb.c   |   36 +++++++++++++++++++++++--------
 4 files changed, 41 insertions(+), 29 deletions(-)
