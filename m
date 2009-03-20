Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56582 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752475AbZCTXEy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 19:04:54 -0400
Cc: lrodriguez@atheros.com, johannes@sipsolutions.net,
	linville@tuxdriver.com, greg@kroah.com,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 21 Mar 2009 00:04:48 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <200903202159.41613.chunkeey@web.de>
Message-ID: <20090320230448.261020@gmx.net> (sfid-20090321_000457_387438_F699F902)
MIME-Version: 1.0
References: <200903170408.12626.chunkeey@web.de>
 <200903202036.09255.chunkeey@web.de> <20090320200736.261050@gmx.net>
 <200903202159.41613.chunkeey@web.de>
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's
 otus)
To: Christian Lamparter <chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo Christian!

> Now, what "changes" are you referring to?

I wand see this changes in Johannes' git.

> Most of the qos, hw & rate control changes were already present in
> Johannes' tree.

No rate control like minstrel doesn't work in Johannes' git tree. It ha=
ngs ever at 1 MBit and don't come higher.

> What's missing? Well, there is no BA (fail) & MCS rate report, true..=
=2E
> But under normal operation the rate should go up or down depending on=
 the
> current link quality.
>=20
> However, please tell me about your idea. As my way of solving this is=
sue
> properly has some drawbacks (of course, I'm _fully_ aware of them)!

I must test your code first to answer.

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
