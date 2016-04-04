Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56503 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbcDDXUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 19:20:20 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3]  ath10k: add a support of set_tsf on vdev interface
Date: Mon, 4 Apr 2016 16:19:13 -0700
Message-ID: <1459811956-26186-1-git-send-email-poh@qca.qualcomm.com> (sfid-20160405_012028_104071_A184C47A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.2.4 and 10.4 firmware has introduced new function to
set TSF via vdev parameter.
set_tsf function can be used to shift TBTT that will help
avoid its clockdrift which happens when beacons are collided.

Peter Oh (3):
  ath10k: add a support of set_tsf on vdev interface
  ath10k: update 10.4 WMI vdev parameters
  ath10k: enable set_tsf vdev command to WMI 10.4

 drivers/net/wireless/ath/ath10k/mac.c     | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c     |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  8 ++++++++
 4 files changed, 40 insertions(+)

-- 
1.9.1

