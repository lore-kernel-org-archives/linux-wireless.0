Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:60053 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031128Ab2CPDwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 23:52:07 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/5] mwifiex: support CQM
Date: Thu, 15 Mar 2012 20:51:46 -0700
Message-Id: <1331869911-10624-1-git-send-email-bzhao@marvell.com> (sfid-20120316_045213_501964_E46425FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds CQM support in mwifiex driver.

Thanks,
Bing

--
Amitkumar Karwar (5):
  mwifiex: update signal strength in mBm units
  mwifiex: add cfg80211 dump_station handler
  mwifiex: remove redundant signal handling code
  mwifiex: support STATION_INFO_SIGNAL_AVG
  mwifiex: add set_cqm_rssi_config handler support

 drivers/net/wireless/mwifiex/cfg80211.c    |   81 +++++++++++++++++++----
 drivers/net/wireless/mwifiex/fw.h          |   17 +++++
 drivers/net/wireless/mwifiex/ioctl.h       |   49 ++++++--------
 drivers/net/wireless/mwifiex/main.h        |    6 +-
 drivers/net/wireless/mwifiex/scan.c        |    5 +-
 drivers/net/wireless/mwifiex/sta_cmd.c     |   98 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   80 ++++++++++++++---------
 drivers/net/wireless/mwifiex/sta_event.c   |   15 ++++-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   33 ---------
 9 files changed, 273 insertions(+), 111 deletions(-)

