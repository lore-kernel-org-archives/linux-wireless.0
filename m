Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:43226 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbYAKUOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 15:14:24 -0500
Received: by ug-out-1314.google.com with SMTP id z38so519384ugc.16
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 12:14:22 -0800 (PST)
Message-ID: <4787CCAF.1030500@gmail.com> (sfid-20080111_201428_589269_A03B1F23)
Date: Fri, 11 Jan 2008 21:08:15 +0100
From: Ronald <ronald645@gmail.com>
Reply-To: ronald645@gmail.com
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: Bcm4311 shuts down on closing lid (intended?)
References: <47866FE6.4010100@gmail.com> <200801102028.43222.mb@bu3sch.de> <4787021F.4020803@gmail.com> <200801111628.26119.mb@bu3sch.de>
In-Reply-To: <200801111628.26119.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Friday 11 January 2008 06:43:59 Ronald wrote:
>>>> On Thursday 10 January 2008 20:20:06 Ronald wrote:
>>>>> Hi,
>>>>>
>>>>> The b43 driver in the linux kernel 2.6.24-rc7 works really good :) . 
>>>>> Keep it up! However, one thing is bugging me: Why does the card stop 
>>>>> sending/receiving packets when I close the lid? Is this behaviour 
>>>>> intended in the new driver? If yes, can I disable it?
>>>> I guess the machine goes to suspend, right?
>>>> You obviously can't use the machine when it's suspended.
>>>>
>>  >Nope, it doesn't go into suspend. With the old driver, I could close 
>>  >the lid and for example SSH into it. Now, that is not possible. I 
>> tried >it with a radio station. It stops playing after a while once I 
>> close >the lid.... . The only thing that changes is that the screen 
>> light >shuts down (but not the card! it worked before when closing the 
>>  >screen!)
> 
> I'm pretty sure there are no lid related routines in the wireless
> driver, though. ;) So the problem must be somewhere else.
> 
> 
Weird >.< I recompiled the kernel with the latest git patch (rc7-git3) 
and it seems fixed. I only removed nl80211 from the configuration. I 
will chech later if this makes the difference....

							Ronald
