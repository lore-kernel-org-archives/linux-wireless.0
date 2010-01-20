Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:37560 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab0ATKpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 05:45:14 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NXY3f-0004cD-79
	for linux-wireless@vger.kernel.org; Wed, 20 Jan 2010 11:45:07 +0100
Received: from ppp85-141-66-119.pppoe.mtu-net.ru ([85.141.66.119])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 11:45:07 +0100
Received: from passshok by ppp85-141-66-119.pppoe.mtu-net.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 11:45:07 +0100
To: linux-wireless@vger.kernel.org
From: Pavel Ulpi <passshok@gmail.com>
Subject: Re: ath5k: 2.6.32-rc6 &quot;no further txbuf available, dropping packet&quot;
Date: Wed, 20 Jan 2010 10:39:55 +0000 (UTC)
Message-ID: <loom.20100120T113718-823@post.gmane.org>
References: <4AF99EF9.4040408@nets.rwth-aachen.de> <b6c5339f0911102013k20d927d3mc021d25bf6703303@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@...> writes:

> Yes, there is a good reason (there are no buffers for the hardware to
> play with).  Actually mac80211 tx is never supposed to return anything
> but TX_OK.
> 
> Try this patch (it needs work which is why it's not upstream yet):
> 
> http://patchwork.kernel.org/patch/56785/
> 


I'm using the same configuration. This patch solved the problem for me in AP
mode too.

