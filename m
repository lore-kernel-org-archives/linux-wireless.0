Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.blueoakdb.com ([76.10.130.48]:1980 "EHLO
	sheldon.hillsandlakes.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751687AbXKOSgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 13:36:20 -0500
From: Pablo Sanchez <pablo@blueoakdb.com>
To: Mike Kershaw <dragorn@kismetwireless.net>
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
Date: Thu, 15 Nov 2007 13:36:16 -0500
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Ismail D?nmez <ismail@pardus.org.tr>,
	Dan Williams <dcbw@redhat.com>, Stephen.Clark@seclark.us,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <20071017135452.GJ5043@kernel.dk> <200711150530.14363.pablo@blueoakdb.com> <20071115150519.GA27231@drd1813.lan>
In-Reply-To: <20071115150519.GA27231@drd1813.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711151336.16589.pablo@blueoakdb.com> (sfid-20071115_183625_943804_81F9DAF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 November 2007 at 10:05 am, Mike Kershaw penned
about "Re: [ipw3945-devel] iwl3945 doesn't work:

> On Thu, Nov 15, 2007 at 05:30:14AM -0500, Pablo Sanchez wrote:
> > On Thursday 15 November 2007 at 5:26 am, Jens Axboe penned
> >
> > about "Re: [ipw3945-devel] iwl3945 doesn't work:
> > > I'll revert to using ipw3945, it worked flawlessly for me.
> > > Hopefully the iwl3945 driver will work sometime in the future,
> > > but as you note, not a lot of progress appears to be happening.
> > > So I wont hold my breath.
> >
> > Hmmm, will that driver work on my Intel PRO 4965 card?
>
> No, but iwl4965 from the same driver tree will.

I think you jumped into the thread.  The iwl4965 driver is covered by
iwlwifi and that's the driver which I've reported a couple of issues.
So far, no word from Intel.  Hence why I'm using 'blinky'

blinky - a 3COM card which blinks once a second.

Cheers,
-- 
Pablo

