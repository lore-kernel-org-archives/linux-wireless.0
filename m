Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:40330 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYLPS31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 13:29:27 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Memory errors from p54usb
Date: Tue, 16 Dec 2008 19:29:28 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <49466F56.6060805@lwfinger.net> <200812161813.31227.chunkeey@web.de> <4947EA70.3090400@lwfinger.net>
In-Reply-To: <4947EA70.3090400@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812161929.28796.chunkeey@web.de> (sfid-20081216_192937_020672_6D98841A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 December 2008 18:50:40 Larry Finger wrote:
> Christian Lamparter wrote:
> > On Tuesday 16 December 2008 17:55:22 Larry Finger wrote:
> >> It is in station mode. I don't know how to get the radio_enabled flag.
> >>> do you see anything else than probe request?
> >> just probes.
> > does the AP answer the probe requests?
> 
> My AP didn't respond to any of them, but my neighbor's AP did to one of them.
> That was on channel 6; whereas my AP is on channel 1.
> 
> > Is this with WPA-PSK TKIP on? what happens if you disable the
> > hardware crypto offload stuff (e.g p54common nohwcrypt=1 )
> 
> Yes, WPA-PSK TKIP was on. Same thing happens with hardware crypto disabled.
> 
> This time I discovered that ifdown/ifup restores the connection as well as
> module unload/load.
> 
well, a first it sounds like TKIP countermeasures...
but since you said it also happens even if you disable the hardware
crytographic offload... I'm a bit "out of clues".

Do you still have kismets captured pcaps?

Regards,
	Chr
