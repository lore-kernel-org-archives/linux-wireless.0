Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:38484 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758223Ab2FUDVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 23:21:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stone Piao <piaoyun@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Ying Luo <luoy@marvell.com>, Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.5 0/4] mwifiex: bug fixes for 3.5
Date: Wed, 20 Jun 2012 20:21:09 -0700
Message-Id: <1340248873-5455-1-git-send-email-bzhao@marvell.com> (sfid-20120621_052125_571828_4CE63913)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I'm resending the 3.5 series as they must be applied in sequence.

Thanks,
Bing

---
Amitkumar Karwar (2):
  mwifiex: fix bugs in event handling code
  mwifiex: improve error path handling in usb.c

Stone Piao (2):
  mwifiex: fix 11n rx packet drop issue
  mwifiex: fix WPS eapol handshake failure

 drivers/net/wireless/mwifiex/11n_rxreorder.c |    5 ++-
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    7 ++++++
 drivers/net/wireless/mwifiex/sdio.c          |    6 ++--
 drivers/net/wireless/mwifiex/sta_event.c     |    9 +++----
 drivers/net/wireless/mwifiex/usb.c           |   28 ++++++++++++++++++-------
 drivers/net/wireless/mwifiex/wmm.c           |    3 ++
 6 files changed, 40 insertions(+), 18 deletions(-)

