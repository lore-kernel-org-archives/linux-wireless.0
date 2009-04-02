Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760281AbZDBQ1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 12:27:50 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49D4D833.9070107@lwfinger.net>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-k9xeh85xOPalBo+ulHgr"
Date: Thu, 02 Apr 2009 18:27:16 +0200
Message-Id: <1238689637.24708.41.camel@johannes.local> (sfid-20090402_182807_297249_7CD911FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k9xeh85xOPalBo+ulHgr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 10:22 -0500, Larry Finger wrote:

> Without your "rfkill rewrite" patch, but with "rfkill-remove-unused-code"=
,
> "rfkill-remove-deprecated", and "rfkill-remove-user-claim" patches, the f=
ile
> /sys/class/..../trigger contains "none ide-disk BAT0-charging-or-full
> BAT0-charging BAT0-full ADP1-online phy0rx phy0tx phy0assoc phy0radio [rf=
kill0]"

On my system that's exactly what it looks like with my patch (well,
rfkill4 right now). I'm stumped. What kernel are you running?

johannes

--=-k9xeh85xOPalBo+ulHgr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1OdiAAoJEKVg1VMiehFYyGwQALga9vUvVE1+N1U4F/AjqjeJ
PPzVC31trs9djmSt2+566xDgCRPxcykU0Z/NzsgVFExe01lNTY287HkaEYLQVCE4
pubfsWnuE2L5vm91E06fOyyaw/Kdac9hTCeR9/pnuxTFjRTZgpvOrTzQunjC99RI
mktlyyCW7FaejVHqU3BksNzig9VgZkdZ/cZDBz8Kz2WXQCjd1S3qfuBaxoJ6eP4e
/qccskJbIDn6oF3DYhMVv860jklxBJNrVUVH8T4t5aY65PkAvR5ZqjBWEI/nyFMI
qVfxQg9xyTHq9P0E4nqfqw1GAFwWc2I5l5iEro/GVuXy+2UhqS7OKQYkM1ZESWKk
rS6ncDsxHszNRSzJuucH189aJqnjQdtStXPagUIfbbUifvEul3bcCCDdF6d3RuU0
ClRE6NPjlDm+eEv9/av8fFAVlK0sa0zfve9a01QFN990lTlG4Kjm1VOWpSJgl/Qj
1iK/FrjN4uei5+XkzGlEEMXcxS9ZCJ226+kMdhYTenFYsGbmlkvgPWsH05ouikca
HeuLAhTSB1uSYDw0hmpCP9aCqUfWkBPfI2mB34/vxemghhJ+q6pShwjHCUZ91r4v
VbSf4GwAcfieED/4knyjmuuwpXLyOAlQAXPiEKCNtRfbWgwOeatlhv8jSCKz9j9W
+GhviJq+k0NuU6VMO9Ve
=v9G7
-----END PGP SIGNATURE-----

--=-k9xeh85xOPalBo+ulHgr--

