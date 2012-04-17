Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4106 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab2DQKeN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 06:34:13 -0400
Message-ID: <4F8D471F.5070901@broadcom.com> (sfid-20120417_123417_931116_21A6A124)
Date: Tue, 17 Apr 2012 12:34:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Frank Kingswood" <frank@kingswood-consulting.co.uk>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic with brcm4313 (kernel 3.2.2)
References: <jgjoab$l54$1@dough.gmane.org>
 <4F2E6C34.6060903@broadcom.com>
 <4F2E9651.5020601@kingswood-consulting.co.uk>
In-Reply-To: <4F2E9651.5020601@kingswood-consulting.co.uk>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2012 03:46 PM, Frank Kingswood wrote:
> On 05/02/12 11:47, Arend van Spriel wrote:
>> On 02/04/2012 06:02 PM, Frank A. Kingswood wrote:
>>
>>> On a new (Samsung 305U1A) laptop with BRCM4313 wireless I have not been
>>> able to use the wireless at all, although occasionally a flicker of life
>>> can be seen in it.
>>>
>>> "iwconfig scan" usually fails to report more than one access point.
>>> Disabling the local AP makes it show up a different one, suggesting it
>>> is actually able to see it but somewhere fails to pass the data along.
>>>
>> Could you sent me the output of 'iwconfig scan' or better 'iw scan'?
>> What is the SSID of the 'local AP'?
>>
> Thanks for picking this up.

>>> Fiddling with NetworkManager produces this kernel panic:
>>>
>> What does 'Fiddling with NetworkManager' mean exactly?
>>
> Hard to say :-)
> I was trying to get NM to first find and then connect to the AP. This is
> not really reproducable, sorry, it took perhaps a dozen attempts.
>
> Frank
>

Sorry for getting back to you after so long. I was looking at some other 
issues with bcm4313 and there was a reference to a message you posted on 
LKML. So I searched my email archive for your name.

I noticed in some log you sent that your regulatory domain is set to GB, 
which makes sense. I submitted a patch [1] last week so could you try 
that and let me know the results.

Gr. AvS

[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/88651

