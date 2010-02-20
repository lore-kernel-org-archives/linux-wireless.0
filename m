Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab0BTUtx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 15:49:53 -0500
Date: Sat, 20 Feb 2010 12:46:55 -0800
From: Greg KH <gregkh@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Frederic Leroy <fredo@starox.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8192su: fix compile error from
	wireless-testing commit
Message-ID: <20100220204655.GA22055@suse.de>
References: <20100218002526.01d1de5f@houba> <20100219195215.GL4950@tuxdriver.com> <871vgfhi7n.fsf@purkki.valot.fi> <4B80310D.2060302@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B80310D.2060302@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 20, 2010 at 12:59:25PM -0600, Larry Finger wrote:
> On 02/20/2010 12:31 PM, Kalle Valo wrote:
> > "John W. Linville" <linville@tuxdriver.com> writes:
> > 
> >> Since I've got the 'offending' commit in my tree, I'll carry this
> >> staging fixup as well...
> > 
> > And I was the one who broke this, sorry. What's the general rule for
> > this, should I also start compile testing staging drivers when
> > changing something?
> 
> As someone else that was hit by this problem, I think that is a good idea. I
> realize that staging drivers are a special case, but it is likely easier for the
> person changing the ABI to fix any breakage. In addition, if the fixes are
> entered at the same time as the original change, there will not be any build
> breakage during bisection, and any questions of which coordinator to use will be
> avoided.

Ideally, yes, you should also fix up the staging drivers.

But in reality, no, I do not expect you, or anyone else to do so.  If it
causes you extra hassles and work, do not worry about anything in
drivers/staging/ I will handle that.

I can handle api changes just fine, it's not all that hard :)

So don't worry about it.

thanks,

greg k-h
