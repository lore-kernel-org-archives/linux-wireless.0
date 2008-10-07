Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49884 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbYJGNRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 09:17:10 -0400
Date: Tue, 7 Oct 2008 09:16:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
Message-ID: <20081007131615.GR3448@tuxdriver.com> (sfid-20081007_151714_811519_9A72E81D)
References: <1223311803.15196.36.camel@johannes.berg> <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com> <200810070821.56462.hs4233@mail.mn-solutions.de> <20081007071529.GA5010@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081007071529.GA5010@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 07, 2008 at 03:15:29AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 07, 2008 at 08:21:56AM +0200, Holger Schurig wrote:
> > > I don't want these macros eithers but I NACK any patches with
> > > cursing in the commit logs.
> > 
> > I fully agree. There's no need to speak about "crap" when 
> > changing other people's code. In some cultures thats quite 
> > insulting.
> 
> Well, it is crap.  Looks at it objectively.  It's a perfectly fine
> description and most of us use it perfectly happily for our own code,
> too.

I agree that this is at worst a little bit rude.  The patch should be
rejected or merged on its own basis, although I do reserve the right
to edit a changelog from time to time... :-)

Now, can we discuss the patch rather than Johannes' intemperate
word choice?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
