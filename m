Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3505 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab2BCV6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 16:58:06 -0500
Message-ID: <4F2C5847.4020603@broadcom.com> (sfid-20120203_225811_922036_38C7705D)
Date: Fri, 3 Feb 2012 13:57:27 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Daniel Smith" <viscous.liquid@gmail.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: Re: Broadcom brcm80211 monitor mode
References: <CADGLRPncrRHRFUXHfUWM31d0THzuJx_2a=+aifcFR39jT7WpLA@mail.gmail.com>
 <4F2C4BB2.1070207@broadcom.com>
 <CADGLRPn93_vjD00sGpof5dSg3Vpyf3iOREh+mU8S9tZDDj5=rg@mail.gmail.com>
In-Reply-To: <CADGLRPn93_vjD00sGpof5dSg3Vpyf3iOREh+mU8S9tZDDj5=rg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/2012 01:28 PM, Daniel Smith wrote:
> Hey Arend,
>
> On Fri, Feb 3, 2012 at 4:03 PM, Arend van Spriel<arend@broadcom.com>  wrote:
>> On 02/03/2012 09:01 PM, Daniel Smith wrote:
>>> Hi
>>>
>>> I see on the "To be done list" for both the fullmac and softmac chips
>>> is to add support for monitor mode. I was wondering how realistic is
>>> that task. If it is definitely going to occur, any idea what it will
>>> support, e.g. capturing management frames. Also any kind of hint what
>>> kind of time frame are you looking at? Any info would be greatly
>>> appreciated.
>>>
>>> V/r,
>>> Daniel Smith
>>>
>>
>> For brcmsmac it has already been done just using the radiotap
>> functionality. I did not implement it, but I think this functionality is
>> provided by cfg80211. Not sure if that is sufficient info.
>>
>> Gr. AvS
>>
>
> Thanks for the quick response and that is excellent to hear! Is there
> any word on the fullmac side? I am actually interested in both as I
> will be dealing with both standard and mobile devices. Due to the
> popularity of your chips, it would be great if I could add Broadcom to
> my list of viable chips.
>
> Thanks!
> dps
>

Monitor mode is not supported in fullmac at the moment. I am afraid we 
don't have an ETA as well. But if for mobile devices you mean Android 
devices using Broadcom wifi chipset, current Android driver does have 
monitor mode support.

Franky

