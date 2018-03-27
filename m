Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33932 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbeC0GYt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 02:24:49 -0400
Received: by mail-lf0-f66.google.com with SMTP id c78-v6so26925434lfh.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 23:24:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c3d2bae3da74abf969072eb7ce001a07@codeaurora.org>
References: <1519634437-6672-1-git-send-email-mkenna@codeaurora.org>
 <CAKmTU=ptKUweW-WgoJiZRPS=6X+8q60XX2nHQwsqf=A1j-18iQ@mail.gmail.com> <c3d2bae3da74abf969072eb7ce001a07@codeaurora.org>
From: Joshua Zhao <swzhao@gmail.com>
Date: Mon, 26 Mar 2018 23:24:47 -0700
Message-ID: <CAKmTU=q2ybEAdu5KsUkAeBHdprQ2WtjP94kYRZb4Nm7JM8mozg@mail.gmail.com> (sfid-20180327_082454_380762_A982780C)
Subject: Re: [PATCH v2] ath10k: debugfs support to get final TPC stats for
 10.4 variants
To: Maharaja Kennadyrajan <mkenna@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What exactly "control power" means? Can you illustrate or give examples?
Thanks!

On Mon, Feb 26, 2018 at 9:33 PM, Maharaja Kennadyrajan
<mkenna@codeaurora.org> wrote:
> On 2018-02-27 1:19 am, Joshua Zhao wrote:
>>
>> as you said:
>>         The existing tpc_stats debugfs file provides the dump which is
>> minimum of target power and regulatory domain.
>>                         cat
>> /sys/kernel/debug/ieee80211/phyX/ath10k/tpc_stats
>>
>> I=E2=80=99m curious what=E2=80=99s exact difference w/ this new addition=
:
>>         Export the final Transmit Power Control (TPC) value, which is
>> the minimum of control power and existing TPC value to user space via
>> a new debugfs file "tpc_stats_final" to help with debugging.
>>
>> Can you clarify or give examples on the difference?
>>
>> Thanks!
>
>
> The existing tpc_stats is the minimum of "target power and regulatory
> domain".
> The new addition is the minimum of "existing tpc_stats and control power"
> which means minimum of "control power, target power and regulatory domain=
".
>
> --
> Regards,
> Maha
