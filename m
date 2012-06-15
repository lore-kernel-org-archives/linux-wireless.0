Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm8.bullet.mail.ukl.yahoo.com ([217.146.182.249]:22603 "HELO
	nm8.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757323Ab2FOTFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 15:05:49 -0400
From: Schrober <franzschrober@yahoo.de>
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k bug in country domain handling
Date: Fri, 15 Jun 2012 21:00:23 +0200
Message-ID: <3396938.ZAv4RZqcUo@sven-desktop.home.narfation.org> (sfid-20120615_210552_561731_757DCEE9)
In-Reply-To: <9709270.9fbk3VIit7@sylvesterjr.cmi.ua.ac.be>
References: <9709270.9fbk3VIit7@sylvesterjr.cmi.ua.ac.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 13 June 2012 13:17:49 Erwin Van de Velde wrote:
> Dear all,
> 
> I have 802.11n cards with an atheros chipset with no default country domain.
> Upon initialization, crda is set to US domain, after which I try to change
> it to another domain, the driver only accepts further limitations: i.e. if
> a channel is allowed in the US but not in Belgium, it is disabled, but the
> other way round: if a channel is not allowed in the US, but is allowed in
> Belgium it is not enabled.

That is not a bug, but something we call restriction.

Regards,
Franz
