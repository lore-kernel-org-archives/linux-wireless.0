Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:37159 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030609AbXC2SLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 14:11:37 -0400
Message-ID: <460C0157.5030404@lwfinger.net>
Date: Thu, 29 Mar 2007 13:11:35 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] bcm43xx: Change initialization for 2050 radios
References: <460a92d5.+NfCgWddLCeb9ty2%Larry.Finger@lwfinger.net>	 <1175188955.3122.42.camel@pmac.infradead.org>	 <460BFDF0.9010401@lwfinger.net> <1175191382.3122.44.camel@pmac.infradead.org>
In-Reply-To: <1175191382.3122.44.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On Thu, 2007-03-29 at 12:57 -0500, Larry Finger wrote:
>> Is the better performance for 11M in transmitting or receiving? How is
>> it measured? My 4306's, which should be the same as yours, do better
>> at 24M than at 11M. 
> 
> It's for 'scp <somekernelrpm> shinybook:' -- it's not a particularly
> good test.
> 
> And in fact the 'normal' module seems to be performing quite well today
> too. I think the real performance problem comes when there are dropped
> packets.

OK, you are measuring receive speed, which is nearly independent of Bit Rate. Do you have access to
any other host on your LAN that could be an Iperf server, or that is an NFS server?

Larry
