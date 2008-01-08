Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:8296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbYAHGDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 01:03:41 -0500
Received: by fg-out-1718.google.com with SMTP id e21so4427502fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2008 22:03:38 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Tue, 8 Jan 2008 06:03:14 +0000
Cc: "Kalle Valo" <kalle.valo@nokia.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <200801022002.29262.IvDoorn@gmail.com> <200801041709.12043.chris2553@googlemail.com>
In-Reply-To: <200801041709.12043.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801080603.14619.chris2553@googlemail.com> (sfid-20080108_060343_906479_572B358A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 January 2008, Chris Clayton wrote:
> On Wednesday 02 January 2008, Ivo van Doorn wrote:
>
> <snip>
>
> > On Wednesday 02 January 2008, Chris Clayton wrote:
> > > Ah, does the patch I have applied and am running need enhancement,
> > > please?
>
> Thanks, I'll run 2.6.24-rc6-git10 with this patch over the weekend and let
> you know if there are any problems

OK, I've been running 2.6.24-rc6-git kernels (rc7 last night) with the patch 
applied and my wireless connection has been fine. So here's my

Tested-by: Chris Clayton <chris2553@googlemail.com>

Thanks

>
> Chris
>
> > ---
> >
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c
> > b/drivers/net/wireless/rt2x00/rt2x00dev.c index ff399f8..3c10a68 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> > +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
>
> <snip>



-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
