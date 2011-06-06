Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39709 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab1FFJ0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:26:05 -0400
Date: Mon, 6 Jun 2011 14:46:21 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/4] AMSDU TX optimization
Message-ID: <20110606091615.GA28184@hertz.marvell.com> (sfid-20110606_112609_123024_7F1DBDAD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series optimizes AMSDU TX path.

Yogesh Ashok Powar (4):
  mwifiex: Remove list traversal in mwifiex_num_pkts_in_txq
  mwifiex: Remove redundant skb_queue_empty checks
  mwifiex: Adding check for enough space before padding
  mwifiex: disable transmission buffer aggregation for AMSDU packets

 drivers/net/wireless/mwifiex/11n_aggr.c |   54 +++++++++++++++++++------------
 drivers/net/wireless/mwifiex/main.h     |    1 +
 drivers/net/wireless/mwifiex/wmm.c      |   30 +++--------------
 3 files changed, 40 insertions(+), 45 deletions(-)

-- 
1.7.3.5

