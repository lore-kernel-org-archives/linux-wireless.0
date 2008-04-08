Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:15572 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYDHAzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 20:55:05 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1722298wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2008 17:55:04 -0700 (PDT)
Message-ID: <45e8e6c40804071755u1a99e2edxd1722aaeb71e3117@mail.gmail.com> (sfid-20080408_015508_745408_C2142F9A)
Date: Mon, 7 Apr 2008 17:55:04 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Tim Harvey" <tim_harvey@yahoo.com>
Subject: Re: Libertas SDIO card?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <974457.55682.qm@web35605.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <974457.55682.qm@web35605.mail.mud.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gumstix sells the SDIO version of the '8385 with a (documented)
surface mount connector:
http://gumstix.com/store/catalog/product_info.php?cPath=31&products_id=191
it's not an SD Card out of the box, but you could probably make one
from it if you had to, at least for a prototype.

  -Andrey

On Mon, Apr 7, 2008 at 5:19 PM, Tim Harvey <tim_harvey@yahoo.com> wrote:
> > On Fri, 04 Apr 2008 16:29:11 -0700, Tim Harvey wrote:
>  >
>  >> Does anyone know what SDIO cards are available that use a Marvell
>  >> 88W8385/88W8386 'Libertas' chipset?  Looks like 2.6.24 has a libertas SDIO
>  >> driver but I've not been able to locate a vendor/manufacturer of one yet.
>  >>
>  >> Thanks for any info,
>  >>
>  >> Tim
>  >
>  >My Motorola A910 cellular phone has one of those built in. Surely, they
>  >got it from somewhere...
>  >
>
>  Yes, your cell-phone has one of the 88W8385/88W8386 chips built-in but not as an SDIO 'card'.
>  I'm looking for an SDIO card with the Libertas chipset.
>
>  Thanks,
>
>  Tim
>
>
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
