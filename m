Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3296 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbXFKSyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 14:54:38 -0400
Date: Mon, 11 Jun 2007 14:43:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Message-ID: <20070611184327.GE10397@tuxdriver.com>
References: <4668c71b.E0vXnFMnxxm8I5gE%Larry.Finger@lwfinger.net> <200706072038.36708.flamingice@sourmilk.net> <20070611173112.GC10397@tuxdriver.com> <200706111111.11547.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200706111111.11547.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 11, 2007 at 11:11:07AM -0700, Michael Wu wrote:
> On Monday 11 June 2007 10:31, John W. Linville wrote:
> > How about "I think you forgot some curly braces"?  Until Johannes
> > posted his patch (which you could have done just as easily) I had no
> > idea what you were talking about here...
> >
> Well, I did end up explaining it later after it was obvious that Larry Finger 
> didn't understand what I mean.

Nothing says it like a patch...

> As for posting a patch to fix it? I figured Larry Finger would post a fixed 
> patch after I explained the comment. I didn't think you were going to merge 
> it.

I put it in wireless-dev -- I might ask to be forgiven, if I thought
that was a problem.

Are you satisfied with that patch as it stands now (i.e. w/ the
proper braces)?  Or do you want to peck at it some more?

John
-- 
John W. Linville
linville@tuxdriver.com
