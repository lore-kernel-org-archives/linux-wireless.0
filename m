Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762249AbYARUvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 15:51:43 -0500
Subject: RE: [PATCH 04/12] iwlwifi: document scan command
From: Johannes Berg <johannes@sipsolutions.net>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <4220499A1B034C4FA93B547BA01E1FF001746541@orsmsx413.amr.corp.intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
	 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
	 (sfid-20080115_022705_457944_D9860755) <1200441772.5887.167.camel@johannes.berg>
	 <4220499A1B034C4FA93B547BA01E1FF001746541@orsmsx413.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YayrZdR++bU8INBQgSzU"
Date: Fri, 18 Jan 2008 21:39:42 +0100
Message-Id: <1200688782.5716.38.camel@johannes.berg> (sfid-20080118_205147_469540_2E600DEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YayrZdR++bU8INBQgSzU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > iwl4965 will transmit a probe request and go to the next=20
> > channel before hostapd sends the probe response, iwl4965=20
> > still sees the response, but the b43 card never sees the ACK=20
> > because it's receiver isn't quite as good as the iwl4965 receiver.
>=20
> I'm not sure of the history of the dwell time values, but it's an
> attempt to balance reliability of scan vs. speed of scan.  The active
> dwell times are, of course, more speed-aggressive than the passive ones.
> Would you be willing to experiment with your setup, and try some
> different values?

Sure, can do that next week, do I just change the defines at the top of
the file?

johannes

--=-YayrZdR++bU8INBQgSzU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5EOjaVg1VMiehFYAQLekg/+KYYi4wJZMDrKGGkz3dhlyW+FeQrylACg
aFFxl/LHXUHHuyM85RnMtXsTN8octr5zHTQNEfoz+0cNqDe0qSnuxKz8oC+s+4qt
8p519VrYkWjNHy7McMmHMYuuXWA4BGDWJNsbqTJpXnps4aC6r+WHdkKkpOHg9SHC
juhAxG3cWVjYcHxVVaSY2gfEnxeo5CixnvseZo5Ot3Cna/ZqXoejb7+CFBvQOSEB
xv05ttgSN7Cg7Bik/2qa1G79gyL82b1NlG4dqIvwLJ2yUT9n70Dg3bKTO3CT52Bk
KPmyHbGqIwUKfc9MYxSMc8/Lyo7AwQnN9jIlvoMmPxnGIqHUFBVIcz3dNPrVHS31
q3eDwQWYelhtjfYWJvogsANSMsnb719INZmrt2P58cD2L4Dy0hAmoJD2dzhU+R0V
9dvJ6aiq4NIs5oMiaT8k/4xfnncg+dRH0OxyEx+1pVffXdXsO+xmedXdZiBR7bwb
MXMhpmJ0M4RZDoM2pUZWhHLGVNdilEuSEJacgXuiS+YpSxCYhRTO6fzIkIIMGmpk
cVhoPDVcutjhWrEYpcG8G1boTHQ2+6zCccMNOfuBHhT6paaA+UHd0lX96ocbwtge
0vinta2tsb3kMLUrw8q33ZZLW9ozfvDHHsRa9AmpGEhpS+c+0FDq8qU04IuhQn8q
5GfU4dtFwOE=
=uOh8
-----END PGP SIGNATURE-----

--=-YayrZdR++bU8INBQgSzU--

