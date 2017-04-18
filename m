Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:39816 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932559AbdDRKkZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 06:40:25 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Xuebing Wang <xbing6@gmail.com>
Cc: Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Subject: Re: [B.A.T.M.A.N.] [batman-adv] Does batman-adv works perfectly?
Date: Tue, 18 Apr 2017 12:40:16 +0200
Message-ID: <3124220.7tTabXjFJx@prime> (sfid-20170418_124046_982262_761AB5A8)
In-Reply-To: <CAG5qQ7hQACaP=vz6jmvWDXoK=Sn0wpE3DrDhJv8Qajnhjbp+Og@mail.gmail.com>
References: <9309484e-a9c2-0476-3ddf-a2d68a51c58e@gmail.com> <2383073.8lvV2lGcs0@bentobox> <CAG5qQ7hQACaP=vz6jmvWDXoK=Sn0wpE3DrDhJv8Qajnhjbp+Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2013281.P7vq0RacnL"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2013281.P7vq0RacnL
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Xuebing,

I didn't try the QSDK on those devices, mainly because of its poor upstream 
support/community involvement. We tried it on other devices, with "mixed" 
results.

Cheers,
      Simon

On Monday, April 17, 2017 10:19:02 PM CEST Xuebing Wang wrote:
> Hi Sven and Simon,
> 
> Thank you very much for your help. I am curious that did you try QCA-WiFi
> driver for ath9k device (like AR9331) + OpenWRT, instead of trying to
> improve ath9k driver?
> 
> QCA-WiFi driver included in QSDK:
> https://www.codeaurora.org/projects/all-active-projects/qsdk
> 
> Thanks.
> Xuebing Wang
> 
> On Thu, Apr 6, 2017 at 3:13 PM, Sven Eckelmann <sven@narfation.org> wrote:
> > On Donnerstag, 6. April 2017 09:04:50 CEST Simon Wunderlich wrote:
> > > Hello Xuebing,
> > > 
> > > it sounds like you have WiFi driver issues. There are some effects like
> > 
> > key
> > 
> > > cache corruption, deafness, and other effects known for the AR93xx
> > 
> > series.
> > 
> > Correct, completely forgot about the deaf and 0xdeadbeef issues. There
> > were
> > also two workarounds for them [1,2] from Simon.
> > 
> > Kind regards,
> > 
> >         Sven
> > 
> > [1] https://patchwork.kernel.org/patch/9433619/
> > [2] https://patchwork.kernel.org/patch/9433621/


--nextPart2013281.P7vq0RacnL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlj17RAACgkQoSvjmEKS
nqESZA//bcDia8YmEDR5pdiIgyGNnf1n+PEzYLd9EIIElsONnvVti7hn8t/OAG7i
PxdK+0dojCetUcNM6928ffs6tHSj+kiyTTVQQF8nGODmiFNVPNzQUHiuFxRbUV7Q
onwkMM/MmJPWy1XMUfdr/Z00pYn11WBH5PftTlyLU0fZaFQ110w49ADnhXyMnAU2
CPLnLJUteU5lIrq5AnkWUCDVurYNqTZEpzrL45NiZoVhcw0dydY9kYV9a3F21uiI
wZ0MWdFPet8LA4MF3L0oPkycfLxlb5x1BPaFubvaXLEqtUBrmGygewq8XwEAr0EY
zb2pykGkoWDeZNeGYc8J42u5NavPb2EqzpGusTIH3vvdQXT9mp8J6hghe449sWWj
/s7xx74xzKC9gXcO10YoQOwfTvvbQ0xAVV99ee31ySsetkdUTKISuJxTLp2/uc/l
jPClgUSzy3PLGhhZ50TRfKbSaYm90peBcNGnBNqBBE2mGe4EAYzS66tyihpi33rt
hgJ8Md5KpsmvQTYPbrb36UsNRhWNYRV2nSQ98+vWhi2YC+dyD7H8/AmnVH+apWFB
c+EP1jQ60PV1l9nfQAQMj4VaXhBpmRDjp/Zp1bUaZw15iSioeq+GsX5WpDQTnTTm
2Rd84tpRK/uU6fQt/aCzns/EGMiDan7c1/AsgCx1vjgvwrlEz7U=
=mFCG
-----END PGP SIGNATURE-----

--nextPart2013281.P7vq0RacnL--
