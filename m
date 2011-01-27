Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab1A0N4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 08:56:46 -0500
Subject: Re: [PATCH v2] mac80211:  Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D406396.2090407@candelatech.com>
References: <1295633142-7437-1-git-send-email-greearb@candelatech.com>
	 <1296056188.3635.36.camel@jlt3.sipsolutions.net>
	 <4D406396.2090407@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 14:56:45 +0100
Message-ID: <1296136605.3622.58.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 10:10 -0800, Ben Greear wrote:

> > However, I guess it'd also be nice to also address the TODO in work.c
> > and move the "don't do so much if not really off-channel" logic into
> > that function? You must run into that when trying to associate on one
> > vif and the others get stopped etc. unnecessarily to do that.
> 
> I think you are right about this, but due to the tricky nature
> of this code, maybe save that for a second patch?

Yeah, I think that might be good -- but maybe prepare in your current
version by not having the offchannel bit in the scan?

In fact -- I'm not even sure why you have two off-channel bits there,
but please reply to my comments on v3 rather than here.

johannes

