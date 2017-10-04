Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:57996 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdJDKLu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 06:11:50 -0400
Date: Wed, 4 Oct 2017 12:11:45 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Icenowy Zheng <icenowy@aosc.io>, Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 1/2] dt-bindings: add device tree binding for
 Allwinner XR819 SDIO Wi-Fi
Message-ID: <20171004101145.kgjufpcktodppuy3@flea> (sfid-20171004_121222_134025_E380B8C8)
References: <20171003165944.13056-1-icenowy@aosc.io>
 <20171003165944.13056-2-icenowy@aosc.io>
 <871smjxp46.fsf@kamboji.qca.qualcomm.com>
 <E46F3A20-294A-497E-AF71-C77A67AFDB8C@aosc.io>
 <59D4B1C8.8020105@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="z5ahan4c2wuj2t6k"
In-Reply-To: <59D4B1C8.8020105@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--z5ahan4c2wuj2t6k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2017 at 10:02:48AM +0000, Arend van Spriel wrote:
> On 10/4/2017 11:03 AM, Icenowy Zheng wrote:
> >=20
> >=20
> > =E4=BA=8E 2017=E5=B9=B410=E6=9C=884=E6=97=A5 GMT+08:00 =E4=B8=8B=E5=8D=
=885:02:17, Kalle Valo <kvalo@codeaurora.org> =E5=86=99=E5=88=B0:
> > > Icenowy Zheng <icenowy@aosc.io> writes:
> > >=20
> > > > Allwinner XR819 is a SDIO Wi-Fi chip, which has the functionality to
> > > use
> > > > an out-of-band interrupt pin instead of SDIO in-band interrupt.
> > > >=20
> > > > Add the device tree binding of this chip, in order to make it
> > > possible
> > > > to add this interrupt pin to device trees.
> > > >=20
> > > > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > > > Acked-by: Rob Herring <robh@kernel.org>
> > > > ---
> > > > Changes in v3:
> > > > - Renames the node name.
> > > > - Adds ACK from Rob.
> > > > Changes in v2:
> > > > - Removed status property in example.
> > > > - Added required property reg.
> > > >=20
> > > >   .../bindings/net/wireless/allwinner,xr819.txt      | 38
> > > ++++++++++++++++++++++
> > > >   1 file changed, 38 insertions(+)
> > > >   create mode 100644
> > > Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
> > >=20
> > > Like I asked already last time, AFAICS there is no upstream xr819
> > > wireless driver in drivers/net/wireless directory. Do we still accept
> > > bindings like this for out-of-tree drivers?
> >=20
> > See esp8089.
> >=20
> > There's also no in-tree driver for it.
>=20
> The question is whether we should. The above might be a precedent, but it
> may not necessarily be the way to go. The commit message for esp8089 seems
> to hint that there is intent to have an in-tree driver:
>=20
> """
>     Note that at this point there only is an out of tree driver for this
>     hardware, there is no clear timeline / path for merging this. Still
>     I believe it would be good to specify the binding for this in tree
>     now, so that any future migration to an in tree driver will not cause
>     compatiblity issues.
>=20
>     Cc: Icenowy Zheng <icenowy@aosc.xyz>
>     Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>     Signed-off-by: Rob Herring <robh@kernel.org>
> """
>=20
> Regardless the bindings are in principle independent of the kernel and ju=
st
> describing hardware. I think there have been discussions to move the
> bindings to their own repository, but apparently it was decided otherwise.

Yeah, I guess especially how it could be merged with the cw1200 driver
would be very relevant to that commit log.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--z5ahan4c2wuj2t6k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZ1LPhAAoJEBx+YmzsjxAg2YUQAJMxy9OzeXuAwzmK4xUR24Jo
Qa/0A+F6F6LzksbVJKLywrRFSEsJ6i++SUzZYygz6jMwwQl7OApg4Dj/qd+2jK/Q
LpgzeyXzgkcpOz2SHGeZZGiGn4YHVt/o1xSEkp2TWarL0iJ1Ckyt51Rs/fq2suoE
qJr/dgyIDR3ZW3ek2Z2JcANCJ3y0q4KdD9lYCiB9ZBSHDs02ksleD5K/7gBArX7B
tk+j+RK6r4A+UhnIC4T1GjWmcJRIkqAjjuaxFE4cFuKa2UvT2yKfoty9KHGfjgrU
Sd71nqBe654ADx3f7nAgH3RehgNlY+JV/2LAW0WWCv+vgB4rFlMZicKNm1XQXFsZ
/qM++w6bzAVyfiRXosOVtBOx7ocTHA2gNkyZT/Eh7PMn9Yt6ftMROL98S23eaXhE
ONjFoIt6HyCU+wu5Kka1L9YizE0dHT4l/hBu4m3j7OEgZaTg+wJflDlNvemuA/AD
jdOcM85UJM1azqjO7MmaaCF8UKQYgAHfiyh3j8vhPNjJ4TvNaMXri622a2ZojWJE
aj0Za2DzNmHSwrlU9CuItNS6WSwphtH3t65LLi/2uxsZUOr0hYdV5uNE1A1n6g1X
m9YAaDshKu4fBYpT9c9guWrET18OKcgxq+SZT3WrXgriVqYtEB6dxEe/gbp9c+lW
mJZBjzQkNFJepMq8fggE
=FjDQ
-----END PGP SIGNATURE-----

--z5ahan4c2wuj2t6k--
