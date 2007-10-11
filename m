Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40841 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbXJKOQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 10:16:44 -0400
Date: Thu, 11 Oct 2007 15:16:42 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
Message-ID: <20071011141642.GA6976@infradead.org> (sfid-20071011_151650_009645_B65A04B3)
References: <200710111151.06989.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200710111151.06989.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 11, 2007 at 11:51:06AM +0200, Holger Schurig wrote:
> Move wlan_postpone_association_work() and wlan_cancel_association_work()
> from a assoc.h file to the sole user, into wext.c.
> 
> In passing, rename the functions to libertas_XXX.

As you seem to do some nice cleanups on libertas is there a chance
you could get rid of this horrible wlan_ namespace abuse in the driver?

