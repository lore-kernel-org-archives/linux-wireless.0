Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0HUJVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Aug 2010 05:21:51 -0400
Subject: Re: Fwd: nl80211 scanning from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Christopher Piggott <cpiggott@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=ioQFQ=0_Z5EWRNVrEYp2o40UU4TROOMaouZX1@mail.gmail.com>
References: <AANLkTi=ZGn0Rt7zYxBJB0jJ-EY=gPpxtBN2bA9svkq99@mail.gmail.com>
	 <1281986025.3683.31.camel@jlt3.sipsolutions.net>
	 <AANLkTiniqFJzrWFzNJTxsF31EZfSTei89dbS2Ak4YDjH@mail.gmail.com>
	 <1281987696.3683.32.camel@jlt3.sipsolutions.net>
	 <AANLkTi=ALaGb=UcWAuB_N8E9j95f0Hgxtw0Dhh7xaPh2@mail.gmail.com>
	 <1281995025.3683.34.camel@jlt3.sipsolutions.net>
	 <AANLkTi=sb0PT4FHsjbuAOQjnDq79GHEj8LbCLTtO8MeS@mail.gmail.com>
	 <AANLkTin90i08fbYeyrc17a7=smhshxR69=ushqUSkA0Z@mail.gmail.com>
	 <1282035102.3747.0.camel@jlt3.sipsolutions.net>
	 <AANLkTikzWs65zQYbCJQuvLv0e_010Rgy-C6J4ucpzBfa@mail.gmail.com>
	 <AANLkTi=ioQFQ=0_Z5EWRNVrEYp2o40UU4TROOMaouZX1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 11:21:48 +0200
Message-ID: <1282382508.3759.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-20 at 19:42 -0400, Christopher Piggott wrote:

> So here's the question: in my NL_CB_VALID listener, how do I
> distinguish the response to the NL80211_CMD_TRIGGER_SCAN (the one that
> indicates scan complete) from the response to the CMD_GET_SCAN (fetch
> the results) message?

One will be unicast to you, and the event is multicast to everybody. You
should be able to tell the difference.

johannes

