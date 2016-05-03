Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41850 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756533AbcECVAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 17:00:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id B042720F54
	for <linux-wireless@vger.kernel.org>; Tue,  3 May 2016 17:00:53 -0400 (EDT)
Date: Tue, 3 May 2016 14:00:52 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Kangjie Lu <kangjielu@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Kangjie Lu <kjlu@gatech.edu>
Subject: Re: [PATCH] fix infoleak in wireless
Message-ID: <20160503210052.GA23109@kroah.com> (sfid-20160503_230119_187130_3912B5FA)
References: <1462308013-6032-1-git-send-email-kjlu@gatech.edu>
 <1462308044.10444.19.camel@sipsolutions.net>
 <CABEk9YxqyBxnqOseJ3-d-aKxnREZBFt1z89nOjHf=DvNQy_hTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABEk9YxqyBxnqOseJ3-d-aKxnREZBFt1z89nOjHf=DvNQy_hTw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Tue, May 03, 2016 at 04:47:16PM -0400, Kangjie Lu wrote:
> Hi Greg,
> 
> Could you please take a look at this issue.
> mac_addr is not initialized is some implementations of dump_station(), which
> can be exploited by attackers for leaking information.

You are going to have to give me more context here...

Like the patch itself?

thanks,

greg k-h
