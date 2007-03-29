Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:46640 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030339AbXC2SDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 14:03:11 -0400
Subject: Re: [PATCH] bcm43xx: Change initialization for 2050 radios
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <460BFDF0.9010401@lwfinger.net>
References: <460a92d5.+NfCgWddLCeb9ty2%Larry.Finger@lwfinger.net>
	 <1175188955.3122.42.camel@pmac.infradead.org>
	 <460BFDF0.9010401@lwfinger.net>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 19:03:02 +0100
Message-Id: <1175191382.3122.44.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-03-29 at 12:57 -0500, Larry Finger wrote:
> Is the better performance for 11M in transmitting or receiving? How is
> it measured? My 4306's, which should be the same as yours, do better
> at 24M than at 11M. 

It's for 'scp <somekernelrpm> shinybook:' -- it's not a particularly
good test.

And in fact the 'normal' module seems to be performing quite well today
too. I think the real performance problem comes when there are dropped
packets.

-- 
dwmw2

