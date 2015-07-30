Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:57993 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbbG3JKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 05:10:32 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 0/5] 2nd patch for illegal coding style
Date: Thu, 30 Jul 2015 18:10:09 +0900
Message-ID: <1438247414-19708-1-git-send-email-tony.cho@atmel.com> (sfid-20150730_111038_627639_87DBD8B3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch V2 includes only patches rejected. The rejected patch for the
following, #ifdef conditionals cover entire functions, introduced new error on
required space before the open parenthesis '('. This is my mistake while
rewriting codes.

The original 13th patch didn't include new fix introduced on the previous patch
due to no sync-up issue. The original 13th patch fixed the same warnings but
in different place. 

The 64bit compile warnings will be resolved after sending these patches. Then,
ambiguous sdio/spi parts including preprocessor conditionals will be tried.

Tony Cho (5):
  staging: wilc1000: #ifdef conditionals cover entire functions
  staging: wilc1000: remove unnecessary blank lines
  staging: wilc1000: remove warnings on missing blank line
  staging: wilc1000: remove errors on required space
  staging: wilc1000: remove unused functions

 drivers/staging/wilc1000/wilc_sdio.c | 518 +++++++++++++++++++----------------
 drivers/staging/wilc1000/wilc_wlan.c |   1 -
 2 files changed, 283 insertions(+), 236 deletions(-)

-- 
1.9.1

