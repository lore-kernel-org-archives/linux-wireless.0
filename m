Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eastrmmtao103.cox.net ([68.230.240.9]:61550 "EHLO
	eastrmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab0HXWrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 18:47:17 -0400
Subject: Re: iwlagn fails to associate on 2.6.36-rc2
From: lance lassetter <lance@lass205.info>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 17:47:15 -0500
Message-ID: <1282690035.5180.16.camel@lass205.info>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Mon, 2010-08-23 at 20:03 -0500, lance lassetter wrote:
> 
> > Don't know if this is related but upon resume of a tuxonice kernel from
> > hibernation wireless is deauthenticated.  The router software runs 2.4
> > linux kernel.   The dmesg output is:
> > 
> > [ 3372.060428] wlan0: deauthenticated from 68:7f:74:26:dd:2e (Reason: 7)
> > [ 3372.065039] cfg80211: All devices are disconnected, going to restore
> > regulatory settings
> > [ 3372.065043] cfg80211: Restoring regulatory settings
> > [ 3372.065047] cfg80211: Calling CRDA to update world regulatory domain
> 
> That's unrelated, and perfectly normal.
> 
> johannes

Johannes,

Hi,

I have a few questions:

First is why this didn't happen with kernel 2.6.30?  Connection was automatically up upon thaw being complete.

Second is how to restore wireless connectivity upon resume from hibernation without having to manually restart the network?

Lance
