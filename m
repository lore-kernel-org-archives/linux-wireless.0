Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:62579 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYLPRum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 12:50:42 -0500
Message-ID: <4947EA70.3090400@lwfinger.net> (sfid-20081216_185045_079701_6E86CA5D)
Date: Tue, 16 Dec 2008 11:50:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Memory errors from p54usb
References: <49466F56.6060805@lwfinger.net> <200812161431.17790.chunkeey@web.de> <4947DD7A.9060700@lwfinger.net> <200812161813.31227.chunkeey@web.de>
In-Reply-To: <200812161813.31227.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Tuesday 16 December 2008 17:55:22 Larry Finger wrote:
>> It is in station mode. I don't know how to get the radio_enabled flag.
>>> do you see anything else than probe request?
>> just probes.
> does the AP answer the probe requests?

My AP didn't respond to any of them, but my neighbor's AP did to one of them.
That was on channel 6; whereas my AP is on channel 1.

> Is this with WPA-PSK TKIP on? what happens if you disable the
> hardware crypto offload stuff (e.g p54common nohwcrypt=1 )

Yes, WPA-PSK TKIP was on. Same thing happens with hardware crypto disabled.

This time I discovered that ifdown/ifup restores the connection as well as
module unload/load.

Larry
