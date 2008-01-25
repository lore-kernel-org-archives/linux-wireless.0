Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755056AbYAYV4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 16:56:40 -0500
Date: Fri, 25 Jan 2008 13:54:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <200801252221.07558.mb@bu3sch.de>
Message-ID: <alpine.LFD.1.00.0801251350090.5056@hp.linux-foundation.org> (sfid-20080125_215647_625021_E5938D4D)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801251941.25310.mb@bu3sch.de> <200801251311.45392.inaky@linux.intel.com> <200801252221.07558.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 25 Jan 2008, Michael Buesch wrote:
> > Well, you forgot the point that maybe it is not that simple to get such
> > a seemingly simple change into the firmware for a long list of reasons.
> 
> The reasons being?

.. the reason being that people just expect existing firmware to work, for 
example.

The point being, even if a newer firmware was _available_, people wouldn't 
necessarily run with it.

We do *not* accept "upgrade the BIOS" as an answer to broken BIOSes 
either. We work around BIOS limitations.

There can easily be other issues too. The DMA engine literally might only 
do word-aligned transfers. Or other operating systems have different rules 
from Linux, and the firmware is designed for those other systems.

Realistically, if it works with Windows, and I was a hardware team, and 
the Linux people were whining about it, I'd feel perfectly fine in saying 
"you're the buggy ones, we work fine".

So no, whining about hardware or firmware features isn't really very 
productive. You take what you get.

				Linus
