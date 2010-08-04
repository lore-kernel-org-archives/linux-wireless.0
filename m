Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50347 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0HDPXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 11:23:12 -0400
Subject: Re: iwlwifi connection problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <8762zq76p3.fsf@sycorax.lbl.gov>
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	 <1279917523.10769.1.camel@wwguy-huron>
	 <1280135867.3693.5.camel@jlt3.sipsolutions.net>
	 <87mxtd5xlq.fsf@sycorax.lbl.gov>
	 <1280212629.19098.0.camel@jlt3.sipsolutions.net>
	 <87bp9l6f4k.fsf@sycorax.lbl.gov>
	 <1280746705.3923.11.camel@jlt3.sipsolutions.net>
	 <878w4pvx5e.fsf@sycorax.lbl.gov>
	 <1280766201.24503.0.camel@jlt3.sipsolutions.net>
	 <87aap4z70b.fsf@sycorax.lbl.gov>
	 <1280817596.3874.0.camel@jlt3.sipsolutions.net>
	 <87mxt3n9xh.fsf@sycorax.lbl.gov>
	 <1280908365.3768.4.camel@jlt3.sipsolutions.net>
	 <87aap28m8v.fsf@sycorax.lbl.gov>
	 <1280934185.3768.8.camel@jlt3.sipsolutions.net>
	 <8739uu8lg2.fsf@sycorax.lbl.gov>
	 <1280934689.17718.3.camel@jlt3.sipsolutions.net>
	 <8762zq76p3.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 17:23:02 +0200
Message-ID: <1280935382.17718.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-04 at 08:12 -0700, Alex Romosan wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Wed, 2010-08-04 at 08:08 -0700, Alex Romosan wrote:
> >
> >> > Thanks. The down/up is fine, I'll be able to identify that in the
> >> > traces. Except the "working" trace looks like it only starts after you
> >> > connected already?
> >> 
> >> the driver connects automatically on boot, so, yes, it was after i was
> >> connected. i can bring down the interface and try again if you want.
> >
> > Yes, please do that.
> 
> http://caliban.lbl.gov/iwlwifi/trace.dat-working.before.ifup.gz

Thank you. I need to adjust my analysis tools because you're using 3945,
not sure if I can finish that today.

johannes

