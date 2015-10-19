Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:28878 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbbJSBoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 21:44:08 -0400
Subject: Re: [PATCH 35/40] staging: wilc1000: rename variable s32Error
To: Greg KH <gregkh@linuxfoundation.org>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
 <1444883121-31757-35-git-send-email-tony.cho@atmel.com>
 <20151017045649.GA32158@kroah.com>
CC: <devel@driverdev.osuosl.org>, <rachel.kim@atmel.com>,
	<chris.park@atmel.com>, <austin.shin@atmel.com>,
	<linux-wireless@vger.kernel.org>, <johnny.kim@atmel.com>,
	<Nicolas.FERRE@atmel.com>, <adel.noureldin@atmel.com>,
	<leo.kim@atmel.com>, <adham.abozaeid@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <56244AD6.3010905@atmel.com> (sfid-20151019_034412_376923_AE3D3285)
Date: Mon, 19 Oct 2015 10:43:50 +0900
MIME-Version: 1.0
In-Reply-To: <20151017045649.GA32158@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 17일 13:56, Greg KH wrote:
> On Thu, Oct 15, 2015 at 01:25:16PM +0900, Tony Cho wrote:
>> From: Leo Kim <leo.kim@atmel.com>
>>
>> This patch renames variable s32Error to result
>> to avoid CamelCase naming convention.
>>
>> Signed-off-by: Leo Kim <leo.kim@atmel.com>
>> Signed-off-by: Tony Cho <tony.cho@atmel.com>
>> ---
>>   drivers/staging/wilc1000/host_interface.c | 784 ++++++++++++++----------------
>>   1 file changed, 371 insertions(+), 413 deletions(-)
> This patch doesn't apply, so I stopped in the series here, please rebase
> and resend the rest of this series.

I will rebase and send them again.

Thanks,

Tony.

>
> thanks,
>
> greg k-h

