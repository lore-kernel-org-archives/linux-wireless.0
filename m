Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:45138 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3EOX0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 19:26:40 -0400
Received: by mail-la0-f52.google.com with SMTP id fo13so2386710lab.11
        for <linux-wireless@vger.kernel.org>; Wed, 15 May 2013 16:26:38 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 May 2013 17:26:38 -0600
Message-ID: <CAJu560g_TvoG1PSTQ=Ns8buigMoaHzqbh=7W27qc0+LgJ23mGg@mail.gmail.com> (sfid-20130516_012644_176673_5F8F652D)
Subject: Re: STA doesn't support ACM for QoS
From: Cyril Segretain <cyrilseg@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/5/15 Ben Greear <greearb@candelatech.com>:
> On 05/15/2013 03:42 PM, Cyril Seg wrote:
>>
>> Hello ,
>>
>> In my testbed, there is an AP that works with ath9k_htc and hostapd and
>> there
>> also are 2 STAs that work with ath9k_htc.
>> Video flows aren't in the good priority, they are in Best_Effort.
>> But if I enable the ACM parameter for VIDEO and BEST EFFORT, video flows
>> are
>> now in BACKGROUND priority.
>> STAs doesn't support the admission control ...
>>
>> Does someone have a solution ?
>>
>> I work with Kali Linux, kernel 3.7
>
>
> See what ToS bits are in your video frames.   Some definitions
> of ToS had low values for video (32), but wifi requires different
> settings (something like 128).
>

The ToS for Video Streaming should be at 160.
But in my testbed all ToS bits are 0. I don't know why...

> Thanks,
> Ben
>
>
>
>>
>> Thanks,
>>
>> Cyril Segretain
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
