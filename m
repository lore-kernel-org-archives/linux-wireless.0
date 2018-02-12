Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.150.225]:33132 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbeBLP2v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 10:28:51 -0500
Date: Mon, 12 Feb 2018 15:22:32 +0000
From: James Hogan <james.hogan@mips.com>
To: <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>
CC: Adric Blake <promarbler14@gmail.com>, <m@bues.ch>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: B43 driver no longer works in Linux 4.15 (bisected)
Message-ID: <20180212152231.GK11819@jhogan-linux.mipstec.com> (sfid-20180212_162949_631394_F146F9D9)
References: <CAE1jjefE1qjgcHMik36Na0OYoFON+kCi5cEDSq=y11HdsyPn0Q@mail.gmail.com>
 <20180205183324.GD8479@saruman>
 <87sha68cv9.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lZZ4ablUVnt2XgAh"
In-Reply-To: <87sha68cv9.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--lZZ4ablUVnt2XgAh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 12, 2018 at 05:08:10PM +0200, Kalle Valo wrote:
> James Hogan <jhogan@kernel.org> writes:
> > On Mon, Feb 05, 2018 at 01:23:31PM -0500, Adric Blake wrote:
> >> I bisected to this "first bad commit:"
> >>=20
> >> commit 58eae1416b804d900014d84feadda7195007cc30
> >> Author: James Hogan <jhogan@kernel.org>
> >> Date:   Mon Jan 15 21:17:14 2018 +0000
> >>=20
> >>     ssb: Disable PCI host for PCI_DRIVERS_GENERIC
> >
> > Yes, really sorry about that and thanks for going to the effort of
> > bisecting. There is a patch here:
> > https://patchwork.kernel.org/patch/10185397/
> >
> > which is applied to linux-next as commit
> > a9e6d44ddeccd3522670e641f1ed9b068e746ff7, and is tagged for stable,
> > though I've just noticed the stable email address is incorrect... I'll
> > make sure it gets applied to the 4.15 stable branch though as soon as
> > I notice its merged.
>=20
> The commit is now in v4.16-rc1.

Yes, thanks,

Greg: Please can commit a9e6d44ddeccd3522670e641f1ed9b068e746ff7 ("ssb:
Do not disable PCI host on non-Mips") be applied to 4.15 stable (the
wrong stable email address was Cc'd in the commit message).

Thanks
James

--lZZ4ablUVnt2XgAh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAlqBsTEACgkQbAtpk944
dnoW7g/7BauajOVfRAoPO4fV0Jq9YkV0rKzOVfBHfL8IwQA4O12BHRupdIXNfe8t
pdni0H560mHlhlX3FIl6kXZGQNMDAQpAyErsW7vFkk2/SJWrP1gEMQImPMgROdKp
mCVIv2iOtIke106hAdR8YaGyBE4iUefNpjYkuYimnTEI1DvgweDWUrMUuejg/6LO
fEiKvikaBEG7W/XivabTvPn/BBcRRnle2LtVH4PcXkvecX+6DCDu/wcSVfBceRAQ
1wdhPB9a2pPcg+seCMgvAOnHWqTYr6eGQOjuRCUIBcHJ+PTi1pNU8jn07PntjZ6D
YyvFX4ebCPogVfOtUJ/tz3IR2s24LDlpylXPysBhaDWNgkyggpmpiObfO6hlfagL
1ohbZbCMunS3vmE/dwn3lsiVLu90srvP7i4+8SU1IkI24RPpcyUEjZ0nVyB25+qj
ivEEe3rhNDaigESKBdkPYSoReVT+NE58lwT/7IIn606A4PkEVIgucxhA+P/gKe9s
Ef6Es6DHjnQ1tUmitCBUZc2vHSMEty7xx4mtu4If+XlBjbilX/Cz9xOLRdK/irAh
k//xovujDYCiAKKJZRINhmE3ltTWY1tyaWsGm6fNUCCQ4XsgK8AGHtbdDVkm12Oh
6zdFpbM7Rw4nWYZycTu4TF9xyFwP92PU3DTSLTXxcLQ9NQq8ZRs=
=eg0W
-----END PGP SIGNATURE-----

--lZZ4ablUVnt2XgAh--
