Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0IXN61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 09:58:27 -0400
Subject: Re: Patch to get iw building on Fedora 8
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C9CAB62.2040607@candelatech.com>
References: <4C98DFB6.10902@candelatech.com>
	 <1285090085.12764.6.camel@jlt3.sipsolutions.net>
	 <4C9BDD2C.1090806@candelatech.com>
	 <1285320687.3699.8.camel@jlt3.sipsolutions.net>
	 <4C9CAB62.2040607@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 15:58:26 +0200
Message-ID: <1285336706.3699.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-24 at 06:45 -0700, Ben Greear wrote:
> On 09/24/2010 02:31 AM, Johannes Berg wrote:
> > On Thu, 2010-09-23 at 16:05 -0700, Ben Greear wrote:
> >> I notice that you added some code to try to get this working:
> >>
> >> #ifndef _ISOC99_SOURCE
> >> #define _ISOC99_SOURCE
> >> #endif
> >>
> >>
> >> However, it still will not build for me on Fedora 8.  In case I'm doing something
> >> else strange..were you able to build it on FC8 by any chance?
> >>
> >> I can easily carry the fix in my own tree, but thought
> >> you might want to know...
> >
> > No, I don't have FC8 anywhere ... Does it build for you with -std=c99?
> > But that gives me a lot of warnings due to a libnl header file bug
> > ("extern inline").
> 
> Any problem with just changing it to 'strtod' ?

I did that earlier today.

johannes

