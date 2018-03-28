Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33570 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbeC1H7t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 03:59:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 28 Mar 2018 13:29:47 +0530
From: vthiagar@codeaurora.org
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Steve deRosier <derosier@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        steve.derosier@gmail.com
Subject: Re: [RFC 0/4] wireless: Per-sta NoAck and offload support
In-Reply-To: <5ABB4636.2040900@broadcom.com>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
 <CALLGbR+d8gCS0-_NV8i0K6ktL14OEiDjxVG4bvubmti7Yp5OoQ@mail.gmail.com>
 <94497d97976ff1934a08e70cc118bf56@codeaurora.org>
 <5ABB4636.2040900@broadcom.com>
Message-ID: <e4449f3b1dc37f3c91284f284211d1c9@codeaurora.org> (sfid-20180328_095952_783172_67226002)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-28 13:07, Arend van Spriel wrote:
> On 3/28/2018 8:09 AM, vthiagar@codeaurora.org wrote:
>> On 2018-03-27 22:18, Steve deRosier wrote:
>>> Hi Vasanthakumar,
>>> 
>>> On Tue, Mar 27, 2018 at 1:42 AM, Vasanthakumar Thiagarajan
>>> <vthiagar@codeaurora.org> wrote:
>>>> Adds infrastructure for driver to offload NoAck functionality, 
>>>> driver
>>>> like ath10k could make use of it. Also extends the current ndev wide
>>> 
>>> I'm not really much of a fan of adding a feature without some use of
>>> the feature. Perhaps if drivers "like" ath10k could use it, maybe you
>>> should add a patch(s) to the series where one of those drivers
>>> actually uses the feature.  An API without an example of use is also
>>> harder to evaluate effectively.
>> 
>> I agree driver patch using the new NoAck infrastructure would help 
>> with
>> understanding, ill post it once it is ready. But not sure the driver 
>> patch
>> can be part of the same series.
> 
> The API patches would go in mac80211-next tree and indeed the driver
> patch would go through wireless-drivers-next tree. However, an option
> would be to add the driver patch(es) as RFC in the series so Johannes
> can ignore it and we still have an example to look at.

Sounds good. Ill try to include the driver patch in the next version.

Vasanth
