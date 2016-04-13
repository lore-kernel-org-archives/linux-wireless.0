Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56827 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbcDMNSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 09:18:36 -0400
Message-ID: <570E472A.2040901@candelatech.com> (sfid-20160413_151842_692983_0347C3AB)
Date: Wed, 13 Apr 2016 06:18:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: General VHT rate-ctrl question
References: <570D8956.8090806@candelatech.com>	 (sfid-20160413_014843_049708_B2F53AD9) <1460534484.3057.2.camel@sipsolutions.net>
In-Reply-To: <1460534484.3057.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/13/2016 01:01 AM, Johannes Berg wrote:
> On Tue, 2016-04-12 at 16:48 -0700, Ben Greear wrote:
>> If a station and it's peer can both do VHT, is there ever a good
>> reason to even try HT rates?
>>
>
> Not really; perhaps if you could do HT greenfield preamble (which VHT
> doesn't have) you could get something out of it, beyond that I don't
> see a reason to try.
>
> Unless, for some strange reason, it supports only single stream VHT and
> dual-stream HT or something really weird?

I was wondering if there was ever a reason that, say 450Mbps HT
would work better than MCS-1 for VHT.  Or, maybe a mid-rate HT MCS would
have more range than VHT, or something like that.

After fighting with the firmware's rate-ctrl all day, I am even more interested
in trying to make it use mistrel_ht.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
