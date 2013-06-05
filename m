Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:14147 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756350Ab3FERAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 13:00:40 -0400
Date: Wed, 5 Jun 2013 18:58:37 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
	Antonio Quartulli <ordex@autistici.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCHv4 2/4] brcm80211: make mgmt_tx in brcmfmac accept a NULL
 channel
Message-ID: <20130605165837.GI2349@open-mesh.com> (sfid-20130605_190042_790771_192C89D5)
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
 <1370444989-2095-2-git-send-email-ordex@autistici.org>
 <51AF5A92.9050906@broadcom.com>
 <51AF5AB7.2070703@broadcom.com>
 <1370446810.25710.6.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Hlh2aiwFLCZwGcpw"
In-Reply-To: <1370446810.25710.6.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Hlh2aiwFLCZwGcpw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

iOn Wed, Jun 05, 2013 at 08:40:10AM -0700, Johannes Berg wrote:
> On Wed, 2013-06-05 at 17:35 +0200, Arend van Spriel wrote:
> > On 06/05/2013 05:34 PM, Arend van Spriel wrote:
> > > On 06/05/2013 05:09 PM, Antonio Quartulli wrote:
> > >> From: Antonio Quartulli <antonio@open-mesh.com>
> > >>
> > >> cfg80211 passes a NULL channel to mgmt_tx if the frame has
> > >> to be sent on the one currently in use by the device.
> > >> Make the implementation of mgmt_tx correctly handle this
> > >> case
> > >>
> > >> Cc: Arend van Spriel <arend@broadcom.com>
> > >> Cc: brcm80211-dev-list@broadcom.com
> > >> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> > >> ---
> > >
> > > For my name above you (or Johannes) can change 'Cc:' to 'Acked-by:'
> >=20
> > Or John?
>=20
> I think I'll take the whole series if that's ok with everyone, otherwise
> we get synchronisation issues between John and myself :)
>

Yeah, I think that's the best option.

Thanks everybody!

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--Hlh2aiwFLCZwGcpw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRr249AAoJEADl0hg6qKeOKJgP/1QUBeqEwr6BsI8sH2wFoKth
T7OluADc46YU4Ol7UOZR8n/YTFhfhsGiFoQP7qSCcnpCm0bFkc0rnRaiq6Gjk3dV
ziyoLf6J6NCX2cyC/QpObVPZ75IbSLwYOZOrLA2SFQIwlMXJPiqzRuzZvvYfthwe
cj/CZWSkaK1VFS59IxfcIRr/XZNlIv/77iP4wy6Z+9WJAN2Vw82mbHZoVSji4X3t
QWa+dCcYWbpvQHbPc757wuUv/CIq+lXNcfOwlYGPuYEN5Mr2seISWGmg3kEmohfU
jshNIJc1pngOZnKQhARhv6PE858w017XZvmcn3i/bVM/nckixSTJY3zLhYB5RNDX
GeLOzEIe3ZH6zfu6hZ7+kshTKYUDq+mVxoiYZVGmq7oF3d3B5x6HdTb/w3fW0p+k
xMcaveDyZ9FjMlSxWqxVDhcB5X7GIhTPTFngoX5JZndxbNXznJ5jWPbxIGDvKKTF
dsKb0YfhoKYyWZ1Gi07r6qMtBq607CoboNlALT71UyT2lxY36UKp1UuO4lsXnMlb
gd7nhkLfgxpyXZsqKYdfmJtq7s0XBNs5UblkThtQlLsMKMj9IpGD+PF2s+jOqRnW
O+eRwx6R1IOod4IaNW/0/t/C4glug6FYzDFhWznxhsLh8iPmFr5/GISbgt4tKVUX
PY2YEqrSc0lPU515pNnn
=H4/n
-----END PGP SIGNATURE-----

--Hlh2aiwFLCZwGcpw--
