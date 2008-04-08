Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web35605.mail.mud.yahoo.com ([66.163.179.144]:30036 "HELO
	web35605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750988AbYDHPdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 11:33:37 -0400
Date: Tue, 8 Apr 2008 08:33:36 -0700 (PDT)
From: Tim Harvey <tim_harvey@yahoo.com>
Subject: Re: Libertas SDIO card?
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <634515.88168.qm@web35605.mail.mud.yahoo.com> (sfid-20080408_163342_941039_9C09156E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the Wistron NeWeb DRCM81 802.11b/g module (more info here: http://www.avr32linux.org/twiki/bin/view/Main/WirelessNetworking)

While the Libertas 88W8385/88W8386 chips support SDIO this particular module supports only CF down to its connector.

However, again, I'm specifically looking for an SDIO form-factor 'card' but at this point I don't think anyone makes one.

Thanks,

Tim

>
>
>----- Original Message ----
>From: Andrey Yurovsky <andrey@cozybit.com>
>To: Tim Harvey <tim_harvey@yahoo.com>
>Cc: linux-wireless@vger.kernel.org
>Sent: Monday, April 7, 2008 5:55:04 PM
>Subject: Re: Libertas SDIO card?
>
>Gumstix sells the SDIO version of the '8385 with a (documented)
>surface mount connector:
>http://gumstix.com/store/catalog/product_info.php?cPath=31&products_id=191
>it's not an SD Card out of the box, but you could probably make one
>from it if you had to, at least for a prototype.
>
>  -Andrey
>
>On Mon, Apr 7, 2008 at 5:19 PM, Tim Harvey <tim_harvey@yahoo.com> wrote:
>> > On Fri, 04 Apr 2008 16:29:11 -0700, Tim Harvey wrote:
>>  >
>>  >> Does anyone know what SDIO cards are available that use a Marvell
>>  >> 88W8385/88W8386 'Libertas' chipset?  Looks like 2.6.24 has a libertas SDIO
>>  >> driver but I've not been able to locate a vendor/manufacturer of one yet.
>>  >>
>>  >> Thanks for any info,
>>  >>
>>  >> Tim
>>  >
>>  >My Motorola A910 cellular phone has one of those built in. Surely, they
>>  >got it from somewhere...
>>  >
>>
>>  Yes, your cell-phone has one of the 88W8385/88W8386 chips built-in but not as an SDIO 'card'.
>>  I'm looking for an SDIO card with the Libertas chipset.
>>
>>  Thanks,
>>
>>  Tim
>>
>>
>>
>>
>>  --
>>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>  the body of a message to majordomo@vger.kernel.org
>>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>



