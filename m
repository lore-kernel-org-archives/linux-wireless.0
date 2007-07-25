Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbXGYUhw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:37:52 -0400
Subject: Re: [Fwd: [PATCH] libertas: Per-socket mesh-ttl via setsockopt().]
From: Dan Williams <dcbw@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070725153725.GB11785@infradead.org>
References: <1185371628.11035.11.camel@xo-13-A4-25.localdomain>
	 <20070725153725.GB11785@infradead.org>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 16:35:59 -0400
Message-Id: <1185395760.15817.2.camel@xo-13-A4-25.localdomain>
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

It _WAS_ posted to netdev on 2007-07-03 with the subject "Proposed
interface for per-packet mesh-ttl" from Javier.  Only the crickets were
heard in response.  Please reply to that thread with comments then.

Dan


