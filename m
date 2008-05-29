Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2307 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbYE2A6Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 20:58:24 -0400
Date: Wed, 28 May 2008 20:35:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-05-28
Message-ID: <20080529003527.GC22536@tuxdriver.com> (sfid-20080529_025828_905027_F0C87AD9)
References: <20080528213831.GA3133@tuxdriver.com> <1212012670.21624.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1212012670.21624.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2008 at 12:11:10AM +0200, Johannes Berg wrote:
> On Wed, 2008-05-28 at 17:38 -0400, John W. Linville wrote:
> > David,
> > 
> > Another round of fixes for 2.6.26 follows...
> > 
> > Please let me know if there are problems!
> 
> What about
> 
> [PATCH] b43legacy: fix build errors when DMA or PIO are not selected

That claims to correct a problem created by "mac80211: move TX info
into skb->cb", which is not in the 2.6.26 stream.  I will apply it
to wireless-next-2.6.

John
-- 
John W. Linville
linville@tuxdriver.com
