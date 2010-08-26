Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56722 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0HZN3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 09:29:42 -0400
Date: Thu, 26 Aug 2010 07:58:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/6] "runtime" iftype switching
Message-ID: <20100826115800.GA6733@tuxdriver.com>
References: <20100825205619.152295081@sipsolutions.net>
 <20100825211036.GO2557@tuxdriver.com>
 <1282807400.3812.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1282807400.3812.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 26, 2010 at 09:23:20AM +0200, Johannes Berg wrote:
> On Wed, 2010-08-25 at 17:10 -0400, John W. Linville wrote:
> > On Wed, Aug 25, 2010 at 10:56:19PM +0200, Johannes Berg wrote:
> > > Here's some code to allow runtime (while the
> > > interface is UP) interface type switching,
> > > so far only for STA, IBSS and AP because the
> > > others seem a bit trickier and harder to
> > > verify.
> 
> > What is driving this?
> 
> Mostly the fact that it's awkward to set the interface down every time,
> because for example every time you do that some IPv6 configuration gets
> lost.
> 
> Also, "because I can" :)

Fair enough... :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
