Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3785 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbbIQIr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 04:47:26 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 0/2] resend version 2 for RX_BH_TYPE patch
Date: Thu, 17 Sep 2015 17:47:23 +0900
Message-ID: <1442479645-10656-1-git-send-email-tony.cho@atmel.com> (sfid-20150917_104732_105094_07F9ABBA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patch is the version 2 for the RX_BH_TYPE patch before sent.

Glen Lee (2):
  staging: wilc1000: remove define RX_BH_TYPE
  staging: wilc1000: remove do-nothing ifdef statement

 drivers/staging/wilc1000/linux_wlan.c         | 149 +-------------------------
 drivers/staging/wilc1000/linux_wlan_common.h  |   3 -
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  15 ---
 drivers/staging/wilc1000/wilc_wlan.c          |   3 -
 4 files changed, 2 insertions(+), 168 deletions(-)

-- 
1.9.1

