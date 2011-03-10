Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab1CJJ3L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 04:29:11 -0500
Date: Thu, 10 Mar 2011 10:27:54 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Subject: Re: Problem with BCM943224
Message-ID: <20110310092753.GA2323@redhat.com>
References: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>
 <4D77A06E.3050902@lwfinger.net>
 <AANLkTinYp64QZ5o1-=xP_ehVhLPwDLR+gQnQk7MADHFA@mail.gmail.com>
 <4D77AD18.60804@lwfinger.net>
 <AANLkTingWDXtuxWtQwkVFbhOnfHmAPsp1KsyQWJcRBqR@mail.gmail.com>
 <4D77B4B6.8030603@lwfinger.net>
 <AANLkTinEC5b6-vP_zc2RE2Juc8YFx8nkEK7isvQw+UVX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTinEC5b6-vP_zc2RE2Juc8YFx8nkEK7isvQw+UVX@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 09, 2011 at 07:04:01PM +0100, Rafał Miłecki wrote:
> Do you think buying some more expensive adapter could help? The newest
> offered by hwtools seems to be:
> http://www.hwtools.net/Adapter/MP2H.html
> (ver 2.2). It is not so expensive at all, $15 without shipping.
> 
> I've already written to them with question about BCM943224
> compatibility (they don't have that chipset on their list).
> 
> Stanisław: I remember you telling that you have such a adapter. Do you
> maybe have access to some BCM943224/BCM94313 card? Could you test that
> combo for me, please?

I have new laptop at home with some bcm device, don't know exacly what
version, but most likely is somehting that you listed or similar. I'll
test and let you now next week. I planned to replace wireless adapter
on that laptop anyway.

> The only other solution I can see is to buy motherboard with mini PCIe
> slot. There are some *D410P* (BLKD410PT, BOXD410PT, BLKD410PTL,
> D410PT) and D510MO having such a slow (and Atom CPU.... :/). Kernel
> compilation would be disaster but I think I could live with that.

If you configure out all unnedded drivers/features, compilation time
should not be so bad.

> Do
> you think such a boards would be compatible with Broadcom's cards?

I think any miniPCIe host should be compatibile with any miniPCIe device.

Cheers
Stanislaw
