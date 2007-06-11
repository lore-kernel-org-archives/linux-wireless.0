Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3916 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbXFKRyg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 13:54:36 -0400
Date: Mon, 11 Jun 2007 13:31:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Message-ID: <20070611173112.GC10397@tuxdriver.com>
References: <4668c71b.E0vXnFMnxxm8I5gE%Larry.Finger@lwfinger.net> <200706072038.36708.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200706072038.36708.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 07, 2007 at 08:38:27PM -0700, Michael Wu wrote:
> On Thursday 07 June 2007 20:03, Larry Finger wrote:
> >  	for (i = 0; i < mode->num_rates; i++) {
> >  		if ((sta->supp_rates & BIT(i)) &&
> >  		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
> >  			sta->txrate = i;
> > +			break;
> >  	}
> Uh, what's the point of having a loop if you're gonna do that? ;)

How about "I think you forgot some curly braces"?  Until Johannes
posted his patch (which you could have done just as easily) I had no
idea what you were talking about here...

John
-- 
John W. Linville
linville@tuxdriver.com
