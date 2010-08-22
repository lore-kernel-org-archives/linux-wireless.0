Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54374 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0HVTtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 15:49:10 -0400
Received: by vws3 with SMTP id 3so4717596vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 12:49:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282382508.3759.0.camel@jlt3.sipsolutions.net>
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
	<1282382508.3759.0.camel@jlt3.sipsolutions.net>
Date: Sun, 22 Aug 2010 15:49:05 -0400
Message-ID: <AANLkTimmRMhy-4_r3ZxZ=c=2jUJi_GoevqL8DVdMZemP@mail.gmail.com>
Subject: Re: Fwd: nl80211 scanning from userspace
From: Christopher Piggott <cpiggott@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> One will be unicast to you, and the event is multicast to everybody. You
> should be able to tell the difference.

Oh, right ... or, is there some kind of "message source address" that
I can get to?  The only thing I have been able to figure out so far is
that the messages coming from the second message (multicast) seem to
have a PID of 0... maybe if I make sure mine is set to something else
I can tell that way.
