Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62674 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZCUV6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 17:58:08 -0400
Received: by fxm2 with SMTP id 2so1315786fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 21 Mar 2009 14:58:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C55670.6010705@jumpy.it>
References: <49C55670.6010705@jumpy.it>
Date: Sat, 21 Mar 2009 22:57:49 +0100
Message-ID: <69e28c910903211457n147735fao93f296a2f9107853@mail.gmail.com> (sfid-20090321_225811_918269_53E10031)
Subject: Re: bug notify
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: ciccio <aspcicc@jumpy.it>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 21, 2009 at 10:04 PM, ciccio <aspcicc@jumpy.it> wrote:
> computer acer 5737z that uses atheros AR928X wireless adapter
> PCLinuxos 2009.1 installed that uses kernel 2.6.26.8
> I have downloaded compat-wireless-old and i obtain errore during make=
:
>
> ***ERROR: CONFIG_MAC(=3D"!!_QOS is somehow enabled in your kernel, ho=
w did
> that happen.....................

CONFIG_MAC80211_QOS?

BTW can you upload a full log of "make V=3D1"?

> ...........
>
> Goodbye
>
> I have installed old kernel 2.6.24 and make goes good but at the end =
of make
> install i receive an error in depmod but ath9.ko is compiled and inst=
alled
> and works.
>
> Now i want to try sidux that uses kernel 2.6.28
>
> Goodbye
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Thanks,
G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
