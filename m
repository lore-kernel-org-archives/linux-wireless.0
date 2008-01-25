Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754101AbYAYQpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 11:45:22 -0500
Date: Fri, 25 Jan 2008 08:43:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <200801251723.58891.mb@bu3sch.de>
Message-ID: <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org> (sfid-20080125_164525_479846_7EAEAF15)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <1201264166.12870.16.camel@johannes.berg> <alpine.LFD.1.00.0801250753240.14161@hp.linux-foundation.org> <200801251723.58891.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 25 Jan 2008, Michael Buesch wrote:
> 
> If we are talking about what's sane or not...
> It's trivial to fix this in the firmware, like sane vendors like
> Broadcom do.

You just showed your total disregard for any sanity by calling broadcom 
"sane".

Quite frankly, Broadcom is probably the single worst chip manufacturer in 
terms of both bugginess of the silicon itself and in terms of lack of 
support.

> Architectures that can't do unaligned access are heavily used in
> wireless embedded routers. So we are not going to pay a huge
> price there so just one vendor doesn't have to fix his firmware.

.. and you also showed that you didn't even read my email and the options 
I outlined. The fact is, the Intel wireless chipset only works with x86 
CPU's. There is absolutely zero "price" on crap CPU's, because they are 
simply not relevant to this driver.

		Linus
