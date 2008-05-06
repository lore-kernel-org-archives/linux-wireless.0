Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764945AbYEFJSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 05:18:00 -0400
Subject: Re: [PATCH 25/25] iwlwifi: map A-MPDU HW queue to mac80211 A-MPDU
	SW queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240805060209x3765abf6lf5ece51055b0d60@mail.gmail.com> (sfid-20080506_110823_078106_5D0EDF31)
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-22-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-24-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-25-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-26-git-send-email-yi.zhu@intel.com>
	 <1ba2fa240805060209x3765abf6lf5ece51055b0d60@mail.gmail.com>
	 (sfid-20080506_110823_078106_5D0EDF31)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cZU7JU+Fnt2v/Jsf3k1K"
Date: Tue, 06 May 2008 11:16:56 +0200
Message-Id: <1210065416.8012.56.camel@johannes.berg> (sfid-20080506_111731_516887_C43643ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cZU7JU+Fnt2v/Jsf3k1K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-05-06 at 12:09 +0300, Tomas Winkler wrote:
> On Mon, May 5, 2008 at 5:22 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> > From: Ron Rindjunsky <ron.rindjunsky@intel.com>
> >
> >  This patch maps A-MPDU HW queue to mac80211 SW queue scheme (as introd=
uced
> >  in patch "mac80211: QoS related cleanups"), when trying to perform
> >  ieee80211_wake_queue.
> >
> >  Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> >
>=20
> Is this going to make it to 2.6.26?
> Without this it will be hard to run 5000 under 2.6.26 as is.

The referenced QoS cleanup patch isn't in 2.6.26 is it?

johannes

--=-cZU7JU+Fnt2v/Jsf3k1K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCAiB6Vg1VMiehFYAQJ5mBAAhBCUUAdZHqRBfS1of2iKqzED5tRYo8rb
e4/CqxvRGw9evB4jX2xXa3SZVVOlztIel3X4BBB8tGh4D8BCSNcKGUYdFh12P646
q/IsraWvLS4OfSP1f7WPp3glaz1MUnEzL6lM7TBckHzs5Tt8zR1kCWcpNGTsTRoE
UKuBOsLu3t+J2zCPOWPivDNMLLV5wGNpdldlWQiimMgqWl0T67y5gMgQuIkAqjBo
nYcMS8VG4C5TciqHgV5STB8729m5pAjcHzwLln2vEYYFj9DxfhsuIzwhxh9LKtmC
sADZtiMMzjX1BpLh2Dl5Hoy72xf9FMirIShcZhCP6XgMxfaVcfIYQGtPDAUJaJ+F
X/4rgNzMz5FSm+oZ+nGc7qWDyVpjpeoeTpXltFdRPBgWYNqCxjlPJKOR354+B1d4
Cc2H58GAxf8nEpTN+vzA/+BYX3IhqaMxdvsNurOUK3GyxjNAYXw1vfXsA/SOCrye
eFylVqxpyxacv6QCliY19YGWAR2X9l94GzQ3mQt3p+MDvotEX9D8o4HzwRu6Nsz/
5R+qpkAooHVd638i305cK5pUQZyKs4z0cAsR7+hD63Zq5eNp4kU9Z7D70bSMLEap
dtmhBITXRUzAU6rPo7e9BlUkxehbqQ1Hwnx2ekr1yhUoCYTJE3mwtXq3lxqmKMWe
8O4aQulG3yU=
=ojS7
-----END PGP SIGNATURE-----

--=-cZU7JU+Fnt2v/Jsf3k1K--

