Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48196 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab3GWJrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 05:47:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>,
	<ath10k@lists.infradead.org>
Subject: Pull request: ath-current 20130723
Date: Tue, 23 Jul 2013 12:46:57 +0300
Message-ID: <87ehapwqum.fsf@kamboji.qca.qualcomm.com> (sfid-20130723_114712_562016_95F05BBB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's an ath6kl and ath10k pull request for 3.11-rc series.

Geert Uytterhoeven fixed an ath10k build problem when NO_DMA=y. I added
a missing MAINTAINERS entry for ath10k and updated ath6kl git tree
location.

Please let me know if there are any problems, or if you prefer me to
send them through wireless-next instead.

Kalle

The following changes since commit 64b6f46f1141ad938e354f37af62e28da972e8eb:

  ath9k_hw: Fix multicast search for AR9002 family (2013-07-18 16:22:00 -0400)

are available in the git repository at:

  git://github.com/kvalo/ath.git for-linville-current

for you to fetch changes up to 58cfb681bffb43654776a218a087028ff425ba9e:

  MAINTAINERS: update ath6kl git location (2013-07-22 12:26:12 +0300)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      ath10k: ATH10K should depend on HAS_DMA

Kalle Valo (2):
      MAINTAINERS: add ath10k
      MAINTAINERS: update ath6kl git location

 MAINTAINERS                             |   10 +++++++++-
 drivers/net/wireless/ath/ath10k/Kconfig |    2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

-- 
Kalle Valo
