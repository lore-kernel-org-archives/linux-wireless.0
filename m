Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:12642 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbZIHLLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 07:11:35 -0400
MIME-Version: 1.0
In-Reply-To: <20090908105415.GD28127@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl>
	 <84144f020909060114s74de2d2y850745dd82ece753@mail.gmail.com>
	 <200909061028.48442.elendil@planet.nl>
	 <1252226116.11274.10.camel@penberg-laptop>
	 <20090908105415.GD28127@csn.ul.ie>
Date: Tue, 8 Sep 2009 14:11:35 +0300
Message-ID: <84144f020909080411n4e010308qa153039bee1b8336@mail.gmail.com>
Subject: Re: iwlagn: order 2 page allocation failures
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>,
	cl@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 8, 2009 at 1:54 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> My feeling is also that a number of these page allocation failures have
> been related to wireless drivers. Is that accurate? If so, have there
> been changes made to the wireless stack in this cycle that would have
> increased the order of pages allocated?

That's my general feeling as well. We have linux-wireless CC'd so
maybe this rings a bell for them.
