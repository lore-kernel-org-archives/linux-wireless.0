Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2895 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105AbXHXAO1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 20:14:27 -0400
Date: Thu, 23 Aug 2007 19:43:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43, b43legacy: Fix inconsistency between branches  'b43' and 'everything' in wireless-dev
Message-ID: <20070823234333.GA3472@tuxdriver.com>
References: <46ce12c4.2TC1IuG0LDupBuDr%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46ce12c4.2TC1IuG0LDupBuDr%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 23, 2007 at 06:05:40PM -0500, Larry Finger wrote:

> I'm not sure how to handle this. In it's present state, branch 'b43' cannot be used
> to generate a working version of b43 or b43legacy. In addition,  the Kconfig and Makefile
> from b43legacy are not included, thus it is not possible to build b43legacy
> in that branch.

I had neglected to pull the mac80211 updates into the branches that
depend on them (now most of the driver branches).  I have done that
now, and pushed the results.

Hth!

John

P.S.  FWIW, b43legacy seems to have Kconfig and Makefile in my tree.
I was able to build it just fine.  Yes, I checked to make sure I had
included them in git. :-)
-- 
John W. Linville
linville@tuxdriver.com
