Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:36315 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933819AbcKDONv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2016 10:13:51 -0400
Received: by mail-qt0-f173.google.com with SMTP id w33so48634236qtc.3
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2016 07:13:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local>
 <566849DB.9040901@candelatech.com> <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr>
From: Bruno Antunes <baantunes@gmail.com>
Date: Fri, 4 Nov 2016 14:13:29 +0000
Message-ID: <CABUTiXWg3t5qK6O5ooDE+4=Xk3Msybs5mu9+tQm_Bb0wdSrfWQ@mail.gmail.com> (sfid-20161104_151355_424516_D3EC8814)
Subject: Re: ATH10K VLAN firmware issue
To: voncken <cedric.voncken@acksys.fr>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Old thread but I think the issue is still present.

I'm running a setup with VLANs with WDS and ath10k cards.

To make it work both cards must be loaded in rawmode, AP
and Sta, and with no security.

I'm using a OpenWrt trunk r49941 and the most recent firmware,
10.2.4.70.58, from Kalle ath10k firmware tree.

Although it works the throughput is very bad.
Are there any alternatives to improve the throughput.

Best Regards,
Bruno

On 9 December 2015 at 17:24, voncken <cedric.voncken@acksys.fr> wrote:
>
>
>> -----Message d'origine-----
>> De : Ben Greear [mailto:greearb@candelatech.com]
>> Envoy=C3=A9 : mercredi 9 d=C3=A9cembre 2015 16:34
>> =C3=80 : Cedric VONCKEN; ath10k@lists.infradead.org; linux-wireless
>> Objet : Re: ATH10K VLAN firmware issue
>>
>> This only happens when you use STA  + WDS, or is .1q broken for you in
>> other cases as well?
>
> No, this issue occurs in all modes (STA, STA + WDS, AP).
>
> Thanks
>
> Cedric.
>
>>
>> Thanks,
>> Ben
>>
>> On 12/08/2015 06:29 AM, Cedric VONCKEN wrote:
>> >     I'm testing to transmit frame with 802.1q tag (VLAN).
>> >
>> >     My client is set in STA + WDS and the netdev is bridged with eth0.
>> >     I have a computer with vlan configuration set connected to the STA
>> > eth0.
>> >
>> >     If I try to transmit frames with 802.1q tag, the frames are not
> sent.
>> >     I checked with wireless sniffer, and I don't see the frame with VL=
AN
>> > tag (the frames without VLAN tag are sent).
>> >
>> >     I tested with firmware 10.2.4.70.14-2 from kale github,
>> > 10.1.467-ct-com-full-015 from candelatech and 10.2.4.70-2 from
>> > openwrt, and in all cases I have the same issue.
>> >
>> >     Thanks for your help.
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe
>> > linux-wireless" in the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
