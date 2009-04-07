Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbZDGUlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 16:41:37 -0400
Subject: Re: [PATCH v2 3/5] mac80211: check if HT40+/- is allowed before
 sending assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890904071338q4f9667ddo2958067c57442888@mail.gmail.com> (sfid-20090407_223826_570259_084A19A1)
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
	 <1239048958-11775-4-git-send-email-lrodriguez@atheros.com>
	 <1239099071.22453.12.camel@johannes.local> <20090407162345.GC5758@tesla>
	 <1239131370.6199.0.camel@johannes.local>
	 <43e72e890904071338q4f9667ddo2958067c57442888@mail.gmail.com>
	 (sfid-20090407_223826_570259_084A19A1)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zG7GZ2Qbtb5ePyGsAIFc"
Date: Tue, 07 Apr 2009 22:41:03 +0200
Message-Id: <1239136863.7475.66.camel@johannes.local> (sfid-20090407_224140_652703_55CB63AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zG7GZ2Qbtb5ePyGsAIFc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 13:38 -0700, Luis R. Rodriguez wrote:

> >>                 switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC=
_OFFSET) {
> >>                 case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
> >>                         if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
> >>                                 cap &=3D ~IEEE80211_HT_CAP_SUP_WIDTH_2=
0_40;
> >>                                 cap &=3D ~IEEE80211_HT_CAP_SGI_40;
> >>                         }
> >>                         break;
> >>                 case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
> >>                         if (flags & IEEE80211_CHAN_NO_HT40MINUS) {
> >>                                 cap &=3D ~IEEE80211_HT_CAP_SUP_WIDTH_2=
0_40;
> >>                                 cap &=3D ~IEEE80211_HT_CAP_SGI_40;
> >>                         }
> >
> > Yeah, that looks ok.
>=20
> That's what was there or what I added in my patches.

Indeed, it's already there. I guess I got confused, sorry for the noise.

johannes

--=-zG7GZ2Qbtb5ePyGsAIFc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ27pcAAoJEKVg1VMiehFYN8UQAMIdtAXrMYEYCiG3nFTJvwP3
lRUbEE7gTnKnskjJRsXDl/ptucSb8QF7L+fq1P2qAx73PSrEGqgMGpJMaYXIPIB4
WyS6eQXVb1He0ovMshh+vDaAdU/Pi/6kJVr/1JOgo4DEVvSWgkHMTv6UndanijJG
c/iN3gzY9hFVBOpPiy7clhm8ecfX0pIqPI6WBE3zXMPcAS1Zzz+76yDWbIsNMYF7
/Wevl78S9M4p62eg/QtbB9womxVXcN7ZA1JPINvTmwk3xYd8M626B0PxCJi7ZY0u
L4mT2/ZFTtxnxuVcTVDVKeKSODk6W7m5LEVBW9IWY0PwkWytl/cx6WOrPzJvJHU8
8S+lt+WDj/N5rgrg3NCAc/2v3HaxL1K25n4eOhl2K68Z5IjQyCDeNjnDsppRZ9K8
ISJSY5VGLjy8j0DVcI70pXlpqK5l4ZXfsmg5lfS9OFvmIZ4tP3vTaG2660Bra6jt
PPFIg7e9UBm3zX7K890GqxKZR607d3oakWdQkF6tc8d+mxOIK3bECbJomIETyhb7
2mTI9zACNp2RjTWuCr2TrSmwxNQiFTpT/o1z09lnjWtIDPnoSjerU7hA6kikR3TI
IgtIcyu61rIkan7mt7Ngecw/MdLfMSwy1MstTEOYHNWNxOY80+Q2Cl2H9Gbf3Yvh
/4UceGQ0rgUxrJyuBXwL
=uayT
-----END PGP SIGNATURE-----

--=-zG7GZ2Qbtb5ePyGsAIFc--

