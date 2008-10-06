Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYJFUnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 16:43:19 -0400
Subject: Re: at76_usb driver status
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, Greg KH <greg@kroah.com>,
	Kalle Valo <kalle.valo@iki.fi>, proski@gnu.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081006203118.GG3448@tuxdriver.com> (sfid-20081006_223213_249783_E57EA54A)
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	 <20081005061603.GB28533@kroah.com>
	 <1223306593.31040.33.camel@dhcp-100-3-195.bos.redhat.com>
	 <20081006183520.GA17647@kroah.com>
	 <1223323940.31717.3.camel@dhcp-100-3-195.bos.redhat.com>
	 <20081006203118.GG3448@tuxdriver.com>
	 (sfid-20081006_223213_249783_E57EA54A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1/JC1xEXZzuMa0LxkvNc"
Date: Mon, 06 Oct 2008 22:42:28 +0200
Message-Id: <1223325748.3778.30.camel@johannes.berg> (sfid-20081006_224322_407465_940DBE71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1/JC1xEXZzuMa0LxkvNc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 16:31 -0400, John W. Linville wrote:
> On Mon, Oct 06, 2008 at 04:12:20PM -0400, Dan Williams wrote:
> > On Mon, 2008-10-06 at 11:35 -0700, Greg KH wrote:
>=20
> > > I'll gladly drop it from drivers/staging when the "real" version hits
> > > mainline, until then, it should stay in staging, as that is the whole
> > > point of it.
> >=20
> > It does nobody any good if (a) the drivers are _never_ going to go
> > upstream, and (b) if the drivers aren't going to get any attention in
> > their current form because of (a).
> >=20
> > I don't care if the driver allows peoples hardware to work; I want a
> > driver that makes peoples hardware work _well_.  Out of tree drivers
> > that are never going upstream will not work well.
>=20
> I think/thought the main point of -staging was to give drivers
> visibility in hopes of people working to fix them.

Shouldn't then the mac80211-based at76_usb be in -staging instead? That
one might not work completely, but at least it's fixable without a
rewrite.

johannes

--=-1/JC1xEXZzuMa0LxkvNc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6ngxAAoJEKVg1VMiehFYRVYP/3PBEBsvKRPpxYRKULvQSty9
TJ1+UsJxTirXq+mL2xY9nQmJYfdlrr8q3BposKS5+sXOw4SAgdcA7HatnKtmbYpK
MO45J9gV2svm9FPFpKIdvTnAccYgcyF3EQlHLOWorjYEMZK19ycQBmVejSUgPQXF
W/bfW54eyV92jhPfTs0bA4POMDhnX8mnJTLwKHUzytJ03p8iIIMk6AxH96tZZS3/
Gc6kDuaHVfyjbs9wYmB+C0iV77Eax40pWafTBXw2ze9o8bXmvzKwX2cHdK64vhMd
XbgMo2/LlftHxpwArpCbKljxEHa6pEECxikONLrc5UXPq7hhwQkzMNUUFuKAk0Nl
o/ch3H5RZAtfAJaqtreue1BcyYjuiFh+Psh8MDDEyUVQGk14hAGgJbt9BUxg0Ni4
b/5+RYvNBpLFkiCA1t7PYNNm15GJibtKjGL+oLaIWTBYy1vigkuqDTR5KcD5s0Ko
jw/u9GqMBSwuYAetCj7ov7k1180C43lhHfgLzNYbBMBUjEUBdBefAGuvkIbVIJjs
kjnQocgn8RPQgTD9ecAysc6nJZZDmYdYj/3B/0otWGausoPzXzeTHww+Ve583G8F
w3yGEva1MybCL7MReX4f54ATpaOKIDU2fgULnLrMaYuZePHbH8/8mf79qU4vLE/v
AVYw311dMCxfbQN93AVO
=qtUQ
-----END PGP SIGNATURE-----

--=-1/JC1xEXZzuMa0LxkvNc--

