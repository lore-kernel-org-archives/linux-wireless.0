Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55020 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbeCIKiE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 05:38:04 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Variable-length arrays considered bad
References: <87zi3j9cz7.fsf@codeaurora.org>
        <CAEhWJF=s=gHJ-yKn+VW2Hs6Nj9KbfF59-1Tk=fkzQk6wFFddNw@mail.gmail.com>
Date: Fri, 09 Mar 2018 12:38:01 +0200
In-Reply-To: <CAEhWJF=s=gHJ-yKn+VW2Hs6Nj9KbfF59-1Tk=fkzQk6wFFddNw@mail.gmail.com>
        (Amitkumar Karwar's message of "Fri, 9 Mar 2018 12:58:54 +0530")
Message-ID: <87muzha60m.fsf@codeaurora.org> (sfid-20180309_113808_915188_7E72AF41)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> On Thu, Mar 8, 2018 at 2:10 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Hi,
>>
>> in an lkml discussion[1] it was mentioned that variable-length arrays
>> should not be used. Few warnings were found[2] from wireless:
>>
>> drivers/net/wireless/ath/ath9k/dfs.c:104:2: warning: ISO C90 forbids
>> variable length array 'max_bin' [-Wvla]
>> drivers/net/wireless/rsi/rsi_91x_sdio.c:570:2: warning: ISO C90
>> forbids variable length array 'temp_buf' [-Wvla]
>>
>> Patches welcome.
>>
>> [1]
>> https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>>
>> [2] http://paste.ubuntu.com/p/srQxwPQS9s/
>>
>
> I will submit a cleanup patch for RSI warning

Thanks, but Tobin was faster:

https://lkml.kernel.org/r/1520577493-24603-1-git-send-email-me@tobin.cc

He just forgot to CC linux-wireless.

-- 
Kalle Valo
