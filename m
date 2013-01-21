Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:52937 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3AUI7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 03:59:33 -0500
Message-ID: <1358758714.6252.135.camel@cumari.coelho.fi> (sfid-20130121_095944_398787_9B7C5BBE)
Subject: Re: wl12xx: does not connect to WPA2-personal
From: Luciano Coelho <coelho@ti.com>
To: Ketan Kamat <Ketan_Kamat@persistent.co.in>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 21 Jan 2013 10:58:34 +0200
In-Reply-To: <125C46FB9265D3469829069CDC69BF445278B39E@HJ-MBX2.persistent.co.in>
References: <loom.20130120T094649-416@post.gmane.org>
	 <1358754973.6252.131.camel@cumari.coelho.fi>
	 <125C46FB9265D3469829069CDC69BF445278B39E@HJ-MBX2.persistent.co.in>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-21 at 08:42 +0000, Ketan Kamat wrote:
> Hi Luciano,
> 
> I applied some of the code commits that were done to wl12xx driver (http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=history;f=drivers/net/wireless;hb=HEAD;pg=20 ):
> 
> 2012-04-10  	Eyal Shapira 		wl12xx: increase scan timeout to 30s
> 2012-04-10	Eyal Shapira		wl12xx: adaptive sched scan dwell times
> 2012-04-10	Eyal Shapira		wl12xx: fix a memory leak of probereq template upon
> 2012-04-10	Eliad Peller		wl12xx: free ap keys only in ap mode
> 2012-04-10	Eyal Shapira		wl12xx: fix race between suspend/resume and recovery
> 2012-04-10	Victor Goldenshtein	wl12xx: fix station channel switch
> 2012-04-10	Eliad Peller		wl12xx: set do_join on BSS_CHANGED_ASSOC
> 
> After applying these changes, it got connected to WPA2-personal. Currently doing some more testing

This sounds quiet weird.  I don't think any of the patches you applied
have any influence in AES connections.  Are you sure you didn't change
anything else?

I just tried vanilla 3.4 and I didn't have problems connecting from my
wl127x chip to a wl18xx running hostapd with WPA2/AES.

--
Cheers,
Luca. 

