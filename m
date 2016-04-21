Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:54681 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbcDUSJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 14:09:29 -0400
From: Maximilian Engelhardt <engelhardt@perisens.de>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	maxi@daemonizer.de
Subject: Re: wireless-regdb: Update regulatory rules for Germany (DE) on 5GHz
Date: Thu, 21 Apr 2016 20:08:46 +0200
Message-ID: <2919568.ssjlN6KUVX@perisens15> (sfid-20160421_200934_868587_705A2CD1)
In-Reply-To: <20160421131938.GA95003@ubuntu-hedt>
References: <1958820.LBuzOElZFT@perisens15> <20160421131938.GA95003@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3059911.tYIIAVPGIC"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart3059911.tYIIAVPGIC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Thursday 21 April 2016 08:19:38 Seth Forshee wrote:
> On Tue, Apr 19, 2016 at 08:03:16PM +0200, Maximilian Engelhardt wrote=
:
> > Hi,
> >=20
> > In Europe ETSI standardized the used for short range devices (SRD) =
[1] in
> > ETSI EN 300 440-1 [2].
> > According to this standard generic use equipment is allowed to tran=
smit in
> > the frequency range form 5725 MHz to 5875 MHz with a maximum output=
 power
> > of 25 mW e.i.r.p. This generic allocation also allows transmission =
of
> > 802.11 devices.
> >=20
> > [3] has a list of countries and their status about the implementati=
on of
> > the SRD frequency bands. For the 5 GHz band this can be seen on pag=
e 38
> > in the paragraph ANNEX 1 and the entry Annex j.
> >=20
> > Attached is a patch that adds the 5 GHz SRD band to db.txt for Germ=
any.
> >=20
> > If it is acceptable I can provide a patch adding the 5 GHz SRD band=
 for
> > the
> > other countries listed in [3].
>=20
> The changes seem okay as far as I can tell. You do need to include yo=
ur
> signed-off-by tag on the patch however, see
> https://git.kernel.org/cgit/linux/kernel/git/sforshee/wireless-regdb.=
git/tre
> e/CONTRIBUTING.
>=20
> Thanks,
> Seth

Hi Seth,

Thanks for your reply. You can find my signed-off-by tag below together=
 with=20
the unchanged patch.

I can affirm I did check this carefully with the official documents of =
the=20
German administration for radio equipment (Bundesnetzagentur f=FCr Elek=
trizit=E4t,=20
Gas, Telekommunikation, Post und Eisenbahnen).

I noticed that the links to the other entries for Germany are broken, a=
s the=20
website design was changed and thus all old link became non functional.=
 I can=20
provide a patch fixing this if it is something that's considered useful=
.


The comments to my initial mail indicated that the statement in the ERC=
=20
recommendation I linked are alone not enough to add this frequency rang=
es for=20
other countries. Unfortunately I don't have the possibility to do these=
 checks=20
for countries other than Germany.

If there is anything I can do to help adding the SRD entries for more=20=

countries please let me know.

Thanks,
Maxi


Signed-off-by: Maximilian Engelhardt <engelhardt@perisens.de>
=2D-

diff --git a/db.txt b/db.txt
index e9ba21a..38a9340 100644
=2D-- a/db.txt
+++ b/db.txt
@@ -319,6 +319,9 @@ country CZ: DFS-ETSI
 # limit is used here as the non-interference with radar and satellite
 # apps relies on the attenuation by the building walls only in the
 # absence of DFS; the neighbour countries have 100mW limit here as wel=
l.
+# The ETSI EN 300 440-1 standard for short range devices in the 5 GHz =
band has
+# been implemented in Germany:
+# https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete=
/Telekommunikation/Unternehmen_Institutionen/Frequenzen/Allgemeinzuteil=
ungen/2014_69_SRD_pdf.pdf
=20
 country DE: DFS-ETSI
        # entries 279004 and 280006
@@ -329,6 +332,8 @@ country DE: DFS-ETSI
        (5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
        # entries 308002, 309001 and 310003
        (5470 - 5725 @ 160), (500 mW), DFS
+       # short range devices (ETSI EN 300 440-1)
+       (5725 - 5875 @ 80), (25 mW)
        # 60 GHz band channels 1-4, ref: Etsi En 302 567
        (57000 - 66000 @ 2160), (40)

--nextPart3059911.tYIIAVPGIC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXGRczAAoJECiijTBlkGWFOlIP/0Rg0wy2tG2v4dxNgBDkp+CX
GxMpfyqVpXrh+7Uq+FewpnKe7yTFV+8B82T2Vo4rVy/As345FkYO1ghvxMccF3+9
O2BnslVybQqb9AB6vre3kYz0/RadjoGb07W1qHUFhvfCOk8nQxK/7oAc0zWcXobu
Osd7imuu9PXHOmrC1xh11WPYDWsab4jd+7i5iRLczyKs3FO/Hbs4SL7UagoGpEc9
vchj7HlGdvVIhL1MyVOkXYlP7jNo4VZqAnp77GPG0iS2rTEBg+rzLgzp19WSwD+g
uwdFE6AUX5PTPD+ESP1zUV/P0P6qULZt0UwUc/+k2yf+TkXVAiRHgcNsuElV+0dp
Oce2FUPI35AU8hjfccMQL0UroKYQ7RcfxaYkqTFvq74/ZGvDwbCpkRCfsPyqvSOb
6DCpw1EVHZUX5ynZvAAmTx1gZhVX1OduPVA8DCvLzJkRvgJK5sNfM7A+fNEw2bXd
jAamuz7lQp/yn6VIakI3/I1exQALEIJ7M8qCdOZaRCWE9/UyrD4SP4KZLKV+zH96
0e8NnE6erp5wSop/TY01kyEF4r0DjwX4wjQZEBcQ4HB5FlCRBVQHQTBA4ERYVHP4
jkIcdU66HdrsOgLep+SAweUHc04F1AlZvM9Ehlkm98ngGKLUxSeb9uuTYBg/l6hk
ifUt7+FJJ2Xx9ZxwtOMo
=n+kg
-----END PGP SIGNATURE-----

--nextPart3059911.tYIIAVPGIC--

