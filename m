Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:27156 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbXKOLJk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 06:09:40 -0500
Date: Thu, 15 Nov 2007 12:08:16 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Pablo Sanchez <pablo@blueoakdb.com>
Cc: ipw3945-devel@lists.sourceforge.net,
	Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	Dan Williams <dcbw@redhat.com>, Stephen.Clark@seclark.us,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
Message-ID: <20071115110815.GA5035@kernel.dk> (sfid-20071115_110950_046351_FFF2E7B9)
References: <20071017135452.GJ5043@kernel.dk> <200711150523.14834.pablo@blueoakdb.com> <20071115102648.GI638@kernel.dk> <200711150530.14363.pablo@blueoakdb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200711150530.14363.pablo@blueoakdb.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 15 2007, Pablo Sanchez wrote:
> On Thursday 15 November 2007 at 5:26 am, Jens Axboe penned
> about "Re: [ipw3945-devel] iwl3945 doesn't work:
> 
> > I'll revert to using ipw3945, it worked flawlessly for me.
> > Hopefully the iwl3945 driver will work sometime in the future, but
> > as you note, not a lot of progress appears to be happening. So I
> > wont hold my breath.
> 
> Hmmm, will that driver work on my Intel PRO 4965 card?

Nope, I think you are out of luck, it only covers 3945ABG only.

> Do you know whether I need to download the different microcode?

I don't know how big the differences between 3945 and 4945 are, but I'd
be surprised if that works. Others here will know more for sure.

> I'm all for junking the El Cheapo card.  It's annoying have it blink
> at me every second.  :p

:-)

-- 
Jens Axboe

