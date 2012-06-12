Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43751 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab2FLKRv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 06:17:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SeOAU-0002Oh-D1
	for linux-wireless@vger.kernel.org; Tue, 12 Jun 2012 12:17:46 +0200
Received: from 194.42.38.169 ([194.42.38.169])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 12:17:46 +0200
Received: from contact by 194.42.38.169 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 12:17:46 +0200
To: linux-wireless@vger.kernel.org
From: Antonis Hadjiantonis <contact@antonis.mobi>
Subject: Re: ath9k rate control statistics not updated for UDP
Date: Tue, 12 Jun 2012 10:17:30 +0000 (UTC)
Message-ID: <loom.20120612T112824-220@post.gmane.org> (sfid-20120612_121755_505846_05FD9356)
References: <loom.20120611T152810-2@post.gmane.org> <4FD63078.9000808@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Ben Greear <greearb@...> writes:

> Your UDP traffic may be completely uni-directional, so no packets
> are ever received.  Maybe try setting up a bi-directional traffic
> flow?
> 
> Ben

Thanks Ben, indeed UDP traffic was uni-directional from client to 
server on the wireless AP, so the bidirectional flag did the trick!

Would appreciate some input on a few more questions below:

So, if I got it right, rate control and its statistics refer to 
traffic sent from the AP to stations, i.e. only outgoing/transmitted traffic ?

Also, does this mean that the uplink and downlink rates of a session
 between an AP and a Station are independent?

Finally, is there any way for the AP to control the uplink rate its
 stations use, or is it up to each station to use appropriate RC algorithms? 

Looking forward to your replies,

Thanks
Antonis

