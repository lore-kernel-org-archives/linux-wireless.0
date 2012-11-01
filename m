Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59003 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2KARlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 13:41:09 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so2058697lbo.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2012 10:41:08 -0700 (PDT)
Message-ID: <5092B430.7040409@gmail.com> (sfid-20121101_184128_925229_486692A2)
Date: Thu, 01 Nov 2012 18:41:04 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	linville@tuxdriver.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	achadd@qca.qualcomm.com
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com> <20121011203112.GB3317@kroah.com> <5077BE43.7050200@gmail.com> <CAGRGNgVAuV7bYaU0rMZit81PFdpSprfdJkaqHqnm1WGx_FBtVA@mail.gmail.com> <5077D5D2.6020302@gmail.com> <CAJ-Vmom7ENhQ4mxq6w1yj-o3ZPK1wz2gPfd+m0fcHFvm6kvk8g@mail.gmail.com>
In-Reply-To: <CAJ-Vmom7ENhQ4mxq6w1yj-o3ZPK1wz2gPfd+m0fcHFvm6kvk8g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-30 18:08, Adrian Chadd wrote:

>> I've found the firmware source. I have no idea how difficult it will
>> be to build today, but it's a MIPS CPU core so I should be able to do
>> it with a cross-compiled MIPS GCC.
>>
>> I've also found the AR5523 datasheet here.
>>
>> So, poke me if you'd like me to look up what's going on. It honestly
>> looks like a MIPS core with a USB device controller and an AR5212 MAC
>> (the datasheet refers to the AR5212 MAC/BB documentation, so it's
>> quite likely exactly that.)
>>

Thanks for looking into this. Sounds great. Is it possible for qca
to share any of this me, with or without NDA?

Cheers,

Pontus
