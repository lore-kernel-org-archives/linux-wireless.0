Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:39507 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab0EXIPK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:15:10 -0400
Date: Mon, 24 May 2010 11:14:55 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Silence debug prints when using adhoc mode
Message-ID: <20100524081455.GB19669@nalle>
References: <20100523162240.GZ19669@nalle> <1274688345.3743.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1274688345.3743.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 24, 2010 at 10:05:45AM +0200, Johannes Berg wrote:
> On Sun, 2010-05-23 at 19:22 +0300, Mikko Rapeli wrote:
> > This is flooded to syslog quite a few times when connecting to another
> > Linux box in adhoc mode. Syslog files fill up the disk fast:
> > 
> > $ dmesg | tail -10
> > [ 1986.772018] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > [ 1986.776149] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > [ 1986.780076] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > [ 1986.784020] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > [ 1986.788149] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > [ 1986.792108] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > [ 1986.796070] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > [ 1986.800018] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > [ 1986.804186] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> > [ 1986.808072] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> 
> Hm. That's not supposed to happen over and over again that quickly, only
> every few seconds. I wonder if that's related to the other timer issue
> that we saw in ibss.

I've had this spamming problem since December 2009 with all 2.6.32 kernels
from Debian unstable, so this not something new from 2.6.34.

-Mikko
