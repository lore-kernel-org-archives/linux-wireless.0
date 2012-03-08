Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:30379 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2CHGn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 01:43:56 -0500
Date: Thu, 8 Mar 2012 09:46:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: NFC: Fragment LLCP I frames
Message-ID: <20120308064617.GI674@mwanda> (sfid-20120308_074359_539172_DF3463C2)
References: <20120307095142.GA24805@elgon.mountain>
 <20120308024952.GA9008@sortiz-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VkVuOCYP9O7H3CXI"
In-Reply-To: <20120308024952.GA9008@sortiz-mobl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--VkVuOCYP9O7H3CXI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 08, 2012 at 03:49:52AM +0100, Samuel Ortiz wrote:
> > Shouldn't this be msg_ptr +=3D frag_len?
> Right as well.
> I'll send an patch to John for fixing that. Do you mind me adding a:
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> to it ?

That would be great.

regards,
dan carpenter



--VkVuOCYP9O7H3CXI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWFW5AAoJEOnZkXI/YHqRh0cP/jRSYOzAmQlWEvLf5Ui+8oVn
tT4/jIl1nz0dvphqpZVR4fiWDQmpqq3lCAa+PLTnh1iLL6UZna0kNyBAsmBmbjtg
39Ys81NAn16WvOtujYky8pPVlyagrJv70YnuwQ33PDsQoUX7C+xT6hZIc0LaByi0
K/yQ3OOIJ0TaUNgYiY8NQHCUaZxIY3EfhKEPm6h2L+J7tXfqf94hxsitblh4exZY
yBHX0DdUAO7j0Hu6lsmJYhNYYYdjvRiQQ0y1LEaX8i2AQqisb9GGsMb7tkopqZr6
FfJNSttns9nBRfpQzOXo8inBPl7/TOm6WW9wev4VnaFiRm6Zg08vBLYe1amc3dkc
cP9PlSfR+FEWsnuYt649PFt3V2o/q6f6dt8Oy7wxwg8V9R1mhIdJ6ph7gKoeKF9Z
K0fnwOfIf8zggVHv91uIubDsNrUFjeAuqsEbywzuKgJvPbIjpckevQcE90ZXofrr
g8g/vHalKUX4c9zaJP90dtfymBQ29xYsLhDd/IhpEHFVPwVZTT0/aylmiSKLn/QR
4o4Bekp/+R68nAGfJC257fcWTwGAIck2PUat81NaN3i5vo9sar7ixPQQq3GUeW8d
86uRMR8NgrzYWxZn6O3HrW74yDh3E7DgaLiVAVX6wCAtD+FLe3isk5yV8oN0/sFx
CK3816hXotnF5n6y/zHM
=ogmM
-----END PGP SIGNATURE-----

--VkVuOCYP9O7H3CXI--
