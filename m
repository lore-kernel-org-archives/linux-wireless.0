Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:29780
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753640AbcA2T70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 14:59:26 -0500
Date: Fri, 29 Jan 2016 14:24:34 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: ksenija.stanojevic@gmail.com,
	"driverdev-devel@linuxdriverproject.org"
	<driverdev-devel@linuxdriverproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Move wlan-ng out of staging?
Message-ID: <20160129192434.GD5811@shaftnet.org> (sfid-20160129_205929_645234_20BD535A)
References: <56AB8C90.2050909@gmail.com>
 <56AB8F18.9000909@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/kgSOzhNoDC5T3a"
In-Reply-To: <56AB8F18.9000909@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--0/kgSOzhNoDC5T3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 29, 2016 at 05:11:04PM +0100, Xose Vazquez Perez wrote:
> >> I'm helping Greg do a bit of cleanup in the staging tree, I noticed th=
at
> >> wlan-ng driver is maybe ready to be moved out of staging. Are there
> >> any TODO tasks left to do beside checkpatch.pl clean-up?
> >=20
> > Its FAQ was very clear: ftp://ftp.linux-wlan.org/pub/linux-wlan-ng/FAQ
> > [archived at http://puppylinux.dreamhosters.com/wireless/linux-wlan-org=
_FAQ.txt ]

As author of that particular FAQ entry (written nearly ten years ago)=20
let me say that nothing in there has any bearing on the situation that=20
exists today.

At the time, I didn't think it was worth the significant effort to get=20
prism2_usb into the mainline, but obviously some enterprising folks=20
disagreed with me, and eventually put forth the elbow grease necessary=20
to get it into -staging and all of the subsequent cleanups.

=46rom where I sit, the basic question is this: Is the prism2_usb driver=20
now considered good enough to promote out of -staging? If not, what=20
needs doing and who is willing to see it through?  If it is, then just=20
do it already.  :)

Oh, I'm still hosting the firmware files needed for this thing, and I=20
see a consistent 4K or so downloads a month.  So there are obviously=20
users out there still.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--0/kgSOzhNoDC5T3a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iD8DBQFWq7xyPuLgii2759ARAn10AKCzi1wInzfItvFkG9CfDV4L+BFASQCgjZHS
z2I4/S3SxQEkZmzgKS23Zc8=
=X+7Z
-----END PGP SIGNATURE-----

--0/kgSOzhNoDC5T3a--
