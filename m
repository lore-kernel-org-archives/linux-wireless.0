Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.blueoakdb.com ([76.10.130.48]:4594 "EHLO
	sheldon.hillsandlakes.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752033AbXKOKXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 05:23:18 -0500
From: Pablo Sanchez <pablo@blueoakdb.com>
To: ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
Date: Thu, 15 Nov 2007 05:23:14 -0500
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>,
	Dan Williams <dcbw@redhat.com>, Stephen.Clark@seclark.us,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <20071017135452.GJ5043@kernel.dk> <200711150253.48628.ismail@pardus.org.tr> <20071115093921.GH638@kernel.dk>
In-Reply-To: <20071115093921.GH638@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711150523.14834.pablo@blueoakdb.com> (sfid-20071115_102322_224555_EE6C082A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 November 2007 at 4:39 am, Jens Axboe penned
about "Re: [ipw3945-devel] iwl3945 doesn't work:

> I'll second that, using todays snap still requires me to do an
> iwlist scan before I can use the network.

Same here and for now, I've given up on using the Intel card on my
laptop.  I slapped an El Cheapo 3COM card.  While less mW's and
sensitivity, the MadWifi support is awesome for this atheros based
card.

Under stress, my ping times are within 100ms (unlike what I reported
previously), throughput is at 5Mbps and it works well with
KnetworkManager.

I'm not complaining about the Intel support, just noting for now the
problem isn't pressing for me.  I'll happily test new drops as they
come out and address the issues I reported.

I'd appreciate even an acknowledgment though (rather than the old
/dev/null treatment).

Cheers,
-- 
Pablo

