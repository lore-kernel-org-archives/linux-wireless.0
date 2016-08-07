Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52358 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbcHGQtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Aug 2016 12:49:49 -0400
Message-ID: <1470588577.4325.4.camel@decadent.org.uk> (sfid-20160807_184952_437873_8E01E9DD)
Subject: Re: wext: Fix 32 bit iwpriv compatibility issue with 64 bit Kernel
From: Ben Hutchings <ben@decadent.org.uk>
To: Johannes Berg <johannes.berg@intel.com>
Cc: rasun Maiti <prasunmaiti87@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>
Date: Sun, 07 Aug 2016 17:49:37 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-TfIF++KxaGp1kbSH8qT1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TfIF++KxaGp1kbSH8qT1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm looking at commit=C2=A03d5fdff46c4b as part of the stable process.

The path it touches is only used for drivers that don't describe their
private wext handlers, right? =C2=A0So how can we know that the private
ioctl is using the iw_point structure and not one of the other types in
union iwreq_data? =C2=A0Doesn't this result in a regression when another
type is being used?

Ben.

--=20
Ben Hutchings
Beware of bugs in the above code;
I have only proved it correct, not tried it. - Donald Knuth
--=-TfIF++KxaGp1kbSH8qT1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXp2ahAAoJEOe/yOyVhhEJ8rcP/j7iCOnWpAe5bVXEDg96A0ed
SUjhruHIMO1SXgH9FivxogphIUXghdbii0KJWrDXRdyr96wTJfIRCI+Y+0ycEylI
IQ/ruAXzZ/9u3ibmk2GEjpI+7Pz7M9Wx70BaiOtZUVRYeSIbbBw0g7egS3xiJzxq
wuKGc+TAA2Hk3wlw3MaOX0KAfvwphJqQRFT93azzEIFLi9pJCHLtR//oFWY9KxdO
PYn6rvSgJP7Al15U5GTNkwUK1HiryU0Ark/RcrjAJTAHxWYDZNdUMDgQ6g72uEFc
chdJkQTLTk+JfBGBCflHhc/Retmb7HJ14FZWkXJB+XAqpg7R03BfAZb+sd8KP/Bc
JaLd2JjT/5gsg5ZWj/CQ9OCe0DKyjCIAof4jlMZWODtPuGKJitgldiEgZ1/IgF8b
reRVmxYPTzRdYFPDDAQA9PoLuY336EUxUwSAzL2WK34dpcpYhwE9rJHdP+uGJtX+
nxGeRShHJ3RDOTtidIq/In3RxEQqoVGv1rQNOqEBdQn012+51GBgHH4Lzau+f4Wg
Qfzzjbq2R2ShFDRXPowNfBEKv2FPAuZx9GJQrU21UksX7XhOl+gjJOJiQsBsg1kf
ZcX0uIO8vD39AnW4uhBdVt51kBIsMmw6kiPU6iWqtxcVRNPIcRlSVz+iP/mymu5O
VACvCRrZ0KANg+5zkLDI
=2IvV
-----END PGP SIGNATURE-----

--=-TfIF++KxaGp1kbSH8qT1--
