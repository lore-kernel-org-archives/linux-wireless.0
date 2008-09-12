Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYILHqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 03:46:13 -0400
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <18633.57010.19741.838935@gargle.gargle.HOWL>
References: <20080910220145.707263000@sipsolutions.net>
	 <18632.55008.411078.289830@gargle.gargle.HOWL>
	 <1221139351.6986.26.camel@johannes.berg>
	 <18633.57010.19741.838935@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hHPWiB2GkjZlyIP7UMC/"
Date: Fri, 12 Sep 2008 09:45:24 +0200
Message-Id: <1221205524.11204.0.camel@johannes.berg> (sfid-20080912_094617_801527_602468BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hHPWiB2GkjZlyIP7UMC/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-12 at 08:44 +0530, Sujith wrote:
> Johannes Berg wrote:
>  > I had actually tried
>  > (http://johannes.sipsolutions.net/patches/kernel/ath9k-sta-node.patch)
>  > but you're using refcounting for the nodes while mac80211 RCU-protects
>  > them, so I didn't get very far. It needs a bit more effort to make sur=
e
>  > you don't have node pointers stick around in some tx descriptor after
>  > mac80211 decides to remove a node (which may very well happen while
>  > frames are queued)
>=20
> Well, the node stuff is sprinkled throughout ath9k right now, I'll start
> cleaning up all that and revamp the aggregation logic in the process too.
> Do you mind if I build on this patch ?

Not at all, feel free to use it for whatever you want.

johannes

--=-hHPWiB2GkjZlyIP7UMC/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyh4PAAoJEKVg1VMiehFYpEsP/0GhpGHXIyCNPTlZib/sKvUx
VCry4QVGoMCpcdN6A1nuzXosxNYujnwSSiIGoGfz1RJLUAGBDVr3eAmiwT8NvVEC
SBFbAgeEbbbX4giWNl0aUJssbVTjKEd93nYHqLaetZXXKh4NFv+/K9Cc/PiCb8Q8
nawCBm0+LjFI1hhSW/VNW1O2pV+uRp7fvDe2E1jPZXL4XnTh0humojF/0kEZxGjX
K5HPUsnkwVw60P8c9KrRI3W3e0elc8kNZ06qAB/hzk9PbPyLCY4F/yquBbplEfAW
8v09NMOwfeaHr5jz9/uwBHnBhNBpiJAL3r2dnKy7505YKA6uC45eAtZHvmrlOo8l
KJJ1y+WLaA//9RO2v6p+/oXsodU0X7M435Xis/zW1zT4mNvje1ObXbIIwBA7l13i
dXV8xfO5sOg8iNZm9hJba58Y3UNyK+sI2NT0bNPg7aZFgE7Tt1diYztDB7foOFKI
7RIlsfzFNsfIBFF9jpVWzd4Fd70lW5Dk2OPMJDkj7ZaAv2VfkGDGp3XIvAtd7aWq
uIvvqEVCYE6yIFSAD+LIpZ7Qy1QgKQu0DeCXn3PWtRk44EmeJGPwHIA9RJYoVjF/
YufZnv4/4pWPumoYKtJtNqSZ8m2OcTLkfYvbfpjTsneK+qMwypISsYIiOKjQwkR/
jzTROGwSfv5l0d8sqBlu
=wbxr
-----END PGP SIGNATURE-----

--=-hHPWiB2GkjZlyIP7UMC/--

