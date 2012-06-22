Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:50143 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757850Ab2FVOtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 10:49:09 -0400
Message-ID: <1340376549.31821.19.camel@joe2Laptop> (sfid-20120622_164920_623051_FA1D140B)
Subject: Re: [PATCH 4/6] mac80211: clean up debugging
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Date: Fri, 22 Jun 2012 07:49:09 -0700
In-Reply-To: <1340376203.4491.29.camel@jlt3.sipsolutions.net>
References: <1340370882-9258-1-git-send-email-johannes@sipsolutions.net>
	 <1340370882-9258-5-git-send-email-johannes@sipsolutions.net>
	 <1340375828.31821.11.camel@joe2Laptop>
	 (sfid-20120622_163725_973326_440DEFC6) <1340376203.4491.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 16:43 +0200, Johannes Berg wrote:
> > Using a single style _with_ a newline limits defects and
> > limits the likely misuse in other styles.
> 
> I'd rather have double newlines once a while than missing ones. I've
> seen a lot of bugs with missing newlines, which is rather annoying.

Yeah, I have too.

It's because people add macros that add terminating
newlines and there's no style consistency.

I think you should _not_ add more macros that promote
this inconsistency.

usb's uses of err/warn/info/dbg are going away.

These should too.

