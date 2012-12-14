Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab2LNTMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 14:12:18 -0500
Message-ID: <1355512358.9571.11.camel@jlt4.sipsolutions.net> (sfid-20121214_201220_368846_BBFD2EF2)
Subject: Re: RSSI threshold events?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 14 Dec 2012 20:12:38 +0100
In-Reply-To: <50CB66D5.6070900@candelatech.com> (sfid-20121214_185024_393287_1E46F699)
References: <50CB66D5.6070900@candelatech.com>
	 (sfid-20121214_185024_393287_1E46F699)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 09:50 -0800, Ben Greear wrote:
> I'm seeing lots of these events in the 3.7.0+ kernel (and in 3.5 as well).
> 
> I *should* be connected to good APs that are only a few feet away.
> 
> Either way, maybe we should report the threshold and actual value
> that caused the event to make it easier to figure out what the
> problem is?

Are you saying you're seeing these events without even having configured
them? They should only happen if you configured a CQM RSSI threshold
(and hysteresis) so you should pretty much know what's going on?

johannes

