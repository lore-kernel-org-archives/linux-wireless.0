Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58988 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760861AbXFRSok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2007 14:44:40 -0400
Date: Mon, 18 Jun 2007 19:44:36 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	hs4233@mail.mn-solutions.de, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: libertas (private) ioctls vs. nl80211
Message-ID: <20070618184436.GC17479@infradead.org>
References: <1181757483.29767.99.camel@johannes.berg> <20070614170901.GA13384@infradead.org> <20070614103836.23b07a72.akpm@linux-foundation.org> <20070614181307.GA16856@infradead.org> <1182188327.22149.5.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1182188327.22149.5.camel@xo-28-0B-88.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 18, 2007 at 01:38:47PM -0400, Dan Williams wrote:
> On Thu, 2007-06-14 at 19:13 +0100, Christoph Hellwig wrote:
> > > I suspect that the probability of your proposal succeeding would be increased
> > > if you could prepare a patch...
> 
> Applied to upstream-fixes branch of libertas-2.6 which is destined for
> 2.6.22; I hope you don't mind that I just added the Signed-off-by for
> you.

Adding a signed off line for a patch that purely removes codes seems
rather pointless to me, but feel free to add it if you care.
