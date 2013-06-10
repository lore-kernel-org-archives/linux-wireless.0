Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:47844 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab3FJJkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 05:40:43 -0400
Received: by mail-ob0-f172.google.com with SMTP id wo10so9788146obc.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jun 2013 02:40:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51A112FC.8060100@hauke-m.de>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
	<CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com>
	<alpine.DEB.2.02.1305132025560.1278@kelly.ryd.net>
	<20130524164922.GA2175@tuxdriver.com>
	<alpine.DEB.2.02.1305252058060.1282@kelly.ryd.net>
	<51A112FC.8060100@hauke-m.de>
Date: Mon, 10 Jun 2013 11:40:43 +0200
Message-ID: <CACna6rxgx7r1ojK2EEeH30uLE=0TYmo8PChfS3+1u-Qx+JG21Q@mail.gmail.com> (sfid-20130610_114047_099384_5C78DBE0)
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Thommy Jakobsson <thommyj@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	m@bues.ch, piotras@gmail.com, Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/5/25 Hauke Mehrtens <hauke@hauke-m.de>:
> On 05/25/2013 09:02 PM, Thommy Jakobsson wrote:
>>
>>
>> On Fri, 24 May 2013, John W. Linville wrote:
>>
>>> Ping?  Should I drop this one?
>>>
>> Still working great on my device, so from that I think we should go for
>> it. But it would be great if Rafal (or someone) tested it on some other
>> hardware as well.
>>
>> //Thommy
>
> This is included in OpenWrt for ~4 weeks now and I haven't read of
> anybody complaining about any new problems introduced by this patch or
> something which looks like the DMA under run.
> I am also for adding this to the kernel.

Yeah, I saw some ticker on OpenWrt with very positive feedback. Nice
we have that issue worked out.

I'm still curious how Broadcom handles that without this interrupt.
Anyway, glad we found our way :)

-- 
Rafał
