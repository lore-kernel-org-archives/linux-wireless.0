Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56178 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZCDOP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 09:15:26 -0500
Date: Wed, 4 Mar 2009 09:14:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Mike Cui <cuicui@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Bug in iw prevents setting the "cook" monitor flag
Message-ID: <20090304141402.GB7965@tuxdriver.com> (sfid-20090304_151529_108318_FCDFB214)
References: <7c8826910903021516t640aa84dxfbb61a278b69c740@mail.gmail.com> <20090303145233.GB17678@tuxdriver.com> <87tz69six4.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87tz69six4.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 04, 2009 at 12:04:39PM +0200, Kalle Valo wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:
> 
> > On Mon, Mar 02, 2009 at 03:16:14PM -0800, Mike Cui wrote:
> >> There is an off by one error in interface.c of iw that prevents
> >> passing of the cook flag when creating a monitor interface. The fix is
> >> simple:
> >> 
> >> 
> >> --- a/interface.c       2009-03-02 15:11:58.748078548 -0800
> >> +++ b/interface.c       2009-03-02 15:12:14.695203787 -0800
> 
> [...]
> 
> > FWIW, I think I like "x <= Y" instead of "x < Y + 1".
> 
> I agree.
> 
> > Also, please make sure you are following the guidelines explained here:
> >
> > 	http://linux.yyz.us/patch-format.html
> >
> > In particular, I need a Signed-off-by line from you.
> 
> But this is for iw, not for wireless-testing. Or did I miss something?

Ah, you're right... :-)  Then I'll let Johannes worry about that.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
