Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:50713 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZJ2Vtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 17:49:42 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Thu, 29 Oct 2009 22:48:42 +0100
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linville@tuxdriver.com
References: <200910291212.41656.bzolnier@gmail.com> <200910291514.40318.bzolnier@gmail.com> <84144f020910291245l1a7a3fd6o8822ecd4ce3b5504@mail.gmail.com>
In-Reply-To: <84144f020910291245l1a7a3fd6o8822ecd4ce3b5504@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200910292248.42229.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 29 October 2009 20:45:07 Pekka Enberg wrote:
> Hi Bart,
> 
> On Thu, Oct 29, 2009 at 4:14 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> >> lots of cleanups to the staging drivers, why not direct some of that
> >> energy to the drivers/net/wireless ones?
> >
> > When did we start to apply "fix it yourself" rule instead of "submitter
> > should fix it" one to the _new_ code..
> 
> Don't be silly, I didn't say that.

Sorry, I must have misunderstood you.

> I was simply pointing out that your time would probably be better
> spent in improving the "proper" ralink wireless drivers but if you

Thanks for the concern.  However recent discussions made my realize how
I should really be spending my time effectively way too well.

> _really_ prefer to spend your time in pointless arguments, go ahead.

I don't think that my technical arguments are pointless.

Quite the contrary, I'm pretty confident that addressing my review concerns
would result in better RT28x00 / RT30x0 support in the very near future.

> It should be pretty obvious by now that the best way to improve things
> is to work with the relevant maintainers, not against them. (Unless
> you wish your work to be ignored, of course.)

I work with a lot of other maintainers.  I would say that providing valuable
review feedback is also "working with" (at least I would be very happy with
such feedback in my projects).

--
Bartlomiej Zolnierkiewicz
