Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34732 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbcBWUFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 15:05:52 -0500
Message-ID: <1456257946.9910.23.camel@sipsolutions.net> (sfid-20160223_210555_985826_EE9718EA)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation
 timeout.
From: Johannes Berg <johannes@sipsolutions.net>
To: Avery Pennarun <apenwarr@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Date: Tue, 23 Feb 2016 21:05:46 +0100
In-Reply-To: <CAHqTa-1CkJ-Pm6o7-pxcek4h+hmq6EtA0u12zGGraOUjDjeXSQ@mail.gmail.com> (sfid-20160223_194354_293486_AB1DEE76)
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
	 <1455658091-28262-1-git-send-email-apenwarr@gmail.com>
	 <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
	 <1456222441.2041.10.camel@sipsolutions.net>
	 <CAHqTa-1CkJ-Pm6o7-pxcek4h+hmq6EtA0u12zGGraOUjDjeXSQ@mail.gmail.com>
	 (sfid-20160223_194354_293486_AB1DEE76)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 13:43 -0500, Avery Pennarun wrote:

> We're putting my version of the patch into our devices in order to be
> able to try different values and see how it changes the percentage of
> devices with nonzero 'pending' field in agg_status.  I'm hoping using
> zero here will result in total elimination of the pending problem,
> but we'll see.

:)
I for one would be interested in the result. And, if you find mac80211
is at fault, knowing what happens there.

> If people think this is important, I can respin the patch, otherwise
> feel free to discard.
> 

Up to you. I've discarded it for now with "changes requested", if you
never resend I'll not worry about it. Clearly we haven't had a need for
it so far.

johannes
