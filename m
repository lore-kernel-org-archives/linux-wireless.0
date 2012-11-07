Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39780 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2KGHgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 02:36:23 -0500
Received: by mail-wi0-f172.google.com with SMTP id hq12so5013023wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2012 23:36:21 -0800 (PST)
Date: Wed, 7 Nov 2012 08:36:34 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: eddie@ehuk.net, stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: Linux 3.6.5
Message-ID: <20121107073634.GA6560@kroah.com> (sfid-20121107_083634_884786_236FBE72)
References: <50979D38.6010002@ehuk.net>
 <1352116868.9466.2.camel@jlt4.sipsolutions.net>
 <509838F4.4010301@ehuk.net>
 <1352188621.9440.4.camel@jlt4.sipsolutions.net>
 <50992E0E.3040606@ehuk.net>
 <1352217244.9440.16.camel@jlt4.sipsolutions.net>
 <50995E25.6080601@ehuk.net>
 <1352229634.8814.8.camel@jlt4.sipsolutions.net>
 <5099669E.2040301@ehuk.net>
 <1352233894.8814.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352233894.8814.10.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 06, 2012 at 09:31:34PM +0100, Johannes Berg wrote:
> On Tue, 2012-11-06 at 19:35 +0000, Eddie Chapman wrote:
> 
> > > Right, we're still looking at that. It seems that it's not an ideal
> > > solution, the regulatory change I proposed is probably better. Could you
> > > check if it helps as well? That is, remove this patch, and apply this
> > > one: http://p.sipsolutions.net/8877cbe3440d94b1.txt
> > 
> > OK, so I've removed 0129f39c7d882289.txt, applied 8877cbe3440d94b1.txt, 
> > and I've kept 3a40414f826a8f1096d9b94c4a53ef91b25ba28d applied.
> > 
> > Rebooted, and happy to report throughput is still good, so 
> > 8877cbe3440d94b1.txt also "fixes" it for me.
> 
> Great, thanks. I'm not really sure which one to apply, and if we apply
> the 8877 one we'll also want to update the reg db (that you aren't
> using). A lot of people are in Barcelona right now though, so that might
> be a week or so until we can close this.

I'm in Barcelona all this week, but a nice summary of what I'm supposed
to do here for the stable tree would be great to have when ever you
figure it out, don't wait for me to return, my email queues up just fine :)

thanks,

greg k-h
