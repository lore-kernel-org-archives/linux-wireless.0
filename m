Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:65020 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0D0E1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 00:27:43 -0400
Subject: Re: [RFC PATCHv3 1/2] mac80211: Determine dynamic PS timeout based
 on ps-qos network latency
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1272285059.3619.31.camel@jlt3.sipsolutions.net>
References: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271409274-17162-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1271688177.23671.1.camel@jlt3.sipsolutions.net>
	 <1271740120.6205.5733.camel@wimaxnb.nmp.nokia.com>
	 <1271925939.3605.7.camel@jlt3.sipsolutions.net>
	 <1271926547.6205.8870.camel@wimaxnb.nmp.nokia.com>
	 <1271927257.3605.18.camel@jlt3.sipsolutions.net>
	 <1271928576.6205.8919.camel@wimaxnb.nmp.nokia.com>
	 <1272282845.3619.25.camel@jlt3.sipsolutions.net>
	 <1272283483.6205.10416.camel@wimaxnb.nmp.nokia.com>
	 <1272283911.3619.29.camel@jlt3.sipsolutions.net>
	 <1272284587.6205.10424.camel@wimaxnb.nmp.nokia.com>
	 <1272285059.3619.31.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 07:27:07 +0300
Message-ID: <1272342427.6205.10428.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, 2010-04-26 at 14:30 +0200, ext Johannes Berg wrote:
> On Mon, 2010-04-26 at 15:23 +0300, Juuso Oikarinen wrote:
> 
> > Heh, I could in turn say that you think too little about power
> > consumption :) This particular thing, dynamic ps timer, has a *huge*
> > effect on the total power consumption just because it's so frequent.
> 
> Heh :)
> 
> > I'm basically open for any means to tell cfg80211 that it should
> > sacrifice service quality in the name of saving as much power as it can
> > (apart from shutting the thing down :). Can you give me a hint on what
> > you would consider an acceptable way to do this?
> 
> Well personally I'm happy with this approach.
> 
> I just fear that at one point, somebody will tweak the algorithm, and
> you will have deeply ingrained assumptions about where the cutoff points
> are in your userland software, which will cause all kinds of grief.

Ok, I shall then propose this as a patch. I'm pretty sure there are
people out there, probably more innovative than I, who are having the
same thoughts about the dynamic ps as I, as linux is being more widely
used in handhelds. So I count on it that someone will tweak the
algorithm, and make it better.

-Juuso

> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


