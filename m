Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38557 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZFJBpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 21:45:30 -0400
Date: Tue, 9 Jun 2009 21:34:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, sfr@canb.auug.org.au,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rfkill: include err.h
Message-ID: <20090610013440.GA3523@tuxdriver.com>
References: <1244555812.4672.9.camel@johannes.local> <20090609.174952.40068461.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090609.174952.40068461.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 09, 2009 at 05:49:52PM -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Tue, 09 Jun 2009 15:56:52 +0200
> 
> > Since we use ERR_PTR and similar macros, we need to include linux/err.h.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> I'm applying this directly to net-next-2.6 to fix the -next
> build.
> 
> Please submit the more critical build fixes for regressions
> introduced by the wireless tree direclty to me in the future
> thanks.

That's a fine policy -- no objection.  However, please be aware that
Stephen picks-up stuff from the wireless trees even when I haven't
yet asked Dave to pull (so Dave might not always have the patch that
causes the break).  So, just keep that in mind (and CC me as well,
please). :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
