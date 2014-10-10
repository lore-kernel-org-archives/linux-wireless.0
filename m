Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35382 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbaJJPLd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 11:11:33 -0400
Message-ID: <1412953891.3206.4.camel@jlt4.sipsolutions.net> (sfid-20141010_171138_740583_F3AC9EA2)
Subject: Re: [PATCH] cfg80211: set the rates mask in connection probes over
 specified freq
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Fri, 10 Oct 2014 17:11:31 +0200
In-Reply-To: <1412953834.3206.3.camel@jlt4.sipsolutions.net> (sfid-20141010_171040_727045_E76386DE)
References: <1412674938-13071-1-git-send-email-karl.beldan@gmail.com>
	 <1412847177.1828.33.camel@jlt4.sipsolutions.net>
	 <20141009130035.GB20644@magnum.frso.rivierawaves.com>
	 <1412861162.1828.45.camel@jlt4.sipsolutions.net>
	 <20141009162616.GA27065@magnum.frso.rivierawaves.com>
	 <1412879793.1828.61.camel@jlt4.sipsolutions.net>
	 <20141009204912.GB19745@gobelin>
	 (sfid-20141009_224917_787775_122952DC) <1412953834.3206.3.camel@jlt4.sipsolutions.net>
	 (sfid-20141010_171040_727045_E76386DE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-10 at 17:10 +0200, Johannes Berg wrote:
> On Thu, 2014-10-09 at 22:49 +0200, Karl Beldan wrote:
> 
> > > Either way - is it worth for 3.18/stable?
> > > 
> > Your call.
> 
> I've seen no complaints, and you haven't indicated that you'd like to
> see it in older kernels, so I've applied it to mac80211-next.

With a memory leak fix :)

johannes

