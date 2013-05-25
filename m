Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33778 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab3EYUhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 May 2013 16:37:05 -0400
Received: by mail-ob0-f176.google.com with SMTP id wp18so6728313obc.35
        for <linux-wireless@vger.kernel.org>; Sat, 25 May 2013 13:37:04 -0700 (PDT)
Message-ID: <51A120EE.40008@lwfinger.net> (sfid-20130525_223710_085316_D7FCAF5B)
Date: Sat, 25 May 2013 15:37:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	Thommy Jakobsson <thommyj@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlYw==?= =?UTF-8?B?a2k=?=
	<zajec5@gmail.com>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, piotras@gmail.com
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net> <CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com> <alpine.DEB.2.02.1305132025560.1278@kelly.ryd.net> <20130524164922.GA2175@tuxdriver.com> <alpine.DEB.2.02.1305252058060.1282@kelly.ryd.net> <51A112FC.8060100@hauke-m.de> <20130525214223.4e69a772@milhouse>
In-Reply-To: <20130525214223.4e69a772@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2013 02:42 PM, Michael Büsch wrote:
> On Sat, 25 May 2013 21:37:32 +0200
> Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
>> On 05/25/2013 09:02 PM, Thommy Jakobsson wrote:
>>>
>>>
>>> On Fri, 24 May 2013, John W. Linville wrote:
>>>
>>>> Ping?  Should I drop this one?
>>>>
>>> Still working great on my device, so from that I think we should go for
>>> it. But it would be great if Rafal (or someone) tested it on some other
>>> hardware as well.
>>>
>>> //Thommy
>>
>> This is included in OpenWrt for ~4 weeks now and I haven't read of
>> anybody complaining about any new problems introduced by this patch or
>> something which looks like the DMA under run.
>> I am also for adding this to the kernel.
>
> I'm probably missing something, but isn't this patch already in Linus' tree?
> It's in stable review after all.

The patch is in wireless-testing with John's s-o-b, and in the mainline tree 
with the same annotation.

It has been working OK here, but my devices did not show underrun.

Larry


