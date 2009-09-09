Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:45812 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZIIH4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 03:56:55 -0400
Received: by ewy2 with SMTP id 2so3466586ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 00:56:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909081638.36897.mb@bu3sch.de>
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de>
Date: Wed, 9 Sep 2009 15:56:57 +0800
Message-ID: <a8e1da0909090056q722057d8m4b5da8afbcb7d975@mail.gmail.com>
Subject: Re: b43 dma error
From: Dave Young <hidave.darkstar@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linville@tuxdriver.com, netrolller.3d@gmail.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 8, 2009 at 10:38 PM, Michael Buesch<mb@bu3sch.de> wrote:
> On Tuesday 08 September 2009 15:47:32 Dave Young wrote:
>> I tested wireless-testing b43 driver, but got "Fatal DMA error"
>> then the controller keep restarting...
>>
>> Please tell what I can provide or test, Thanks.
>
> Is this a regression? If so, please bisect.

Not sure, It's the first time for me to use b43 with the lp-phy
because I happend to know it is supported now.

If it's a regression I can do bisection.

>
> --
> Greetings, Michael.
>



-- 
Regards
dave
