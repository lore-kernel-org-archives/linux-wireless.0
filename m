Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761620AbXG0Owp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 10:52:45 -0400
Subject: Re: [Fwd: [PATCH] libertas: Per-socket mesh-ttl via setsockopt().]
From: Dan Williams <dcbw@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070725153725.GB11785@infradead.org>
References: <1185371628.11035.11.camel@xo-13-A4-25.localdomain>
	 <20070725153725.GB11785@infradead.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 10:50:43 -0400
Message-Id: <1185547843.14054.1.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-07-25 at 16:37 +0100, Christoph Hellwig wrote:
> On Wed, Jul 25, 2007 at 09:53:48AM -0400, Dan Williams wrote:
> > Any objections before I push to libertas?
> 
> Please post this to netdev to get the deserved amount of flames from
> the core developers.  Or to make it short, no way a driver should register
> sockops ever, and no way you should be using netfilter code for that.

I will assume that since there has been no reply to Javier's message on
netdev (and my forward of his patch) since Wednesday, that you are OK
with the patch?

If you have objections, please voice them...
 
Thanks,
Dan


