Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:23715 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbbHaRoU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 13:44:20 -0400
From: Kuei Hao Liu <alanliu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3] *** Add wmi-tlv support in test mode ***
Date: Mon, 31 Aug 2015 10:44:10 -0700
Message-ID: <1441043051-14107-1-git-send-email-alanliu@qca.qualcomm.com> (sfid-20150831_194423_824618_E220873A)
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

