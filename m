Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbYLLXB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 18:01:58 -0500
Subject: Re: [RFC 2/3] mac80211: Make use of the new F_TX_NOACK and
	F_TX_NOSEQ Radiotap TX flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910812121500n67e45a52lb589833d84413adf@mail.gmail.com> (sfid-20081213_000004_022743_889F33D2)
References: <69e28c910812121432n6e84de41s94a887110051a1dd@mail.gmail.com>
	 <1229121558.3565.6.camel@johannes.berg>
	 <69e28c910812121443h1fae52e6uc88749d7e9baf529@mail.gmail.com>
	 <1229121947.3565.13.camel@johannes.berg>
	 <69e28c910812121451u25713c82o229a56006089edd6@mail.gmail.com>
	 <1229122339.3565.18.camel@johannes.berg>
	 <69e28c910812121500n67e45a52lb589833d84413adf@mail.gmail.com>
	 (sfid-20081213_000004_022743_889F33D2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GiX7qa9x2xNvpcohmdW/"
Date: Sat, 13 Dec 2008 00:01:52 +0100
Message-Id: <1229122912.3565.26.camel@johannes.berg> (sfid-20081213_000200_916955_EAC81D16)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GiX7qa9x2xNvpcohmdW/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-13 at 00:00 +0100, Stefanik G=C3=A1bor wrote:
> On Fri, Dec 12, 2008 at 11:52 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2008-12-12 at 23:51 +0100, Stefanik G=C3=A1bor wrote:
> >
> >> But if we redefine !ASSIGN_SEQ to mean "use the sequence number
> >> supplied by userspace", we will need a new flag to distinguish between
> >> driver-level vs. stack-level sequence number assignments, which is
> >> essentially the same as this patch. There is no way to switch between
> >> 3 states (control in driver, stack or userspace) using only one bit.
> >
> > Good point, I forgot about that. But that isn't true for no-ack :)
> >
> > johannes
> >
>=20
> By the way, here is a bit more about the oops:

For that to make any sense, you'd have to show me the code too :)

johannes

--=-GiX7qa9x2xNvpcohmdW/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQu1cAAoJEKVg1VMiehFYZjMP/jawWBY5DqiF3K7LYh9mCY8Z
2ha0CZWs5jIoPYztntNhLMg3CLqXi3Swe4P+9fu4i/n+lgyOYW6WB/c0tgeKPiV3
CGGbLahKk8rVJtlKzoBurgotxxTI8VMCpH9QKF+uY2o/sMMC/4i8xOEXzVtPc2SK
RZnOKKju30Hrxiaayvs00UfJ8W/smcv4p1jxIXGMImlRDd/Aq8yoo5Wk7XrkZnwz
zuYkZOk+4LiM8iVlJ2E84juuT2epqmTyXeHRXx/m68L5cnQBDqpaSnrnQseJ3oaG
x0X02U/oigmKV9DrA2CrjaI2mvFHs0L17FZLRAgZG7hH3ivQUgk7j6my21neL+FD
DLgmI8Pd/4A9cWdN9xcSCyNvDkSUBmU5ITSzkAGWMmliWyAI64nkLFSZZ/nvuy9U
mkYAyIISfQ17bx9rjqoeIRoWUHQyJdCiG6XIV/XHWLVmfB+EZXudRu2B3TkCD8qk
n2H1UDzlif+BGlAOpcxZZhWAGX18dlE1inA25RzBhbaf1YiNtI3ClcSZ2ym+Z7L0
fOzTvicFnIh/IUDjDeG3CzsW9IJ5WmVjP+dIf3+8mF82i1MM87EqFFJI+UD1kaLk
hU78iT72loVIHAysmRtSyp+J5L0mh4artzJKBjXb0fL6Bb9Hpbnnk0mXq5MPJAcz
0qrXu8HAZlG3LLwX3F49
=q5Qj
-----END PGP SIGNATURE-----

--=-GiX7qa9x2xNvpcohmdW/--

