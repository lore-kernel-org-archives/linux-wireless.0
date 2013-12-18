Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab3LRNMa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 08:12:30 -0500
Message-ID: <52B19F38.7060503@redhat.com> (sfid-20131218_141247_440749_3CEE9363)
Date: Wed, 18 Dec 2013 14:12:24 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com,
	Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>, arend@broadcom.com
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com> <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com> <52B17973.1000608@broadcom.com>
In-Reply-To: <52B17973.1000608@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 12/18/2013 11:31 AM, Arend van Spriel wrote:
> On 12/05/2013 10:46 PM, Julian Calaby wrote:
>> Firstly, are there any plans to support the BCM43362 chipset with the
>> brcmfmac driver in the near future?
>
> Hi Julian,
>
> I am working on a patch to support this chip. It is looking promising.
> Just have to go after a firmware image to be sure.

Cool. Do you have a cubietruck? With my latest wip tree:
https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-next

We've mmc/sdio controller support on top of 3.13-rc4, it would be
nice if we could also get the wifi and bluetooth to work here.

I'm certainly willing to give some patches for this a try. Do you
have an example of what the dts file for a board with broadcom sdio
wifi looks like ?

Regards,

Hans


p.s.

Your last name seems Dutch, are you Dutch, and if so, are you
located in the Netherlands?
