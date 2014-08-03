Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56642 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaHCPCb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2014 11:02:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1XDxIr-0007lU-9V
	for linux-wireless@vger.kernel.org; Sun, 03 Aug 2014 17:02:29 +0200
Received: from p5dd56dbd.dip0.t-ipconnect.de ([93.213.109.189])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2014 17:02:29 +0200
Received: from Manuel.Spam by p5dd56dbd.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2014 17:02:29 +0200
To: linux-wireless@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: Problems with rtl8192cu driver (disassociated from ... (Reason:
 2))
Date: Sun, 03 Aug 2014 17:02:18 +0200
Message-ID: <lrlitq$9na$1@ger.gmane.org> (sfid-20140803_170254_145525_8D1694ED)
References: <lrjs9d$s51$1@ger.gmane.org> <1407068037.29448.12.camel@w7>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <1407068037.29448.12.camel@w7>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/03/2014 02:13 PM, Steve Brown wrote:
> I had a similar problem with this driver.

Thank you very much for this feedback.

Searching for 'rtl8192cu "Reason 2"' on the net reveals more cases for 
such problems. For example:

https://dev.openwrt.org/ticket/15342
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1220007
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=661860

So in other words: Seems like rtl8192cu driver is broken.

And as I am unable to fix it, I'll have to try to find a WLAN interface 
with better Linux support.

> After a while, the aggregation
> session seems to hang. If I connect as b/g, no problem. If I disable
> aggregation by patching the driver, again the problem goes away.

What exactly is "b/g"?

Greetings,

Manuel

