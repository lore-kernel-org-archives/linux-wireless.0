Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46601 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab1LOEQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 23:16:41 -0500
Received: by iaeh11 with SMTP id h11so2176479iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 20:16:41 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 0/3] ath9k: DFS placeholders
Date: Wed, 14 Dec 2011 20:16:31 -0800
Message-Id: <1323922595-15533-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111215_051645_594836_3D5D7D39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have a lot of work left ahead for DFS but this is a respin
of Zefir's work to make it upstreamable. The last patch highlights
the stuff we still need to address for ath9k specifically. I think
the first 3 patches are OK to get upstream as placeholders given that
we still need to address a bit of the rest. But I see no need to have
that stuff wait longer.

Zefir Kurtisi (3):
  ath: add a debug level for DFS
  ath9k_hw: add DFS testing check
  ath9k: add DFS radar pulse processing

 drivers/net/wireless/ath/ath.h             |    2 +
 drivers/net/wireless/ath/ath9k/Kconfig     |   22 +++
 drivers/net/wireless/ath/ath9k/Makefile    |    2 +
 drivers/net/wireless/ath/ath9k/debug.c     |    3 +
 drivers/net/wireless/ath/ath9k/debug.h     |    2 +
 drivers/net/wireless/ath/ath9k/dfs.c       |  215 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs.h       |   43 ++++++
 drivers/net/wireless/ath/ath9k/dfs_debug.c |   81 +++++++++++
 drivers/net/wireless/ath/ath9k/dfs_debug.h |   57 ++++++++
 drivers/net/wireless/ath/ath9k/hw-ops.h    |    9 ++
 drivers/net/wireless/ath/ath9k/hw.c        |   27 ++++
 drivers/net/wireless/ath/ath9k/hw.h        |    1 +
 12 files changed, 464 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.h
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.h

-- 
1.7.4.15.g7811d

