Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2LONcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 08:32:25 -0500
Message-ID: <1355578368.11966.2.camel@jlt4.sipsolutions.net> (sfid-20121215_143235_960112_9515443B)
Subject: Re: RSSI threshold events?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 15 Dec 2012 14:32:48 +0100
In-Reply-To: <50CB7EC9.7080003@candelatech.com>
References: <50CB66D5.6070900@candelatech.com>
	  (sfid-20121214_185024_393287_1E46F699) <1355512358.9571.11.camel@jlt4.sipsolutions.net>
	 <50CB7EC9.7080003@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 11:32 -0800, Ben Greear wrote:
> On 12/14/2012 11:12 AM, Johannes Berg wrote:
> > On Fri, 2012-12-14 at 09:50 -0800, Ben Greear wrote:
> >> I'm seeing lots of these events in the 3.7.0+ kernel (and in 3.5 as well).
> >>
> >> I *should* be connected to good APs that are only a few feet away.
> >>
> >> Either way, maybe we should report the threshold and actual value
> >> that caused the event to make it easier to figure out what the
> >> problem is?
> >
> > Are you saying you're seeing these events without even having configured
> > them? They should only happen if you configured a CQM RSSI threshold
> > (and hysteresis) so you should pretty much know what's going on?
> 
> I did not configure anything on purpose, at least...is this something
> that would be configured through supplicant?

I suppose the supplicant might use it for roaming, but I have no idea
how/where/...

johannes

