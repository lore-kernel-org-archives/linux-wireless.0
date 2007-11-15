Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:27558 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbXKOK0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 05:26:52 -0500
Date: Thu, 15 Nov 2007 11:26:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Pablo Sanchez <pablo@blueoakdb.com>
Cc: ipw3945-devel@lists.sourceforge.net,
	Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	Dan Williams <dcbw@redhat.com>, Stephen.Clark@seclark.us,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
Message-ID: <20071115102648.GI638@kernel.dk> (sfid-20071115_102654_875264_4389C3AD)
References: <20071017135452.GJ5043@kernel.dk> <200711150253.48628.ismail@pardus.org.tr> <20071115093921.GH638@kernel.dk> <200711150523.14834.pablo@blueoakdb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200711150523.14834.pablo@blueoakdb.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 15 2007, Pablo Sanchez wrote:
> On Thursday 15 November 2007 at 4:39 am, Jens Axboe penned
> about "Re: [ipw3945-devel] iwl3945 doesn't work:
> 
> > I'll second that, using todays snap still requires me to do an
> > iwlist scan before I can use the network.
> 
> Same here and for now, I've given up on using the Intel card on my
> laptop.  I slapped an El Cheapo 3COM card.  While less mW's and
> sensitivity, the MadWifi support is awesome for this atheros based
> card.
> 
> Under stress, my ping times are within 100ms (unlike what I reported
> previously), throughput is at 5Mbps and it works well with
> KnetworkManager.
> 
> I'm not complaining about the Intel support, just noting for now the
> problem isn't pressing for me.  I'll happily test new drops as they
> come out and address the issues I reported.
> 
> I'd appreciate even an acknowledgment though (rather than the old
> /dev/null treatment).

I'll revert to using ipw3945, it worked flawlessly for me. Hopefully the
iwl3945 driver will work sometime in the future, but as you note, not a
lot of progress appears to be happening. So I wont hold my breath.

-- 
Jens Axboe

