Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:3968 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbXKOPKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 10:10:32 -0500
Date: Thu, 15 Nov 2007 16:09:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Kershaw <dragorn@kismetwireless.net>
Cc: Pablo Sanchez <pablo@blueoakdb.com>,
	Ismail D?nmez <ismail@pardus.org.tr>,
	Dan Williams <dcbw@redhat.com>, Stephen.Clark@seclark.us,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
Message-ID: <20071115150906.GE5035@kernel.dk> (sfid-20071115_151034_907267_00237F55)
References: <20071017135452.GJ5043@kernel.dk> <200711150523.14834.pablo@blueoakdb.com> <20071115102648.GI638@kernel.dk> <200711150530.14363.pablo@blueoakdb.com> <20071115150519.GA27231@drd1813.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071115150519.GA27231@drd1813.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 15 2007, Mike Kershaw wrote:
> On Thu, Nov 15, 2007 at 05:30:14AM -0500, Pablo Sanchez wrote:
> > On Thursday 15 November 2007 at 5:26 am, Jens Axboe penned
> > about "Re: [ipw3945-devel] iwl3945 doesn't work:
> > 
> > > I'll revert to using ipw3945, it worked flawlessly for me.
> > > Hopefully the iwl3945 driver will work sometime in the future, but
> > > as you note, not a lot of progress appears to be happening. So I
> > > wont hold my breath.
> > 
> > Hmmm, will that driver work on my Intel PRO 4965 card?
> 
> No, but iwl4965 from the same driver tree will.

Ehm, I'd be surprised if Pablo didn't mean if ipw3945 would work with
his card, not iwl3945.

-- 
Jens Axboe

