Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:36671 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbZDSUCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 16:02:24 -0400
Date: Sun, 19 Apr 2009 16:01:46 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090419200146.GB28885@storm.local.network> (sfid-20090419_220227_723836_9D3BAEBC)
References: <20090414113928.GA20470@storm.local.network> <1239709727.4778.6.camel@johannes.local> <1239712106.11795.21.camel@violet> <1239713034.17109.10.camel@johannes.local> <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network> <20090415011020.GC10045@kroah.com> <20090415015116.GJ20470@storm.local.network> <20090419170950.GA28885@storm.local.network> <49EB8119.1020402@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
In-Reply-To: <49EB8119.1020402@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Larry,

On Sun, Apr 19, 2009 at 02:52:57PM -0500, Larry Finger wrote:
> Forest Bond wrote:
> >=20
> > However, I did have a question:
> >=20
> > The vt6655 driver builds viawget.ko, and the vt6656 driver builds vntwu=
sb.ko.
> > Should the directories be named "viawget" and "vntwusb," respectively, =
or is it
> > appropriate for them to be named "vt6655" and "vt6656"?
>=20
> Of course Greg has the final say, but I vote to keep the directories with=
 the
> vt6656 name and change the name of the driver, which is defined in  the l=
ine
> #define DEVICE_NAME "vntwusb" in file include/device_cfg.h in the vendor =
driver.

This makes sense to me.  I'll proceed this way for now.  Greg, let me know =
if
you'd prefer I didn't do this.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQFJ64MqRO4fQQdv5AwRAjmaAJiRqFubg2kTm3jBL86CgiIcZ3bKAKDH1vwg
SXIgfmAb66OKb2ZtvZZCjg==
=i5iW
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
