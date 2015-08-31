Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47294 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbbHaRxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 13:53:10 -0400
From: Kuei Hao Liu <alanliu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath10k-devel@qca.qualcomm.com>,
	<ath10k-tieto.external@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3] *** Add wmi-tlv support in test mode ***
Date: Mon, 31 Aug 2015 10:53:02 -0700
Message-ID: <1441043583-2908-1-git-send-email-alanliu@qca.qualcomm.com> (sfid-20150831_195313_446311_7CBB10FB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*** BLURB HERE ***

alanliu (1):
  Add wmi-tlv support in test mode

 drivers/net/wireless/ath/ath10k/core.c     |   4 +-
 drivers/net/wireless/ath/ath10k/core.h     |   5 +-
 drivers/net/wireless/ath/ath10k/testmode.c | 123 ++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c  |  15 +++-
 4 files changed, 131 insertions(+), 16 deletions(-)

-- 
1.9.1

