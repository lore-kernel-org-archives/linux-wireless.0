Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbYDAMKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:10:25 -0400
Subject: Re: [PATCH] rt2x00: TO_DS filter depends on intf_ap_count
From: Johannes Berg <johannes@sipsolutions.net>
To: Bas Hulsken <bhulsken@hotmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1206987819.3085.7.camel@Bas>
References: <200803311524.53768.IvDoorn@gmail.com>
	 <1206987819.3085.7.camel@Bas>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eCDeybjS07Kt+j5xWhOL"
Date: Tue, 01 Apr 2008 14:10:18 +0200
Message-Id: <1207051818.5143.64.camel@johannes.berg> (sfid-20080401_131028_028357_63AAF620)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eCDeybjS07Kt+j5xWhOL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> unfortunately I still don't have a working AP, since hostapd crashes
> when receiving the EAPOL key from the client. I'm still trying to find
> out what exactly happens, I'll post more info in a new thread. I'm
> inclined to think that the problem lies on the driver side, since this
> used to work at the 31st of January this year, with hostapd-0.6.2, which
> is the version I've tested with now.

What exactly happens? I guess you have my (single) hostapd patch
applied?

johannes

--=-eCDeybjS07Kt+j5xWhOL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/ImKqVg1VMiehFYAQJirg//RJLyUHqAHOI13pGOsIVdsC9OhXbdbPxE
JbbVxy8wwRDiQ7wFdKlwSfjNPvB7sGG63tElbBn0M2Pm3HddkvYbsfDm939Pg3lF
JhRi0yM067sJFvDTMN5lj0jWzRCh82YLlgq2U8gs9UHUsMT2Dsdt9qiFo72fCCfv
vynEAZMd2L1H/9/ooByX+uF0VfPeULvScd2i58IlR4l50U8S91UWcn2CSONII437
PPWBPNMrCEkn7WqQIRtxQIBeOw1YFay16YPefvLbcHsAYA0Nlpp857b9NrKfWNBI
ZvjHcJKgS2N2/OsBpfV0uW7P5qLFKOiyJOToAETeO3PpuNVzit8Wato5YVg0mhRw
BGAuiJeyDMvGPMm62Mko8yd5NwprpVBmyew00I8cMWN9F9abQDR0TNDnyHyUdDVf
NChITiMvEwmWSD3M8iHpLt8Ycey5V8lYBtBOrv4bfR5nAjv3oSMsGbfiLCaY9Uap
UZ8UvjTRUq40cwhZy3iUW9sJCOV1EkKMqyXCXxEy3KQpFMaT8DskKwBZnAUSg8I0
ICHMGH/XkzTyCFAYwo+BwZWx9fEyNQ238FiXIutwSFofGrhlRgIDIma/Ae7XLWAu
Hd+Bf1vgugT91SA+8sx/1O7Tb3MLaz8fLh4LjajE3f4dtOVeYtoLvUmZw+GVrzXj
582po08m9AI=
=qs2P
-----END PGP SIGNATURE-----

--=-eCDeybjS07Kt+j5xWhOL--

