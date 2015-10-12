Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11195 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbbJLCNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2015 22:13:20 -0400
Subject: Re: staging: wilc1000: WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
To: Greg KH <gregkh@linuxfoundation.org>,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
References: <5616B60F.7040804@gmail.com> <20151008184724.GA11027@kroah.com>
CC: <johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<chris.park@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
	<linux-kernel@vger.kernel.org>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <561B1730.9050408@atmel.com> (sfid-20151012_041335_783859_213B5E2F)
Date: Mon, 12 Oct 2015 11:13:04 +0900
MIME-Version: 1.0
In-Reply-To: <20151008184724.GA11027@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 09일 03:47, Greg KH wrote:
> On Thu, Oct 08, 2015 at 09:29:35PM +0300, Stanislav Kholmanskikh wrote:
>> Hi!
>>
>> I noticed that drivers/staging/wilc1000/Kconfic defines:
>>
>> config WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
>>          bool "Dynamically allocate memory in real time"
>>          ---help---
>>            This choice supports dynamic allocation of the memory
>>            for the receive buffer. The driver will allocate the RX buffer
>>            when it is required.
>>
>>
>> "MEMROY" looks suspicious. Is it a typo (MEMORY?) or by intent?
> Probably a typo, but be sure to see if it lines up with what the code
> expects before changing anything.
>
> Ideally in the end this option should be removed as the driver should
> only do dynamic allocation, no static allocation should be needed.

I agree with Greg's opinion. The team is now restructuring the driver and they will be removed and changed.

Thanks for your valuable opinion,

Tony.

>
> thanks,
>
> greg k-h

