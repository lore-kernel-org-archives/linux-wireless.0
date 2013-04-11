Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63697 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab3DKLvd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:51:33 -0400
Received: from mailout-de.gmx.net ([10.1.76.34]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MdY5y-1UEG080aWC-00PMXY for
 <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2013 13:51:32 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: bzhao@marvell.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	daniel@zonque.org, yogeshp@marvell.com, patila@marvell.com,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH v3 0/2] wmm queues handling simplificatons
Date: Thu, 11 Apr 2013 13:51:06 +0200
Message-Id: <1365681068-27820-1-git-send-email-andreas.fenkart@streamunlimited.com> (sfid-20130411_135138_982319_88D2CE82)
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DE96073@SC-VEXCH1.marvell.com>
References: <477F20668A386D41ADCC57781B1F70430D9DE96073@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v3: minor cleanups for coding style; checkpatch.pl --strict 
v2: split 6 patches into 2 patchsets. This is the set 2.

Andreas Fenkart (2):
  mwifiex: replace ra_list_curr by list rotation.
  mwifiex: rework round robin scheduling of bss nodes.

 drivers/net/wireless/mwifiex/11n_aggr.c |   14 +--
 drivers/net/wireless/mwifiex/init.c     |   21 ++--
 drivers/net/wireless/mwifiex/main.h     |    1 -
 drivers/net/wireless/mwifiex/wmm.c      |  160 ++++++++++---------------------
 drivers/net/wireless/mwifiex/wmm.h      |    3 +
 5 files changed, 61 insertions(+), 138 deletions(-)

-- 
1.7.10.4

