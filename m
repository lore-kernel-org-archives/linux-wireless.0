Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36763 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412AbaJaFJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 01:09:10 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <huxm@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>, <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 0/2] mwifiex: ACS support for mwifiex AP
Date: Fri, 31 Oct 2014 16:08:25 +0530
Message-ID: <1414751907-4957-1-git-send-email-patila@marvell.com> (sfid-20141031_060918_416699_202D4A2E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds Automatic channel selection- ACS support for
mwifiex AP.

Avinash Patil (1):
  mwifiex: channel statistics support for mwifiex

Xinming Hu (1):
  mwifiex: add cfg80211 dump_survey handler

 drivers/net/wireless/mwifiex/cfg80211.c    | 66 ++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/decl.h        | 10 ++++
 drivers/net/wireless/mwifiex/fw.h          | 16 +++++++
 drivers/net/wireless/mwifiex/main.c        |  6 +++
 drivers/net/wireless/mwifiex/main.h        |  6 ++-
 drivers/net/wireless/mwifiex/scan.c        | 76 +++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  2 +-
 7 files changed, 179 insertions(+), 3 deletions(-)

-- 
1.8.1.4

