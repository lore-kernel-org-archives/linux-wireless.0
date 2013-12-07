Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32446 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab3LGXBX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Dec 2013 18:01:23 -0500
Message-ID: <1386457281.2195.55.camel@jtkirshe-mobl> (sfid-20131208_000127_235275_8E381015)
Subject: Re: [net] nfc: Fix FSF address in file headers
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Date: Sat, 07 Dec 2013 15:01:21 -0800
In-Reply-To: <1386456926.31845.57.camel@joe-AO722>
References: <1386348976-24657-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <52A39F18.8080202@broadcom.com> <1386456552.2195.52.camel@jtkirshe-mobl>
	 <1386456926.31845.57.camel@joe-AO722>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LqPi0IdVyl80OKnjwtN0"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LqPi0IdVyl80OKnjwtN0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-12-07 at 14:55 -0800, Joe Perches wrote:
> On Sat, 2013-12-07 at 14:49 -0800, Jeff Kirsher wrote:
> > On Sat, 2013-12-07 at 23:20 +0100, Arend van Spriel wrote:
> > > On 12/06/2013 05:56 PM, Jeff Kirsher wrote:
> > > > Several files refer to an old address for the Free Software Foundat=
ion
> > > > in the file header comment.  Resolve by replacing the address with
> > > > the URL<http://www.gnu.org/licenses/>  so that we do not have to ke=
ep
> > > > updating the header comments anytime the address changes.
> > >=20
> > > This seems to pop up from time to time and unfortunately the resoluti=
on=20
> > > seems not consistent at those times. Why not simply refer to the full=
=20
> > > license text that is in the COPYING file in the tree itself.
> >=20
> > I, personally have only had one request in the last 10 years to change
> > our Intel Wired Ethernet headers and that was because the address
> > changed.  I am open to suggestions, although when I proposed either
> > updating the address to the current address or use the URL on LKML and
> > netdev, the response I got was to update to the use the URL.
> >=20
> > I guess the only argument I would have against referring to the COPYING
> > in the tree itself is that the headers already state:
> >=20
> > You should have received a copy of the GNU General Public License along
> > with this program;
> >=20
> > (which refers to the COPYING file) and then it states...
> >=20
> > if not, write to the Free Software Foundation, Inc.,
> > 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> >=20
> > This is the second part that needs cleanup if the file refers to the ol=
d
> > address.  So just by removing the address and providing the URL, you ar=
e
> > providing a place that users can get the license *if* the COPYING file
> > gets removed (or altered) by who ever releases the kernel.
>=20
> Hi Jeff.
>=20
> I think what you've done is fine, but remember that
> URLs come and go too.

True, I just wish that were true for those embarrassing pictures of me
20 years ago... <joking>

>=20
> There was a discussion about this just a bit ago on lkml
> https://lkml.org/lkml/2013/10/6/158
> and this message was added to checkpatch recently:
>=20
> "Do not include the paragraph about writing to the Free Software
> Foundation's mailing address from the sample GPL notice. The FSF has
> changed addresses in the past, and may do so again. Linux already
> includes a copy of the GPL.\n"

Thanks for the info, I overlooked that thread.



--=-LqPi0IdVyl80OKnjwtN0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSo6jBAAoJEOVv75VaS+3OhhIP/iCcDM+VlOnRSWlDO2wFAGJ8
Iyz56bi34Ek691gLkxOml/tlr/7Li+gjc1/rWw8JwPftvwTtFj09YK49qg94UvVH
QBc+N8CtM5Oj9KmXc+xm7yQNKVW1YJZTzVxdsZCTiEaCukxQ/ihebtJnYa29MHLQ
quvPVhZRahMibCdvFz7AavE1MJ8ZCcExykJlgS5joQLxs5KVolq0g459xsxKvUSA
HClMC7Xv2Y+UkSAmtzimS3gleoUkVTrfYXwva5LiuQp4o0lmkgH+0MundtU3roM1
UOk2xUg0SwZVbyvQl+f2hhvjBvPJY5tVfN3eW6EZX6Mo9dICUACNlRH2ChAN1XRC
2WbHv9VrAq/58JpeFBbrEYWl8DLakqLYU9BvC3B9Bo7JBkph96+V4GWMfYfaEZdE
APfEuekkgitKe7pyhLDq4bmqsuV98yc4NXbnn9QKZjuJRgM/E0upWVWwSmWZPpHO
SzFb1IW0G0Qh//BqnQ9Bk8JPsQ169hHCmO8+G6E3IPW6eGKPMtBfD85w4JguBOIY
gjX0p44w9NNfKnBPFtlz5daP5vUfrxqyGJ1cjz03ln3pZsMPJff9ZzCX9lP3jrj8
OWL/Xz+lDk/Ip8fMEgVKZK3K4MIMA4lgjnKBKUVp5cAKltRCmYIYbKDCzIibGN11
y9Vvi4781Y5ognC5ITNQ
=SdNd
-----END PGP SIGNATURE-----

--=-LqPi0IdVyl80OKnjwtN0--

