Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46175 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1CAFEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 00:04:14 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [RFC v2 0/2] hexdump dynamic debug
Date: Mon, 28 Feb 2011 21:06:54 -0800
Message-Id: <1298956016-30673-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds hexdump macros utilizing dynamic debug.

v2: rebase against linux-next.git tree and split into 2 patches

Bing Zhao (2):
  dynamic debug: add dynamic_hexdump_debug macro
  printk: add hexdump_debug macro

 include/linux/dynamic_debug.h |   22 ++++++++++++++++++++++
 include/linux/printk.h        |   14 ++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

