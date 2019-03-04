Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32961C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 11:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C70520815
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 11:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfCDLI5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 06:08:57 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41799 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfCDLIz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 06:08:55 -0500
Received: by mail-wr1-f68.google.com with SMTP id n2so5049324wrw.8
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2019 03:08:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o8Ha0s7UoQ4EHRWn1GRFEUKB9x6oHfhXl3JWjB3Y4wg=;
        b=jL/y3rjmKFjODxgEgpaFrid+pdrYiuGdNsmgGoKYsmWi/lDrlRwD4AIVYCZzIpaWQX
         h1rvv2yOSqMRFfNAMFwoCayIpwWvOcROM5Qbilt2Z+TTmcPZ8zCG1gjr56gqjLkF+MI9
         btt4d9leXoSEuHmUlMQ3sjvrygPiji6FffrwRl2WKHMg/UzX3LbrsBwgGd4Pd5dQXMwd
         KEeRCMuhWvQ23N0W48gPgpdzxVZv5O0vXboO0Q8NEAzBPgBG+2BUOSpwSIftm/Ad6JPZ
         SUgcTTStGQdigmzAZfp83t3qIi3YakjU9lJwoWrAJWMUUN8JGH17zHcVMiaHp9cMmkqs
         px/A==
X-Gm-Message-State: APjAAAVj74dQyBU640qiQ5HA28yvS7RjhG4nfKk3BVq/FMknQbUrx3bG
        JrwYqm6ovCx8fV16rFAcRTNqzQ==
X-Google-Smtp-Source: APXvYqyr/FSAo7QhBm2AYUsh8uflHmKRnXmJ6/zjziJ0JYc3joLH4Y8JajSbyNwG5vDC/VNlJLAPeA==
X-Received: by 2002:adf:de83:: with SMTP id w3mr11862109wrl.56.1551697733181;
        Mon, 04 Mar 2019 03:08:53 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id w4sm11208973wmg.8.2019.03.04.03.08.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Mar 2019 03:08:52 -0800 (PST)
Date:   Mon, 4 Mar 2019 12:08:48 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/11] mt76x02: enable AP mode for USB
Message-ID: <20190304110847.GC3073@localhost.localdomain>
References: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
 <1551692896-7062-12-git-send-email-sgruszka@redhat.com>
 <20190304105506.GB3073@localhost.localdomain>
 <20190304110427.GA2008@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hYooF8G/hrfVAmum"
Content-Disposition: inline
In-Reply-To: <20190304110427.GA2008@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--hYooF8G/hrfVAmum
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mar 04, Stanislaw Gruszka wrote:
> On Mon, Mar 04, 2019 at 11:55:07AM +0100, Lorenzo Bianconi wrote:
> > > Enable AP mode. For now without multi-vif support, this will require
> > > more testing and investigation.
> > >=20
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > ---
> > >  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/driv=
ers/net/wireless/mediatek/mt76/mt76x02_util.c
> > > index 38997076cb03..99c729f6701d 100644
> > > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > > @@ -142,6 +142,7 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
> > > =20
> > >  	wiphy->interface_modes =3D
> > >  		BIT(NL80211_IFTYPE_STATION) |
> > > +		BIT(NL80211_IFTYPE_AP) |
> > >  #ifdef CONFIG_MAC80211_MESH
> > >  		BIT(NL80211_IFTYPE_MESH_POINT) |
> >=20
> > I think we need to disable DFS channels for the moment (for mt76x{0,2}u=
) since
> > dfs is not supported yet
>=20
> How this should be done ? Is sufficient to check IEEE80211_CHAN_RADAR
> and mt76_is_usb() on set channel end return -EINVAL error ? Or different
> way ?

Re-reading my email I was not so clear, sorry. I mean we need to clear
radar_detect_widths for mt76_usb or as suggested by Felix to have a new
iface_combinations for mt76_usb where we do not set radar_detect_widths

Regards,
Lorenzo

>=20
> Stanislaw
>=20
>=20

--hYooF8G/hrfVAmum
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXH0HPQAKCRA6cBh0uS2t
rCBdAP9+ZqzFC+/HOcezFQuEskhwLqyvaCsqkJquSKwNOywYAAEAxm6AnjpQh26R
E8NnUXH6wb84l3WeNif+gRfYdBBcdAs=
=bjlu
-----END PGP SIGNATURE-----

--hYooF8G/hrfVAmum--
