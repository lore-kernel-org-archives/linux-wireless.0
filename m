Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48707 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759590AbZCUPWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 11:22:31 -0400
Cc: lrodriguez@atheros.com, linville@tuxdriver.com, greg@kroah.com,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org, chunkeey@web.de
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 21 Mar 2009 16:22:28 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1237648159.5100.218.camel@johannes.local>
Message-ID: <20090321152228.102650@gmx.net> (sfid-20090321_162247_162065_8CFE0292)
MIME-Version: 1.0
References: <200903170408.12626.chunkeey@web.de>	
 <200903202036.09255.chunkeey@web.de> <20090320200736.261050@gmx.net>	
 <200903202159.41613.chunkeey@web.de> <20090320230448.261020@gmx.net>	
 <20090321145933.102650@gmx.net> (sfid-20090321_160004_602859_A9B03B14)
 <1237648159.5100.218.camel@johannes.local>
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's
 otus)
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> > your new code is not compatible with compat-wireless. The function
> > usb_poison_anchored_urbs() is missing in the 2.6.27 kernel.
>=20
> That's something compat has to fix then -- we don't impose any backwa=
rd
> compatibility rules for the kernel code.

ACK, I only want advert on this.

Regards
Alina

--=20
Aufgepasst: Sind Ihre Daten beim Online-Banking auch optimal gesch=FCtz=
t?
Jetzt absichern: https://homebanking.gmx.net/?mc=3Dmail@footer.hb
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
