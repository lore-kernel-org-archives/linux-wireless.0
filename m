Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48695 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaJJQH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2014 12:07:29 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so4325658wgh.7
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2014 09:07:28 -0700 (PDT)
Date: Fri, 10 Oct 2014 18:07:18 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] cfg80211: set the rates mask in connection probes over
 specified freq
Message-ID: <20141010160718.GA12929@magnum.frso.rivierawaves.com> (sfid-20141010_180732_758176_A183B185)
References: <1412674938-13071-1-git-send-email-karl.beldan@gmail.com>
 <1412847177.1828.33.camel@jlt4.sipsolutions.net>
 <20141009130035.GB20644@magnum.frso.rivierawaves.com>
 <1412861162.1828.45.camel@jlt4.sipsolutions.net>
 <20141009162616.GA27065@magnum.frso.rivierawaves.com>
 <1412879793.1828.61.camel@jlt4.sipsolutions.net>
 <20141009204912.GB19745@gobelin>
 <1412953834.3206.3.camel@jlt4.sipsolutions.net>
 <1412953891.3206.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1412953891.3206.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2014 at 05:11:31PM +0200, Johannes Berg wrote:
> On Fri, 2014-10-10 at 17:10 +0200, Johannes Berg wrote:
> > On Thu, 2014-10-09 at 22:49 +0200, Karl Beldan wrote:
> > 
> > > > Either way - is it worth for 3.18/stable?
> > > > 
> > > Your call.
> > 
> > I've seen no complaints, and you haven't indicated that you'd like to
> > see it in older kernels, so I've applied it to mac80211-next.
> 
> With a memory leak fix :)
> 
Arf yes, thanks !
 
Karl
