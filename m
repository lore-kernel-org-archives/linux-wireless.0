Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:33916 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZDXLEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 07:04:07 -0400
Date: Fri, 24 Apr 2009 07:03:29 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090424110329.GJ2830@storm.local.network> (sfid-20090424_130413_071122_2498A62E)
References: <1239712106.11795.21.camel@violet> <1239713034.17109.10.camel@johannes.local> <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network> <20090415011020.GC10045@kroah.com> <20090415015116.GJ20470@storm.local.network> <20090419170950.GA28885@storm.local.network> <49EB8119.1020402@lwfinger.net> <20090419200146.GB28885@storm.local.network> <20090419223218.GA30599@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dwWFXG4JqVa0wfCP"
In-Reply-To: <20090419223218.GA30599@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--dwWFXG4JqVa0wfCP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Sun, Apr 19, 2009 at 03:32:18PM -0700, Greg KH wrote:
> On Sun, Apr 19, 2009 at 04:01:46PM -0400, Forest Bond wrote:
> > On Sun, Apr 19, 2009 at 02:52:57PM -0500, Larry Finger wrote:
> > > Forest Bond wrote:
> > > >=20
> > > > However, I did have a question:
> > > >=20
> > > > The vt6655 driver builds viawget.ko, and the vt6656 driver builds v=
ntwusb.ko.
> > > > Should the directories be named "viawget" and "vntwusb," respective=
ly, or is it
> > > > appropriate for them to be named "vt6655" and "vt6656"?
> > >=20
> > > Of course Greg has the final say, but I vote to keep the directories =
with the
> > > vt6656 name and change the name of the driver, which is defined in  t=
he line
> > > #define DEVICE_NAME "vntwusb" in file include/device_cfg.h in the ven=
dor driver.
> >=20
> > This makes sense to me.  I'll proceed this way for now.  Greg, let me k=
now if
> > you'd prefer I didn't do this.
>=20
> No objection from me.

The following git repository has a vt6655 branch and a vt6656 branch:

  http://www.alittletooquiet.net/media/code/vt665x.git

The vt6655 branch contains pretty much all of the work I'll likely be able =
to do
for that driver.  The vt6656 branch needs more work.  I've not gone farther=
 than
build-testing either, at this point.

As I've mentioned before, some of this kind of work is really a bit outside=
 my
usual domain, so if you do look at it, I'd appreciate feedback.

Feel free to make requests.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--dwWFXG4JqVa0wfCP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ8ZyBRO4fQQdv5AwRAn9cAKDRnowfb0WEGPFE4UmyLMg6CtQHhgCggM+N
ZvfFP7WdO/9eJy6VzlWQk4c=
=WTva
-----END PGP SIGNATURE-----

--dwWFXG4JqVa0wfCP--
