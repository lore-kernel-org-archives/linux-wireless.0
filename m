Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from seehuhn.de ([80.68.93.199]:3486 "EHLO seehuhn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759145AbXHYPIh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2007 11:08:37 -0400
Date: Sat, 25 Aug 2007 15:19:16 +0100
From: Jochen Voss <voss@seehuhn.de>
To: ian <ischram@telenet.be>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: letting drivers choose their preferred rate scale
Message-ID: <20070825141915.GA24683@plonk.seehuhn.de>
References: <46CF95F9.6090802@telenet.be> <1188028962.9529.13.camel@johannes.berg> <46D01D57.6060806@telenet.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
In-Reply-To: <46D01D57.6060806@telenet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

just a cosmetic issue:

On Sat, Aug 25, 2007 at 02:15:19PM +0200, ian wrote:
> +	printk(KERN_DEBUG "%s: Failed to initialize %s rate control "
> +               "algorithm\n", local->mdev->name,
> +		hw->preferred_rate_control ?
> + 		hw->preferred_rate_control : "default");

It would be nicer if this was

 +	printk(KERN_DEBUG "%s: Failed to initialize %srate control "
 +               "algorithm\n", local->mdev->name,
 +		hw->preferred_rate_control ?
 + 		hw->preferred_rate_control : "default ");

to avoid a spurious space in the non-default case.

I hope this helps,
Jochen
--=20
http://seehuhn.de/

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG0Dpjf+iD8yEbECURAv+EAJ9sC5j+9vgWtCCkY/eYiFtJUqgfbgCfWG2P
rkUmCBD6wlVRNmedagPQGjw=
=dXUj
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
