Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965008Ab2LFKtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 05:49:50 -0500
Message-ID: <1354791010.10150.1.camel@jlt4.sipsolutions.net> (sfid-20121206_114954_177797_3BFBA9CD)
Subject: Re: [PATCH] {nl, cfg, mac}80211: set beacon interval and DTIM
 period on mesh join
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Date: Thu, 06 Dec 2012 11:50:10 +0100
In-Reply-To: <CAG6hwVOc=E67ZxuFZnk3goM8VVEOqSWOi6dn63L2rmEyWOfG1g@mail.gmail.com> (sfid-20121205_235803_339880_D4FADE0C)
References: <1354745174-2941-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <CAG6hwVOc=E67ZxuFZnk3goM8VVEOqSWOi6dn63L2rmEyWOfG1g@mail.gmail.com>
	 (sfid-20121205_235803_339880_D4FADE0C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 14:57 -0800, Thomas Pedersen wrote:
> On Wed, Dec 5, 2012 at 2:06 PM, Marco Porsch
> <marco.porsch@etit.tu-chemnitz.de> wrote:
> > Move the default mesh beacon interval and DTIM period to cfg80211 and
> > make it accessible to nl80211. This enables setting both values when joining
> > an MBSS.
> >
> > NOTE: In a mesh with links in PS mode it is not advised to use the default
> > parameters 1000:4, as these cause excessive buffering delays that exceed
> > various timeouts (e.g. HWMP path request).
> 
> Then make the default parameters reasonable? How is 1000:2?

That's still ~2 seconds, no?

johannes

