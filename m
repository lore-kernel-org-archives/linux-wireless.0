Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from col0-omc4-s4.col0.hotmail.com ([65.55.34.206]:34698 "EHLO
	col0-omc4-s4.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbZCPPEH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 11:04:07 -0400
Message-ID: <COL113-W3112753E5580938034189ECB9B0@phx.gbl> (sfid-20090316_160410_610221_2DFA95B0)
From: Adrian Bassett <adrian.bassett@hotmail.co.uk>
To: <larry.finger@lwfinger.net>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: rtl8180 Bit Rate regression in 2.6.29
Date: Mon, 16 Mar 2009 15:04:06 +0000
In-Reply-To: <49BE64CF.8020407@lwfinger.net>
References: <COL113-W348B209977311F6BB460ADCB9B0@phx.gbl>
 <49BE64CF.8020407@lwfinger.net>
Content-Type: text/plain; charset=Windows-1252
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Thanks for the quick response.

I already use git and kernel source from kernel.org so I'll branch out,=
 follow the bisect instructions in git man/docs, and see what I can com=
e up with ...

Adrian Bassett

> Date: Mon, 16 Mar 2009 09:40:15 -0500
> From: Larry.Finger@lwfinger.net
> To: adrian.bassett@hotmail.co.uk
> CC: linux-wireless@vger.kernel.org
> Subject: Re: rtl8180 Bit Rate regression in 2.6.29
>=20
> Adrian Bassett wrote:
>>=20
>> (I'm not currently subscribed so please Cc: in any response ...)
>>=20
>> Using PCI device 1799:700f and the rtl8180 kernel wireless driver.
>>=20
>> With the vanilla 2.6.29-rc releases (rc8 most recently but also with=
 predecessors) I've noticed that the Bit Rate of my wireless device app=
ears to be more or less fixed at 1 Mb/s.  Occasionally, iwconfig report=
s higher values but, as the stats below show, no attempts are successfu=
l at higher Bit Rates with this kernel version.
>>=20
>> With the 2.6.28 series, however, the Bit Rate will vary in the norma=
l way, with the majority of the network activity happening at the highe=
r end, if not the highest(54 Mb /s) point, of the range supported by th=
is device.
>=20
> It would be immensely helpful if you, or someone else with this hardw=
are and the
> problem, could use git to download the mainline tree and find the bad=
 commit
> using bisection. In a review of the commit log, I found only one chan=
ge in the
> rtl8180 code in the 2.6.28 to 2.6.29-rcX range, and without it the rt=
l8180 would
> not work at all. As a result, I cannot suggest a trial patch.
>=20
> My system says that there are 6172 commits between 2.6.29-rc8 and 2.6=
=2E28, thus
> it will take roughly 13 kernel builds to bisect the problem.
>=20
> Larry

_________________________________________________________________
View your Twitter and Flickr updates from one place =96 Learn more!
http://clk.atdmt.com/UKM/go/137984870/direct/01/--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
