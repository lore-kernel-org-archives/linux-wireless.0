Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbYHGTyC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 15:54:02 -0400
Subject: Re: [RFC] cfg80211: keep track of supported interface modes
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1218138465.3630.60.camel@johannes.berg>
References: <1218122495.3630.2.camel@johannes.berg>
	 <1218132788.15728.15.camel@localhost.localdomain>
	 <1218138465.3630.60.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 15:55:37 -0400
Message-Id: <1218138937.32083.23.camel@localhost.localdomain> (sfid-20080807_215407_783505_BBE815ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-08-07 at 21:47 +0200, Johannes Berg wrote:
> On Thu, 2008-08-07 at 14:13 -0400, Dan Williams wrote:
> > On Thu, 2008-08-07 at 17:21 +0200, Johannes Berg wrote:
> > > It is obviously good for userspace to know up front which interface modes
> > > a given piece of hardware might support (even if adding such an interface
> > > might fail later because of concurrency issues), so let's make cfg80211
> > > aware of that. For good measure, disallow adding interfaces in all other
> > > modes so drivers don't forget to announce support for one mode when they
> > > add it.
> > 
> > This makes me happy.
> 
> We discussed this in Ottawa, didn't we? It just slipped my mind and I
> remembered earlier today.

Yep, we did.

Dan

> No somebody just needs to go through and add the corresponding hunks for
> all drivers. *hint* :) (it mostly consists in seeing what the
> add_interface callback will accept, which is correct for all drivers but
> iwlwifi as far as I know)
> 
> johannes

