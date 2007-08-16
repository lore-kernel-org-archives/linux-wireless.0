Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbXHPQ7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 12:59:54 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Russell Senior <seniorr@aracnet.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <86wsvv8m9t.fsf@coulee.tdb.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com> <1187275344.23489.6.camel@johannes.berg>
	 <86wsvv8m9t.fsf@coulee.tdb.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pdIr2wC8s2ZCHbiAFkOe"
Date: Thu, 16 Aug 2007 19:02:38 +0200
Message-Id: <1187283758.23489.38.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pdIr2wC8s2ZCHbiAFkOe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-16 at 09:41 -0700, Russell Senior wrote:

>   I have yet to see (maybe I am just blind), except for a very sparse
>   smattering of examples, a description of how mac80211 is intended to
>   be used.  I've never needed hostapd for master-mode before. =20

That is, I expect, because you had a device that handled all that in
hardware/firmware. We now handle many MLME things in software, and have
pushed it out of the kernel into userspace.

>   I am
>   not even sure what it does.

It handles everything from association to encryption etc.

>   Is there somewhere I should be looking
>   for user-level documentation?

http://hostap.epitest.fi/hostapd/
But I think you need git version to compile against the current
wireless-dev 'everything' branch.

johannes

--=-pdIr2wC8s2ZCHbiAFkOe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxIMu/ETPhpq3jKURAmWUAJ9wXuABcTIkJwm+pU4VCyhfNMav4ACgmWTH
50dqCyycGN+97aUv8YVwGtM=
=WTLA
-----END PGP SIGNATURE-----

--=-pdIr2wC8s2ZCHbiAFkOe--

