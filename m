Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57692 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab1G2QHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 12:07:46 -0400
Received: by fxh19 with SMTP id 19so2411588fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 09:07:45 -0700 (PDT)
Message-ID: <4E32DAC6.7030308@gmail.com> (sfid-20110729_180749_792189_724BE704)
Date: Fri, 29 Jul 2011 18:07:34 +0200
From: p4u <hakais@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: IBSS channel support
References: <4E32D144.6050304@gmail.com> <1311954873.3084.2.camel@dcbw.foobar.com>
In-Reply-To: <1311954873.3084.2.camel@dcbw.foobar.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks.
I think I can use it

On 29/07/11 17:54, Dan Williams wrote:
> On Fri, 2011-07-29 at 17:27 +0200, p4u wrote:
>> Hi,
>> This is my first mail to this list, I'm Pau from Barcelona working in
>> guifi.net (wireless community)
>> First of all I want to say thank you guys for your amazing job :-)
>>
>> Now, I have a little question. Using command "iw phy phy0 info" I can
>> see that IBSS mode is only avaiable in some channels for 5ghz spectrum.
>> I have been looking for information about it, but I cannot find from
>> what depends if some channel can by used in IBSS mode or not. So I think
>> it depends on the driver and on the regdomain, is it right?
> Yes.
>
>> Also I'm working in some scripts, and I need to know if a channel has
>> IBSS support or not. The only way I found is with iw command, but pharse
>> this data is very dirty. Furthermore I can read in the end of iw help:
>>
>> "Do NOT screenscrape this tool, we don't consider its output stable."
>>
>> So I need another way to get this information. Any idea?
> Couldn't you use the CRDA database?  That's got bits that indicate
> whether or not some channels allow IBSS in your domain or not.
>
> http://wireless.kernel.org/download/wireless-regdb/
>
> Dan
>
>


-- 
./p4u

