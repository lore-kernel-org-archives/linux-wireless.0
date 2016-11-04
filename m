Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53252 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759308AbcKDVRX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2016 17:17:23 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Bruno Antunes <baantunes@gmail.com>
CC: voncken <cedric.voncken@acksys.fr>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: ATH10K VLAN firmware issue
Date: Fri, 4 Nov 2016 21:17:13 +0000
Message-ID: <87twbnueqv.fsf@kamboji.qca.qualcomm.com> (sfid-20161104_221727_622065_E219EA98)
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local>
        <566849DB.9040901@candelatech.com>
        <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr>
        <CABUTiXWg3t5qK6O5ooDE+4=Xk3Msybs5mu9+tQm_Bb0wdSrfWQ@mail.gmail.com>
In-Reply-To: <CABUTiXWg3t5qK6O5ooDE+4=Xk3Msybs5mu9+tQm_Bb0wdSrfWQ@mail.gmail.com>       (Bruno
 Antunes's message of "Fri, 4 Nov 2016 14:13:29 +0000")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bruno Antunes <baantunes@gmail.com> writes:

> Old thread but I think the issue is still present.
>
> I'm running a setup with VLANs with WDS and ath10k cards.
>
> To make it work both cards must be loaded in rawmode, AP
> and Sta, and with no security.
>
> I'm using a OpenWrt trunk r49941 and the most recent firmware,
> 10.2.4.70.58, from Kalle ath10k firmware tree.
>
> Although it works the throughput is very bad.
> Are there any alternatives to improve the throughput.

Can someone file a bug to bugzilla about this so that all the info is
properly stored? The more comprehensive the report is the better.

https://bugzilla.kernel.org/

--=20
Kalle Valo=
