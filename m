Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:50782 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZDNV5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 17:57:01 -0400
Date: Tue, 14 Apr 2009 10:19:06 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Greg KH <greg@kroah.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090414141852.GB20470@storm.local.network> (sfid-20090414_235707_613913_7B1EDECE)
References: <20090414105200.GE25746@storm.local.network> <1239707258.4778.3.camel@johannes.local> <20090414113928.GA20470@storm.local.network> <1239709727.4778.6.camel@johannes.local> <1239712106.11795.21.camel@violet> <1239713034.17109.10.camel@johannes.local> <20090414130248.GA3291@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
In-Reply-To: <20090414130248.GA3291@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 14, 2009 at 09:02:48AM -0400, John W. Linville wrote:
> On Tue, Apr 14, 2009 at 02:43:54PM +0200, Johannes Berg wrote:
> > Hi Marcel,
> >=20
> > > just to document the irony here. Two or three years ago at OLS, Kyle =
and
> > > Greg were making fun of Ubuntu merging its 5th wireless stack into th=
eir
> > > kernel. Now the staging crap is doing exactly the same.
> >=20
> > :)
> >=20
> > Actually, last I counted it was already 7 or 8 stacks in staging _only_.
> > This (and the other patch) will add two more. Not to mention that of
> > course we already have something like two and a half stacks in the
> > kernel tree (mac80211, in hostapd, and libipw [former ieee80211]).
>=20
> FWIW I had started trying to consolidate some code between those three.
> I stalled-out a bit and got distracted with the rndis_wlan cfg80211
> bits, but I hope to get back to it.  Of course, hostap seems mighty
> complex internally -- it might just have to lay there.  And libipw
> and mac80211 target different types of designs, but I hope they can
> eventually share some infrastructure in lib80211.
>=20
> None of the above is meant to disagree about the staging crap.
> Having that stuff around is at best an optimistic attempt to help a
> few stray users... :-)

Well, gosh, I understand the criticism here and if I were a kernel develope=
r I
imagine my perspective would be much the same.  But I can't help but feel t=
hat
there's some amount of hypocrisy when we hammer on a manufacturer to proper=
ly
license their driver and then let it drop dead when they do.

I understand that the problem would be solved if they manufacturers would
suddenly "get it," but the scale of social problem preventing that is likel=
y too
large to change anytime soon.

If kernel developers are too busy to support the hardware, why do the
manufacturers take so much criticism for releasing binary-only drivers or b=
adly
licensed drivers, or for neglecting to release technical specifications?  If
what I'm sensing is correct and there's no practical likelihood of these de=
vices
getting in-kernel support even with those issues resolved, the criticism al=
most
seems unjustified.

I appreciate what the kernel developers do, of course, and my intention is =
not
to ruffle feathers.  But when a manufacturer that has taken a lot of critic=
ism
for its approach to the Linux community shows some good will, it seems like=
 we
ought to be able to turn that into something productive.  If we can't, what=
 have
we been complaining about?

My apologies if I'm way off on this.  I haven't been around all that long s=
o it
is certainly possible.

Respectfully,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ5JtaRO4fQQdv5AwRAqlJAJsHJuzpe0s24yWP+SyKhLICOAZNfQCg3dJR
Bm/Jyviv9Q/Ec09Qgqpxtio=
=jDYx
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
