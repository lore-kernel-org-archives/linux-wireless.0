Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:40936 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab3LRQQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 11:16:22 -0500
Message-ID: <52B1CA51.4010202@broadcom.com> (sfid-20131218_171635_620543_FD1DE001)
Date: Wed, 18 Dec 2013 17:16:17 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	<linux-sunxi@googlegroups.com>,
	Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com> <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com> <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com>
In-Reply-To: <52B19F38.7060503@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/2013 02:12 PM, Hans de Goede wrote:
> Hi,
> 
> On 12/18/2013 11:31 AM, Arend van Spriel wrote:
>> On 12/05/2013 10:46 PM, Julian Calaby wrote:
>>> Firstly, are there any plans to support the BCM43362 chipset with the
>>> brcmfmac driver in the near future?
>>
>> Hi Julian,
>>
>> I am working on a patch to support this chip. It is looking promising.
>> Just have to go after a firmware image to be sure.
> 
> Cool. Do you have a cubietruck? With my latest wip tree:
> https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-next

No cubietruck here. I googled the term last week because it came up and
found embeddedcomputer.nl selling it.

> We've mmc/sdio controller support on top of 3.13-rc4, it would be
> nice if we could also get the wifi and bluetooth to work here.
> 
> I'm certainly willing to give some patches for this a try. Do you
> have an example of what the dts file for a board with broadcom sdio
> wifi looks like ?

I am still struggling with dts changes for a Pandaboard. As I understood
the cubietruck uses AP6210 module and the dts really depends on how
things are wired up with it. Apart from the SDIO lines it may have an
additional GPIO output to power the module and GPIO inputs to wakeup the
host and interrupt line.

> Regards,
> 
> Hans
> 
> 
> p.s.
> 
> Your last name seems Dutch, are you Dutch, and if so, are you
> located in the Netherlands?

Geboren en getogen. We hebben idd een Broadcom vestiging in Nederland.

Gr. AvS
