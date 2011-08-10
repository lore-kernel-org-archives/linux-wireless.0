Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3760 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab1HJPFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 11:05:36 -0400
Message-ID: <4E429E3B.9000504@qca.qualcomm.com> (sfid-20110810_170543_489654_9756041F)
Date: Wed, 10 Aug 2011 18:05:31 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Pull request: ath6kl 2011-08-10
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's just one patch to fix the linker error Stephen found.

The following changes since commit 392e741939ddb7dd7adf7e4ec414b2140fb3a15b:

  Merge branch 'for-linville' of
master.kernel.org:/pub/scm/linux/kernel/git/kvalo/ath6kl (2011-08-09
16:02:26 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath6kl.git
for-linville

Kalle Valo (1):
      ath6kl: fix function name conflicts with ath9k

 drivers/net/wireless/ath/ath6kl/htc.c     |   61
+++++++++++++++--------------
 drivers/net/wireless/ath/ath6kl/htc.h     |   45 +++++++++++----------
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    4 +-
 drivers/net/wireless/ath/ath6kl/init.c    |   16 ++++----
 drivers/net/wireless/ath/ath6kl/main.c    |    4 +-
 drivers/net/wireless/ath/ath6kl/txrx.c    |   14 +++---
 6 files changed, 74 insertions(+), 70 deletions(-)
