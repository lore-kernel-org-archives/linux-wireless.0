Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYG1PQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 11:16:19 -0400
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217257628.15381.2.camel@johannes.berg>
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <200807281544.33509.mb@bu3sch.de> <1217253397.6364.2.camel@localhost>
	 <200807281600.39103.mb@bu3sch.de>
	 <1217257174.28198.27.camel@localhost.localdomain>
	 <1217257628.15381.2.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 11:14:00 -0400
Message-Id: <1217258040.28198.40.camel@localhost.localdomain> (sfid-20080728_171622_494191_B993B77A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-28 at 17:07 +0200, Johannes Berg wrote:
> On Mon, 2008-07-28 at 10:59 -0400, Dan Williams wrote:
> 
> > > If that's really a problem, yes. 01:00:00:00:00:00 is still better
> > > than a pseudo random MAC, IMO. It's immediately obvious to the user
> > > that the MAC currently is not set.
> > 
> > How about 44:44:44:44:44:44 like orinoco uses for bogus BSSID?  If we
> > can, let's not keep creating yet more bogus MAC addresses.
> 
> Either way, the problem is that these will confuse udev if you have two
> at the same time, no?

the udev script I attached from Fedora 9 already ignores devices with
00:00:00::: so I don't think we'd have a problem with that.  Screw the
Xerox thing, all zeros is just bogus and tons of stuff treats it that
way already.

Dan


