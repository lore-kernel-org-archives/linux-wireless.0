Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZGXQYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 12:24:37 -0400
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <wfmy6u6opl.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers>
	 <1247762215.4235.21.camel@mj> <wf1vogmujw.fsf@calligramme.charmers>
	 <1247775641.6841.16.camel@mj> <wfzlau7co1.fsf@calligramme.charmers>
	 <1248449030.21715.23.camel@mj> <1248449371.32151.23.camel@johannes.local>
	 <1248450733.21715.26.camel@mj> <1248451197.32151.26.camel@johannes.local>
	 <1248451440.21715.27.camel@mj> <1248451757.32151.27.camel@johannes.local>
	 <wfmy6u6opl.fsf@calligramme.charmers>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7bJ5VaLvpiRGANVGAFeD"
Date: Fri, 24 Jul 2009 18:24:35 +0200
Message-Id: <1248452675.32151.31.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7bJ5VaLvpiRGANVGAFeD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-24 at 17:16 +0100, Jon Fairbairn wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> > I also added a short overview over the form factors on the page:
> > http://wireless.kernel.org/en/users/Devices/PCI.
>=20
> That's really good!

And quick too, thanks Pavel!

> (In the "asking for the moon on a stick" department, it would be handy
> to have a table somewhere with "supported features" and "form factor"
> dropdowns, so that I could have selected "AP" and "PCIe" and get the
> card I now have ;-)

I wondered about that, but the list really gets too wide, and it's
really a driver rather than device property whether it supports AP or
not.

Then of course, there's also band/11n streams/... information that you
might want.

I'm starting to think we should remove all the numbers (pci vendor,
product, subvendor, subsystem) in favour of more interesting information
like that.

However, as far as AP is concerned, how about we just add a little help
text that explains that you should look on the Drivers page to see
whether it supports what you need, and then select by driver? We could
make the driver table better to allow filtering.

johannes

--=-7bJ5VaLvpiRGANVGAFeD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaeBAAAoJEODzc/N7+QmahJwP/iEfzTs7ffLzoCOeMOcFlTRZ
gK84I6m7tBcHqy9PvqPURGhgzGmcIQQtR/yFLdVRn3iGS62zbDfSIF0WBKPpHTQ3
A0BfqQVvN4eavahAigMDkI1ffqOhhl3qdv460cYhubV7JlbBc3mNn+BPLy0emFTr
Qgv2PQmE3RWn1zvnit1jP7DSrlvpgbWV5/MxxiCmapnzeei0jnfO5rJhmLlzpnbb
ElP98EcDy4NPUL9jEt66ve2Fhla47E5bPxp4nw+UIwpjUe/P3VMQ1GIRMr+oYJkW
18WiqVqBWOP7JkTD3F7J+uBEyKX8wZtYlk4X5CoAv8ikSx98fTptCCNL+Qz4Swad
DQXwfFrTTVK0w9mk5EA9fxhEWnVRdn8ZAvECUMU0oSqlBluYr4p4r+wl5hxN0HW3
uXI+0TmHVsqW2NNHP2K7OA3n9Bwp8K7hJfPbTIA5Bu32Ulx71UGdEYtk//KFwGpJ
NpxCpoVafDwc374bxzP0q4LxBy5kNbobd++4p6hZmEw3/pSxwC8uK32zklIlYmGB
bdC3H9VAIMceVtm/0M3Gix24i7PpUy+C8F7exf1VlFFACUpQxRQXRGgSDcE6U5hb
ymc2U71Z+0NH1lOEpUswExIjhtHTTpS+U77+DXLyH33oRBP9ZXe43EK6kbXw7O3/
lp3h+aglz9oSWtaUfbej
=kLuv
-----END PGP SIGNATURE-----

--=-7bJ5VaLvpiRGANVGAFeD--

