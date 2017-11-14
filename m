Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:53553 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdKNCpc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 21:45:32 -0500
Received: by mail-qk0-f172.google.com with SMTP id j202so11492468qke.10
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 18:45:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALLGbRKwcm0ugSKAV1p3rxGseAkp6Zk9RZvKZeTrWFJ_=-pSKg@mail.gmail.com>
References: <CAL3ir7JHwLpNFRSv0jEED50XeFAWmSz4gXXOs0MpM=VeTGiKnQ@mail.gmail.com>
 <CALLGbRKwcm0ugSKAV1p3rxGseAkp6Zk9RZvKZeTrWFJ_=-pSKg@mail.gmail.com>
From: Daniel Ghansah <smartwires@gmail.com>
Date: Mon, 13 Nov 2017 21:45:30 -0500
Message-ID: <CAL3ir7J5GwTjgo6U4k_r91uqMV4Nowr10k8-Kd+t8cXfrwKQDQ@mail.gmail.com> (sfid-20171114_034536_638792_F5F2921D)
Subject: Re: PS-Poll not behaving as expected
To: Steve deRosier <derosier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        yurishih1985@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Steve,
         Thanks for your prompt response, and sorry for my lack of
details my colleague Yuri will provide this info shortly Thanks

Regards
Daniel

On Mon, Nov 13, 2017 at 7:01 PM, Steve deRosier <derosier@gmail.com> wrote:
> Hi Daniel,
>
> On Mon, Nov 13, 2017 at 2:40 PM, Daniel Ghansah <smartwires@gmail.com> wrote:
>>        Here is the problem we experience:
>>
>> When the station (wifi devices) sends a null QoS frame with power save
>> telling our AP that it is going into power save mode. RIght now, our
>> problem is that the AP will not stop sending data packets to the
>> station. Correct behavior is that the AP will buffer data packets and
>> stop sending any data or null packets (WiFi Alliance allows at most 2
>> of these packets to be sent by the AP before station sends ps-poll,
>> exclude retries) until a PS-Poll packet is sent by the station to
>> collect data. The AP should also respond only 1 packet per PS-Poll
>> (exclude any retries). Right now, we are also experiencing that the AP
>> will, at times, send more than 1 data packet to the station per
>> PS-Poll. The first and second problems may be linked together.
>>
>
> You've given no context with which we can help you. Things like the
> Linux version, the hardware running on the AP and client, which it is
> you're trying to report a bug on (the AP or Client), dmesg logs,
> wireless traces, and so on would all be somewhere between mandatory to
> helpful information. Trying to give us nothing but your interpretation
> of what the 802.11 standard says (which most of us know very well)
> isn't a useful bug report.
>
> This might help:
> https://wireless.wiki.kernel.org/en/users/documentation/reporting_bugs
>
> Please try again and send us the information we need to be able to help.
>
> Thanks,
> - Steve



-- 
Regards,
Daniel Ghansah
305-801-4895
