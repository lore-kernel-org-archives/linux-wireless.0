Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20747 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbJWINY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 04:13:24 -0400
Subject: Re: [PATCH 05/28] staging: wilc1000: wilc_handle_isr: add argument
 wilc to wilc_handle_isr
To: Dan Carpenter <dan.carpenter@oracle.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
 <1445578124-31486-5-git-send-email-glen.lee@atmel.com>
 <20151023065703.GV7340@mwanda> <5629E367.1000006@atmel.com>
 <20151023075253.GA7289@mwanda>
CC: Glen Lee <glen.lee@atmel.com>, <gregkh@linuxfoundation.org>,
	<devel@driverdev.osuosl.org>, <austin.shin@atmel.com>,
	<linux-wireless@vger.kernel.org>, <Nicolas.FERRE@atmel.com>,
	<adel.noureldin@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <5629EC11.40507@atmel.com> (sfid-20151023_101346_100137_CA5D96DF)
Date: Fri, 23 Oct 2015 17:13:05 +0900
MIME-Version: 1.0
In-Reply-To: <20151023075253.GA7289@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 23일 16:52, Dan Carpenter wrote:
> On Fri, Oct 23, 2015 at 04:36:07PM +0900, Tony Cho wrote:
>> In addition, the function parameter names will be wilc
>> for the variable of struct wilc.
>>
>> The "wl" is local variable naming as well.
> So if it is a parameter it is wilc but if it is a local variable then it
> is wl?  That seems like an arbitrary meaningless distinction.  It just
> makes searching harder and complicates things for no reason.

I will be on the business trip for the time being so let me ask Glen to

reconsider your concerns to apply your opinion to coming patches.

I always appreciate your guide and reviews because learning valuable things from you.

Thanks,

Tony.

>
> regards,
> dan carpenter
>

