Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:39746 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754798AbYAYVlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 16:41:55 -0500
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: Linux 2.6.24-rc7
Date: Fri, 25 Jan 2008 13:28:35 -0800
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801251311.45392.inaky@linux.intel.com> <200801252221.07558.mb@bu3sch.de>
In-Reply-To: <200801252221.07558.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801251328.35985.inaky@linux.intel.com> (sfid-20080125_214159_276802_B984DF1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008, Michael Buesch wrote:
> On Friday 25 January 2008 22:11:44 Inaky Perez-Gonzalez wrote:
> > On Friday 25 January 2008, Michael Buesch wrote:
> > > On Friday 25 January 2008 19:34:46 Linus Torvalds wrote:
> > > > My attitude is: CPU's that do unaligned accesses right are the *good* 
> > > > CPU's. We should encourage them, and put the onus of being crap on the 
> > > > ones that are crap, rather than penalizing the ones that aren't.
> > > 
> > > I absolutely agree. But as this can get fixed with _no_ performance loss
> > > at all inside of the firmware (and who if not intel can change stuff
> > > in their firmware?), I think this warning is in fact valid.
> > 
> > Well, you forgot the point that maybe it is not that simple to get such
> > a seemingly simple change into the firmware for a long list of reasons.
> 
> The reasons being?

For example: want to ship new firmware, drivers *and* full validation and
certification for a product that is already completed just to satisfy a 
fraction of a market which is not part of the designed target?

Do you know how much money that costs?

I'll be happy to eat my words without any ketchup and mustard if it happens,
btw, but I don't think it will [and I am speaking for myself, not for Intel,
when saying this].

