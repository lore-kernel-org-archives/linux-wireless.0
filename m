Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64499 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaJMFqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 01:46:32 -0400
Received: by mail-wg0-f50.google.com with SMTP id a1so7644528wgh.21
        for <linux-wireless@vger.kernel.org>; Sun, 12 Oct 2014 22:46:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local>
Date: Mon, 13 Oct 2014 07:46:30 +0200
Message-ID: <CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com> (sfid-20141013_074635_361622_1B6107A6)
Subject: Re: ath10k firmware crash
From: Michal Kazior <michal.kazior@tieto.com>
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 October 2014 16:46, Cedric VONCKEN <cedric.voncken@acksys.fr> wrote:
>         Hi all,
>
>         I'm trying to use ath10k in client mode and AP mode with 2 wireless cards (Ap on one card and client on another card).
>         The AP mode work, but the client mode always crash. Please find below the ath10k crash information
>
> [   79.131301] ath10k: hardware name qca988x hw2.0 version 0x4100016c
> [   79.149420] ath10k: firmware version: 999.999.0.636
> [   79.167248] ath10k: target register Dump Location: 0x0040AC14
> [   79.185939] ath10k: target Register Dump
> [   79.201804] ath10k: [00]: 0x4100016C 0x00000000 0x009C4521 0x00000000
> [   79.220184] ath10k: [04]: 0x009C4521 0x00060330 0x00000019 0x00955A00
> [   79.238566] ath10k: [08]: 0x0000D0CE 0x00000000 0x0040CC94 0x00000020
> [   79.256945] ath10k: [12]: 0x00000000 0x00000000 0x00958360 0x0095836B
> [   79.275327] ath10k: [16]: 0x809A0978 0x0040AD94 0x00439304 0x0040D074
> [   79.293706] ath10k: [20]: 0x0000FFFF 0x00000000 0x0041EFB8 0x00000000
> [   79.312086] ath10k: [24]: 0x809A0978 0x0040AD94 0x00439304 0x0343389A
> [   79.330466] ath10k: [28]: 0x809AD1A2 0x0040ADE4 0x00439304 0x0043F68C
> [   79.348845] ath10k: [32]: 0x809B01DA 0x00000000 0x00410110 0x0041937C
> [   79.367224] ath10k: [36]: 0x00000000 0x00000000 0x00000000 0x00000000
> [   79.385604] ath10k: [40]: 0x00000000 0x00000000 0x00000071 0x00412700
> [   79.403984] ath10k: [44]: 0x00439BB8 0x00000000 0x00000000 0x00400000
> [   79.422364] ath10k: [48]: 0x809AE0B4 0x0040AE04 0x00400000 0x0043F68C
> [   79.440744] ath10k: [52]: 0x00000001 0x00000000 0x004231F0 0x00400000
> [   79.459124] ath10k: [56]: 0x809AE17E 0x0040AE44 0x0040FE6C 0x0040D310
>
>         I'm using openwrt, and I have the same problem with/without configuration option "Firmware optimized for sta operation".

Can you then provide a crash register dump for 10.1, please? I can't
help you much with the 636 dump.

Are you perhaps trying to run STA with 4addr bridging? If so then make
sure you use recent ath10k as this was known to be a problem.

Can you also provide ath10k traces or debug logs, please?


>         Is it possible to use at the same time on 2 different cards the AP mode and client mode?

Yes, it is possible.


Michał
