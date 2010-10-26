Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62851 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab0JZEmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 00:42:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 21:42:37 -0700
Message-ID: <4CC65C42.70604@atheros.com>
Date: Tue, 26 Oct 2010 10:12:42 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [RFC] ath9k: Fix incorrect access of rate flags in RC
References: <1288021004-7315-1-git-send-email-mshajakhan@atheros.com> <AANLkTi=M9AR6ubFfuZb3rDLit_DvrkL14emM7OQYdmSb@mail.gmail.com>
In-Reply-To: <AANLkTi=M9AR6ubFfuZb3rDLit_DvrkL14emM7OQYdmSb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

looks like ,but not very sure Luis,need to consult Senthil and will tell 
you.
thanks,
shafi

On Monday 25 October 2010 10:06 PM, Luis R. Rodriguez wrote:
> On Mon, Oct 25, 2010 at 8:36 AM, Mohammed Shafi Shajakhan
> <mshajakhan@atheros.com>  wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> The index variable to access the rate flags should be obtained from the
>> inner loop counter which corresponds to rate table structure.
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>      
> Is this a stable fix?
>
>    Luis
>    
