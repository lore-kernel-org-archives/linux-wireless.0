Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:33478 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2GLPZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 11:25:46 -0400
Date: Thu, 12 Jul 2012 11:25:46 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Anyone using rtl8192de with 2.4GHz 802.11g?
Message-ID: <20120712152545.GA9489@alittletooquiet.net> (sfid-20120712_172551_324741_8C061AB8)
References: <20120712002149.GA14850@alittletooquiet.net>
 <4FFE211C.3020506@lwfinger.net>
 <20120712013216.GB14850@alittletooquiet.net>
 <4FFE2F38.7030604@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
In-Reply-To: <4FFE2F38.7030604@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Larry,

On Wed, Jul 11, 2012 at 08:58:16PM -0500, Larry Finger wrote:
> On 07/11/2012 08:32 PM, Forest Bond wrote:
> >On Wed, Jul 11, 2012 at 07:58:04PM -0500, Larry Finger wrote:
> >>On 07/11/2012 07:21 PM, Forest Bond wrote:
> >>>The rtl8192de driver is working fine for me at 5GHz, but I am having t=
rouble
> >>>getting scan results for 2.4GHz 802.11g networks.  I have been doing a=
 lot of
> >>>debugging but am not making much progress.  I suspect the 802.11 b/g/n=
 phy is
> >>>not being initialized correctly, but I'm pretty far outside my domain =
on this
> >>>one.
> >>>
> >>>Is anyone successfully using this driver with a 2.4GHz 802.11g network?
> >>
> >>I have several different models - some work better than others. What
> >>is the PCI ID for yours?
> >
> >This is the one I have:
> >
> >02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. Devic=
e [10ec:8193]
> >02:00.1 Network controller [0280]: Realtek Semiconductor Co., Ltd. Devic=
e [10ec:8193] (rev 01)
>=20
> It turns out that both kinds have the same ID. I think one of them
> is a prototype, while the other is probably a production unit.
> Obviously, bitrot has set in while I wasn't testing. With the kernel
> driver, neither unit can even scan in the 2.4 GHz band. Using the
> latest version of the vendor driver, the production version connects
> with APs running WEP, WPA, or WPA2. The prototype can only handle
> WEP.
>=20
> Obviously, I have some work to do. In the meantime, I will send you
> a tarball containing the vendor driver - privately so as not to spam
> the list.

Thank you, I appreciate that.

Of course, my preference would be to fix up the kernel driver.  I don't mind
doing some manual bisection with compat-wireless releases unless you think =
that
would be a total waste of time.  Do you have any sense for what the last wo=
rking
kernel version would have been?

As you suggest, we may need to use the vendor driver in the meantime.  Than=
ks
again for sending it over (although I suspect it is the same version I
downloaded from Realtek's web site).

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/+7HkACgkQRO4fQQdv5AyYPwCfZUpLPnkfe8XhcqeZNRbuU/Bt
8TUAoM8rUf7ab3yvgh41dEldL8Nwxl+h
=zTIM
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
