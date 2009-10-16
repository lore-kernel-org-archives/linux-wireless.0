Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:20916 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZJPXOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 19:14:32 -0400
Received: by ey-out-2122.google.com with SMTP id 9so561139eyd.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 16:14:36 -0700 (PDT)
Message-ID: <4AD8FE53.4040500@gmail.com>
Date: Sat, 17 Oct 2009 01:14:27 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, eddy_tsai@ralinktech.com.tw
Subject: Re: [rt2x00-users] [PATCH] rt73usb.c : more ids
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 13, 2009 at 01:20:17PM +0100, Luis Correia wrote:

> 2009/10/13 Xose Vazquez Perez <xose.vazquez@gmail.com>

> > stolen from windows inf file(07/17/2009, 1.03.05.0000)
> > Ovislink 0x1b75, 0x7318
> > MSI 0x0db0, 0x4600
> > WideTell 0x7167, 0x3840
>>
> Are you absolutely sure that these devices are really rt73usb?

No.

I have copied them from windows driver file. No HW here.

> By being in the windows inf file doesn't mean they would work in Linux.

I don't understand why they were added by ralink to the rt73.inf file
*recently* .

Maybe Microsoft's ninjas are trying  to commit sabotage against the
linux kernel ;-)


some information that I have found.

WideTell:
http://www.widetell.com/Product_body.asp?id=212
http://www.widetell.com/Product_body.asp?id=224
http://www.google.es/search?hl=en&q=ralink++site%3Awidetell.com

msi:
http://eu.msi.com/index.php?func=downloaddetail&type=driver&maincat_no=131&prod_no=1308

sorry, nothing about Ovislink. Maybe http://www.airlive.com/product/product_3.jsp?pdid=PD1217466858603


the only people who can know it for sure is the new rt2x00 team member:
Eddy Tsai <eddy_tsai@ralinktech.com.tw> from Ralink Technology

-thanks-

-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
