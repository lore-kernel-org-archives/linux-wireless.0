Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub004-omc4s30.hotmail.com ([157.55.2.105]:54270 "EHLO
	DUB004-OMC4S30.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934068AbbGHIlx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 04:41:53 -0400
Message-ID: <DUB128-W77C11FFEB09B442BD8C9229C910@phx.gbl> (sfid-20150708_104200_952625_3CC3E1B5)
From: David Binderman <dcb314@hotmail.com>
To: Larry Finger <larry.finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: linux-4.2-rc1/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c:2183: bad
 expression ?
Date: Wed, 8 Jul 2015 08:41:51 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

[linux-4.2-rc1/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c:2183]: (style) Expression '(X & 0xfc) == 0x3' is always false.

Source code is

   if ((bt_msr & 0xfc) == MSR_AP)

Regards

David Binderman

 		 	   		  