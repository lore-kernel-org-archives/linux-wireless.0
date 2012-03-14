Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35721 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030469Ab2CNCXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 22:23:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 0/9] mwifiex: coding style cleanups
Date: Tue, 13 Mar 2012 19:22:33 -0700
Message-Id: <1331691762-5514-1-git-send-email-bzhao@marvell.com> (sfid-20120314_032357_016220_B94593AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This series of v2 patches takes care of the coding style issues
in mwifiex driver.

These patches have been checked with "checkpatch.pl --strict"
using the patch from Joe Perches <joe@perches.com>:

[PATCH v3] checkpatch: Add some --strict coding style checks

Thanks,
Bing

--
v2: try to keep the "formats" in one line wherever possible (Joe Perches)

Yogesh Ashok Powar (9):
  mwifiex: fix checkpatch --strict warnings/errors Part 1
  mwifiex: fix checkpatch --strict warnings/errors Part 2
  mwifiex: fix checkpatch --strict warnings/errors Part 3
  mwifiex: fix checkpatch --strict warnings/errors Part 4
  mwifiex: fix checkpatch --strict warnings/errors Part 5
  mwifiex: fix checkpatch --strict warnings/errors Part 6
  mwifiex: fix checkpatch --strict warnings/errors Part 7
  mwifiex: fix checkpatch --strict warnings/errors Part 8
  mwifiex: fix checkpatch --strict warnings/errors Part 9

 drivers/net/wireless/mwifiex/11n.c           |   22 +-
 drivers/net/wireless/mwifiex/11n.h           |    7 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      |   15 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   42 ++--
 drivers/net/wireless/mwifiex/cfg80211.c      |   90 +++---
 drivers/net/wireless/mwifiex/cfp.c           |    4 +-
 drivers/net/wireless/mwifiex/cmdevt.c        |  166 ++++++------
 drivers/net/wireless/mwifiex/fw.h            |    4 +-
 drivers/net/wireless/mwifiex/init.c          |   31 +--
 drivers/net/wireless/mwifiex/join.c          |  164 ++++++------
 drivers/net/wireless/mwifiex/main.c          |   49 ++--
 drivers/net/wireless/mwifiex/main.h          |    4 +-
 drivers/net/wireless/mwifiex/pcie.c          |  384 +++++++++++++------------
 drivers/net/wireless/mwifiex/scan.c          |  343 ++++++++++++------------
 drivers/net/wireless/mwifiex/sdio.c          |  188 +++++++------
 drivers/net/wireless/mwifiex/sta_cmd.c       |  175 ++++++------
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   60 ++--
 drivers/net/wireless/mwifiex/sta_event.c     |   41 ++--
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  102 ++++----
 drivers/net/wireless/mwifiex/sta_rx.c        |   12 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |   22 +-
 drivers/net/wireless/mwifiex/txrx.c          |   13 +-
 drivers/net/wireless/mwifiex/util.c          |   20 +-
 drivers/net/wireless/mwifiex/wmm.c           |  122 ++++----
 24 files changed, 1047 insertions(+), 1033 deletions(-)

