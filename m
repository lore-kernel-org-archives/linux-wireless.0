Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47972 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756546AbcECVqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 17:46:15 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 0EBEF20305
	for <linux-wireless@vger.kernel.org>; Tue,  3 May 2016 17:46:14 -0400 (EDT)
Date: Tue, 3 May 2016 14:46:12 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Kangjie Lu <kangjielu@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Kangjie Lu <kjlu@gatech.edu>
Subject: Re: [PATCH] fix infoleak in wireless
Message-ID: <20160503214612.GA13289@kroah.com> (sfid-20160503_234630_825880_12A2E9C7)
References: <1462308013-6032-1-git-send-email-kjlu@gatech.edu>
 <1462308044.10444.19.camel@sipsolutions.net>
 <CABEk9YxqyBxnqOseJ3-d-aKxnREZBFt1z89nOjHf=DvNQy_hTw@mail.gmail.com>
 <20160503210052.GA23109@kroah.com>
 <CABEk9YwiqpP+Ahxax3AC7tbPcmpUQnrB-Nwsb4rixhVjcL4Crw@mail.gmail.com>
 <20160503213401.GB23469@kroah.com>
 <CABEk9YwmQt9bQb_KXgYRj=irq9-edtdOeANs7+Z4qZp1zmqpxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CABEk9YwmQt9bQb_KXgYRj=irq9-edtdOeANs7+Z4qZp1zmqpxg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Tue, May 03, 2016 at 05:41:46PM -0400, Kangjie Lu wrote:
> You are right. But wouldn't it be more general/better if we initialize the
> allocation at very beginning?
> To avoid information leaks, I think we are supposed to initialize all
> allocations properly if 
> we are not sure how they are used.

But the networking maintainers told you to fix the broken drivers
instead.  So please do that and send those patches to the correct
developers and mailing lists.

The fact that only 2 staging drivers got this wrong means that everyone
knows how to use this api properly, so I agree with the maintainers
here.

thanks,


greg k-h
