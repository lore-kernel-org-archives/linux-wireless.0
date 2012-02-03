Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3624 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab2BCViX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 16:38:23 -0500
Message-ID: <4F2C53C3.2050001@broadcom.com> (sfid-20120203_223829_021639_42099165)
Date: Fri, 3 Feb 2012 22:38:11 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Daniel Smith" <viscous.liquid@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: Broadcom brcm80211 monitor mode
References: <CADGLRPncrRHRFUXHfUWM31d0THzuJx_2a=+aifcFR39jT7WpLA@mail.gmail.com>
 <4F2C4BB2.1070207@broadcom.com>
 <CADGLRPn93_vjD00sGpof5dSg3Vpyf3iOREh+mU8S9tZDDj5=rg@mail.gmail.com>
In-Reply-To: <CADGLRPn93_vjD00sGpof5dSg3Vpyf3iOREh+mU8S9tZDDj5=rg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/2012 10:28 PM, Daniel Smith wrote:
> Hey Arend,
> 
> On Fri, Feb 3, 2012 at 4:03 PM, Arend van Spriel <arend@broadcom.com> wrote:
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
> t
> Thanks for the quick response and that is excellent to hear! Is there
> any word on the fullmac side? I am actually interested in both as I
> will be dealing with both standard and mobile devices. Due to the
> popularity of your chips, it would be great if I could add Broadcom to
> my list of viable chips.
> 
> Thanks!
> dps
> 

With fullmac chip management frames are normally not sent to the host so
there is a bit more work involved, but still realistic. At this moment I
can not really give a date when to expect it.

Gr. AvS

