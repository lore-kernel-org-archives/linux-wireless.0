Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30892 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980Ab2JLLtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 07:49:55 -0400
From: "Chadd, Adrian" <achadd@qca.qualcomm.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>,
	Julian Calaby <julian.calaby@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>, "s.L-H@gmx.de" <s.L-H@gmx.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"Manoharan, Sujith" <c_manoha@qti.qualcomm.com>,
	"Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qca.qualcomm.com>
Subject: RE: [PATCH 0/4] Driver for the ar5523 chipset
Date: Fri, 12 Oct 2012 11:45:01 +0000
Message-ID: <48EC4E8D43A28947B1AB2639FA97CDB90C0217C6@nasanexd02a.na.qualcomm.com> (sfid-20121012_134958_113156_1EFB1C9E)
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
 <20121011203112.GB3317@kroah.com> <5077BE43.7050200@gmail.com>
 <CAGRGNgVAuV7bYaU0rMZit81PFdpSprfdJkaqHqnm1WGx_FBtVA@mail.gmail.com>,<5077D5D2.6020302@gmail.com>
In-Reply-To: <5077D5D2.6020302@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeah, leave it with me. I'm still trying to chase down the right person internally to speak to about such old hardware. :-)

I'll let you know if I can find the firmware source and tools.



Adrian

________________________________________
From: Pontus Fuchs [pontus.fuchs@gmail.com]
Sent: Friday, 12 October 2012 1:33 AM
To: Julian Calaby
Cc: Greg KH; linux-wireless@vger.kernel.org; hch@lst.de; s.L-H@gmx.de; linville@tuxdriver.com; Rodriguez, Luis; Manoharan, Sujith; Shajakhan, Mohammed Shafi (Mohammed Shafi); Chadd, Adrian
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset

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

