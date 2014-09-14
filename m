Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28761 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaINIOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 04:14:47 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH] wil6210 - fix compilation warnings
Date: Sun, 14 Sep 2014 11:14:09 +0300
Message-ID: <1410682450-5493-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140914_101453_398920_B98E3802)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is quick fix for the new warnings reported.
John, could you please squash it with original commit before it
goes up?

Vladimir Kondratiev (1):
  fixup! wil6210: fix usage of print_hex_dump_debug

 drivers/net/wireless/ath/wil6210/wil6210.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

-- 
1.9.1

