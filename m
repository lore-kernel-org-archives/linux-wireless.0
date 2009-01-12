Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57488 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751094AbZALEPg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 23:15:36 -0500
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=iso-8859-1
Date: Mon, 12 Jan 2009 05:15:34 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090110091659.GC1170@jm.kir.nu>
Message-ID: <20090112041534.24150@gmx.net> (sfid-20090112_051544_424007_F5A62DCD)
MIME-Version: 1.0
References: <20090106020130.302750@gmx.net> <20090108091055.GA7009@jm.kir.nu>
 <20090109205315.277310@gmx.net> <20090110091659.GC1170@jm.kir.nu>
Subject: Re: [PATCH] Fixed BSSID step 3: Don't merge with the same BSSID
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jouni!

> Yes, I think it would be better option than removing it and the
> reset_tsf()
> call. Removing STA entries for other IBSS members in any merge case,
> even if BSSID changes, does not sound correct in the first place. Thi=
s
> should really only be done if the SSID changes.
>=20
> [...]
>=20
> For the particular problem that you are
> seeing, the minimal change would probably be just to make
> sta_info_flush_delayed() call conditional on SSID change (I don't thi=
nk
> this would need to be based on BSSID change).

If the others agree, I can implement it in the end of the week. Or do y=
ou want it the other way?
I personally don't want change too much...?

Regards
Alina
--=20
Sensationsangebot verl=E4ngert: GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
