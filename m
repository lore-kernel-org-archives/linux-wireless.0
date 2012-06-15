Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2FOIRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 04:17:39 -0400
Message-ID: <1339748255.4512.7.camel@jlt3.sipsolutions.net> (sfid-20120615_101745_291540_78B5ED03)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andre Heider <a.heider@gmail.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Fri, 15 Jun 2012 10:17:35 +0200
In-Reply-To: <4FDA97E5.3090208@lwfinger.net> (sfid-20120615_040326_000897_768A8A5E)
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	  <CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
	  <4FD22727.7000500@lwfinger.net>
	  <1339180580.5748.32.camel@jlt3.sipsolutions.net>
	  <1339180948.5748.35.camel@jlt3.sipsolutions.net>
	  <1339182289.5748.36.camel@jlt3.sipsolutions.net>
	  <1339576294.4519.17.camel@jlt3.sipsolutions.net>
	  <CAHsu+b9soGKgZmqWLU=-v0zOG0v_Arf8DFoCn1EQ7-86Mg_CdQ@mail.gmail.com>
	  <1339602402.4519.48.camel@jlt3.sipsolutions.net>
	  <20120613204230.474d1b6c@milhouse>
	  <CAHsu+b_ue7LknbwMCdYsK6pQ8XxwjCL8Ham3xLucaaXZab69-g@mail.gmail.com>
	  <1339691877.9786.0.camel@jlt3.sipsolutions.net>
	  <CAHsu+b9XNO5roFZNETAgs8_5OLymCaKNcTU1XUsc2fXBu+4kpg@mail.gmail.com>
	  <1339693777.9786.6.camel@jlt3.sipsolutions.net>
	  <1339694227.9786.7.camel@jlt3.sipsolutions.net>
	  <CAHsu+b85rvSsGBfJQFFjdMhrF=Ycw0+pxxjf=U=xA2Or2q9jXQ@mail.gmail.com>
	  (sfid-20120614_192302_952190_7ED159EF) <1339694837.9786.8.camel@jlt3.sipsolutions.net>
	 <4FDA97E5.3090208@lwfinger.net> (sfid-20120615_040326_000897_768A8A5E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-14 at 21:03 -0500, Larry Finger wrote:

> >>> http://p.sipsolutions.net/e45e57bbc9509e69.txt
> >>
> >> No oops during loading the fw or bringing the device up, but same
> >> crash as in the picture above ;)
> >
> > I guess I shouldn't be doing this right now ...
> >
> > Can't somebody else help me out? Rafal? Larry? Michael? I clearly don't
> > know this code well enough and you should be able to identify the intent
> > from the patch ...
> 
> I will give it a try. I was in the Canadian wilderness for 5 days fishing, which 
> is why I have not responded earlier.
> 
> The device does not fail on my hardware, but I can prepare things for Andre to test.

Thanks Larry! Hope you brought home some good catch :-)

johannes

