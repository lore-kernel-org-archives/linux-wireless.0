Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua1-f47.google.com ([209.85.222.47]:45362 "EHLO
        mail-ua1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbeILFlS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 01:41:18 -0400
Received: by mail-ua1-f47.google.com with SMTP id q7-v6so142899uam.12
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2018 17:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <CALGY4ft2u2QufAcWLygNzRp8+=XvSz1FD+-f8Jr4A3qhuwU6JQ@mail.gmail.com>
In-Reply-To: <CALGY4ft2u2QufAcWLygNzRp8+=XvSz1FD+-f8Jr4A3qhuwU6JQ@mail.gmail.com>
From: Nikolay Martynov <mar.kolya@gmail.com>
Date: Tue, 11 Sep 2018 20:39:15 -0400
Message-ID: <CALGY4ftOc35yBt8zT2s+t6JqcjfcfJW6s0yfwLV9z+YUxudvPg@mail.gmail.com> (sfid-20180912_023931_670651_7AEE8E59)
Subject: Re: QCA988X firmware version and performance
To: linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org, Kalle Valo <kvalo@codeaurora.org>,
        kavitam@cdot.in
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I did some more testing and it looks like new (latest) firmware shows
same performance as old firmware on short distance from AP (~1m) - but
as shown above the difference if 30+% on large distance - ~10-15m.
This probably means that this is not some sort of 'global' performance
limitation in newer firmware but rather something is off with rate
and/or power control.
On Sat, Sep 8, 2018 at 4:11 PM Nikolay Martynov <mar.kolya@gmail.com> wrote:
>
> Hi.
>
>   I've got some observation about firmware version and speed that I
> would like to share.
>   I have tp-link archer c5 with 'ath10k_pci 0000:01:00.0: qca988x
> hw2.0 target 0x4100016c chip_id 0x043202ff sub 0000:0000' running
> Openwrt.
>
>   When I use firmware version 10.2.4.70.61-2 I get modulation speeds
> about twice as large as with other firmware versions. I've also tried
> 10.2.4.70.66 and firmware-5.bin_10.2.4-1.0-00033 and one that was
> Openwrt/Lede stock before that - all show performance noticeably worse
> than 10.2.4.70.61-2.
>   In fact if my laptop stands on my desk (some distance away from AP)
> and I use 10.2.4.70.61-2 I get stable 2 spacial stream reception, if I
> use other versions mentioned above I usually get one 1 special stream
> as shown by 'iw' command on a client.
>   I've also perfomed some speed measurements with iperf:
> * with latest firmware I get 30MB/s and iw on a client shows signal
> strength of -72dBm
> * with 10.2.4.70.61-2I get 53MB/s and iw on a client shows signal
> strength of -63dBm
> All with laptop (client) unmoved.
>   So it looks like downgrading firmware gains 30+% performance.
>
>   I've already tried to raise this question ~8 months ago but didn't
> get any reply.
>
>   It seems like this is a bug in newer versions of firmware and it
> would be really nice if that bug could be fixed.
>   Is there any way I can help with that? Maybe someone could provide
> me with better channel to ask these questions?
>
>   Please let me know if I can provide any more information.
>   Thanks!
> --
> Martynov Nikolay.
> Email: mar.kolya@gmail.com



-- 
Martynov Nikolay.
Email: mar.kolya@gmail.com
