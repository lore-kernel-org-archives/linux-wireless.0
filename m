Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub004-omc2s35.hotmail.com ([157.55.1.174]:60745 "EHLO
	DUB004-OMC2S35.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbbAGKHj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 05:07:39 -0500
Message-ID: <DUB128-W345D981A960C3908C59FE99C460@phx.gbl> (sfid-20150107_110744_021087_97EF480B)
From: David Binderman <dcb314@hotmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: brcm80211/brcmsmac/phy/phy_n.c: problem with ? : code
Date: Wed, 7 Jan 2015 10:07:37 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

[linux-3.19-rc3/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c:27027]: (style) Same expression in both branches of ternary operator.

Source code is

    desired_log2_pwr = (cal_type == 0) ? 13 : 13;

Suggest code rework.

Regards

David Binderman

 		 	   		  