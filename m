Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbXIAJAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:00:35 -0400
Subject: Re: borkage in 2.6.23-rc4-mm1
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <20070831211603.083dfed2.akpm@linux-foundation.org>
References: <20070831211603.083dfed2.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+U5vBy10wFSh3oOs34LL"
Date: Sat, 01 Sep 2007 11:02:00 +0200
Message-Id: <1188637320.7585.113.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+U5vBy10wFSh3oOs34LL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-31 at 21:16 -0700, Andrew Morton wrote:
> Am seeing random crap like this:

> Aug 31 20:58:07 sony kernel: ipw2200: Firmware error detected.  Restartin=
g.

> Aug 31 21:01:31 sony kernel: ipw2200: Firmware error detected.  Restartin=
g.

> when trying to use ssh on the current rc4-mm1 lineup.

Very odd. I don't recall any patches touching the ieee80211 code though
I'm not entirely sure (last I saw was DIV_ROUND_UP from net-2.6.24). Are
you using WPA/RSN? ISTR I posted about a bug in the ieee80211 code a
while ago but I don't think it should make the ipw2200 firmware upset.

johannes

--=-+U5vBy10wFSh3oOs34LL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2SqH/ETPhpq3jKURAtAMAKCMkESVauKsMxlhh+r57zqrm8f2gQCfci14
GuiTiSUA7Nkal3m+nXW64j0=
=FEoY
-----END PGP SIGNATURE-----

--=-+U5vBy10wFSh3oOs34LL--

