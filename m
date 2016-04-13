Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33881 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbcDMRBi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 13:01:38 -0400
Received: by mail-oi0-f41.google.com with SMTP id s79so70874275oie.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2016 10:01:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570E472A.2040901@candelatech.com>
References: <570D8956.8090806@candelatech.com>
	<1460534484.3057.2.camel@sipsolutions.net>
	<570E472A.2040901@candelatech.com>
Date: Wed, 13 Apr 2016 10:01:37 -0700
Message-ID: <CAA93jw5d9Er+ZcSszg-gd0X7ZWeQJtqmPFXkf1mwXnTDKxg0xA@mail.gmail.com> (sfid-20160413_190144_820232_382B3619)
Subject: Re: General VHT rate-ctrl question
From: Dave Taht <dave.taht@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 13, 2016 at 6:18 AM, Ben Greear <greearb@candelatech.com> wrote:
>
>
> On 04/13/2016 01:01 AM, Johannes Berg wrote:
>>
>> On Tue, 2016-04-12 at 16:48 -0700, Ben Greear wrote:
>>>
>>> If a station and it's peer can both do VHT, is there ever a good
>>> reason to even try HT rates?
>>>
>>
>> Not really; perhaps if you could do HT greenfield preamble (which VHT
>> doesn't have) you could get something out of it, beyond that I don't
>> see a reason to try.
>>
>> Unless, for some strange reason, it supports only single stream VHT and
>> dual-stream HT or something really weird?
>
>
> I was wondering if there was ever a reason that, say 450Mbps HT
> would work better than MCS-1 for VHT.  Or, maybe a mid-rate HT MCS would
> have more range than VHT, or something like that.
>
> After fighting with the firmware's rate-ctrl all day, I am even more
> interested
> in trying to make it use mistrel_ht.

I just put up Andrew's old paper on minstrel, if that helps any.

http://blog.cerowrt.org/post/minstrel/

>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
