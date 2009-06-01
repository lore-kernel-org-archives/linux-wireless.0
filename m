Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZFAMi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 08:38:56 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090601122839.GB11011@khazad-dum.debian.net>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk>
	 <20090601122839.GB11011@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-G5U1Bo3zYME4H/A/HaT2"
Date: Mon, 01 Jun 2009 14:38:51 +0200
Message-Id: <1243859931.5299.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G5U1Bo3zYME4H/A/HaT2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 09:28 -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 01 Jun 2009, Alan Jenkins wrote:
> >> See, Henrique says that the use case is Thinkpads which store the
> >> previous state in the BIOS. But that matters to you only if you use a
> >> mixture of operation systems, which we don't have to support.
>=20
> Well, if you do all in userspace, how do you propose to avoid the usual r=
ace
> conditions of the sort "radio starts on, but it should have started off",
> etc?  You'd have to kick the radios off on rfkill module load for safety,
> and that will also cause nastyness (it kicks my built-in wlan
> (eeepcargh)/bluetooth(most)/wwan(most) off bus, then hotplugs it again!).

Have you bothered reading the code? If you turn things off with
CHANGE_ALL that applies to hot-plugged devices too.

johannes

--=-G5U1Bo3zYME4H/A/HaT2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI8vYAAoJEODzc/N7+QmamtoP/AyTP7j1l42rr1hZI9Rj/JGf
GxTFRH++IxuWpCYO3KAytammySjAoR7+rrhjMRuwrSUBd+p72X9zymIl7j8TSMBQ
T6qQWr4rK4SpJGwuIkrmcyU4T6TPOYa5Pvtv4OwlYSGzNnIs7Q6aBqldwpEpQX8T
PJ8jGqwEVeYHcuBUGMooTd1k5eDWiFxOOXu1PULx+/v/hTzYNZE7ACwhZcavp0Ln
RF/cS2OAfRYZsOROt16FsG9Vl4Wg19y5c7+qJUP2qQMqaglSBTeoLgQWj4Fa3SOV
oYbHCevygdeKGF2ziTUBcLyWWuh+/cpMs2+V5dyNiF+YKmfn39Bqrcji+Rp+hqYf
+EDopsly8F8+s8w5T1IZQ8D49+yKFf/ymWfN/MaCjhFvTGfcSkMjCbmYPMERf8dm
uq1JrKjdBwPfky5D4GTEhfimkxdAQ5xfRsidgc5QIGZ3qNpjF34uujsOwtlyiZH8
E+FcA2sz3XmvWnunMcFSF5dlv6kqKw9j8PBIHExCoiOsobGuUwj9pvr67jHl77ix
2kD+rq02bibrma8ccjWLXjumfkxgfSs/w0MIXHUZagVGOPVtTEvZhIu9eViehybI
vMLtwvMuE43YPoIYR7DfK8tAa21Gv/xVIyryZoMYA7sB3yfWnkQqSK8E9k9dTnUg
dFWtw6g1Pu0ItW84lXKL
=wCfe
-----END PGP SIGNATURE-----

--=-G5U1Bo3zYME4H/A/HaT2--

