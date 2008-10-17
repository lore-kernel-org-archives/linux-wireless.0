Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:36249 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYJQV6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 17:58:37 -0400
Received: by rv-out-0506.google.com with SMTP id k40so773134rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 14:58:35 -0700 (PDT)
Message-ID: <48F90A84.60902@gmail.com> (sfid-20081017_235841_012262_81B6477A)
Date: Fri, 17 Oct 2008 14:58:28 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: stefano.brivio@polimi.it, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: reduce checkpatch.pl errors
References: <48F8E479.30304@gmail.com> <200810172302.38127.mb@bu3sch.de> <48F90564.3040301@gmail.com> <200810172345.52581.mb@bu3sch.de>
In-Reply-To: <200810172345.52581.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Friday 17 October 2008 23:36:36 John Daiker wrote:
>   
>> -		if (1 /*FIXME: the last PSpoll frame was sent successfully */ )
>> +		if (1) /*FIXME: the last PSpoll frame was sent successfully */ {
>>     
>
> Well, go for this, if you're really forced to fix this. ;)
>
>   
>>> One additional thing I'd like you to do.
>>> Do a b43 compile before and after applying the patch.
>>> Keep the b43.ko files for both runs and do an md5sum on them.
>>> Add the results to the commit log. The sums _must_ match.
>>> If they don't, please send the changes that change the actual
>>> binary code in seperate patches.
>>>   
>>>       
>> Will do this next time with updated patch, among other things.
>>     
>
> Thanks. Also make sure to enable all kconfig options.
> (also remove the BROKEN dependencies that some options have,
> if you are changing files related to these options.)
I'm assuming you're debugging and forcing PIO over DMA?
For the BROKEN things, can I just remove 'BROKEN' from the Kconfig 
depends line?
