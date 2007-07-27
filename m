Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:35072 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442AbXG0AEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 20:04:45 -0400
Message-ID: <46A93695.3060909@lwfinger.net>
Date: Thu, 26 Jul 2007 19:04:37 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Subject: Re: A problem with shared interrupts
References: <46a90082./TQABjOfVYW1o6lY%Larry.Finger@lwfinger.net> <200707270042.27917.mb@bu3sch.de>
In-Reply-To: <200707270042.27917.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> I neither think this is the correct solution, nor do I think that this
> is the way bcm43xx-softmac does it. This would always return HANDLED, right?
> regardless if the IRQ was for bcm43xx or not. I _do_ think that the bug is
> in the driver sharing the IRQ with bcm43xx.
> 

I misread the bcm43xx-mac80211 code from Linville's tree. clearly my patch is wrong. I'll have to 
find the differences between the two trees in drivers that share that IRQ. Fortunately, it is only 
yenta and bcm4301.

Larry


