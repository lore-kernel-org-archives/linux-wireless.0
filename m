Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:53002 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbXEZF0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 01:26:10 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Will Dyson" <will.dyson@gmail.com>
Subject: Re: BUG: at net/mac80211/ieee80211.c:1280 ieee80211_tx()
Date: Fri, 25 May 2007 22:24:13 -0700
Cc: linux-wireless@vger.kernel.org,
	"Broadcom Linux" <bcm43xx-dev@lists.berlios.de>,
	"Jiri Benc" <jbenc@suse.cz>
References: <8e6f94720705251637o71a13d71w70199a3057048592@mail.gmail.com> <200705251805.25696.flamingice@sourmilk.net> <8e6f94720705252110k46be0397v5f446aabdf34fe3f@mail.gmail.com>
In-Reply-To: <8e6f94720705252110k46be0397v5f446aabdf34fe3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1743762.2eHgsqlGou";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705252224.18457.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1743762.2eHgsqlGou
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 25 May 2007 21:10, Will Dyson wrote:
> On 5/25/07, Michael Wu <flamingice@sourmilk.net> wrote:
> > On Friday 25 May 2007 16:37, Will Dyson wrote:
> > > But I've got ton's of these in my log:
> > >
> > >  BUG: at net/mac80211/ieee80211.c:1280 ieee80211_tx()
> >
> > Do you have CONFIG_NET_SCHED on?
>
> I do not have it set in this kernel. Should I?
It may help. mac80211 didn't work correctly without it before and I'm not=20
entirely sure if it works correctly now without that.

=2DMichael Wu

--nextPart1743762.2eHgsqlGou
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGV8SCT3Oqt9AH4aERAsAZAKCZhnKJnMwJQsfzKkgiYkiqdnomfwCdF7Ly
gzPePssUs+hxkB9HbDMVgxM=
=n7Gn
-----END PGP SIGNATURE-----

--nextPart1743762.2eHgsqlGou--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
