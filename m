Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60340 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab1K2R4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 12:56:46 -0500
Subject: Re: [PATCH v3] iw: Support ht-capability overrides mask.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4ED51BF5.9010508@candelatech.com>
References: <1322505622-13446-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111128_194043_702798_6A11361F) <1322556714.4110.13.camel@jlt3.sipsolutions.net>
	 <4ED51BF5.9010508@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 18:56:43 +0100
Message-ID: <1322589403.4110.27.camel@jlt3.sipsolutions.net> (sfid-20111129_185649_686503_73A732F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-29 at 09:52 -0800, Ben Greear wrote:
> On 11/29/2011 12:51 AM, Johannes Berg wrote:
> > On Mon, 2011-11-28 at 10:40 -0800, greearb@candelatech.com wrote:
> >> From: Ben Greear<greearb@candelatech.com>
> >>
> >> Let user know which capabilities are supported.
> >
> > I applied this with a bunch of modifications, but I think you should
> > follow up and make it more complete. You're covering exactly and only
> > the case that you're working on right now, I don't think that's good
> > practice.
> 
> It looks to me like your change isn't going to compile on older
> systems (Fedora Core 8, for instance), because htole16 isn't
> defined there (no endian.h file).
> 
> That is why I hand-coded an equivalent method...

I assume you mean Fedora 8 (they dropped the Core after 6)? That was
released, uh, about 4 years ago. I don't think I care.

johannes

