Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:49584 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbYKYDwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 22:52:19 -0500
Message-ID: <492B7671.8030408@lwfinger.net> (sfid-20081125_045222_615394_F50F609E)
Date: Mon, 24 Nov 2008 21:52:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT][RFC][PATCH] p54: utilize cryptographic accelerator
References: <200811242215.00475.chunkeey@web.de>
In-Reply-To: <200811242215.00475.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch allows p54 to utilize its WEP, TKIP and CCMP accelerator.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>

OK for WPA-PSK/TKIP.

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>



