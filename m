Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab0HQIvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 04:51:44 -0400
Subject: Re: nl80211 scanning from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Christopher Piggott <cpiggott@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTin90i08fbYeyrc17a7=smhshxR69=ushqUSkA0Z@mail.gmail.com>
References: <AANLkTi=ZGn0Rt7zYxBJB0jJ-EY=gPpxtBN2bA9svkq99@mail.gmail.com>
	 <1281986025.3683.31.camel@jlt3.sipsolutions.net>
	 <AANLkTiniqFJzrWFzNJTxsF31EZfSTei89dbS2Ak4YDjH@mail.gmail.com>
	 <1281987696.3683.32.camel@jlt3.sipsolutions.net>
	 <AANLkTi=ALaGb=UcWAuB_N8E9j95f0Hgxtw0Dhh7xaPh2@mail.gmail.com>
	 <1281995025.3683.34.camel@jlt3.sipsolutions.net>
	 <AANLkTi=sb0PT4FHsjbuAOQjnDq79GHEj8LbCLTtO8MeS@mail.gmail.com>
	 <AANLkTin90i08fbYeyrc17a7=smhshxR69=ushqUSkA0Z@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 10:51:42 +0200
Message-ID: <1282035102.3747.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-16 at 19:16 -0400, Christopher Piggott wrote:
> Forgive me if this is an obtuse question but why would one use
> nl_socket_add_membership, if all that isn't necessary to get back the
> scan results?

Well, you want to know when the scan finished, and for that you need to
be in the right group to receive the event when it finishes.

johannes


