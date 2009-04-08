Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:24757 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZDHQ1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 12:27:13 -0400
Received: by yw-out-2324.google.com with SMTP id 5so195985ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Apr 2009 09:27:12 -0700 (PDT)
Message-ID: <49DCD05B.9050802@gmail.com> (sfid-20090408_182716_387741_820F7FED)
Date: Wed, 08 Apr 2009 12:27:07 -0400
From: Will Keaney <keaneyw@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Fwd: Re: Trouble Associating with ath5k on AR5212]
References: <49DCA8E3.3060603@gmail.com>	 <b6c5339f0904080758k2be9ae3dm1a98b564f3b10867@mail.gmail.com>	 <49DCC641.4010405@gmail.com> <b6c5339f0904080920q47a33315j127a0aa2eca84444@mail.gmail.com>
In-Reply-To: <b6c5339f0904080920q47a33315j127a0aa2eca84444@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig347D4202BE0035BD415DF285"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig347D4202BE0035BD415DF285
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Bob Copeland wrote:
>> I also have to manually set the reg domain to US every time I load the=

>> ath5k module. =EF=BF=BDI tried configuring wpa_supplicant.conf to do t=
his
>> itself, but that doesn't seem to work. =EF=BF=BDIt would be nice to ha=
ve a
>> module parameter for setting this at load time.
>>    =20
>
> I may be wrong but I think that only works in wpa_supplicant if you
> use -Dnl80211 (instead of -Dwext).
>
> FWIW in the default world roaming domain you can still connect to most
> APs.  Besides iw/wpa_supplicant, pending patches to ath5k will set the
> default regdomain automatically based on the value stored in the eeprom=
=2E
>  =20
Ahh, interesting.  I didn't see nl80211 documented in the wpa_supplicant
example configs or man page. I'll give that a shot.
I seem to get much better scanning results with the region set properly,
than on the world roaming domain.


--------------enig347D4202BE0035BD415DF285
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknc0FsACgkQjfayWCA8dDGb+gCfVBnb7Qk89mI1srR4X8BGasYd
Q1sAn1tGy8DqI/qrgNDbXaifNBbr5XeR
=Bgjl
-----END PGP SIGNATURE-----

--------------enig347D4202BE0035BD415DF285--
