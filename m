Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13900 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXKVQTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 11:19:13 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Thu, 22 Nov 2007 17:19:40 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <200711221605.55506.hs4233@mail.mn-solutions.de> <1195746110.4149.23.camel@johannes.berg>
In-Reply-To: <1195746110.4149.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711221719.40412.hs4233@mail.mn-solutions.de> (sfid-20071122_161918_677250_CA22AD96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Face it or not, not everything in life is defined. Nowhere
> > is defined how bees behave, and yet they behave in uniform,
> > somewhat predicatable ways. So please stop this discussion
> > about defined or not defined. mac80211 behaves
> > out-of-the-order compared to older drivers. No matter if
> > this behavior was formally defined or not.
>
> It *does* matter because the only thing tools and people using
> the tools can rely on is what is defined rather than "happens
> to work with driver XY so it must be right"

So, things brings me to a weird conclusion:

a) earlier you said that in WEXT, the only command that is 
defined to get you an association is the "iwconfig XXX ap YYY" 
command.

b) you also say that tools should only rely on things that are 
defined

If I accept both sentences as valid, I must conclude that 
mac80211 is faulty. It happens that mac80211 triggers an 
association to an access-point also by the "iwconfig XXX essid 
YYYY" command. This is not defined. Hey, wait a minute. mac80211 
is not allowed to do ANYTHING that is undefined, because tools 
can only rely on defined things. So mac80211 is faulty. Crap, 
ditch it.

I hope you get that somehow this is not only weird, it's 
unhelpful. Maybe now you can understand why I see thinking in 
the lines of "only what has defined is right and everything else 
is wrong" isn't helpful at all.
