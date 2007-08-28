Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbXH1LEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 07:04:42 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <87absbsz5f.fsf@nokia.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com> <1187275344.23489.6.camel@johannes.berg>
	 <871wdphsus.fsf@nokia.com> <1188290911.7837.65.camel@johannes.berg>
	 <87absbsz5f.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nUe8zyDbP54zuQBzZA6u"
Date: Tue, 28 Aug 2007 13:05:59 +0200
Message-Id: <1188299159.7837.96.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nUe8zyDbP54zuQBzZA6u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 13:59 +0300, Kalle Valo wrote:

> I just have a fear that we don't endup in "udev-hell", that is
> incompatibility between kernel and hostapd versions. It was just awful
> with udev few years ago, let's try to avoid that. Official hostapd
> releases should work with all official kernel releases, without any
> exceptions.

Well, with mac80211 mainline kernels currently don't support AP mode at
all, and wireless-dev/hostapd are quite in lockstep. As soon as we merge
the AP mode stuff into mainline, however, it will be via nl80211 which
shall be a stable interface for that.

> > In any case, I'm fairly sure the TIM is just wrong, if you have a third
> > device you could try capturing the beacons and check that the TIM is
> > never updated.
>=20
> I will check that later and send the results here.

Thanks, I appreciate it.

johannes

--=-nUe8zyDbP54zuQBzZA6u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD4DBQBG1AGX/ETPhpq3jKURAj0SAJj9cVXIsD4PKIFp7a+1D6dRiLJkAJ4uYVmf
ZiHaSoSH8VmWo01HF1ps9A==
=udOi
-----END PGP SIGNATURE-----

--=-nUe8zyDbP54zuQBzZA6u--

