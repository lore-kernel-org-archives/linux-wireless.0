Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:32476 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbbIQKCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 06:02:22 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 0/4] v2 of the series including the null check routin
Date: Thu, 17 Sep 2015 19:02:16 +0900
Message-ID: <1442484140-13485-1-git-send-email-tony.cho@atmel.com> (sfid-20150917_120227_728554_18403FC0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous series of 4 patches include a commit message ambiguous and
not enough to explain why the patch is made and needed. So, this version 2
includes the modification on the commit message of the patch for a null check
fix.

Leo Kim (4):
  staging: wilc1000: fix null check routine
  staging: wilc1000: remove warnings on the multiple blank lines uses
  staging: wilc1000: remove warnings line over 80 characters
  staging: wilc1000: wilc_wlan_if.h align defines

 drivers/staging/wilc1000/host_interface.c |    4 +-
 drivers/staging/wilc1000/wilc_wlan_if.h   | 1324 +++++++++++++++--------------
 2 files changed, 708 insertions(+), 620 deletions(-)

-- 
1.9.1

