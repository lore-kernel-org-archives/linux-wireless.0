Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:49498
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab3KHNqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 08:46:45 -0500
Date: Fri, 8 Nov 2013 08:46:32 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: future of prism2_usb (aka wlan-ng) in staging tree
Message-ID: <20131108134632.GB13255@shaftnet.org> (sfid-20131108_144649_125682_8AECF94B)
References: <20131107160522.GA12612@shaftnet.org>
 <527BC04F.2080000@lwfinger.net>
 <20131107163719.GC12612@shaftnet.org>
 <20131107175201.GA2002@tuxdriver.com>
 <20131107185714.GD12612@shaftnet.org>
 <20131107191122.GD2002@tuxdriver.com>
 <20131107194641.GE12612@shaftnet.org>
 <1383863100.2391.5.camel@dcbw.foobar.com>
 <20131107230215.GF12612@shaftnet.org>
 <1383867422.2391.10.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
In-Reply-To: <1383867422.2391.10.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2013 at 05:37:02PM -0600, Dan Williams wrote:
> > Given that there never was a hostap_usb, there's no overlap at all.  If=
=20
> > you have a prism2.5/3 USB widget, you'll need prism2_usb to make it mor=
e=20
> > than a lousy paperweight.
>=20
> Sorry, I see now I meant orinico_usb, not hostap...

I'd started to write a more detailed history of the somewhat inbred=20
HFA384x chipsets, but eh, it's not particularly relevant.  Suffice it to=20
say that the differences between the Orinoco and Prism2.5/3 USB hardware=20
are enough to make trying to support both with a single codebase an=20
insane proposition.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQFSfOs4PuLgii2759ARAiMUAJ9XQ04P0rmaSlUQUYz2hWc77KTOcwCcCsoF
CmC2UA9hmEfMHmzSsU4Xrq0=
=TLfK
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
