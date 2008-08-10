Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:61648 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbYHJXEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 19:04:49 -0400
Message-ID: <489F7410.3000507@lwfinger.net> (sfid-20080811_010457_169017_30095167)
Date: Sun, 10 Aug 2008 18:04:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted
 from commit 741b4fbc44
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808082038.48840.chunkeey@web.de> <489EF8DE.5030801@lwfinger.net> <200808110027.59918.chunkeey@web.de>
In-Reply-To: <200808110027.59918.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> well, if you don't ping around with -s 1400 of course ;-).
> 
> On the other hand, it doesn't break anything (that wasn't broken before) and 
> if real helps, why not?
> 
> Acked-by: Christian Lamparter <chunkeey@web.de>

The packet size of 1408 problem is fixed here with an 'ifconfig wlan2 
mtu 1300' command. With it I can ping any length.

This patch is already in mainline as commit eda0c003d1ff14c9.

Larry



