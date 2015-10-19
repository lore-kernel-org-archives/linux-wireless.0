Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8243 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbJSJ02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 05:26:28 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 0/6] WILC1000 rebase and resend some of patch series
Date: Mon, 19 Oct 2015 18:26:07 +0900
Message-ID: <1445246773-22253-1-git-send-email-tony.cho@atmel.com> (sfid-20151019_112631_789816_1822DA98)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches are resent after some of 40 patches are rebased.

Leo Kim (6):
  staging: wilc1000: rename variable s32Error
  staging: wilc1000: move variable clients_count
  staging: wilc1000: move variable FALSE_FRMWR_CHANNEL
  staging: wilc1000: fixes unnecessary variable replacement
  staging: wilc1000: fixes alignment should match open parenthesis
  staging: wilc1000: fixes comparison to NULL could be written

 drivers/staging/wilc1000/host_interface.c | 1116 ++++++++++++++---------------
 1 file changed, 530 insertions(+), 586 deletions(-)

-- 
1.9.1

