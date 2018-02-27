Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752573AbeB0O2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 09:28:43 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 0/6] qtnfmac: qsr10g pcie backend updates
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
Date: Tue, 27 Feb 2018 16:28:38 +0200
In-Reply-To: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Mon, 5 Feb 2018 18:05:10 +0300")
Message-ID: <87muzufqw9.fsf@purkki.adurom.net> (sfid-20180227_152939_014544_2302C4FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Hello Kalle and all,
>
> Here is a patch set with various fixes and enhacements for qsr10g
> PCIe backend driver. The major changes include the following two
> items:
> - make rmmod/insmod work properly for qtnfmac_pcie driver
> - provide configuration knobs to control NSM (networked standby mode)
>
> NSM (networked standby mode) is not related to WiFi standard. This is
> a term that has been introduced by European Commission in regulation
> No. 1275/2008. Simplifying things a bit, that regulation specifies
> ecodesing requirements for various operating modes. In that document
> =E2=80=98networked standby=E2=80=99 is defined as a condition in which th=
e equipment
> is able to resume a function by way of a remotely initiated trigger
> from a network connection.
>
> Regards,
> Sergey
>
> Sergei Maksimenko (3)
>   qtnfmac: implement asynchronous firmware loading
>   qtnfmac: enable reloading of qtnfmac kernel modules
>   qtnfmac: enable networked standby mode on device
>
> Sergey Matyukevich (3)
>   qtnfmac: fix releasing Tx/Rx data buffers
>   qtnfmac: fix rmmod for firmware version mismatch
>   qtnfmac: fix rmmod for missing firmware

BTW, I don't see this patchset on patchwork.kernel.org[1], strangely I
only see v2. I don't know if it's because of problems on patchwork or
the submitter deleted the patches, but in case someone did delete these
please do not that. I want to see the old versions from patchwork to
check the old discussions etc.

[1] https://patchwork.kernel.org/project/linux-wireless/list/?state=3D*&q=
=3Dqtnfmac

--=20
Kalle Valo
