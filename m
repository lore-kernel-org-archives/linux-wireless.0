Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbYDSNsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 09:48:40 -0400
Subject: Re: RE: iwl3945 problem with 2.6.25-rc9
From: Johannes Berg <johannes@sipsolutions.net>
To: Vincent C Jones <v.jones@networkingunlimited.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Brian Morrison <bdm@fenrir.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <1208612641.3980.31.camel@X61.NetworkingUnlimited.com>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 <1208558255.4848.60.camel@johannes.berg>
	 <1208558382.4848.63.camel@johannes.berg>
	 <1ba2fa240804181728u7a3440cajbba7dcc696d02909@mail.gmail.com>
	 <1208593973.26186.2.camel@johannes.berg>
	 <1208608786.3980.7.camel@X61.NetworkingUnlimited.com>
	 <1208610565.26186.17.camel@johannes.berg>
	 <1208612641.3980.31.camel@X61.NetworkingUnlimited.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mrAkGAAmdKw9pQIc4GqC"
Date: Sat, 19 Apr 2008 15:48:22 +0200
Message-Id: <1208612902.26186.23.camel@johannes.berg> (sfid-20080419_144855_272045_BB1CE2BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mrAkGAAmdKw9pQIc4GqC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > So how would you feel if I told you that, after you have once used that
> > hidden network, your laptop will be broadcasting the SSID in probe
> > requests every time it scans, no matter where you are, even if you've
> > moved across the continent?
>=20
> I am not going to waste bandwidth debating the correctness of the PCI
> guidelines, because right or wrong, they are what they are. I was just
> trying to point out that the need to deal with access points which do
> not broadcast their SSIDs is real and likely to become more common in
> the future, at least for any systems using wireless in a retail or other
> credit card dealing environment.

Oh, I don't want to debate the PCI guidelines, just saying that, which
is what I started out with, I don't see much reason to have active
scanning for four SSIDs.

> I'll leave it up to you (collective you, not necessarily a personal
> you), how to best deal with associating with APs which are not
> broadcasting their SSIDs. I agree with you (personal you this time) that
> roaming around the country broadcasting those SSIDs does not seem
> particularly desirable. So how should the ability to connect to non SSID
> broadcasting APs be implemented?=20

I would probably list, in network-manager, "I found (a) hidden
network(s)" and ask the user for an SSID to scan for actively at that
particular time, rather than trying to scan for all previously known
SSIDs even if those networks weren't hidden, as windows laptops (at
least those with Intel hardware but I haven't seen many others) seem to
do.

johannes

--=-mrAkGAAmdKw9pQIc4GqC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAn4JKVg1VMiehFYAQJ4ZQ/+IJI743N0zOlgJeNeQeW107Khb9s022X0
dw0Ksnn4SBRf8PC+EMjfPw3R/ukWpY0OH/5WQTURpR3hNj4fXiBaHsR5iPJ14/+g
MXwCm/NGuq1b8tMX/Zfye1r064Yt6fxBDNeQxivOImOczvKFRJhLoF9jIOqWCunJ
GpDPzZNxysurzFW8vBLXSDbN6ZTGjwlMrmfnFFtXzqw1/KJSlYyukdyAz9oB13UG
WDeml2YamUV8Z40PWgQAD95z4hSho2dy1AXO8p1W8LN+e81zMuMhEysVAMpGysdG
BQPUMp7acbVgUEJ9bANkxcjmR1sDBD21GESvrcDKexXB9QkPT8w7bCKEVVMsJyRr
54t1NlR4ZhNwkdzBw0vvHyIjdtbuYVmsNm19v+5KUu42dPqFGrdlgZ5Zfi7KlM5M
dHWxT0+L9RZE0ngIZTibxEEi2iw4jIZL11Lq7KzB54luSZ2vdPDk52gqx7fWQzkb
uzU4T8HlNYKG0j8PvdWx96Ske9CRIqNWjCx91E9YqB6fr9D1a1Pa6DSel+8FZ2bl
zHDsR/PmpuSVdCJWZNF6xwNLiMWAbFlre8I48Erk+UKQBszgP9v4gDlaAqgqKymh
geQbRYdzWFWPkadKkX0+keIqanpsXPVKB88buGZ/Vovaqo+etDLwAYxEt1OwIpJ3
fuQe405PVk8=
=VPvX
-----END PGP SIGNATURE-----

--=-mrAkGAAmdKw9pQIc4GqC--

