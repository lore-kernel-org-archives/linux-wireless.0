Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51581 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbbCKP5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 11:57:42 -0400
Message-ID: <550065F5.5050607@candelatech.com> (sfid-20150311_165755_892976_7503C625)
Date: Wed, 11 Mar 2015 08:57:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?M=E1rio_Lopes?= <mjlopes@inescporto.pt>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Why can we not set the mcast rate for AP/STA interfaces?
References: <54FF7095.9010800@candelatech.com> <20150311105604.42081tsuhqw9inn8@horde.inescporto.pt>
In-Reply-To: <20150311105604.42081tsuhqw9inn8@horde.inescporto.pt>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2015 02:56 AM, Mário Lopes wrote:
> On which 802.11 amendment (a/b/g/n/ac) and driver allows you setting mcast rate for mesh and IBSS interfaces?
> Far as I know, some vendors send multicast traffic as unicast in order to reduce airtime.

I was just looking at the kernel code, I think it was linux/net/wireless/* where
the device type is made.  I didn't look farther to figure out what it would take
to make this work with stations or APs.

Thanks,
Ben

> 
> 
> Quoting Ben Greear <greearb@candelatech.com>:
> 
>>> From looking at 3.17 code, it appears we are only supposed to set the
>> mcast rate for mesh and IBSS interfaces?
>>
>> What if I want to tell an AP or station to send broadcast/multicast
>> at a higher than default rate?
>>
>> Should this just be controlled by the normal 'iw setbitrates' logic?
>>
>> Thanks,
>> Ben
>>
>> -- 
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> 
> ----------------------------------------------------------------
> This message was sent using IMP, the Internet Messaging Program.
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

