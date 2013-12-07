Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab3LGWtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Dec 2013 17:49:13 -0500
Message-ID: <1386456552.2195.52.camel@jtkirshe-mobl> (sfid-20131207_234934_191095_6287DAAF)
Subject: Re: [net] nfc: Fix FSF address in file headers
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Date: Sat, 07 Dec 2013 14:49:12 -0800
In-Reply-To: <52A39F18.8080202@broadcom.com>
References: <1386348976-24657-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <52A39F18.8080202@broadcom.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Vz1sHFsJRGWXg7jAbnb4"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Vz1sHFsJRGWXg7jAbnb4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-12-07 at 23:20 +0100, Arend van Spriel wrote:
> On 12/06/2013 05:56 PM, Jeff Kirsher wrote:
> > Several files refer to an old address for the Free Software Foundation
> > in the file header comment.  Resolve by replacing the address with
> > the URL<http://www.gnu.org/licenses/>  so that we do not have to keep
> > updating the header comments anytime the address changes.
>=20
> This seems to pop up from time to time and unfortunately the resolution=
=20
> seems not consistent at those times. Why not simply refer to the full=20
> license text that is in the COPYING file in the tree itself.

I, personally have only had one request in the last 10 years to change
our Intel Wired Ethernet headers and that was because the address
changed.  I am open to suggestions, although when I proposed either
updating the address to the current address or use the URL on LKML and
netdev, the response I got was to update to the use the URL.

I guess the only argument I would have against referring to the COPYING
in the tree itself is that the headers already state:

You should have received a copy of the GNU General Public License along
with this program;

(which refers to the COPYING file) and then it states...

if not, write to the Free Software Foundation, Inc.,
51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.

This is the second part that needs cleanup if the file refers to the old
address.  So just by removing the address and providing the URL, you are
providing a place that users can get the license *if* the COPYING file
gets removed (or altered) by who ever releases the kernel.

>=20
> > CC:linux-wireless@vger.kernel.org
> > CC: Lauro Ramos Venancio<lauro.venancio@openbossa.org>
> > CC: Aloisio Almeida Jr<aloisio.almeida@openbossa.org>
> > CC: Samuel Ortiz<sameo@linux.intel.com>
> > Signed-off-by: Jeff Kirsher<jeffrey.t.kirsher@intel.com>
>=20



--=-Vz1sHFsJRGWXg7jAbnb4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSo6XoAAoJEOVv75VaS+3O4YUP/18Mc/6st455/udZtCQMnEFz
48/GMJzGiCAkAj4nazdW6qs1KvEvCWr+5NdHAkkJZvVJ/nEjNITQoUm4biMaHmXH
7DpuUGd6jaM4g0VqRDPIByZLuq9QnJlLHd6ownD43pKD7BqrOhZ55M/MCLoY/ni/
/basVoDo0mgMYWhAqhYkcbkzG3ckOtkPzbIdiTL8H5muojnl94NU9zz3qiBK3iyE
zT/L1DAYKbXJv4TNImadWL92zD8pW8qOS208xDEEd6RbCkbpJ/ilODSCg0E8Qb2k
HBGOjU84u1REXv1rbEuo5jQua2cKVX+K2IKSkTgg9pckuoSuAL+zbTzPMHA5o2gT
1cK3tAa0OVef2AfshjtqBj4EYaKn/i8wwCz/9HfIhIuDsb/BmDoUCPx3bo1l7nlp
4ifSoesp88gCXE7HpvL6KFWYDLSrRJGmzCxAqIP7myDaYDp6Er1TG16+/Va13U5y
YfD/PP2JgEvFuzUkIR9Rvzjf1aHHgufrTjRlSEBl4e2+FauKneWtCgV07FowEOt2
EQ0ojCbakY9egSloYoVYS+P8Q2bLQECuru9zjRvbrVOWX0pocqwFBrtmsjcNqc4n
jIpqD7aoZScm4a7icEo7GdVAVQjMPhYzCvJmlsDd7gpeyKL5J9YsHtFUskYq0c+E
b/jAethmdmsm2NEBLR22
=fHP+
-----END PGP SIGNATURE-----

--=-Vz1sHFsJRGWXg7jAbnb4--

