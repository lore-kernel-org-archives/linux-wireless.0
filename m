Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:42062 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750897AbeCIH24 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 02:28:56 -0500
Received: by mail-wr0-f172.google.com with SMTP id k9so8008445wre.9
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2018 23:28:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87zi3j9cz7.fsf@codeaurora.org>
References: <87zi3j9cz7.fsf@codeaurora.org>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Fri, 9 Mar 2018 12:58:54 +0530
Message-ID: <CAEhWJF=s=gHJ-yKn+VW2Hs6Nj9KbfF59-1Tk=fkzQk6wFFddNw@mail.gmail.com> (sfid-20180309_082900_218322_15776AB4)
Subject: Re: Variable-length arrays considered bad
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 8, 2018 at 2:10 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Hi,
>
> in an lkml discussion[1] it was mentioned that variable-length arrays
> should not be used. Few warnings were found[2] from wireless:
>
> drivers/net/wireless/ath/ath9k/dfs.c:104:2: warning: ISO C90 forbids variable length array 'max_bin' [-Wvla]
> drivers/net/wireless/rsi/rsi_91x_sdio.c:570:2: warning: ISO C90 forbids variable length array 'temp_buf' [-Wvla]
>
> Patches welcome.
>
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>
> [2] http://paste.ubuntu.com/p/srQxwPQS9s/
>

I will submit a cleanup patch for RSI warning

Regards,
Amitkumar Karwar
