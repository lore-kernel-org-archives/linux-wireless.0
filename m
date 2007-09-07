Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965379AbXIGNZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 09:25:33 -0400
Subject: Re: [PATCH 03/21] mac80211: revamp interface and filter  configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	rt2400-devel@lists.sourceforge.net,
	Li YanBo <dreamfly281@gmail.com>
In-Reply-To: <200709061905.54102.IvDoorn@gmail.com>
References: <20070905234209.108005000@sipsolutions.net>
	 <20070905234622.671760000@sipsolutions.net>
	 <200709061905.54102.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9GGCsy6GjbmwyA+PZsY/"
Date: Fri, 07 Sep 2007 15:23:04 +0200
Message-Id: <1189171384.28781.129.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9GGCsy6GjbmwyA+PZsY/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-06 at 19:05 +0200, Ivo van Doorn wrote:

> rt2x00 changes look good to me,
> it will probably take me some time to find time
> to make the full correct patch to fix rt2x00 but
> I'll do my best to do it as soon as possible.

Well, this patch isn't fully discussed and obviously not applied yet,
however, if it gets to be applied I think I'd rather have the rt*
drivers not compile (without my patch) than BUG_ON.

johannes

--=-9GGCsy6GjbmwyA+PZsY/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4VC4/ETPhpq3jKURAp2CAKCjrdFl6uYElhoNdRiiMBFsC/dCBQCgoHVM
MiEbvS6GsHauWngxBfC4Q3I=
=pfyE
-----END PGP SIGNATURE-----

--=-9GGCsy6GjbmwyA+PZsY/--

