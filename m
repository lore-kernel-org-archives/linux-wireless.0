Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2KFUbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 15:31:00 -0500
Message-ID: <1352233894.8814.10.camel@jlt4.sipsolutions.net> (sfid-20121106_213114_232066_88060714)
Subject: Re: Linux 3.6.5
From: Johannes Berg <johannes@sipsolutions.net>
To: eddie@ehuk.net
Cc: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 06 Nov 2012 21:31:34 +0100
In-Reply-To: <5099669E.2040301@ehuk.net>
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>
	     <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>
	     (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>
	    <509838F4.4010301@ehuk.net>
	   <1352188621.9440.4.camel@jlt4.sipsolutions.net>
	  <50992E0E.3040606@ehuk.net>
	  <1352217244.9440.16.camel@jlt4.sipsolutions.net>
	  <50995E25.6080601@ehuk.net>
	 <1352229634.8814.8.camel@jlt4.sipsolutions.net> <5099669E.2040301@ehuk.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-06 at 19:35 +0000, Eddie Chapman wrote:

> > Right, we're still looking at that. It seems that it's not an ideal
> > solution, the regulatory change I proposed is probably better. Could you
> > check if it helps as well? That is, remove this patch, and apply this
> > one: http://p.sipsolutions.net/8877cbe3440d94b1.txt
> 
> OK, so I've removed 0129f39c7d882289.txt, applied 8877cbe3440d94b1.txt, 
> and I've kept 3a40414f826a8f1096d9b94c4a53ef91b25ba28d applied.
> 
> Rebooted, and happy to report throughput is still good, so 
> 8877cbe3440d94b1.txt also "fixes" it for me.

Great, thanks. I'm not really sure which one to apply, and if we apply
the 8877 one we'll also want to update the reg db (that you aren't
using). A lot of people are in Barcelona right now though, so that might
be a week or so until we can close this.

Thanks for all the testing!

johannes

