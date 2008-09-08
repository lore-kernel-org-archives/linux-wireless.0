Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48397 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYIHJYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 05:24:11 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809080206u42908ef6yc6641435d747155a@mail.gmail.com> (sfid-20080908_110640_740319_9DE6828D)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 <1220863139.31304.33.camel@johannes.berg>
	 <1ba2fa240809080146o93200eetcf8e142f6ef4a2b1@mail.gmail.com>
	 <1220864314.31304.38.camel@johannes.berg>
	 <1ba2fa240809080206u42908ef6yc6641435d747155a@mail.gmail.com>
	 (sfid-20080908_110640_740319_9DE6828D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7jmL8nUT19YSVFFw3cvv"
Date: Mon, 08 Sep 2008 11:24:03 +0200
Message-Id: <1220865843.31304.48.camel@johannes.berg> (sfid-20080908_112415_748911_932F5CA0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7jmL8nUT19YSVFFw3cvv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 12:06 +0300, Tomas Winkler wrote:

> > How exactly are you triggering that "unauthorized port" message? I can'=
t
> > seem to reproduce to see if stopping the queue helps, but I'm fairly
> > sure, try the patch below that fixes this.
>=20
> Powering off AP, I think I've seen only Cisco AP that are able to send
> deauth packet on power off. So this was without.

Alright, I have an AP where I can log in and turn off the radio :))

I've been able to trigger the message _without_ your patches, but not
_with_ your patches so far!

I still think we should add the queue stopping so we can't run into the
messages. Do you want me to send them out then?

johannes

--=-7jmL8nUT19YSVFFw3cvv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxO8sAAoJEKVg1VMiehFY6sYP/ApGEGIgD3GJ9QzR+Z2tfdqN
Gg9TPvDn3WivaLel2BYD/S46H8ep2fnHLZYbGWPmleXljyFi/oQ9aKtaRVnjMAK6
DCMwi3+Ms1G1T/ZMo+j2zxFzRwd2ujCTsNjMPiyZDD/Qav1N9MFBfL6yxlGhQ/qa
bsvTKxgioNWDW8UJ1V9pvuyZAgOjJNx1X1DdePz9Cb/WffMjUMK/uNsfX0gUByNJ
4dGY6kkvNdrUwesaECX/J9ERcPP5EPZBjtYz3uoZvF5Qc5nzvq8o/TCzMN1saKCf
VO5qTCExt24uigtUrxLhxMcs4hohdT51HS7ngo14rqkuBXXm2iTzHYbbmyzuKGeL
WGRdoM/6qiEoVyIe7CkzNoreMonpcVvXUoqYahcTcO4Jo/xxzXDeH9I2/q9Wur06
1k7W5HhMc4zjfNXoGvuLxi5nPdGYkIxfH+qIY9P89q1LOr+Yro+bvvxDbLH4L9EB
qgg/RZRBjAxYZEs1RqSz93xux+qsMzRDqXM0pM4N/5Zd2r+vmWg1apT2lSU33F+a
p1nyHs8lE66mozQRj2MR3zKqQ7NJOHEd5DRQMa4jbIDQozFVK626OAmKKFh9u63B
46VScWcnPS7Ww4+k7FcnHJ41L070ieHEdxAc+9sT559WHKjMW50sKpV/GmYajtmG
odxip/a60Bqo7DEU/c3r
=7lwL
-----END PGP SIGNATURE-----

--=-7jmL8nUT19YSVFFw3cvv--

