Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51754 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbbIKDET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 23:04:19 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 0/2] resending v2 of the patch for coreconfigurator.c file
Date: Fri, 11 Sep 2015 12:04:18 +0900
Message-ID: <1441940660-5925-1-git-send-email-tony.cho@atmel.com> (sfid-20150911_050423_816562_F8772AAB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the version 2 for the series of the patch which removes unused
functions from the coreconfigurator.c file. Some of functions was not included
in the first patch.

Glen Lee (2):
  staging: wilc1000: remove unused enum
  staging: wilc1000: coreconfigurator.c: remove unused functions

 drivers/staging/wilc1000/coreconfigurator.c | 1059 ---------------------------
 1 file changed, 1059 deletions(-)

-- 
1.9.1

