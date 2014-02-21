Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53334 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbaBUO7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 09:59:21 -0500
Message-ID: <1392994755.10179.30.camel@porter.coelho.fi> (sfid-20140221_155935_946394_046A8841)
Subject: Re: [PATCH 1/2] cfg80211: docbook: fix small formatting error
From: Luca Coelho <luca@coelho.fi>
To: Jones Desougi <jones.desougi@27m.se>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Fri, 21 Feb 2014 16:59:15 +0200
In-Reply-To: <530767DE.4070501@27m.se>
References: <1392907534-14470-1-git-send-email-luca@coelho.fi>
	 <1392971037.4346.16.camel@jlt4.sipsolutions.net> <530767DE.4070501@27m.se>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-21 at 15:51 +0100, Jones Desougi wrote:
> On 02/21/2014 09:23 AM, Johannes Berg wrote:
> > On Thu, 2014-02-20 at 16:45 +0200, Luciano Coelho wrote:
> >> From: Luciano Coelho <luciano.coelho@intel.com>
> >>
> >> docbook (or one of its friends) gets confused with semi-colons in the
> >> argument descriptions, causing it to think that the semi-colon is
> >> marking a new section in the description of addr_mask in wiphy struct.
> >>
> >> Prevent this by using hyphens instead of semi-colons in the mask
> >> example.
> > 
> > Applied, thanks.
> 
> Well, the changelog says that semi-colons are a problem while the patch
> actually replaces colons. Fishy. :)

Heh! Yeah, my mistake.  I probably already had a beer in my hand when I
wrote the commit message since it was a Monday evening.  Oh wait..! ;)

--
Cheers,
Luca.

