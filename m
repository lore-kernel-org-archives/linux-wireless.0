Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44898 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaDRNrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 09:47:52 -0400
Received: by mail-wg0-f52.google.com with SMTP id k14so526537wgh.23
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2014 06:47:50 -0700 (PDT)
Message-ID: <53512D04.5070808@gmail.com> (sfid-20140418_154755_449057_977795FD)
Date: Fri, 18 Apr 2014 16:47:48 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Alexander Monakov <amonakov@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi null pointer dereference
References: <CABtfrpCY7cOkw-dPwv5=8YxNAd4idpvyQV9zL3gU9RQiaSxpCw@mail.gmail.com>	<CANUX_P0fLsNx+c7VnVggbZSGvnarF3inP7M115p-up3DfXyuuA@mail.gmail.com>	<CABtfrpDYL55KJ=Ehr0E8wNtLMbcMmJohz3oA9BgtriMv7hw_qw@mail.gmail.com> <CABtfrpAY7OvH38E_+4QLGwWr2iQB1Rq45zzxdZwdM2Q7rc1NpA@mail.gmail.com> <5350B340.9020201@gmail.com>
In-Reply-To: <5350B340.9020201@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/18/2014 08:08 AM, Emmanuel Grumbach wrote:
> Hi,
> 
> On 04/17/2014 11:56 PM, Alexander Monakov wrote:
>> Emmanuel,
>>
>> I'm curious about the plans w.r.t this fix; is it going to
>> iwlwifi-next.git?  Thanks again.
>>
> 
> It will go to iwlwifi-fixes.
> 

I have to say that this is really strange - I must miss something. It looks like the ISR is called even before it is requested...
So I definitely want to understand what is happening here before applying the fix.
