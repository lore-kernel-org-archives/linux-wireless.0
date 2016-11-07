Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34105 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752013AbcKGMBW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 07:01:22 -0500
Received: by mail-qt0-f169.google.com with SMTP id n6so85515586qtd.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Nov 2016 04:01:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87twbnueqv.fsf@kamboji.qca.qualcomm.com>
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local>
 <566849DB.9040901@candelatech.com> <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr>
 <CABUTiXWg3t5qK6O5ooDE+4=Xk3Msybs5mu9+tQm_Bb0wdSrfWQ@mail.gmail.com> <87twbnueqv.fsf@kamboji.qca.qualcomm.com>
From: Bruno Antunes <baantunes@gmail.com>
Date: Mon, 7 Nov 2016 12:01:01 +0000
Message-ID: <CABUTiXW5QSh2KkD+sQ-6QOD5zTce0dun+nyfAMnvL580U=OVNw@mail.gmail.com> (sfid-20161107_130126_641470_6F7496C0)
Subject: Re: ATH10K VLAN firmware issue
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: voncken <cedric.voncken@acksys.fr>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 November 2016 at 21:17, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Bruno Antunes <baantunes@gmail.com> writes:
>
>> Old thread but I think the issue is still present.
>>
>> I'm running a setup with VLANs with WDS and ath10k cards.
>>
>> To make it work both cards must be loaded in rawmode, AP
>> and Sta, and with no security.
>>
>> I'm using a OpenWrt trunk r49941 and the most recent firmware,
>> 10.2.4.70.58, from Kalle ath10k firmware tree.
>>
>> Although it works the throughput is very bad.
>> Are there any alternatives to improve the throughput.
>
> Can someone file a bug to bugzilla about this so that all the info is
> properly stored? The more comprehensive the report is the better.
>
> https://bugzilla.kernel.org/

I will file a bug report.

But since it appears to be a firmware related issue
under what category can fill in the bug?

Thanks,
Bruno

>
> --
> Kalle Valo
