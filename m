Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:50466 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345AbZKDWft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 17:35:49 -0500
Received: by iwn10 with SMTP id 10so5337822iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 14:35:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257366885.15872.0.camel@localhost.localdomain>
References: <496C8468.4060101@tsr.se> <20090113145213.GA3623@tuxdriver.com>
	<1231951654.14909.22.camel@localhost.localdomain> <496E1D6A.10505@gmail.com>
	<496E3075.6090901@tsr.se> <1231959472.14909.73.camel@localhost.localdomain>
	<4AF1763C.4010901@tsr.se> <m3eioe48c0.wl%holgerschurig@googlemail.com>
	<1257366885.15872.0.camel@localhost.localdomain>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 5 Nov 2009 09:35:34 +1100
Message-ID: <646765f40911041435r5de12f24u6ab0bfb1da31988e@mail.gmail.com>
Subject: Re: Marvell 88w8385 Support
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <holgerschurig@googlemail.com>,
	tsr <tsr.offentlig@tsr.se>, linux-wireless@vger.kernel.org,
	mangoo@wpkg.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 5, 2009 at 07:34, Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2009-11-04 at 16:29 +0100, Holger Schurig wrote:
>> > From what I can tell there was a patch (referenced here:
>> > http://marc.info/?l=linux-wireless&m=123782768023390&w=2) to fix this
>> > but I also get indications that this is not the case since there is both
>> > a USB and miniPCI version of the 88w8385.
>>
>> This patch is only for the CF/PCMCIA versions of this those chips.
>>
>> There is no if_pci.c yet inside drivers/net/wireless/libertas/, if you
>> are certain you've a PCI card you're welcome to write one, should be
>> pretty easy. You can get help by looking at the other if_*.c files for
>> other physical interfaces.
>>
>>
>> > You write something
>> > (http://marc.info/?l=linux-wireless&m=124334594302472&w=2) that is
>> > cryptic to me.
>>
>> Can you elaborate?  What exactly here is cryptic?
>>
>> CF/SDIO/GSPO/USB ?
>> 8015/8385 ?
>>
>>
>> > Also searching the kernel gittree I found
>> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/wireless/libertas/if_spi.c;h=06a46d7b3d6c2460aecd793d2827033c7c0348f6;hb=cadeba315cc91ae1b57632e61b0cec3a4ed7088d
>> > which seems to include a driver for the miniPCI libertas 88w8385.
>>
>> No, if_spi.c is an indicator that this is  for an SPI or GSPI.
>>
>> There's to my knowledge no such thing as a PCI-based Marvell 8385
>> chip/card/whatever.
>
> I'm fairly sure 8385 is only CF and SDIO.
>
> Perhaps he means 8335 instead?  That was available in both USB and PCI,
> but it's a softmac part that doesn't have mwl8k support yet afaik.

Looking through the first half of this thread, he does seem to mean that.

You mentioned that you were working on building support for 8335s into
mwl8k, have you made any progress?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
