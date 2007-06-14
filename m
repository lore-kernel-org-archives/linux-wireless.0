Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60514 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbXFNSYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 14:24:50 -0400
Date: Thu, 14 Jun 2007 11:23:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	dcbw@redhat.com, hs4233@mail.mn-solutions.de,
	linux-kernel@vger.kernel.org
Subject: Re: libertas (private) ioctls vs. nl80211
In-Reply-To: <20070614181307.GA16856@infradead.org>
Message-ID: <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
References: <1181757483.29767.99.camel@johannes.berg> <20070614170901.GA13384@infradead.org>
 <20070614103836.23b07a72.akpm@linux-foundation.org>
 <20070614181307.GA16856@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Thu, 14 Jun 2007, Christoph Hellwig wrote:
>
> > I suspect that the probability of your proposal succeeding would be increased
> > if you could prepare a patch...
> 
> Here we go:

I don't mind ripping them out, but it makes sense only if people are 
actually signed up to implementing this on a higher layer. As such, I'd 
need to get a sign-off from somebody actually involved in wireless mesh 
stuff etc.

Please? I do agree that the private iwpriv interface seems to be totally 
the wrong thing to do, but I want to see this as a first step towards a 
better situation, rather than just a "remove code that is ugly" issue!

Comments?

		Linus
