Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYDRWjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 18:39:45 -0400
Subject: Re:  RE: iwl3945 problem with 2.6.25-rc9
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1208558255.4848.60.camel@johannes.berg> (sfid-20080418_233741_985617_9465C786)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org>
	 <1208376292.27708.3.camel@localhost.localdomain>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 (sfid-20080418_232413_255865_9BD07164)  <1208558255.4848.60.camel@johannes.berg>
	 (sfid-20080418_233741_985617_9465C786)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fduKFO03bvEEZX4IpcPO"
Date: Sat, 19 Apr 2008 00:39:42 +0200
Message-Id: <1208558382.4848.63.camel@johannes.berg> (sfid-20080418_233947_635570_6E3C30E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fduKFO03bvEEZX4IpcPO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-04-19 at 00:37 +0200, Johannes Berg wrote:

> What I've found (a long time ago with hostapd) is that some APs are slow
> and the firmware-assisted scanning has a too small dwell period. Maybe
> we should have a module option for that so we can ask people to change
> that in such cases? You could try to change the IWL_ACTIVE_DWELL_TIME_24
> (and/or IWL_ACTIVE_DWELL_TIME_52) to higher values and maybe setting
> IWL_PLCP_QUIET_THRESH to 0.

Just as a datapoint, mac80211's sw scanning uses about 30 msec for
active and 200 for passive (on both bands).

johannes

--=-fduKFO03bvEEZX4IpcPO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAkjLaVg1VMiehFYAQLsLQ//SuZ08NKRCzgWhzL1rEc6goY1OVP9rZtm
e2o1zXsj+H+KjTZbi61l0mBRYkcnjaymSNDn/RA67LejiEWsyCGKZk8w5PXzDC7p
sO4PDNO2ktO4eh14LxY6RsFuirIxTrYvd2FIgbmOQMyHAJQt1SKoqedvJPxJfP9J
fVgn7JOBqxshQhectpeeD8s/iXqlTe6a6zyUFV+A+Cbo0UjxCGFhA53lGTEk/Hk/
ua7+tNkEfWbNerbsHdYU5ucyJWqOSmIE9031i+Zj3zfOSNOxXLpgb0tGQsyTcJsg
NRN4d9SGO+LU3EL91q8tfH06lcaNHoLmg9ZfkqW7YEkuMiZWpLNHOZT6Wl80EQYg
QVA3swYq3HurWnNM2vClu4Is/w6ClDFMvT3QSHlAR4drFRQ2UMCh5bT7sPNQEa3y
PP63tFAHFl0EcBkkVlWLrlNJrcINFk91UGq9q2L6iYeR3kkRkh+5IoAGha9QeMuv
RA8KLoqyvRqX3vmQR/r+sB7N6nvx7G77n0VsJ7sAgSRxVpFMX74yOsM7WI+6n9xT
BgebSYzYD3jJNmzyROM3ADlY28klw3cZnojcPtoBaGfTHJFadg+a6pg7VjEEGxrC
7A3DsKv/RMEpKZzcP2KT6xEjg9KIJUDYJ8tRX9JKGMSPVZSbI5guk/en3izv2bV2
EaAN4/QL5mI=
=hNnB
-----END PGP SIGNATURE-----

--=-fduKFO03bvEEZX4IpcPO--

