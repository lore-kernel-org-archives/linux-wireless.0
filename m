Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52535 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbcJGEvi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 00:51:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Rameshwar Sahu <sahu.rameshwar73@gmail.com>
Subject: Re: [PATCH] [wl18xx] Fix memory leakage if kzalloc fails
References: <20161005115013.GA22099@symbol-HP-ZBook-15>
        <CAGRGNgWCxLUz0=EUgtNQ5pLo2wCEpsMeNQHYCpKfh12irp6NDg@mail.gmail.com>
        <CAFqt6zYpMJKrX51--eHXKSEcgb+KVJ7ULjoL==DNKyOeOB5_4Q@mail.gmail.com>
Date: Fri, 07 Oct 2016 07:50:46 +0300
In-Reply-To: <CAFqt6zYpMJKrX51--eHXKSEcgb+KVJ7ULjoL==DNKyOeOB5_4Q@mail.gmail.com>
        (Souptick Joarder's message of "Fri, 7 Oct 2016 00:21:13 +0530")
Message-ID: <87oa2w2255.fsf@purkki.adurom.net> (sfid-20161007_065142_720792_A3DA28DD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Souptick Joarder <jrdr.linux@gmail.com> writes:

> Hi Julian,
>
>
> On Thu, Oct 6, 2016 at 3:05 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi,
>>
>> On Wed, Oct 5, 2016 at 10:50 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>>> This patch is added to properly handle memory leak if kzalloc fails
>>> in wl18xx_scan_send() and wl18xx_scan_sched_scan_config()
>>
>> What memory leak?
>
> My Apologies here. I was addressing here about freeing the invalid memories.
> But I put wrong description. I will resend this patch with proper
> descriptions and addressing your comments.

Also the prefix in the title should be "wl18xx: ", not "[wl18xx]". See:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject_name

-- 
Kalle Valo
