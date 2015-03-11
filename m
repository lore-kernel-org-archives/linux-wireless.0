Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.inescn.pt ([192.35.246.20]:49339 "EHLO trubo.inescn.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbbCKQJw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 12:09:52 -0400
Message-ID: <20150311170942.14131uq8uu6moq86@horde.inescporto.pt> (sfid-20150311_170956_626410_464B931E)
Date: Wed, 11 Mar 2015 17:09:42 +0100
From: =?iso-8859-1?b?TeFyaW8=?= Lopes <mjlopes@inescporto.pt>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Why can we not set the mcast rate for AP/STA interfaces?
References: <54FF7095.9010800@candelatech.com>
	<20150311105604.42081tsuhqw9inn8@horde.inescporto.pt>
	<550065F5.5050607@candelatech.com>
In-Reply-To: <550065F5.5050607@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok. I was asking because some routers allow changing basicrate speed  
but only on 802.11a/b/g, in AP mode, not on mesh/Ad-Hoc modes.
Some non-mandatory feactures can be on code of one module but not  
implemented in the whole process.

Thanks.



Quoting Ben Greear <greearb@candelatech.com>:

> On 03/11/2015 02:56 AM, Mário Lopes wrote:
>> On which 802.11 amendment (a/b/g/n/ac) and driver allows you  
>> setting mcast rate for mesh and IBSS interfaces?
>> Far as I know, some vendors send multicast traffic as unicast in  
>> order to reduce airtime.
>
> I was just looking at the kernel code, I think it was  
> linux/net/wireless/* where
> the device type is made.  I didn't look farther to figure out what  
> it would take
> to make this work with stations or APs.
>
> Thanks,
> Ben
>
>>
>>
>> Quoting Ben Greear <greearb@candelatech.com>:
>>
>>>> From looking at 3.17 code, it appears we are only supposed to set the
>>> mcast rate for mesh and IBSS interfaces?
>>>
>>> What if I want to tell an AP or station to send broadcast/multicast
>>> at a higher than default rate?
>>>
>>> Should this just be controlled by the normal 'iw setbitrates' logic?
>>>
>>> Thanks,
>>> Ben
>>>
>>> --
>>> Ben Greear <greearb@candelatech.com>
>>> Candela Technologies Inc  http://www.candelatech.com
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe  
>>> linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>> ----------------------------------------------------------------
>> This message was sent using IMP, the Internet Messaging Program.
>>
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>



----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
