Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43368 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752605AbcKSG4W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Nov 2016 01:56:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Rajat Jain <rajatja@google.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        devicetree@vger.kernel.org, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v8] mwifiex: parse device tree node for PCIe
References: <1479472624-22340-1-git-send-email-akarwar@marvell.com>
        <87oa1coj1m.fsf@purkki.adurom.net>
        <CACK8Z6EAXTd07ZK3Y6Hy=7iGEY0fN91gO9Tz0NMh+shDAJoc+A@mail.gmail.com>
Date: Sat, 19 Nov 2016 08:56:15 +0200
In-Reply-To: <CACK8Z6EAXTd07ZK3Y6Hy=7iGEY0fN91gO9Tz0NMh+shDAJoc+A@mail.gmail.com>
        (Rajat Jain's message of "Fri, 18 Nov 2016 08:38:52 -0800")
Message-ID: <87lgwghsa8.fsf@kamboji.qca.qualcomm.com> (sfid-20161119_075627_183867_6F032C67)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajat Jain <rajatja@google.com> writes:

> On Fri, Nov 18, 2016 at 8:21 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>
>     > @@ -10,6 +10,8 @@ Required properties:
>     >=C2=A0 =C2=A0 - compatible : should be one of the following:
>     >=C2=A0 =C2=A0 =C2=A0 =C2=A0* "marvell,sd8897"
>     >=C2=A0 =C2=A0 =C2=A0 =C2=A0* "marvell,sd8997"
>     > +=C2=A0 =C2=A0 =C2=A0* "pci11ab,2b42"
>     > +=C2=A0 =C2=A0 =C2=A0* "pci1b4b,2b42"
>
>     Are these correct? In v6 Rob said:
>
>     "I think I already said this, but you have the vendor and product IDs
>     reversed."
>
>     https://patchwork.kernel.org/patch/9390225/
>=20=20=20=20
>
>
> I had responded to it:
>
>
> Hi Rob,
>
>> I think I already said this, but you have the vendor and product IDs
>> reversed.
>
> Actually Marvell has 2 vendor IDs assigned to it. In include/linux/pci_id=
s.h:
>
> #define PCI_VENDOR_ID_MARVELL           0x11ab
> #define PCI_VENDOR_ID_MARVELL_EXT       0x1b4b
>
> So in this case the compatible property describes a single product ID,
> with both possible vendor IDs.

Ok, I missed that.

BTW, please avoid using HTML. text/plain is very much preferred.

--=20
Kalle Valo
