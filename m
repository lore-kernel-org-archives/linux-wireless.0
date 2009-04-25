Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:41507 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZDYAJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 20:09:13 -0400
Date: Fri, 24 Apr 2009 20:08:30 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090425000830.GO2830@storm.local.network> (sfid-20090425_020918_108781_9B628253)
References: <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network> <20090415011020.GC10045@kroah.com> <20090415015116.GJ20470@storm.local.network> <20090419170950.GA28885@storm.local.network> <49EB8119.1020402@lwfinger.net> <20090419200146.GB28885@storm.local.network> <20090419223218.GA30599@kroah.com> <20090424110329.GJ2830@storm.local.network> <20090424225820.GE3343@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpgPcFyQO6wM49Um"
In-Reply-To: <20090424225820.GE3343@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--IpgPcFyQO6wM49Um
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 24, 2009 at 03:58:20PM -0700, Greg KH wrote:
> On Fri, Apr 24, 2009 at 07:03:29AM -0400, Forest Bond wrote:
> > Hi Greg,
> >=20
> > On Sun, Apr 19, 2009 at 03:32:18PM -0700, Greg KH wrote:
> > > On Sun, Apr 19, 2009 at 04:01:46PM -0400, Forest Bond wrote:
> > > > On Sun, Apr 19, 2009 at 02:52:57PM -0500, Larry Finger wrote:
> > > > > Forest Bond wrote:
> > > > > >=20
> > > > > > However, I did have a question:
> > > > > >=20
> > > > > > The vt6655 driver builds viawget.ko, and the vt6656 driver buil=
ds vntwusb.ko.
> > > > > > Should the directories be named "viawget" and "vntwusb," respec=
tively, or is it
> > > > > > appropriate for them to be named "vt6655" and "vt6656"?
> > > > >=20
> > > > > Of course Greg has the final say, but I vote to keep the director=
ies with the
> > > > > vt6656 name and change the name of the driver, which is defined i=
n  the line
> > > > > #define DEVICE_NAME "vntwusb" in file include/device_cfg.h in the=
 vendor driver.
> > > >=20
> > > > This makes sense to me.  I'll proceed this way for now.  Greg, let =
me know if
> > > > you'd prefer I didn't do this.
> > >=20
> > > No objection from me.
> >=20
> > The following git repository has a vt6655 branch and a vt6656 branch:
> >=20
> >   http://www.alittletooquiet.net/media/code/vt665x.git
> >=20
> > The vt6655 branch contains pretty much all of the work I'll likely be a=
ble to do
> > for that driver.  The vt6656 branch needs more work.  I've not gone far=
ther than
> > build-testing either, at this point.
> >=20
> > As I've mentioned before, some of this kind of work is really a bit out=
side my
> > usual domain, so if you do look at it, I'd appreciate feedback.
> >=20
> > Feel free to make requests.
>=20
> Could you send it out as patches so it's easier to review?

Yes, I would've preferred that but the first patch is >1MB, so I figured it
might be more useful to point you to a git repository, rather than send out=
 a
compressed patch.  I can send it out uncompressed if you prefer, or I can j=
ust
send all but the first patch (which only copies files from the upstream arc=
hive,
anyway).

-Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--IpgPcFyQO6wM49Um
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ8lR+RO4fQQdv5AwRAm3KAJ9+F8pInDPV1SMn05dfiDCC6TmrNgCgrXY6
ufdmrQUA1kxYbcoc7ZOumH4=
=46jj
-----END PGP SIGNATURE-----

--IpgPcFyQO6wM49Um--
