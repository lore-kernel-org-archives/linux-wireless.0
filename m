Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:47850 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030580AbXC2R5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 13:57:13 -0400
Message-ID: <460BFDF0.9010401@lwfinger.net>
Date: Thu, 29 Mar 2007 12:57:04 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] bcm43xx: Change initialization for 2050 radios
References: <460a92d5.+NfCgWddLCeb9ty2%Larry.Finger@lwfinger.net> <1175188955.3122.42.camel@pmac.infradead.org>
In-Reply-To: <1175188955.3122.42.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On Wed, 2007-03-28 at 11:07 -0500, Larry Finger wrote:
>> This patch implements the changes in the specifications for
>> 2050radio_init that were recently posted.
> 
> That seems to help performance quite a lot -- although 'rate 11M' still
> runs a _lot_ faster than the 24M which the driver seems to settle at by
> default, when it's sitting 1m from the AP.
> 

Is the better performance for 11M in transmitting or receiving? How is it measured? My 4306's, which
should be the same as yours, do better at 24M than at 11M.

Larry

