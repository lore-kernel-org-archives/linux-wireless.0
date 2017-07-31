Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50760 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdGaQfO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 12:35:14 -0400
Subject: Re: QCA9994 ath10k chipset
To: Matteo Grandi <iu5bdp@gmail.com>,
        LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
References: <CAHdg3xaLAhxNdegJO-oj-D-fEZg8cZQM5_5pOCFaLSSnBJYw+A@mail.gmail.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5b76c4c9-7d58-ad01-1e3e-f14d88451cfe@candelatech.com> (sfid-20170731_183517_868815_A73D8B78)
Date: Mon, 31 Jul 2017 09:35:13 -0700
MIME-Version: 1.0
In-Reply-To: <CAHdg3xaLAhxNdegJO-oj-D-fEZg8cZQM5_5pOCFaLSSnBJYw+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Very likely 9984 firmware works for 9994, usually the '9' just means
it is expensive and high-temp and/or high-power capable.

I don't know of any 9994 NIC manufacturers....You might could get some
from zcomax or compex, but might take a special order.

Thanks,
Ben

On 07/31/2017 05:47 AM, Matteo Grandi wrote:
> Dear all,
>
> I have to find a miniPCIe Wi-Fi adapters that uses the QCA9994 chipset.
> As far as I discovered looking to the Internet, seems that only the
> Acelink EW-7956MAC uses the QCA9994 chipset, but I didn't find a
> dealer where to purchase it. Contacting Acelink is useless because
> their email " contact@acelink.com.tw" seems to be inexistent: I
> receive a mail delivery status notification.
>
>
> Moreover, having a look on Kalle Valo git repo, I didn't find any
> QCA9994 but only QCA9984 firmwares. And it's quite easier to find
> devices that use the QCA9984 chipset.
>
>
> Does anyone use/have used such QCA9994 chipset?
> Any hint to find a QCA9994 device and its related ath10k firmware will
> be really appreciated.
>
> Thank you in advance
>
> Matteo
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
