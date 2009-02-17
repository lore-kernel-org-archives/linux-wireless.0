Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:48468 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368AbZBQQFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 11:05:34 -0500
Message-ID: <499AE03C.9050008@lwfinger.net> (sfid-20090217_170539_385635_35F92452)
Date: Tue, 17 Feb 2009 10:05:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?VmlrdG9yIElsaWphxaFpxIc=?= <viktor.ilijasic@gmail.com>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: rtl8187 not handling my usb card
References: <4999F3A6.7020208@gmail.com> <4999F427.4060008@lwfinger.net>	 <3ace41890902161603o447ae321obb536586dcafad69@mail.gmail.com>	 <499A00D7.1080000@lwfinger.net> <63d38a500902170149q275bcb87r9ada40439a013dc7@mail.gmail.com>
In-Reply-To: <63d38a500902170149q275bcb87r9ada40439a013dc7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Viktor Ilija=C5=A1i=C4=87 wrote:
> Hi all.
>=20
> Yesterday evening I tried John's patch (I manually added those two
> lines to the source), and the driver properly loads and it seem to
> work.
>=20
> However.... it would seem that my card died some time in the last few
> days. It works for about 10-15 seconds after i plug it in, and then
> "dies". I'd say that when it gets warm, it's out of the game.
>=20
> In Linux after i plug it in, it works just enough time to:
> 1. detect networks in ubuntu network manager (and return a nice scan
> result with iwlist wlan3 scan)
> 2. starts to connect to my network (and reaches random points in conn=
ecting)
> 3. stops responding altogether, cannot connect, no more results with
> iwlist scan, etc.
>=20
> I noticed this exact behavior in windows too, yesterday morning,
> before I tried these patches, so linux driver is DEFINITELY not to
> blame.
>=20
> In windows it very shortly detects available networks, starts to
> connect and very soon stops responding and finding networks.
>=20
> I'll return it to shop to be replaced, and I'll report back when I ge=
t
> one that works properly.
>=20
> Also, Larry, I took lsusb -v output during those first few moments
> while the card operates properly, hope it helps:

That output confirms that it is an 8187, not an 8187b.

I also had a Realtek device fail, but after replacement, all has been w=
ell.

Thanks for testing.

Larry

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
