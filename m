Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:59345 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYILIdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 04:33:21 -0400
Received: by ey-out-2122.google.com with SMTP id 6so312901eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2008 01:33:19 -0700 (PDT)
Message-ID: <7c8826910809120133o13c744d0pbfae5a18dd72787f@mail.gmail.com> (sfid-20080912_103325_863697_42B32BF4)
Date: Fri, 12 Sep 2008 01:33:19 -0700
From: "Mike Cui" <cuicui@gmail.com>
To: "Nadav Kavalerchik" <nadavkav@gmail.com>
Subject: Re: BMC4310 support (03f0:171d)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4219988b0809091241l565fa8fcpebe2fb552782c4d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4219988b0809011331j4acb1582u3239218c6b7ff573@mail.gmail.com>
	 <4219988b0809011349i640d36e0p497eb8cefe303d0@mail.gmail.com>
	 <200809012333.58897.mb@bu3sch.de>
	 <4219988b0809091240s970c580k763054a56ef740b3@mail.gmail.com>
	 <4219988b0809091241l565fa8fcpebe2fb552782c4d4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What's the PCI ID? I have a BCM 4315 which is misidentified as BCM4310
by lspci. In any case,  Dell releases NDIS 5.1 drivers for broadcom,
while HP doesn't. Try googling for Dell wireless 1395. It works for
me.


On Tue, Sep 9, 2008 at 12:41 PM, Nadav Kavalerchik <nadavkav@gmail.com> wrote:
>  anything i can do to help ?
>
>  ndiswrapper can handle the vista drivers ver 6.1 so i am stuck :-(
>
>  throw me a bone :-)
>
>
>> On Tue, Sep 2, 2008 at 12:33 AM, Michael Buesch <mb@bu3sch.de> wrote:
>>>
>>> On Monday 01 September 2008 22:49:20 Nadav Kavalerchik wrote:
>>> > i just got a new HP tx2520ej tablet laptop with a BCM4310 wlan
>>> > it is identified as Vendor : 03f0  , Product : 171d
>>> >
>>> > any chance i can try a development version that might work ?
>>>
>>> no
>>>
>>>
>>> --
>>> Greetings Michael.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
