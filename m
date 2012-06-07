Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:47965 "HELO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751705Ab2FGEO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 00:14:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/3] mwifiex: improve "scan + tx" handling
Date: Wed,  6 Jun 2012 21:12:39 -0700
Message-Id: <1339042362-30317-1-git-send-email-bzhao@marvell.com> (sfid-20120607_061432_722541_F9A11038)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset reduces scan time and fixes tx delay issue while scanning.

---
Amitkumar Karwar (2):
  mwifiex: fix simultaneous scan and Tx traffic problem
  mwifiex: scan less channels per scan command to improve Tx traffic

Bing Zhao (1):
  mwifiex: shorten per channel scan time

 drivers/net/wireless/mwifiex/init.c |   65 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.c |    4 +-
 drivers/net/wireless/mwifiex/main.h |   11 ++++--
 drivers/net/wireless/mwifiex/scan.c |   59 +++++++++++++++++++++++--------
 4 files changed, 119 insertions(+), 20 deletions(-)

