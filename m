Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub004-omc2s6.hotmail.com ([157.55.1.145]:60592 "EHLO
	DUB004-OMC2S6.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbbAGKKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 05:10:14 -0500
Message-ID: <DUB128-W41FFA1D9F3B81C9695DB709C460@phx.gbl> (sfid-20150107_111020_191981_7640A52D)
From: David Binderman <dcb314@hotmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rtlwifi/rtl8192ee/phy.c: problem with ? : operator
Date: Wed, 7 Jan 2015 10:10:12 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

[linux-3.19-rc3/drivers/net/wireless/rtlwifi/rtl8192ee/phy.c:2420]: (style) Same expression in both branches of ternary operator.

Source code is

 pathon = is_patha_on ? 0x0fc01616 : 0x0fc01616;

Suggest code rework.

Regards

David Binderman

 		 	   		  