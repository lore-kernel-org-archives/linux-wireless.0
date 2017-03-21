Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17625 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757092AbdCUMZu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 08:25:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Konstantin Koslowski <konstantin.koslowski@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>
Subject: Re: Dell DW1601 (WIL6210)
Date: Tue, 21 Mar 2017 12:21:57 +0000
Message-ID: <87var26cre.fsf@kamboji.qca.qualcomm.com> (sfid-20170321_132553_537199_BD354917)
References: <17d816d3dafddb3447e21808c130f596@rainloop.xkonni.de>
In-Reply-To: <17d816d3dafddb3447e21808c130f596@rainloop.xkonni.de> (Konstantin
        Koslowski's message of "Fri, 17 Mar 2017 08:46:36 +0000")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding wil6210 list)

"Konstantin Koslowski" <konstantin.koslowski@gmail.com> writes:

> I recently acquired a few Dell DW1601 cards and after a few initial
> searches it sounded like they could be used to connect to each other.
> Now it seems that they do not have the wifi connectivity enabled, just WB=
E.
>
> relevant lspci output:
> 03:00.0 PCI bridge [0604]: Wilocity Ltd. Wil6200 PCI Express Root Port
> [1ae9:0101] (rev 04)
> 04:00.0 PCI bridge [0604]: Wilocity Ltd. Wil6200 PCI Express Port [1ae9:0=
200] (rev 04)
> 04:02.0 PCI bridge [0604]: Wilocity Ltd. Wil6200 Wireless PCI Express
> Port [1ae9:0201] (rev 14)
> 04:03.0 PCI bridge [0604]: Wilocity Ltd. Wil6200 Wireless PCI Express
> Port [1ae9:0201] (rev 14)
> 05:00.0 Network controller [0280]: Qualcomm Atheros AR9462 Wireless
> Network Adapter [168c:0034] (rev 01)
>
> So the wifi device does not show up. Seems it needs a different firmware.

I was told that this an older device and it only supports WBE, not
Wi-Fi. So it's not actually supported by wil6210.

--=20
Kalle Valo=
