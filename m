Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZDTL25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 07:28:57 -0400
Subject: Re: rfkill rewrite bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49EC3E5B.8060403@tuffmail.co.uk> (sfid-20090420_112032_974132_A09D0446)
References: <49DCA88E.6060400@tuffmail.co.uk>
	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>
	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>
	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>
	 <49E98C86.2040308@tuffmail.co.uk>
	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>
	 <49E9A0C7.8040602@tuffmail.co.uk>
	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>
	 <49EA10F3.3070309@tuffmail.co.uk>
	 (sfid-20090418_194244_839181_896F358B) <1240077571.25100.3.camel@johannes.local>
	 <49EC3366.7080206@tuffmail.co.uk>
	 (sfid-20090420_103348_397116_B4EBC1A4) <1240217064.28218.0.camel@johannes.local>
	 <49EC3E5B.8060403@tuffmail.co.uk> (sfid-20090420_112032_974132_A09D0446)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HgRVjQLFmqdhiRJvxove"
Date: Mon, 20 Apr 2009 13:28:21 +0200
Message-Id: <1240226901.28218.1.camel@johannes.local> (sfid-20090420_132901_241264_040BB6B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HgRVjQLFmqdhiRJvxove
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-20 at 10:20 +0100, Alan Jenkins wrote:

> > Ok, thanks for the heads up. Do you think this will generate significan=
t
> > conflicts?
> >  =20
>=20
> I'm not quite sure what would be considered significant, but it's not
> trivial.  At a high level, I don't think the new behaviours conflict
> with the new rfkill semantics :-).  But the firmware bug workaround
> can't be resolved completely mechanically.  And the pci-hotplug patch
> touches the rfkill error path.

Ok, that helps, I think I'll just resolve the conflict when it hits
linux-next. Might need to ask for your help then :)

johannes

--=-HgRVjQLFmqdhiRJvxove
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7FxSAAoJEKVg1VMiehFYNwYQAIVc7fGyhor0P59Q3W2lFV8l
7WmlfIfFHMLG420RY9pwMfDx2RzlTzBMOHYJAueconQbHTtzjjp5k9Pf3COXZ2Qu
GzLOUhqdP+BlTIDHLFgRQrRcWMnICpqlF55oxpw2kCBHvSIYTbgaOymmZHsvWbFN
jPBF8/TdBfz5a11qNNAvdKpRGPUZhtJIfNEuKS/cRZuQ/1WmjiBDgFyE8e18dKz0
DyaKBD9oTuxaDuac5URhXuukvBcYcVkfAVbnBdF0gumWZME5g7dgB8JJ7A/uweU6
Xo3QSxwPw1jQ61YmPck1QdWqj6+gQ1W5nCBq21cigiOv8O5p2045GOkrm8ZnFB5b
QJeVp1GiSyoMMKJF5NrrEU4vXbZJJt/DYf2yLLCLY1ULArluiDxYUF++xHhY5xpd
Vdez4TE4re5yIzRUrCE+7zkwSZnpE5uj41hiYyyDmRtYDVtg3mf+2xOuvRh1W59i
jpxLd7f9CJMJUWU4+RzcNvy2C9HJxg1iNywwHsGevAYVquUvZ0RXvxDPDiKyjWSl
F5M6ZO5g0kEO0z5u1NXapJpsr6i/0wA5GDokB66GN40cXIRnvwAtrU4O9hwmyMy9
bAKvU//Vgrb9qbaxrJ/m3+adOEPcsB+a5Yc10o/BKu7GEGBYZkWk6qerqcyCgWd/
/jfL1GJINEpuYGWdIw5m
=nsBM
-----END PGP SIGNATURE-----

--=-HgRVjQLFmqdhiRJvxove--

