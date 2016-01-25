Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59404 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbcAYVBu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 16:01:50 -0500
From: Marc Dietrich <marvin24@gmx.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCHv2 3/4] ARM: tegra: use build-in device properties withrfkill_gpio
Date: Mon, 25 Jan 2016 21:59:04 +0100
Message-ID: <1626364.s6q6eBGYVQ@ax5200p> (sfid-20160125_220216_792624_38B22A17)
In-Reply-To: <20160125121840.GA20452@ulmo.nvidia.com>
References: <1453712629-143317-1-git-send-email-heikki.krogerus@linux.intel.com> <1453712629-143317-4-git-send-email-heikki.krogerus@linux.intel.com> <20160125121840.GA20452@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1990714.Ebrfbf8RNK"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1990714.Ebrfbf8RNK
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Montag 25 Januar 2016, 13:18:40 schrieb Thierry Reding:
> On Mon, Jan 25, 2016 at 12:03:48PM +0300, Heikki Krogerus wrote:
> > Pass the rfkill name and type to the device with properties
> > instead of driver specific platform data.
> > 
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > CC: Alexandre Courbot <gnurou@gmail.com>
> > CC: Thierry Reding <thierry.reding@gmail.com>
> > CC: Stephen Warren <swarren@wwwdotorg.org>
> > ---
> > 
> >  arch/arm/mach-tegra/board-paz00.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> Looks fine to me. We might want to wait for Marc (Cc'ed) to give this a
> spin, since I don't have the hardware. For reference, the series can be
> found here:
> 
> 	http://patchwork.ozlabs.org/patch/572640/
> 	http://patchwork.ozlabs.org/patch/572644/
> 	http://patchwork.ozlabs.org/patch/572643/
> 	http://patchwork.ozlabs.org/patch/572642/
> 
> Johannes, I assume that you'll want to take this through your tree
> because of the dependency? In that case:
> 
> Acked-by: Thierry Reding <treding@nvidia.com>

seems to work fine. I wish we could instantiate this from device-tree so we 
can finially get rid of this file.

Tested-by: Marc Dietrich <marvin24@gmx.de>

--nextPart1990714.Ebrfbf8RNK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJWpoyYAAoJEKyeR39HFBtojysH+gPoKfxQC7HZRoPxlW3cvw3w
yQnlrnL8ifHJeFYBiZWSMDZ8COOTb0VkJAfZ/BNTm2+yBPzxPXMNCvrM9B9EHZF/
ikY/8YZ6uMXZqEMguEDxagwGSmr7we8rwAu0NaG+92eS1wYs6sLdBgi6vWxYV9Yy
99/6IdQuCS8ICFWatUlB2FETABxLWtW0o5qW7CoNbCcgRNMqn+csXnBV1kteQK+s
NpKIomwmPqbWXFxYw0sDluVyu6Ljb5NqVh4Z7ybGN+Bjsjerx2+PGUZxIqNNAdNj
dFtB8vAebqxsSdcwPRqhZrh1gCj8JTt9GC8lnAaMU7u6Umw9szAauwq8HmhJBWI=
=9kVs
-----END PGP SIGNATURE-----

--nextPart1990714.Ebrfbf8RNK--

