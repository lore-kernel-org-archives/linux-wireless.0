Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5554 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbbIPBn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 21:43:56 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 00/10] resend all of wilc1000 patches
Date: Wed, 16 Sep 2015 10:43:45 +0900
Message-ID: <1442367835-30733-1-git-send-email-tony.cho@atmel.com> (sfid-20150916_034400_464567_E449F496)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches are being resent becasue it seems that we are out of
sync with Greg. In this series, I squashed two commits seperately issued for
removing variable, g_num_total_switches which is not used anymore to avoid
more confusions.

Glen Lee (9):
  staging: wilc1000: remove useless define PHY_802_11n
  staging: wilc1000: remove unnecessary define FIVE_GHZ_BAND
  staging: wilc1000: remove unused defines
  staging: wilc1000: remove unnecessary extern function declaration
  staging: wilc1000: delete unused global variables.
  staging: wilc1000: remove unused variables
  staging: wilc1000: delete function declaration SendRawPacket
  staging: wilc1000: coreconfigurator.h: remove unused defines
  staging: wilc1000: remove unused variable g_flushing_in_progress

Tony Cho (1):
  staging: wilc1000: remove PANDA_BOARD

 drivers/staging/wilc1000/coreconfigurator.c       | 165 ----------------------
 drivers/staging/wilc1000/coreconfigurator.h       |   6 -
 drivers/staging/wilc1000/linux_wlan.c             |   4 -
 drivers/staging/wilc1000/linux_wlan_common.h      |   3 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   1 -
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   4 -
 6 files changed, 183 deletions(-)

-- 
1.9.1

