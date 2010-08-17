Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32965 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab0HQUjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 16:39:15 -0400
Received: by qwh6 with SMTP id 6so6471790qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 13:39:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100817212825.6f5ecb66@boulder.homenet>
References: <AANLkTimMhW7OX3DT7A3EDNaOnr577KmTv5w9C_mz19TG@mail.gmail.com>
 <20100816204154.5100b604@boulder.homenet> <20100816233544.40f0e1d4@boulder.homenet>
 <4C69CF85.2020809@lwfinger.net> <20100817010923.589d8063@boulder.homenet>
 <20100817011455.4919cfbb@boulder.homenet> <4C69DF79.2020900@lwfinger.net>
 <20100817132337.01392797@boulder.homenet> <20100817212825.6f5ecb66@boulder.homenet>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 17 Aug 2010 22:38:54 +0200
Message-ID: <AANLkTikFi5Nid47WUFYgMGBBq8SY87VizPHiSzv7ZLct@mail.gmail.com>
Subject: Re: [RFT] BCM4312 users with DMA errors, please test!
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 17, 2010 at 10:28 PM, Chris Vine
<chris@cvine.freeserve.co.uk> wrote:
> On Tue, 17 Aug 2010 13:23:37 +0100
> Chris Vine <chris@cvine.freeserve.co.uk> wrote:
>> Reverting to 2.6.35.1 solves this.  Probably 2.6.36-rc1 would be OK as
>> well.  I might later today try the ssb patch on the 2.6.35.1 kernel,
>> but it doesn't look as if it solves the DMA errors.  However,
>> yesterday's tests clearly aren't conclusive about anything.
>
> I have applied the patch to 2.6.35.1, and it does not appear to have
> any effect on the DMA errors.
>
> Chris
>
>
>

Thanks! That's what I was ultimately interested in. So, we now know
it's not the SERDES workaround. (Or maybe it needs to be performed at
a different time.)
