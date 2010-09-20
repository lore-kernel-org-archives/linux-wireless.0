Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46526 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab0ITVmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 17:42:45 -0400
Subject: Re: [PATCH] b43/b43legacy - Credit Broadcom with enabling the
 development of the drivers
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinoe86gtsMJMJ-jitj3yHo35FBdyiqbPKuUAe_R@mail.gmail.com>
References: <1284921651.24835.11.camel@i7.infradead.org>
	 <AANLkTinoe86gtsMJMJ-jitj3yHo35FBdyiqbPKuUAe_R@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 22:42:41 +0100
Message-ID: <1285018961.17079.10.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-20 at 18:36 +0200, Gábor Stefanik wrote:
> Only one problem: the license agreement of these drivers explicitly
> forbids any reverse-engineering for any purpose. 

Which is kind of irrelevant, since the law already prohibits you from
violating the regulatory framework. Making it *also* a potential
copyright violation (except where it's deemed unenforceable) really
doesn't make a blind bit of difference, surely?

> One can debate a lot about whether these are enforceable - however, in
> the US, a similar case (though that one was about resale, rather than
> reverse-engineering) was recently decided in the plaintiff's favor.

I don't believe the reverse engineering was done in the US, was it?

> And I believe Broadcom would indeed sue if they thought they were
> risking their FCC approval by not doing so. 

I don't see how it really affects their FCC approval. The fact that they
do the regulatory enforcement in software is what enables you to
trivially bypass it. 

You are breaking the law by hacking the driver to violate the rules. You
knew that anyway -- it really shouldn't make any difference if they
*also* tell you it's illegal to hack the driver. And it doesn't change
the fact that they have made it possible.

-- 
dwmw2

