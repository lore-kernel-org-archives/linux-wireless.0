Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:52596 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934302AbXCWUDc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:03:32 -0400
Date: Fri, 23 Mar 2007 13:00:37 -0700
To: Chris Wright <chrisw@sous-sol.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: Re: [stable] [PATCH] fix information leak in wireless extensions on 64-bit platforms
Message-ID: <20070323200037.GA5165@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1174640787.3588.65.camel@johannes.berg> <1174657362.3366.6.camel@johannes.berg> <20070323154828.GA4671@bougret.hpl.hp.com> <1174665384.4470.0.camel@johannes.berg> <20070323161339.GA4713@bougret.hpl.hp.com> <20070323193643.GY10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070323193643.GY10574@sequoia.sous-sol.org>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 23, 2007 at 12:36:43PM -0700, Chris Wright wrote:
> * Jean Tourrilhes (jt@hpl.hp.com) wrote:
> 
> > 	The last thing is that I could not test those stuff myself,
> > and the testing done for me was limited. I would be more confident if
> > you were to give it a good beating before we push that into stable,
> > because you know what to test.
> 
> That's useful info.  Have you had any luck (it looks pretty straight
> forward)?

	Let's be more clear. I tested properly on 32 bits. But, 32
bits is not where there is issue, this issue is specific to 64 bits. I
don't have a 64 bits platfor. It seems that few people doing wireless
have access to 64 bits platform (actually, it seems most of them don't
have access to SMP either), otherwise this would have been found many
years ago.
	Johannes is one of the few having access to 64 bits stuff.

> thanks,
> -chris

	Have fun...

	Jean
