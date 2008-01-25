Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289AbYAYRlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 12:41:08 -0500
Date: Fri, 25 Jan 2008 09:38:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dan Williams <dcbw@redhat.com>
cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <1201282027.3422.15.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org> (sfid-20080125_174113_021613_8821A1F7)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>  <1201264166.12870.16.camel@johannes.berg>  <alpine.LFD.1.00.0801250753240.14161@hp.linux-foundation.org>  <200801251723.58891.mb@bu3sch.de>  <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org>
 <1201282027.3422.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 25 Jan 2008, Dan Williams wrote:
> 
> Does Intel need to make iwlwifi and ipw2x00 work reliably on platforms
> other than x86?  Or don't they?

Why should they? 

If somebody else takes over maintenance, because Intel does a bad job, 
that's fine.

If somebody else sends in patches and they get accepted "around" Intel, 
that's obviously also fine.

But complaining about a vendor who does a good job technically, for 
non-technical reasons, I really don't see that as being fine.

Is it even physically *possible* to use that Intel wireless chipset with 
anything but x86 CPU's (not just that, but actually _Intel_ x86 CPU's)? 
And would it make any sense what-so-ever even if it was?

And yes, portability is a great thing, but quite frankly, so is good 
hardware. I personally can't really blame Intel engineers for not caring 
about irrelevant hardware. 

We should make technical decisions on _technical_ grounds, not some 
perceived "this is how the world should work" grounds.

		Linus
