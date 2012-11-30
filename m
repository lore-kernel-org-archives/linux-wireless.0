Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47954 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992781Ab2K3TQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 14:16:32 -0500
Date: Fri, 30 Nov 2012 14:07:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-11-30
Message-ID: <20121130190702.GC2355@tuxdriver.com> (sfid-20121130_201652_983613_2B563BEB)
References: <20121130182459.GB2355@tuxdriver.com>
 <20121130.134018.1859855439413083920.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121130.134018.1859855439413083920.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 30, 2012 at 01:40:18PM -0500, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Fri, 30 Nov 2012 13:25:00 -0500
> 
> > I have a couple of stragglers intended for 3.7...
> > 
> > The iwlwifi patch fixes a bug in CCK basic rate calculations.
> > 
> > The mac80211 patch removes an unnecessary function call that was
> > generating a lot of log SPAM.
> 
> Pulled, thanks John.
> 
> I want to warn you ahead of time that these might not make it.

Yes, I suspect that might be the case -- but it won't make it if I
don't send it... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
