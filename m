Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41773 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbYLTFx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:53:58 -0500
Message-ID: <494C8874.7010101@lwfinger.net> (sfid-20081220_065424_619062_3487E357)
Date: Fri, 19 Dec 2008 23:53:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] p54usb: fix random traffic stalls (LM87)
References: <200812200221.56534.chunkeey@web.de> <494C8705.2030407@lwfinger.net>
In-Reply-To: <494C8705.2030407@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> 
> When the connection failed, unloading the driver and reloading it yielded the lines
> 
> usb 1-5: (p54usb) reset failed! (-22)
> p54usb: probe of 1-5:1.0 failed with error -22

I think this problem was thermal. After the device sat on the shelf for 20
minutes, it worked fine. Maybe I need a better heat sink as well.

Larry
