Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab2FNSvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 14:51:10 -0400
Message-ID: <1339699864.9786.10.camel@jlt3.sipsolutions.net> (sfid-20120614_205114_216219_31F1CF6B)
Subject: Re: [PATCH] mac80211: add support for userspace to handle auth
 frames on adhoc ifaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Hawkins <hawkinsw@opentechinstitute.org>
Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	linux-wireless@vger.kernel.org
Date: Thu, 14 Jun 2012 20:51:04 +0200
In-Reply-To: <4FDA2CED.8090303@opentechinstitute.org>
References: <4FD8B5D4.8060305@opentechinstitute.org>
	    <4FD99A24.3020907@lri.fr>
	 <1339673095.4461.2.camel@jlt3.sipsolutions.net>   <4FD9DD35.4070709@lri.fr>
	 <1339692819.9786.4.camel@jlt3.sipsolutions.net>
	  <4FDA179F.1020501@opentechinstitute.org>
	 <1339693721.9786.5.camel@jlt3.sipsolutions.net>
	 <4FDA2CED.8090303@opentechinstitute.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >>> Oops, sorry, yes. I forgot all about that code!
> >>>
> >>> I suppose we'd have to check whether userspace is handling
> >>> authentication?
> >>
> >> Could use the control_port flag to check for that condition?
> > 
> > Not really, that's not necessarily the same thing -- I think we might
> > want to also allow to offload open auth to userspace.
> > 
> > I think it wouldn't be difficult to notify mac80211 about frame
> > registrations so it can keep track for this purpose?
> > 
> > johannes
> 
> I am happy to code something like this up. I've already taken a look at
> it and don't think it will be too big of a problem. I am going to be AFK
> until Monday so I won't get to it until then. I hope that's not a problem.

No problem, take your time! I'm not in any hurry with this feature :-)

johannes

