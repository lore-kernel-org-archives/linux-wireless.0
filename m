Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41452 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751937AbeB0Fd0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 00:33:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 27 Feb 2018 11:03:25 +0530
From: Maharaja Kennadyrajan <mkenna@codeaurora.org>
To: Joshua Zhao <swzhao@gmail.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: debugfs support to get final TPC stats for
 10.4 variants
In-Reply-To: <CAKmTU=ptKUweW-WgoJiZRPS=6X+8q60XX2nHQwsqf=A1j-18iQ@mail.gmail.com>
References: <1519634437-6672-1-git-send-email-mkenna@codeaurora.org>
 <CAKmTU=ptKUweW-WgoJiZRPS=6X+8q60XX2nHQwsqf=A1j-18iQ@mail.gmail.com>
Message-ID: <c3d2bae3da74abf969072eb7ce001a07@codeaurora.org> (sfid-20180227_063329_896213_5CE833DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-02-27 1:19 am, Joshua Zhao wrote:
> as you said:
>         The existing tpc_stats debugfs file provides the dump which is
> minimum of target power and regulatory domain.
>                         cat 
> /sys/kernel/debug/ieee80211/phyX/ath10k/tpc_stats
> 
> I’m curious what’s exact difference w/ this new addition:
>         Export the final Transmit Power Control (TPC) value, which is
> the minimum of control power and existing TPC value to user space via
> a new debugfs file "tpc_stats_final" to help with debugging.
> 
> Can you clarify or give examples on the difference?
> 
> Thanks!

The existing tpc_stats is the minimum of "target power and regulatory 
domain".
The new addition is the minimum of "existing tpc_stats and control 
power" which means minimum of "control power, target power and 
regulatory domain".

-- 
Regards,
Maha
