Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:33940 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZIJB2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 21:28:49 -0400
Received: by ey-out-2122.google.com with SMTP id 25so1346319eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 18:28:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a8e1da0909090056q722057d8m4b5da8afbcb7d975@mail.gmail.com>
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de>
	 <a8e1da0909090056q722057d8m4b5da8afbcb7d975@mail.gmail.com>
Date: Thu, 10 Sep 2009 09:28:51 +0800
Message-ID: <a8e1da0909091828u20b0eadasc471093036a312ad@mail.gmail.com>
Subject: Re: b43 dma error
From: Dave Young <hidave.darkstar@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linville@tuxdriver.com, netrolller.3d@gmail.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry.Finger@lwfinger.net, daikerjohn@gmail.com, akamoto@ml1.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 9, 2009 at 3:56 PM, Dave Young<hidave.darkstar@gmail.com> wrote:
> On Tue, Sep 8, 2009 at 10:38 PM, Michael Buesch<mb@bu3sch.de> wrote:
>> On Tuesday 08 September 2009 15:47:32 Dave Young wrote:
>>> I tested wireless-testing b43 driver, but got "Fatal DMA error"
>>> then the controller keep restarting...
>>>
>>> Please tell what I can provide or test, Thanks.
>>
>> Is this a regression? If so, please bisect.
>
> Not sure, It's the first time for me to use b43 with the lp-phy
> because I happend to know it is supported now.
>
> If it's a regression I can do bisection.

Add larry/john/Markus to cc-list

News:

With following config option set to y, b43 works happily now.
CONFIG_B43_FORCE_PIO=y

>
>>
>> --
>> Greetings, Michael.
>>
>
>
>
> --
> Regards
> dave
>



-- 
Regards
dave
