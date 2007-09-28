Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537AbXI1PnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 11:43:18 -0400
Subject: Re: add_iface controls
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Kershaw <dragorn@kismetwireless.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070928152317.GA7387@drd1813.lan>
References: <20070928152317.GA7387@drd1813.lan>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZVNlMhSBnquc0PjWYTos"
Date: Fri, 28 Sep 2007 17:44:37 +0200
Message-Id: <1190994277.22960.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZVNlMhSBnquc0PjWYTos
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-28 at 11:23 -0400, Mike Kershaw wrote:
> Sorry for the mostly-usage-related question, but I'm obviously missing
> something simple - after a week of searching list archives and git I
> sure can't find it though...  What patch set is required to enable the
> mac80211 vap add_iface/remove_iface controls in sysfs?

Yeah, they got lost. We decided not to put them into sysfs in mainline
right now because Luis wants to make cfg80211 use configfs. You'll need
to use an as-of-now-unwritten nl80211 client.

johannes

--=-ZVNlMhSBnquc0PjWYTos
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG/SFl/ETPhpq3jKURAj4AAJ0XBhtjiP1QMsDt0MQsBG1YYitWawCfUAdx
MBM7UC4w0mtQkCwa38v60DE=
=bRmD
-----END PGP SIGNATURE-----

--=-ZVNlMhSBnquc0PjWYTos--

