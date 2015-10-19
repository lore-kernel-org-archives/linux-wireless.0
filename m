Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:27839 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbbJSBc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 21:32:28 -0400
Subject: Re: [PATCH V2 01/40] staging: wilc1000: rename ssidLen of struct
 join_bss_param
To: Greg KH <gregkh@linuxfoundation.org>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
 <20151017045907.GA6504@kroah.com>
CC: <devel@driverdev.osuosl.org>, <austin.shin@atmel.com>,
	<linux-wireless@vger.kernel.org>, <Nicolas.FERRE@atmel.com>,
	<adel.noureldin@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <5624481A.2050405@atmel.com> (sfid-20151019_033256_699866_AE297754)
Date: Mon, 19 Oct 2015 10:32:10 +0900
MIME-Version: 1.0
In-Reply-To: <20151017045907.GA6504@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 17일 13:59, Greg KH wrote:
> On Fri, Oct 16, 2015 at 01:37:31PM +0900, Tony Cho wrote:
>> From: Leo Kim <leo.kim@atmel.com>
>>
>> This patch renames ssidLen of struct join_bss_param to ssid_len
>> to avoid CamelCase naming convention.
>>
>> Signed-off-by: Leo Kim <leo.kim@atmel.com>
>> Signed-off-by: Tony Cho <tony.cho@atmel.com>
>> ---
>>   drivers/staging/wilc1000/host_interface.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> Doesn't apply, I missed that you sent this as v2, why did you do that?
> What was wrong with v1?

This series of V2 includes Dan's suggestion, we don't have to add one blank line between malloc and null check if-statement.

In addition, some of global variables are declared as "static" because they are used in only one file so kbuild test robot indicated they had better be declared as "static".

So, I sent the series of them as V2. I can find the V1 of this series are already accepted so I will later make separate patch for them.

Thanks,

Tony.

> thanks,
>
> greg k-h

