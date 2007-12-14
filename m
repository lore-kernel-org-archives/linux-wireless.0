Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbXLNOnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 09:43:13 -0500
Subject: Re: [WIP] cfg80211 infrastructure for channels/bitrates, mac80211
	and b43 conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <43e72e890712140620h90676b5x831563376ccbc1ec@mail.gmail.com> (sfid-20071214_142056_660551_2F9D90A8)
References: <1197631004.16079.25.camel@johannes.berg>
	 <43e72e890712140620h90676b5x831563376ccbc1ec@mail.gmail.com>
	 (sfid-20071214_142056_660551_2F9D90A8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tjbzfHrhfxciFQYrFVS0"
Date: Fri, 14 Dec 2007 15:40:06 +0100
Message-Id: <1197643206.16079.57.camel@johannes.berg> (sfid-20071214_144445_400020_F60249D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tjbzfHrhfxciFQYrFVS0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Looks great, I'm glad I don't have to deal with these changes now :)
> just a few questions and observations:
>=20
> * I didn't see the definition for ieee80211_channel_to_frequency() and
> its counter part, where are those defined?

include/net/wireless.h and net/wireless/util.c

> * This patch didn't have b43 changes

surely does.

> * I'd like to base work on these patches, where can I find them the
> complete series to wget

http://johannes.sipsolutions.net/patches/kernel/all/, just uploaded.

johannes

--=-tjbzfHrhfxciFQYrFVS0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2KVxaVg1VMiehFYAQJ8Sg//VYtuCRH7KF/amJRB3mTgYSyhyV9Qbf+k
o8LhG7vpaPFz3I3V94JEuJ+3Xez8b2W4F0wK8C1koQxh6SrQdcEBqEfOOTokJyxC
1o5nF4NMTKiOK2G/Y/CT4o6NbMQR47VfSF2LLGk19pbFdMrDceyKcDnluocQjTS2
lFYkgYnolNYAyUdUp5cZFldSflNHfmhnodcFRDbsp+upeVgsLdkcTp1/9r6At71A
znffb5pYIWyhAZzK+6j3OA1VLm+gNim7F4tsGQxcKbGrz/1yOtEUogyr3mdYOKfa
NJ8rUERZW4CzsyMo5zYgnOwCnGzk6+LlQINReUtnd/tCzDXZJyGe+6kKKSqL+hYH
ZYvTnYJPIeSTNMM8Jex+3VCfYTPbd0Et6isjBj56C9t6RpFtTrwKVrLRAHIpa5Rp
Z55Jg08ovwn9ic37nVSO1Tm39Cm6UQK3ddftsppi+z1BPHnVTzYWo/XZ1zA4zkS7
WEJO44BjaheZ2Z/eJDjur0wpmJDcwF5vuxpeZtPcCUhZx+dcCcdaF9Bli9lONo+z
aMAi7b9r+2VmE0CniCWsv5xyESUOjj5Gfdbj4s8idvvjPPud40IWFtj1W1sHATwa
fTZPgTfMwG1k6SwnTj8VUMYYdfKCi3H+q4a94rtGZBktrxOtGXsvZTyHa1STojPW
fcZPbUUacXk=
=n/pQ
-----END PGP SIGNATURE-----

--=-tjbzfHrhfxciFQYrFVS0--

