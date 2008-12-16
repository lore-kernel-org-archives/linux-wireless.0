Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48820 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbYLPQ4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 11:56:52 -0500
Received: by bwz14 with SMTP id 14so4121591bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 08:56:51 -0800 (PST)
Message-ID: <45e8e6c40812160856k37cc7e44mc9f512baec0f888e@mail.gmail.com> (sfid-20081216_175656_151204_F2783458)
Date: Tue, 16 Dec 2008 08:56:50 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Peter Wippich" <pewi@gw-instruments.de>
Subject: Re: [PATCH 0/3] libertas: driver for GSPI devices
Cc: "Colin McCabe" <colin@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <Pine.LNX.4.63.0812161654310.7559@redbean.intranet.gw-instruments.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229398052-27465-1-git-send-email-colin@cozybit.com>
	 <Pine.LNX.4.63.0812161654310.7559@redbean.intranet.gw-instruments.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Peter.  The firmware we used is fw 9.70.3p37 and its cap mask is 0x303.

We expect this firmware to be available for download soon.  Thanks,

On Tue, Dec 16, 2008 at 7:56 AM, Peter Wippich <pewi@gw-instruments.de> wrote:
>
> Hi Colin,
>
>> This patch series adds support for GSPI devices to libertas.
>> These devices are found in some embedded systems. We used a blackfin-based
>> board for development.
>>
>> Since the blackfin has specific alignment requirements, this patch set
>> includes  alignment fixes.
>
> Thanks for this one. As you mentioned somewhere else SPI Firmware for 8686
> is not publicly available. However, can you tell me with which firmware
> Version you tested this ??
>
> Thank you and best regards,
>
> Peter
>
>
> |       Peter Wippich                   Voice: +49 30 46776411          |
> |       G&W Instruments GmbH            fax:   +49 30 46776419          |
> |       Gustav-Meyer-Allee 25, Geb. 12  Email: pewi@gw-instruments.de   |
> |       D-13355 Berlin  / Germany                                       |
>
>



-- 
Andrey Yurovsky
cozybit Inc.
