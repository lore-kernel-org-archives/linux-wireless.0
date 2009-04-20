Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbZDTTxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 15:53:41 -0400
Subject: Re: [PATCH 0/4] mac80211 powersave work
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090420194430.GG3369@tuxdriver.com>
References: <20090416111723.904720021@sipsolutions.net>
	 <20090420194430.GG3369@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-p4gP/Gpob4Q3thpjAXeV"
Date: Mon, 20 Apr 2009 21:53:08 +0200
Message-Id: <1240257188.4632.19.camel@johannes.local> (sfid-20090420_215345_644496_C9549A61)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p4gP/Gpob4Q3thpjAXeV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-20 at 15:44 -0400, John W. Linville wrote:
> On Thu, Apr 16, 2009 at 01:17:23PM +0200, Johannes Berg wrote:
> > This is pretty much unchanged from my previous v2 RFCs,
> > except that I added a default of 500ms for the dynamic
> > powersave timer.
> >=20
> > The fourth patch is new, it adds beacon filtering to
> > mac80211 -- for the reasons explained in that patch.
> >=20
> > For 2.6.31, we should make MAC80211_DEFAULT_PS default
> > off instead. John, how do you want to handle that?
>=20
> I'm not sure I understand.  Your patch (which would go to 2.6.31)
> has it turned-on by default.  Which way do you want it?

I want it turned on by default, at least in wireless-testing; Kalle
thinks that we should turn it off for a .31 release.

I would think that since an easy workaround is available ("iwconfig
wlan0 power off") and it doesn't affect most hardware yet anyway (only
those supporting powersave) we should turn it on by default anyway,
since otherwise we won't find any bugs -- but maybe that's just me.

johannes

--=-p4gP/Gpob4Q3thpjAXeV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7NKhAAoJEKVg1VMiehFYT0MQAJaBlwzbQl548hC+NsXV8Foq
KGGHY73bQOL5fRdJaSdAEjE6lNZl7awYWXJrM42UEQEbdoOdpyAQSuUl5W1+iH3h
lk6CUZMpnF6D0sxYcY/qv/Bx4aAUOcqH1ZZ+GHUfTrrmp9N2cLYBybpT1qjnUEQH
BmqO4oA8tbbUuEp8S9r3XFFQNZY8sIZ44XXvWHidVxXIzU5WKoZ6Uw1DAzzKtCGR
TB/SK13O16mNkiROLzkCD9+ARMhtNWLhwPvUvVVUgpL2BFMy4FL7U2h4WxQZiiYg
+muDfMiigSFGa+IulwVGB600mMQHkJATAPutytYtZTv7VdN+bwXkYSDeY6j/gHbW
j9HET4FdSVOz9PmOn+FD9j6zARKchtn1m1a4QaGroa9TniPtIxTqXPBtPHJJtKYw
NfXQdokuWMndkMrdyJdxC69PXsfnVsc1NIRcwSfgxAfalMGk7mQ66s3niNxxh50A
zQSjfz3ktzdsdbBGl5dH9/GSjk1PqI7Jkt848FH8peyrOcsHGBUzs/DWMaRhNgAO
p8ox75Xv+CZPmyNvrbD1zP80KzQGQXI75bgmMMS/PetllDpIP0SoPtAZ4MN5Oer0
wexuAMxaD/BPgnkyOFTURv+pKaXWs9KwQpRffTqU+jnZ/uzuBwdcrFyeDQNsCWvW
Pl2w1rOqVKt/vBjWpL4/
=1QD+
-----END PGP SIGNATURE-----

--=-p4gP/Gpob4Q3thpjAXeV--

