Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54744 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab2ECPRy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 11:17:54 -0400
Date: Thu, 3 May 2012 11:14:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, alexander.duyck@gmail.com,
	alexander.h.duyck@intel.com, netdev@vger.kernel.org,
	edumazet@google.com, jeffrey.t.kirsher@intel.com,
	linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com
Subject: Re: [PATCH 2/2] tcp: cleanup tcp_try_coalesce
Message-ID: <20120503151418.GJ9285@tuxdriver.com> (sfid-20120503_171757_686993_A4DD0879)
References: <1336017985.12425.9.camel@edumazet-glaptop>
 <4FA21087.1080801@gmail.com>
 <1336022373.12425.24.camel@edumazet-glaptop>
 <20120503.012502.44731688706812861.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120503.012502.44731688706812861.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 03, 2012 at 01:25:02AM -0400, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Thu, 03 May 2012 07:19:33 +0200
> 
> > My last patch against iwlwifi is still waiting to make its way into
> > official tree.
> > 
> > http://www.spinics.net/lists/netdev/msg192629.html
> 
> John, please rectify this situation.
> 
> The Intel Wireless folks said they would test it, but that was more
> than a month ago.
> 
> It's not acceptable to let bug fixes rot for that long, I don't care
> what their special internal testing procedure is.
> 
> If they give you further pushback, please just ignore them and apply
> Eric's fix directly.
> 
> Thank you.

I imagine that this somehow got lost in the shuffle during the
merge window.  That doesn't excuse it, of course.

It has waited long enough already, so I'll just go ahead and take it.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
