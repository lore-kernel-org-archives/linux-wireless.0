Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbcFAScM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 14:32:12 -0400
Message-ID: <1464805919.4958.31.camel@redhat.com> (sfid-20160601_203216_220591_701EB4B5)
Subject: Re: Where to post Wireless Tools Patches
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 01 Jun 2016 13:31:59 -0500
In-Reply-To: <1464802721.3465.1.camel@sipsolutions.net>
References: <CACtQq=bixCDdZpSvj6W+SZKt5N6FSebfgPBjQcqePuj2aN8OAA@mail.gmail.com>
	 <1464801615.4958.6.camel@redhat.com>
	 (sfid-20160601_192032_001317_E1E532F3) <1464802721.3465.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-06-01 at 19:38 +0200, Johannes Berg wrote:
> On Wed, 2016-06-01 at 12:20 -0500, Dan Williams wrote:
> 
> > 
> > Assuming you mean the "wireless-tools" package, this list is OK.
> >  But
> > probably nobody will apply the patches, since wireless-tools and
> > the
> > WEXT API are long-since deprecated
> I don't think anyone even maintains the wireless-tools package any
> more. I don't know who would, anyway, since I haven't heard anything
> from Jean in many years.

I was surprised to run into Jean at the 2015 OVS Fall Conference last
November.  He's spent the last few years shepherding OpenFlow
specifications though formalization and hasn't done any work in
wireless for a long long time.  He also said he's extremely unlikely to
do any wireless stuff now or in the future :)  So yeah, wireless-tools
is unmaintained.

Dan
