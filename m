Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:10070 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936229Ab3DRLeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 07:34:12 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 0/4] wil6210 updates
Date: Thu, 18 Apr 2013 14:33:49 +0300
Message-ID: <1366284834-540-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130418_133416_254075_2749479D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Next set of patches that are tested and ready for release.
It is all about Tx/Rx path, main 2 patches are to use
cached copy of Rx/Tx descriptors instead of accessing
non-cacheable memory.

Vladimir Kondratiev (4):
  wil6210: Use cached copy of Rx descriptor
  wil6210: Tx init optimization
  wil6210: Use cached copy of Tx descriptor
  wil6210: more Rx descriptor accessor functions

 drivers/net/wireless/ath/wil6210/txrx.c |   29 +++++++++++++-----
 drivers/net/wireless/ath/wil6210/txrx.h |   49 ++++++++++++++++++++++++++-----
 2 files changed, 63 insertions(+), 15 deletions(-)

-- 
1.7.10.4

