Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39087 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1BRWVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 17:21:37 -0500
Received: by wwa36 with SMTP id 36so4288581wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 14:21:35 -0800 (PST)
Message-ID: <4D5EF0E9.4050908@lwfinger.net>
Date: Fri, 18 Feb 2011 16:21:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Dan Williams <dcbw@redhat.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Request for free-distributable Broadcom's (G|LP)-PHY firmware
References: <AANLkTik45KLdLf5UpjPtXTNgy4Df_BupyQ3SzRr6gZgC@mail.gmail.com>	<AANLkTin_JcEyT21dTS=Ew868HJvZQ2FVZBGXjCZn=8O_@mail.gmail.com>	<4CBF640C.4080405@broadcom.com>	<AANLkTinfwhjvfJU6C97SPJ8YKRqyJaCoQnAcC_uKLZa=@mail.gmail.com>	<1287674517.2383.7.camel@dcbw.foobar.com> <AANLkTikLbtV5dLu+Gu=8ibi=ERPiOykN9qBL4rPKS36g@mail.gmail.com>
In-Reply-To: <AANLkTikLbtV5dLu+Gu=8ibi=ERPiOykN9qBL4rPKS36g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2011 03:24 PM, Rafał Miłecki wrote:
> W dniu 21 października 2010 17:21 użytkownik Dan Williams
> <dcbw@redhat.com>  napisał:
>> On Thu, 2010-10-21 at 00:11 +0200, Rafał Miłecki wrote:
>>> W dniu 20 października 2010 23:50 użytkownik Henry Ptasinski
>>> <henryp@broadcom.com>  napisał:
>>>> Sorry for the delay in responding.  We are exploring what is possible but
>>>> for the moment the answer is no. At present our focus is on providing the
>>>> best open source solution we can for 4313, 43224, 43225, 4329 and future
>>>> chips sets.
>>>
>>> Thanks for answer.
>>>
>>> Please, can you make totally sure person responsible for this gets it
>>> totally right? I believe it's very important.
>>>
>>> The easiest step for you, which we still would appreciate is really
>>> trivial one. It's *not* about writing any code, *not* about releasing
>>> anything new. It's just about releasing in under friendly license.
>>> This firmware is already available, we have access to it, we use it.
>>> The problem is that distributions can not ship it.
>>>
>>> If you let me use simplification: all we need as first nice step is
>>> Broadcom to say: "You can use it".
>>
>> That's not enough to allow Fedora to ship it.  We'd need a clear license
>> from Broadcom (ex the existing Intel or Marvell firmware licenses)
>> before Fedora could feel comfortable about shipping it legally in all
>> jurisdictions.
>>
>> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob;f=LICENCE.mwl8k;h=3224e1bbfba8ccd1d980f57eb88378f20bb2d146;hb=HEAD
>> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob;f=LICENCE.libertas;h=1fd8766c26a170b50605455ae6f54b607baa12cf;hb=HEAD
>>
>> There's an existing Broadcom license in linux-firmware.git, and it *may*
>> be OK, but it's really, really long and given that other major companies
>> adopted the "shorter is better" approach, it's hard to believe that all
>> the existing Broadcom license text is actually needed.
>
> Few months later, is there any progress? Can we expect:
>
> 1) Easier licensing of currently provided firmware (see Fedore case)
> 2) Firmware for LP-PHY devices
> ?

I think we can forget this whole business. It seems that Broadcom is content 
with their business model, even though knowledgeable Linux users are avoiding 
their products like the plague.

Larry
