Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8C7C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 039BC2075C
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfCKPB6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:01:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35618 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfCKPB6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 11:01:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id t18so5474744wrx.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 08:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XzItXpW86jH2iwYjPku79dl5XcRneCM/ibHYnS38h6g=;
        b=I/QBK9BXVvrQkIUwm9rdSEpXs7JyEmffqSsaqAmxBEUEm+6rPBgmilXrgPsrESv6dm
         /F+zCJpRav2cgQw0HrWtEbX1y5g60oB7A1mMzzSngvwlLX4XtxrVc/DsZ0DJPWwioxgk
         qi2NySqzMq0UdY5QJSLpWMZfZavoTNrxv5Z2r0qdYqsGid9pD+jfl2N5pplylR9ITtyL
         3fMnEny/8T2rN+QcYQKaPL8hpspt8dc7CUdpC8vXXxuSdzo75guFGTbVXwWI9hxeRCSY
         EbBc4tuM+vqJzMJcewqyw8C2aeHTk8oZQX873uhoFzFWM4Hvv9srPil2YBcY4mVlvVhg
         Sq/g==
X-Gm-Message-State: APjAAAXtae61QJ2kjU5iQwOQ3L+GrUGbtfphdj0MdvjUaYjyhR1e9aIt
        SfS/T/+Nv1c329vofSklw1fjkA==
X-Google-Smtp-Source: APXvYqxYXhc570CFsbHwMwCuLKLQTAFESuBNmkOObpabf0CAN5SCs2PokBwsxJhyQ38+woakUYjsHw==
X-Received: by 2002:a5d:6ace:: with SMTP id u14mr16335105wrw.240.1552316511499;
        Mon, 11 Mar 2019 08:01:51 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v2sm26584393wme.29.2019.03.11.08.01.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 08:01:50 -0700 (PDT)
Date:   Mon, 11 Mar 2019 16:01:45 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] mt76: mmio: move mt76_insert_hdr_pad in
 mt76_dma_tx_queue_skb
Message-ID: <20190311150144.GA1066@localhost.localdomain>
References: <cover.1552306908.git.lorenzo@kernel.org>
 <e03a38968b3bca0a51a832bdb0dd9ff1beff314d.1552306908.git.lorenzo@kernel.org>
 <20190311133954.GD6089@redhat.com>
 <20190311142517.GB30882@localhost.localdomain>
 <20190311145852.GF6089@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20190311145852.GF6089@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Mar 11, 2019 at 03:25:18PM +0100, Lorenzo Bianconi wrote:
> > On Mar 11, Stanislaw Gruszka wrote:
> > > On Mon, Mar 11, 2019 at 01:35:24PM +0100, Lorenzo Bianconi wrote:
> > > > Introduce tx_aligned4_skbs in mt76_driver_ops and move
> > > > mt76_insert_hdr_pad in mt76_dma_tx_queue_skb. This is a preliminary
> > > > patch in order to unify tx dma mapping for mt76x02 and new chipsets
> > > >=20
> > > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  drivers/net/wireless/mediatek/mt76/dma.c          |  3 +++
> > > >  drivers/net/wireless/mediatek/mt76/mt76.h         |  1 +
> > > >  drivers/net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
> > > >  drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 13 +++++------=
--
> > > >  drivers/net/wireless/mediatek/mt76/mt76x2/pci.c   |  1 +
> > > >  5 files changed, 11 insertions(+), 8 deletions(-)
> > > >=20
> > > > diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net=
/wireless/mediatek/mt76/dma.c
> > > > index a66832a02281..14dd6585bab4 100644
> > > > --- a/drivers/net/wireless/mediatek/mt76/dma.c
> > > > +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> > > > @@ -300,6 +300,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enu=
m mt76_txq_id qid,
> > > >  	}
> > > > =20
> > > >  	skb->prev =3D skb->next =3D NULL;
> > > > +	if (dev->drv->tx_aligned4_skbs)
> > > > +		mt76_insert_hdr_pad(skb);
> > >=20
> > > We need 4 bytes aligned skbs for mt76x02 or we just need header
> > > lenght be multiple of 4 ? =20
> >=20
> > I think IV/LLC should be 4 byte aligned
>=20
> mt76_insert_hdr_pad() does not change alignment of IV/LLC , it only
> moves header.
>=20
> I'm not sure what is actually needed (4 bytes alignment or 4 bytes
> lenght), but I just saw Felix sent 2 mac80211 patches that hopfully
> do the right thing, so this code after appling mac80211 changes
> and set TX_NEEDS_ALIGNED4_SKBS can be removed.

this is the plan :)

Regards,
Lorenzo

>=20
> Stanislaw
>=20

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXIZ4UQAKCRA6cBh0uS2t
rHeGAQCYcj3gjA9uxW7RvLUKe5iM+FlesN4TUFVoTg61FyzQ6gEAjQUtKxvUm0JJ
/tPgo1mAol/B+TVnH6WoRQuY7QhMcQQ=
=rKlC
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
