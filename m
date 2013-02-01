Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38023 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3BANdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 08:33:43 -0500
Received: by mail-ie0-f174.google.com with SMTP id k10so3360257iea.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2013 05:33:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359725329-8027-1-git-send-email-xose.vazquez@gmail.com>
References: <1359725329-8027-1-git-send-email-xose.vazquez@gmail.com>
Date: Fri, 1 Feb 2013 14:33:43 +0100
Message-ID: <CAL1gcdOXY0Gy05sMKxpXbuBtDSzXBxfJCfTfs+BTpQ_oPfT9Eg@mail.gmail.com> (sfid-20130201_143346_186505_E3170EE0)
Subject: Re: [PATCH wireless-next] wireless: rt2x00: rt2800pci add id
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 1, 2013 at 2:28 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> 0x1814,0x359f is a RT3592 802.11a/b/g/n 2x2 WiFi Adapter
> support added by 872834dfb38edc6f72cfc783a5ce78f2a9f36ec5
>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: users@rt2x00.serialmonkey.com
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 0e8d170..48a01aa 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1152,6 +1152,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>         { PCI_DEVICE(0x1814, 0x3562) },
>         { PCI_DEVICE(0x1814, 0x3592) },
>         { PCI_DEVICE(0x1814, 0x3593) },
> +       { PCI_DEVICE(0x1814, 0x359f) },
>  #endif
>  #ifdef CONFIG_RT2800PCI_RT53XX
>         { PCI_DEVICE(0x1814, 0x5360) },
> --
> 1.7.11.7
>



--
---
Gertjan
