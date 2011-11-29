Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imr-mb01.mx.aol.com ([64.12.207.164]:36942 "EHLO
	imr-mb01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1K2SAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 13:00:42 -0500
Message-ID: <4ED51DB5.5090202@aol.com> (sfid-20111129_190046_087395_4EF34FD9)
Date: Tue, 29 Nov 2011 13:00:21 -0500
From: AndrewL733 <AndrewL733@aol.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
References: <4ED3A6E8.4050000@aol.com> <CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com> <CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com> <4ED3B33E.8020309@lwfinger.net> <4ED3FA65.7010104@aol.com> <CACna6rw1gEjd_hcX=5hLHt0YwUqDaVBs7_MO50GLKeok57YtVw@mail.gmail.com>
In-Reply-To: <CACna6rw1gEjd_hcX=5hLHt0YwUqDaVBs7_MO50GLKeok57YtVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2011 12:22 AM, Rafał Miłecki wrote:
> 2011/11/28 AndrewL733<AndrewL733@aol.com>:
>> Hi,
>>
>> Thanks for the suggestions.  Nothing solving the problem so far.
>>
>> I meant
>> find /lib/modules -name "b43.ko"
>>
>>
>> What is the point of looking for b43.ko?  It exists for my running kernel.
> I believe b43.ko from compat-wireless should be put in some specific
> subdirectory, probably "extra". AFAIR it's
> /lib/modules/SOMEKERNEL/extra/...
>
> If you can see only default b43.ko, it means compat-wireless didn't
> install successfully.
>
Thanks for your reply.

You are absolutely right.  My Mandriva kernel's name is 
3.1.2-1.1-desktop but the compat-wireless "make install" is installing 
everything in the directory /lib/modules/3.1.2-1-desktop/updates.  The 
path is missing the ".1" before the "-desktop".

I'm not sure why this is happening.  I am running a Mandriva kernel from 
"Cooker" (running Mandriva 2011, which comes with 2.6.38.x, but the 
Macbook Pro 8,2 DVD isn't recognized until the 3.1 kernel.  I also 
compiled my own 3.2-rc3 kernel but then I can't get fglrx to work properly.

The joys of Macs and Linux..

But getting back to b43.  How can I instruct "make install" to put the 
drivers in the correct path?  I'm going to try to just copy everything 
to the correct place and run depmod  and see what happens.  Maybe 
that'll work??

Andy
