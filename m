Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:42349 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751298Ab1KHDb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 22:31:58 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH RESEND 0/4] mwifiex: resending missed patches
Date: Mon,  7 Nov 2011 19:31:43 -0800
Message-Id: <1320723107-24202-1-git-send-email-bzhao@marvell.com> (sfid-20111108_043201_478763_C922175F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

These patches have been sent before. I'm resending them with my
Acked-by or Signed-off-by.

Could you please merge them to wireless-testing.git?

Thanks,
Bing

---

Amitkumar Karwar (1):
  mwifiex: enable SDIO multiport aggregation

Dan Carpenter (3):
  mwifiex: remove unneeded kfree(NULL);
  mwifiex: remove an unneeded NULL check
  mwifiex: prevent corruption instead of just warning

 drivers/net/wireless/mwifiex/pcie.c |   11 ++++++-----
 drivers/net/wireless/mwifiex/sdio.c |    4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

