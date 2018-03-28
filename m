Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34545 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbeC1Hh2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 03:37:28 -0400
Received: by mail-wm0-f66.google.com with SMTP id a20so24470808wmd.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Mar 2018 00:37:28 -0700 (PDT)
Subject: Re: [RFC 0/4] wireless: Per-sta NoAck and offload support
To: vthiagar@codeaurora.org, Steve deRosier <derosier@gmail.com>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
 <CALLGbR+d8gCS0-_NV8i0K6ktL14OEiDjxVG4bvubmti7Yp5OoQ@mail.gmail.com>
 <94497d97976ff1934a08e70cc118bf56@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        steve.derosier@gmail.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ABB4636.2040900@broadcom.com> (sfid-20180328_093732_268506_5415193C)
Date: Wed, 28 Mar 2018 09:37:26 +0200
MIME-Version: 1.0
In-Reply-To: <94497d97976ff1934a08e70cc118bf56@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/28/2018 8:09 AM, vthiagar@codeaurora.org wrote:
> On 2018-03-27 22:18, Steve deRosier wrote:
>> Hi Vasanthakumar,
>>
>> On Tue, Mar 27, 2018 at 1:42 AM, Vasanthakumar Thiagarajan
>> <vthiagar@codeaurora.org> wrote:
>>> Adds infrastructure for driver to offload NoAck functionality, driver
>>> like ath10k could make use of it. Also extends the current ndev wide
>>
>> I'm not really much of a fan of adding a feature without some use of
>> the feature. Perhaps if drivers "like" ath10k could use it, maybe you
>> should add a patch(s) to the series where one of those drivers
>> actually uses the feature.  An API without an example of use is also
>> harder to evaluate effectively.
>
> I agree driver patch using the new NoAck infrastructure would help with
> understanding, ill post it once it is ready. But not sure the driver patch
> can be part of the same series.

The API patches would go in mac80211-next tree and indeed the driver 
patch would go through wireless-drivers-next tree. However, an option 
would be to add the driver patch(es) as RFC in the series so Johannes 
can ignore it and we still have an example to look at.

Regards,
Arend
