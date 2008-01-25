Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41236 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbYAYVWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 16:22:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Subject: Re: Linux 2.6.24-rc7
Date: Fri, 25 Jan 2008 22:21:07 +0100
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801251941.25310.mb@bu3sch.de> <200801251311.45392.inaky@linux.intel.com>
In-Reply-To: <200801251311.45392.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801252221.07558.mb@bu3sch.de> (sfid-20080125_212247_424393_1B622373)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008 22:11:44 Inaky Perez-Gonzalez wrote:
> On Friday 25 January 2008, Michael Buesch wrote:
> > On Friday 25 January 2008 19:34:46 Linus Torvalds wrote:
> > > My attitude is: CPU's that do unaligned accesses right are the *good* 
> > > CPU's. We should encourage them, and put the onus of being crap on the 
> > > ones that are crap, rather than penalizing the ones that aren't.
> > 
> > I absolutely agree. But as this can get fixed with _no_ performance loss
> > at all inside of the firmware (and who if not intel can change stuff
> > in their firmware?), I think this warning is in fact valid.
> 
> Well, you forgot the point that maybe it is not that simple to get such
> a seemingly simple change into the firmware for a long list of reasons.

The reasons being?

-- 
Greetings Michael.
