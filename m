Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35628 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZJ1TbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 15:31:18 -0400
Date: Wed, 28 Oct 2009 15:20:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, IvDoorn@gmail.com
Subject: Re: [PATCH] rt73usb.c : more ids
Message-ID: <20091028192045.GC2856@tuxdriver.com>
References: <4ADC368F.1050709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4ADC368F.1050709@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2009 at 11:51:11AM +0200, Xose Vazquez Perez wrote:
> hi,
> 
> stolen from windows inf file(07/17/2009, 1.03.05.0000)
> Ovislink 0x1b75, 0x7318
> MSI 0x0db0, 0x4600
> WideTell 0x7167, 0x3840
> 
> 
> -thanks-
> 
> regards,
> 
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> 
> -- 
> «Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
> que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
> impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
> que no sienta mi derecho y dé pecho a mi valor.»
> 
> 

> --- o/drivers/net/wireless/rt73usb.c	2009-10-13 12:58:32.042380351 +0200
> +++ n/drivers/net/wireless/rt73usb.c	2009-10-13 13:01:01.073379225 +0200

WTF is this?  That's not where that file lives in any tree I have...

I manually applied this one, but in the future please go to the
effort of sending a patch against the sources everyone else is using.
Not sending it as an attachment and not cluttering the changelog
with "hi...thanks, regards..." etc would be appreciated as well.
Maybe you could even read the link I sent you previously...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
