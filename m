Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbXBSNfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 08:35:19 -0500
Received: from [84.135.240.62] (helo=johannes.berg)
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HJ8bz-0008Hp-NJ
	for linux-wireless@vger.kernel.org; Mon, 19 Feb 2007 13:31:24 +0000
Subject: FYI: current kernel-doc warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8DFNj0GubZa1FABb54BM"
Date: Mon, 19 Feb 2007 14:35:11 +0100
Message-Id: <1171892111.3471.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8DFNj0GubZa1FABb54BM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Just in case someone is idling and needs something to do, here's the
current list of kernel-doc warnings in d80211.

The list is also on
http://linuxwireless.org/en/developers/d80211/kerneldoc/warnings which
is updated daily from the current wireless-dev tree.

Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'channel'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'freq'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'channel_val'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'phymode'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'regulatory_domain'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'beacon_int'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'flags'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'power_level'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'antenna_max'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'tx_power_reduction'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'antenna_sel'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'antenna_def'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'antenna_mode'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'radar_detect'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'spect_mgmt'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'quiet_duration'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'quiet_offset'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'quiet_period'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'radar_firpwr_threshold'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'radar_rssi_threshold'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'pulse_height_threshold'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'pulse_rssi_threshold'
Warning(wireless-dev/include/net/d80211.h:311): No description found for pa=
rameter 'pulse_inband_threshold'

johannes

--=-8DFNj0GubZa1FABb54BM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF2aeP/ETPhpq3jKURAlSAAKChP5lEGE3oBLlBpBjgu+J6ogEeuwCfYN+e
4gXLG1+PX5Qa5wJGyRwQvAE=
=XbP+
-----END PGP SIGNATURE-----

--=-8DFNj0GubZa1FABb54BM--

