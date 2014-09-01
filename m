Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48902 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaIASwT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 14:52:19 -0400
Message-ID: <1409597534.2703.9.camel@jlt4.sipsolutions.net> (sfid-20140901_205222_034567_5042807B)
Subject: Re: wmediumd performance penalty
From: Johannes Berg <johannes@sipsolutions.net>
To: Dani Camps <danicamps81@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 01 Sep 2014 20:52:14 +0200
In-Reply-To: <CAD3NH5X1AYR5p8AyRyO0DFkkJUtuc_78=s6vEi-nS4UxUZfWCg@mail.gmail.com> (sfid-20140901_173813_368381_480D49AD)
References: <CAD3NH5X1AYR5p8AyRyO0DFkkJUtuc_78=s6vEi-nS4UxUZfWCg@mail.gmail.com>
	 (sfid-20140901_173813_368381_480D49AD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-09-01 at 17:38 +0200, Dani Camps wrote:
> Dear all,
> 
> I am testing a simple 1-hop mesh network over wmediumd. The PHY rate I
> have configured is 54 Mbps, and there is no loss, however the max
> throughput I get is around 14 Mbps. Without wmediumd I get around 30
> Mbps, which seems reasonable given the 54 PHY rate. As I noted above
> there is no loss probability configured in wmediumd.
> 
> My impression is that the performance drop is due to the overhead of
> switching between kernel and user space in wmediumd, however it
> surprises me that the penalty is so high.
> 
> Has anyone had a similar experience? Could there be a way to overcome
> this bottleneck?

What kind of system are you running on? The virtual PHY rate isn't taken
into account at all, so you should see far higher performance.

johannes

