Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51232 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809AbcCUUBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 16:01:17 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/2] wil6210 changes
Date: Mon, 21 Mar 2016 22:01:10 +0200
Message-Id: <1458590472-677-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160321_210121_612872_0D9B0E4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The below patches include a bug fix in debugfs and the ability to determine the interface name.

Lior David (2):
  wil6210: allow empty WMI commands in debugfs wmi_send
  wil6210: add module parameter for alternate interface name

 drivers/net/wireless/ath/wil6210/debugfs.c | 4 ++--
 drivers/net/wireless/ath/wil6210/netdev.c  | 8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

-- 
1.8.5.2

