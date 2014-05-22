Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43420 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbaEVG4w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 02:56:52 -0400
Message-ID: <1400741808.4174.5.camel@jlt4.sipsolutions.net> (sfid-20140522_085655_509364_423E9B78)
Subject: Re: [PATCHv2] nl80211: Provide TDLS link state
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Thu, 22 May 2014 08:56:48 +0200
In-Reply-To: <CAMcMvsh-zKuNgMSyo73VmsEUkM9YnhVtkg_Vigdter0QarJ6_g@mail.gmail.com> (sfid-20140521_221907_003160_C6CF738D)
References: <20140520203657.2C281E0300@pstew.mtv.corp.google.com>
	 <20140520223316.EFCF1E0007@pstew.mtv.corp.google.com>
	 <1400668890.4136.1.camel@jlt4.sipsolutions.net>
	 <CAMcMvsiGJrJFee_nuGC1L8tRuTJLZR3nikU+4F-Zo1mgNeuNjw@mail.gmail.com>
	 <1400702385.4136.18.camel@jlt4.sipsolutions.net>
	 <CAMcMvsh-zKuNgMSyo73VmsEUkM9YnhVtkg_Vigdter0QarJ6_g@mail.gmail.com>
	 (sfid-20140521_221907_003160_C6CF738D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-21 at 13:19 -0700, Paul Stewart wrote:

> > Is it really that bad to demand the firmware notify the host? It's not
> > like this is a very frequent event, and if querying is supported then
> > notification can't be all that much more difficult.
> 
> I think firmware vendors are coming to the point of view that they
> must minimize host processor wakeups.  They may argue from that
> perspective that the firmware should divulge such information only on
> request.

That's reasonable, but the request could also be "list all TDLS peers
please", right? Then you could still implement it very easily. It
doesn't have to be an event.

johannes

