Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbZFKJ6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 05:58:46 -0400
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890906102008u421f5669m3cf23a437f63d278@mail.gmail.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	 <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	 <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
	 <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
	 <3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
	 <1244619027.18481.55.camel@johannes.local>
	 <3ace41890906100639gb800904td06d86efef90e656@mail.gmail.com>
	 <69e28c910906100822q6eae8b29p2381220b23b4f4b1@mail.gmail.com>
	 <1244648968.4178.5.camel@johannes.local>
	 <3ace41890906102008u421f5669m3cf23a437f63d278@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZYYCufzC0usnHAr4zCck"
Date: Thu, 11 Jun 2009 11:59:27 +0200
Message-Id: <1244714367.4706.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZYYCufzC0usnHAr4zCck
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 04:08 +0100, Hin-Tak Leung wrote:

> For the sake of being pedantic, can I have some reference (if only for
> those sleepless nights for lack of boring reading materials...)? Maybe
>  I won't understand it anyway, but maybe somebody else who is
> listening in to this exchange can chip in.
> I have a 1300-page pdf supposedly the  802.11 2007 standard I
> downloaded some months ago through one of the wikipedia links, I think
> (somewhere under http://standards.ieee.org/) ... chapter 11 is MLME
> and section 11.2 is power management, which in turn is split into two
> sub-sections about power management in infrastructure nework and IBSS
> mode. I found a particular sentence in section 11.2.1. which sounds a
> bit like what you are saying (except with some cryptic acronyms!):
>=20
> ------
> If any STA in its BSS is in PSmode, the AP shall buffer all broadcast
> and multicast MSDUs and deliver them to all STAs immediately
> following the next Beacon frame containing a DTIM transmission.
> ------
>=20
> Have I found the right place to read up on such things, or there are
> other documents, etc (more detailed, or more "layman")?

Yes, that's the right place.

> On the broken-AP mode in the zd1211 vendor driver - presumably Zydas
> did not wrote that specially for linux, but just modified/adapted from
> their windows driver? So I guess windows users of zd1211 (or other USB
> sticks) are used to being able to do such things and assume whatever
> it does is normal? It just crossed my mind that if some off-spec
> behavior is sufficiently popular on windows (e.g. if
> connection-sharing requires AP mode to work and won't take IBSS),
> sometimes the spec gets modified to ratify a formerly barbaric
> off-spec behavior.

I don't think windows supports being an AP at all, afaict it's
connection sharing will create an IBSS.

johannes

--=-ZYYCufzC0usnHAr4zCck
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMNV6AAoJEODzc/N7+QmaCQ4P+gNELC/a1XiguZ7efSibBnGn
BT37ucTwvCU5kegVQWvVvkWQZr+hWmyzFrQ8tpuWVIIPRN6Ly6+Lf+DsDXo8M6X5
4sqY4odd3CrKffACjbHQiHcJjp8IYt92ELLvA+fEn5JYkgS5bXvPbhtbkq9KbD5B
QnyV96NtxNMiHJW+e7+e8/vdvNiLBsNhC6HU4KQ30KAOV440B4X+6QIpL+M6xw5r
HDX7fGMrGyDKwu06g7zKUSax/ngIX5PcgEMQlOnmsTiYsgCrjTIs0SxJzYnwSwT+
WLHjo+4ttp4yt486JAFfpcM059fbzLMz5Janv8UwNTuF1p7w2OJIWg+JPH/7GoCW
jsR47HgdTWEPq60m4o0YhkyDi2k3jvNlPt/vDoZ0dZXT2dLWc/WGmsGxQcj7AUb7
o81WyFfjA4Nb+MBhw1ZQzbL4fExdzOSlnI+pVNeKNtzFApRgxf5JDULMHFqUjqiH
sy02xIoT+ENGFVuVP9+vG1KQLXCCmaIdd/dLC/cT1MoZSX1W3BkcNE8gZnVPHJcf
k5aAVe0Db5m/+aB7SYtqCfegfI6ce8SHKeiUrDmindD1iZx5Q5F+9nOvVTzrHai0
ZvJlsQblklcmdM25JPimVLSA5b8zXlmil2tZ02w2e1NwR2I2Xs4/5vDPh9BiqQox
5FSSQ27qsw/W5J+ekl6f
=ySCz
-----END PGP SIGNATURE-----

--=-ZYYCufzC0usnHAr4zCck--

