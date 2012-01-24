Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp12.services.sfr.fr ([93.17.128.68]:50758 "EHLO
	smtp12.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab2AXKfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 05:35:31 -0500
Date: Tue, 24 Jan 2012 11:25:52 +0100 (CET)
From: Milan Bouchet-Valat <nalimilan@club-internet.fr>
Reply-To: Milan Bouchet-Valat <nalimilan@club-internet.fr>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <24107995.140239.1327400752025.JavaMail.www@wsfrf1232> (sfid-20120124_113534_756370_472D7985)
In-Reply-To: <4F1A8C55.6010900@broadcom.com>
References: <1327067694.2590.6.camel@milan> <4F199EAC.3050602@broadcom.com>
 <1327080177.3285.26.camel@milan> <4F1A8C55.6010900@broadcom.com>
Subject: Re: Re: BCM4313 doesn't work after suspend (brcmsmac on
 compat-wireless-next)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le samedi 21 janvier 2012 à 10:58 +0100, Arend van Spriel a écrit :
> I just checked and the suspend/resume patches from Linus were applied on
> January 17th. So you need to pick up the patches (see thread "[0/5]
> bcma/brcmsmac suspend/resume cleanups and fixes" on netdev list).
I just tried the new compat-wireless package built yesterday, and indeed the problem is gone! Funny that I reported it just when it was fixed. I hope it will be backported to 3.2.

Now I've another problem to debug, I'll send a mail soon.

Keep up the good work!
