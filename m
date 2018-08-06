Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f42.google.com ([209.85.208.42]:42983 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbeHFLZT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 07:25:19 -0400
Received: by mail-ed1-f42.google.com with SMTP id r4-v6so4775794edp.9
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2018 02:17:11 -0700 (PDT)
Subject: Re: iw scanning broken?
To: Dan Kosek <daniel.kosek@gmail.com>
References: <C17ECAF6-E13C-40DB-A582-C9945D9BE7D7@gmail.com>
 <5B65FC42.3010604@broadcom.com>
 <0ED1D417-F3DA-41EC-BE23-B0D3F736D255@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B681216.6010402@broadcom.com> (sfid-20180806_111715_626821_65634A3D)
Date: Mon, 6 Aug 2018 11:17:10 +0200
MIME-Version: 1.0
In-Reply-To: <0ED1D417-F3DA-41EC-BE23-B0D3F736D255@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

On 8/5/2018 4:59 AM, Dan Kosek wrote:
> Arend,
>
> Thank you for getting back to me.  Adding the “flush” variable to the command fixes the issue on both systems.  Wow is the single channel scan fast with the flush.  Is appears the full scan (all channels) is faster with the flush option as well.

Glad it worked for you.

> I have attached my bash logs.
>
> No I have don’t have kernel logfiles.
>
> I would be glad to collect the kernel log files for you tomorrow.

There is not really an issue here so no need.

> Can you provide me some instructions or a reference and I will forward them.
> 	(I am a wireless engineer my trade and learning to program now.)

Welcome to the dark side :-p Getting the logs depends on you linux 
distro, but using dmesg tends to work on most of them.

Regards,
Arend
