Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub004-omc4s13.hotmail.com ([157.55.2.88]:51062 "EHLO
	DUB004-OMC4S13.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbbHCMvi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 08:51:38 -0400
Message-ID: <DUB128-W86768E99A8D613CB2A8E59C770@phx.gbl> (sfid-20150803_145141_582445_E941ECCB)
From: David Binderman <dcb314@hotmail.com>
To: "Larry.Finger@lwfinger.net" <larry.finger@lwfinger.net>,
	"chaoming_li@realsil.com.cn" <chaoming_li@realsil.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: linux-4.2-rc5/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:
 Bad test ?
Date: Mon, 3 Aug 2015 12:51:36 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

[linux-4.2-rc5/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:1542] -> [linux-4.2-rc5/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:1545]: (style) Mismatching assignment and comparison, comparison 'bt_pri==4294967295' is always false.

    bt_pri = bt_pri & 0x00ffffff;

   if (bt_tx == 0xffffffff && bt_pri == 0xffffffff &&

Six f in the first line, but eight in the second.

Would use of symbol constants help prevent this kind of problem occurring
in future ? 


Regards

David Binderman

 		 	   		  