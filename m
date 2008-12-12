Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49850 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754930AbYLLPTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 10:19:14 -0500
Date: Fri, 12 Dec 2008 17:16:19 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stefanik =?utf-8?B?R8OhYm9y?= <netrolller.3d@gmail.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Thomas d'Otreppe" <tdotreppe@aircrack-ng.org>
Subject: Re: [PATCH 3/3] mac80211: Add HT rates into radiotap
Message-ID: <20081212151619.GA16981@jm.kir.nu> (sfid-20081212_161920_296478_61BF08D9)
References: <20081212123832.506588839@atheros.com> <20081212123918.723191687@atheros.com> <69e28c910812120647l69b317daxfdbeb914d61ba7e3@mail.gmail.com> <1229093327.3600.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1229093327.3600.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2008 at 03:48:47PM +0100, Johannes Berg wrote:
> On Fri, 2008-12-12 at 15:47 +0100, Stefanik G=C3=A1bor wrote:
>=20
> > Thanks for the heads up, mail forwarded to Thomas d'Otreppe, as thi=
s
> > will need changes in airodump-ng.
>=20
> Guys! This format is brain-dead, it means we don't know 40MHz or SGI,
> let's define something proper in radiotap instead!

While I'm not against defining something more officially for radiotap,
I do not agree with the part about this format being that brain-dead.
Both 40 MHz and short GI are indicated (IEEE80211_CHAN_TURBO and
IEEE80211_RADIOTAP_F_SHORTGI) and shown in the current wireshark
release.

--=20
Jouni Malinen                                            PGP id EFC895F=
A
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
