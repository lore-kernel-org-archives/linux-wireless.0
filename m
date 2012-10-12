Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38189 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab2JLId1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 04:33:27 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so1905892lbo.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2012 01:33:25 -0700 (PDT)
Message-ID: <5077D5D2.6020302@gmail.com> (sfid-20121012_103333_242216_5E7D9423)
Date: Fri, 12 Oct 2012 10:33:22 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	linville@tuxdriver.com,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	achadd@qca.qualcomm.com
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com> <20121011203112.GB3317@kroah.com> <5077BE43.7050200@gmail.com> <CAGRGNgVAuV7bYaU0rMZit81PFdpSprfdJkaqHqnm1WGx_FBtVA@mail.gmail.com>
In-Reply-To: <CAGRGNgVAuV7bYaU0rMZit81PFdpSprfdJkaqHqnm1WGx_FBtVA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-12 10:23, Julian Calaby wrote:
> Hi Pontus,
>
> On Fri, Oct 12, 2012 at 5:52 PM, Pontus Fuchs <pontus.fuchs@gmail.com> wrote:
>> * The FW API is reverse engineered and no real documentation is available.
>
> Have you asked the Atheros guys (mostly CC'd) if there's any
> possibility of the documentation / firmware being released?
>

Yes I have. Adrian promised to see what could be done regarding docs.

The FW blob is already released under a good license. I guess the best 
thing would be if Adrian or Luis could submit the fw to linux-firmware 
but lets deal with that when/if the driver gets merged.

Cheers,

Pontus

