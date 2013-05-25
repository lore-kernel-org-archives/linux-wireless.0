Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46003 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816Ab3EYThn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 May 2013 15:37:43 -0400
Message-ID: <51A112FC.8060100@hauke-m.de> (sfid-20130525_213746_030640_1E949430)
Date: Sat, 25 May 2013 21:37:32 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Thommy Jakobsson <thommyj@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYI=?= =?UTF-8?B?ZWNraQ==?=
	<zajec5@gmail.com>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, m@bues.ch, piotras@gmail.com,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net> <CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com> <alpine.DEB.2.02.1305132025560.1278@kelly.ryd.net> <20130524164922.GA2175@tuxdriver.com> <alpine.DEB.2.02.1305252058060.1282@kelly.ryd.net>
In-Reply-To: <alpine.DEB.2.02.1305252058060.1282@kelly.ryd.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2013 09:02 PM, Thommy Jakobsson wrote:
> 
> 
> On Fri, 24 May 2013, John W. Linville wrote:
> 
>> Ping?  Should I drop this one?
>>
> Still working great on my device, so from that I think we should go for 
> it. But it would be great if Rafal (or someone) tested it on some other 
> hardware as well. 
> 
> //Thommy

This is included in OpenWrt for ~4 weeks now and I haven't read of
anybody complaining about any new problems introduced by this patch or
something which looks like the DMA under run.
I am also for adding this to the kernel.

Hauke

