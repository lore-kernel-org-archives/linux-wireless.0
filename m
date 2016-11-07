Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32132 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932526AbcKGSL3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 13:11:29 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: voncken <cedric.voncken@acksys.fr>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: ATH10K VLAN firmware issue
Date: Mon, 7 Nov 2016 18:06:03 +0000
Message-ID: <871syn5fnb.fsf@qca.qualcomm.com> (sfid-20161107_191133_323357_5AC5E95C)
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local>
        <566849DB.9040901@candelatech.com>
        <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr>
        <CABUTiXWg3t5qK6O5ooDE+4=Xk3Msybs5mu9+tQm_Bb0wdSrfWQ@mail.gmail.com>
        <87twbnueqv.fsf@kamboji.qca.qualcomm.com>
        <CABUTiXW5QSh2KkD+sQ-6QOD5zTce0dun+nyfAMnvL580U=OVNw@mail.gmail.com>
In-Reply-To: <CABUTiXW5QSh2KkD+sQ-6QOD5zTce0dun+nyfAMnvL580U=OVNw@mail.gmail.com>       (Bruno
 Antunes's message of "Mon, 7 Nov 2016 12:01:01 +0000")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bruno Antunes <baantunes@gmail.com> writes:

> On 4 November 2016 at 21:17, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
>> Bruno Antunes <baantunes@gmail.com> writes:
>>
>>> Old thread but I think the issue is still present.
>>>
>>> I'm running a setup with VLANs with WDS and ath10k cards.
>>>
>>> To make it work both cards must be loaded in rawmode, AP
>>> and Sta, and with no security.
>>>
>>> I'm using a OpenWrt trunk r49941 and the most recent firmware,
>>> 10.2.4.70.58, from Kalle ath10k firmware tree.
>>>
>>> Although it works the throughput is very bad.
>>> Are there any alternatives to improve the throughput.
>>
>> Can someone file a bug to bugzilla about this so that all the info is
>> properly stored? The more comprehensive the report is the better.
>>
>> https://bugzilla.kernel.org/
>
> I will file a bug report.

Thanks, it's good to store all in one place so that it's easier to find
the relevant info.

> But since it appears to be a firmware related issue
> under what category can fill in the bug?

You can file it under Drivers/network-wireless, AFAIK we don't have any
separate components for firmware bugs. Here's one example to follow:

https://bugzilla.kernel.org/show_bug.cgi?id=3D186161

--=20
Kalle Valo=
