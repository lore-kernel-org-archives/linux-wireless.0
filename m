Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36993 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323Ab2FOVv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 17:51:58 -0400
Received: by eaak11 with SMTP id k11so1062730eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 14:51:56 -0700 (PDT)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Schrober <franzschrober@yahoo.de>
Subject: Re: ath9k bug in country domain handling
Date: Fri, 15 Jun 2012 23:51:54 +0200
Message-ID: <1425745.oeb9uPtGCl@sylvesterjr.cmi.ua.ac.be> (sfid-20120615_235201_230700_266518A2)
In-Reply-To: <3396938.ZAv4RZqcUo@sven-desktop.home.narfation.org>
References: <9709270.9fbk3VIit7@sylvesterjr.cmi.ua.ac.be> <3396938.ZAv4RZqcUo@sven-desktop.home.narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 June 2012 21:00:23 Schrober wrote:
> On Wednesday 13 June 2012 13:17:49 Erwin Van de Velde wrote:
> > Dear all,
> > 
> > I have 802.11n cards with an atheros chipset with no default country
> > domain. Upon initialization, crda is set to US domain, after which I try
> > to change it to another domain, the driver only accepts further
> > limitations: i.e. if a channel is allowed in the US but not in Belgium,
> > it is disabled, but the other way round: if a channel is not allowed in
> > the US, but is allowed in Belgium it is not enabled.
> 
> That is not a bug, but something we call restriction.
> 

What? It definitely is a bug, since it restricts something that should not be 
restricted in Belgium. I am talking about channels you are allowed to use in 
Belgium, which get disabled by the driver. How can this not be a bug?
If I call crda for the BE domain, I expect to get _all_ channels that are 
allowed in Belgium, not just some.

Regards,
Erwin

