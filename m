Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60494 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3JUNGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 09:06:33 -0400
Message-ID: <1382360786.14310.47.camel@jlt4.sipsolutions.net> (sfid-20131021_150635_581110_5826D1AA)
Subject: Re: NetworkManager not listing access points
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Hawkins <hawkinsw@opentechinstitute.org>
Cc: Detlev Casanova <detlev.casanova@gmail.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Date: Mon, 21 Oct 2013 15:06:26 +0200
In-Reply-To: <52600E1A.6070806@opentechinstitute.org>
References: <31357461.i5mG9q5IfA@naboo> <2916718.7t7kLXuBQV@naboo>
		 <1381131658.13586.0.camel@jlt4.sipsolutions.net>
	 <3301062.MLBKDh0Ksv@naboo>
		 (sfid-20131011_174257_646312_6E07DE10) <1382020735.14410.14.camel@jlt4.sipsolutions.net>
	 <52600E1A.6070806@opentechinstitute.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-17 at 12:19 -0400, Will Hawkins wrote:

> Not to clog up the channel, but I was running into exactly the same
> problem. I expected to see the problem somewhere in the kernel, etc. I
> turned on debugging and kernel tracing and saw nothing. The fix for me
> is almost identical to the fix that Detlev first described.
> 
> However, the problem for me was somewhere else entirely. The access
> point was sending out malformed beacon messages that kept it from
> showing up.

Any idea how they were malformed? Was there a bad DS IE or so?

johannes

