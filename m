Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:48616 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYGJTiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 15:38:52 -0400
Date: Thu, 10 Jul 2008 15:38:48 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Sam Leffler <sam@errno.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] Add new regulatory framework for Linux wireless
Message-ID: <20080710193848.GM17936@ruslug.rutgers.edu> (sfid-20080710_213855_757392_54CCFBA9)
References: <20080710152415.GK17936@ruslug.rutgers.edu> <4876304E.9070508@errno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4876304E.9070508@errno.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2008 at 08:52:46AM -0700, Sam Leffler wrote:
> Luis R. Rodriguez wrote:
> >The industry currently has different techniques for parsing and using
> >Country IEs. What I currently propose is to take the common denominator
> >between what the AP provides, what CRDA has and what the driver can
> >provide privately through its callback. So the wireless core can keep
> >as the common denominator between the AP's Country IE and what CRDA
> >has for the alpha2 provided by the Country IE. Drivers themselves can
> >further enhance regulatory enforcement by relying on private driver
> >data if they wish so.
> >
> >  
> Can you elaborate on the first sentence?  Are you just saying that some 
> software blindly trusts the contents of the country IE and doesn't 
> constrain it's use (as you describe)?  Or are you saying drivers 
> interpret the contents of the country IE in ways different than spec'd?

I'm saying drivers and software stacks used tend to vary on how they
use the country IE. I believe most vendor drivers *never* simply
use what the AP provides due to considerations about "rogue" APs.
I can see why too though -- but it just means the spec didn't
account for these considerations. Hence my suggestion.

  Luis
