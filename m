Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59881 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab0AZOZN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 09:25:13 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NZmLp-0004QW-RJ
	for linux-wireless@vger.kernel.org; Tue, 26 Jan 2010 15:25:06 +0100
Received: from socp-b.scsnet.com ([146.126.51.51])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 15:25:05 +0100
Received: from evolker by socp-b.scsnet.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 15:25:05 +0100
To: linux-wireless@vger.kernel.org
From: Eric Volker <evolker@gmail.com>
Subject: Re: b43 driver hang workaround
Date: Tue, 26 Jan 2010 14:23:16 +0000 (UTC)
Message-ID: <loom.20100126T144339-926@post.gmane.org>
References: <1264472821.2691.0.camel@fwdell4550> <933379711001260339p6c31f345xde472c6052d4c81f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Giuseppe Fontana <gfontana13@...> writes:

> 
> 2010/1/26 Eric Volker <evolker@...>:
> > Thought I'd post my workaround for the issue I've been experiencing. My
> > setup is as follows: Ubuntu 9.10 x86 and a BCM4318 in AP mode.
> 
> Hi Eric. So, if I'm not wrong, you successfully connected to a wi-fi
> ad-hoc network with BCM4318 and Ubuntu 9.10. I tried with my Acer 5024
> with CM4318 without success (if you want you can take a look at my
> thread "Broadcom BCM4318 AirForceOne issue - Ubuntu 9.10 on Acer
> Aspire 5024wlmi"). Are you using a laptop too? What's your wifi
> adapter model?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Sorry, I think I may have replied to this off-list. I'm using a BCM4318 PCI 
card as an access point. I've got it in mixed wpa/wpa2 mode and have had it up 
for a couple of days so far. It's a Bufflo card, though I'm not sure of the 
exact model. It is in a desktop, a Dell Dimension 4550. Thus far it has vastly 
outperformed my old DLink DIR-655. I'm quite happy, though it took me about a 
wink to iron out several kinks. I also had to use "eapol_version=1" in 
hostapd.conf to get everything working properly. If you need any further 
details, please let me know.

Eric


