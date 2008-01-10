Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3097 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbYAJQVd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 11:21:33 -0500
Date: Thu, 10 Jan 2008 10:46:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Will Dyson <will.dyson@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Message-ID: <20080110154654.GC3109@tuxdriver.com> (sfid-20080110_162137_528267_F9180828)
References: <200801062337.35904.IvDoorn@gmail.com> <8e6f94720801100352t615025b6j1c2cc0081626fee5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8e6f94720801100352t615025b6j1c2cc0081626fee5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 10, 2008 at 06:52:40AM -0500, Will Dyson wrote:

> Hmm. Looking at Linus's tree, I can see that rt61pci is missing at
> least 1 critical fix from Mattias Nissler that has been in
> wireless-2.6 for a long time now.
> 
> rt2x00: Allow rt61 to catch up after a missing tx report
> 
> I'd be pretty disappointed if we released 2.6.24 without this. It is a
> simple fix for a really obnoxious problem (although one that triggers
> rarely on my hardware).

This one can be cherry-picked fairly easily for 2.6.24.  Ivo, any
reason not to do that?
 
> There are also a bunch of antenna selection fixes that never went
> upstream. These are required for my card to operate well at rates
> greater than 1Mbit, even when fairly close to the AP.

Can you identify specific patches?  If so I can evaluate whether they
apply easily to 2.6.24 or if they need significant rework.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
