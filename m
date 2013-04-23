Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:34523 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756611Ab3DWTIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 15:08:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 0/2 RESEND] mwifiex wmm queues handling simplificatons
Date: Tue, 23 Apr 2013 12:06:30 -0700
Message-ID: <1366743992-14309-1-git-send-email-bzhao@marvell.com> (sfid-20130423_233114_948993_EB48AC91)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v3: minor cleanups for coding style; checkpatch.pl --strict 
v2: split 6 patches into 2 patchsets. This is the set 2.


Andreas Fenkart (2):
  mwifiex: replace ra_list_curr by list rotation.
  mwifiex: rework round robin scheduling of bss nodes.

 drivers/net/wireless/mwifiex/11n_aggr.c |   14 +---
 drivers/net/wireless/mwifiex/init.c     |   21 +---
 drivers/net/wireless/mwifiex/main.h     |    1 -
 drivers/net/wireless/mwifiex/wmm.c      |  160 ++++++++++---------------------
 drivers/net/wireless/mwifiex/wmm.h      |    3 +
 5 files changed, 61 insertions(+), 138 deletions(-)

