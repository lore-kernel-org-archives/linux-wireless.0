Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:48081 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932594Ab1ALNWR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 08:22:17 -0500
Subject: Re: [PATCH] mac80211: use maximum number of a-msdu frames as
 default in BA RX
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <1294837426.2097.32.camel@pimenta>
References: <1294836681-21712-1-git-send-email-coelho@ti.com>
	 <1294836844.3639.26.camel@jlt3.sipsolutions.net>
	 <1294837426.2097.32.camel@pimenta>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 15:21:23 +0200
Message-ID: <1294838483.2097.38.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 14:03 +0100, Coelho, Luciano wrote:
> On Wed, 2011-01-12 at 13:54 +0100, Johannes Berg wrote:
> > On Wed, 2011-01-12 at 14:51 +0200, coelho@ti.com wrote:
> > > From: Luciano Coelho <coelho@ti.com>
> > > 
> > > When the buffer size is set to zero in the block ack parameter set
> > > field, we should use the maximum supported number of subframes.  The
> > > existing code was bogus and was doing some unnecessary calculations
> > > that lead to wrong values.
> > > 
> > > Thanks Johannes for helping me figure this one out.
> > > 
> > > Cc: stable@kernel.org
> > > Cc: Johannes Berg <johannes@sipsolutions.net>
> > 
> > Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> > 
> > It'd be easier for stable if you reordered with the other patch, I
> > think, but I guess it's easy enough to fix up.
> 
> Will do.

Sent v2 rebased in a cleaner head and changed "a-msdu" to AMPDU in the
commit subject, as Johannes pointed out.


-- 
Cheers,
Luca.

