Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20962 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbbIUDRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:17:15 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 00/34] resending v2 for the patches of removing typedef
Date: Mon, 21 Sep 2015 12:16:29 +0900
Message-ID: <1442805423-3711-1-git-send-email-tony.cho@atmel.com> (sfid-20150921_051736_159075_F583D518)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the version 2 for the series of the patch that mostly removes the       
typedef from the structures and renames its names to comply with the Linux      
coding style.

The version 2 is rebased again onto the staging-testing branch to synchronize
with the mainstream.

Tony Cho (34):
  staging: wilc1000: rename tstrHostIFmsg
  staging: wilc1000: remove typedef from the struct
  staging: wilc1000: rename strHostIFmsg
  staging: wilc1000: rename u16MsgId
  staging: wilc1000 remove typedef from the union
  staging: wilc1000: rename uniHostIFmsgBody
  staging: wilc1000: remove typedef from the struct tstrHostIFscanAttr
  staging: wilc1000: remove typedef from the struct
    tstrHostIFconnectAttr
  staging: wilc1000: remove typedef from the struct tstrRcvdNetworkInfo
  staging: wilc1000: remove typedef from the struct
    tstrRcvdGnrlAsyncInfo
  staging: wilc1000: remove typedef from the struct tstrHostIFkeyAttr
  staging: wilc1000: remove typedef from the struct
    tstrHostIFCfgParamAttr
  staging: wilc1000: remove typedef from the struct tstrHostIFSetChan
  staging: wilc1000: remove typedef from the struct tstrHostIFGetChan
  staging: wilc1000: remove typedef from the struct tstrHostIFSetBeacon
  staging: wilc1000: remove typedef from the struct tstrHostIFDelBeacon
  staging: wilc1000: remove typedef from the struct tstrWILC_AddStaParam
  staging: wilc1000: remove typedef from the struct tstrTimerCb
  staging: wilc1000: remove typedef from the struct
    tstrHostIfPowerMgmtParam
  staging: wilc1000: remove typedef from the struct
    tstrHostIfStaInactiveT
  staging: wilc1000: remove typedef from the struct tstrHostIFSetIPAddr
  staging: wilc1000: remove typedef from the struct
    tstrHostIfSetDrvHandler
  staging: wilc1000: remove typedef from the struct tstrHostIFSetMulti
  staging: wilc1000: remove typedef from the struct
    tstrHostIfSetOperationMode
  staging: wilc1000: remove typedef from the struct
    tstrHostIfSetMacAddress
  staging: wilc1000: remove typedef from the struct
    tstrHostIfGetMacAddress
  staging: wilc1000: remove typedef from the struct
    tstrHostIfBASessionInfo
  staging: wilc1000: remove typedef from the struct tstrHostIFDelSta
  staging: wilc1000: remove typedef from the struct
    tstrHostIfRemainOnChan
  staging: wilc1000: remove typedef from the struct
    tstrHostIfRegisterFrame
  staging: wilc1000: remove typedef from the struct tstrHostIFDelAllSta
  staging: wilc1000: remove unnecessary global variable
  staging: wilc1000: remove u32Intialized which is unnecessary
  staging: wilc1000: delete unnecessary comments and dead code

 drivers/staging/wilc1000/host_interface.c         | 1110 +++++++++++----------
 drivers/staging/wilc1000/host_interface.h         |   55 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |    4 +-
 3 files changed, 587 insertions(+), 582 deletions(-)

-- 
1.9.1

