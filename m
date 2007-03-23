Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2408 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbXCWQWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 12:22:09 -0400
Date: Fri, 23 Mar 2007 11:42:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org, linux-wireless <linux-wireless@vger.kernel.org>,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH] fix information leak in wireless extensions on 64-bit platforms
Message-ID: <20070323154237.GB3882@tuxdriver.com>
References: <1174640787.3588.65.camel@johannes.berg> <1174657362.3366.6.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1174657362.3366.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 23, 2007 at 02:42:42PM +0100, Johannes Berg wrote:
> On Fri, 2007-03-23 at 14:40 +0100, Johannes Berg wrote:
> > Wireless extensions on 64-bit platforms leak information from the kernel
> > stack due to padding in structs that is copied. This affects any
> > wireless event stream including scan results and so hence is available
> > to unprivileged users.
> 
> Ignore this patch, I see Jean just posted one as well :)

Hmmm...I seem to have missed it.  Perhaps I was too quick w/ the 'd'
this morning? :-)

Jean, could you bounce me another copy?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
