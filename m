Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:41293 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbYARAfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 19:35:15 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1386782wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2008 16:35:15 -0800 (PST)
Message-ID: <1ba2fa240801171635t50f3f267o6f7ba5e4dc31cf48@mail.gmail.com> (sfid-20080118_003524_652627_2477094C)
Date: Fri, 18 Jan 2008 02:35:15 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: led support in mac80211 and drivers
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Tomas Carnecky" <tom@dbservice.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200801172313.00246.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <478DF297.9020904@dbservice.com>
	 <20080116200126.GA3164@tuxdriver.com>
	 <1200584782.8007.59.camel@johannes.berg>
	 <200801172313.00246.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 18, 2008 12:12 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Thursday 17 January 2008 16:46:22 Johannes Berg wrote:
> > > > > > Actually the major problem I have currently with mac80211 trigger
> > > > > > implementation RX/TX trigger since Intel's led doesn't have to be
> > > > > > triggered ON/OFF on each packet, led is capable of blinking itself.,
> >
> > I'm wondering if this shouldn't simply be a driver decision and mac80211
> > exports an RXon LED that is always "on" for as long as receive is
> > running (whatever that means, please specify!)
>
> I read this thread multiple times, but I don't get where the problem is.
> Why don't you simply implement this in the driver:
> When LED didn't change software state for X jiffies, switch the auto-blinking
> LED in the hardware off. Switch it on if it's off in hardware and there's
> a software state transition.
> Where's the problem? This is trivial to implement.

Sure it's simple, even there are few implementations already in the
mailing list.. just still missing the flexibility I seek.
Tomas
