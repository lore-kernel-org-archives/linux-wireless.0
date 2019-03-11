Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B605C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19C2F20657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 15:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="QNiVP2pU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfCKP3G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:29:06 -0400
Received: from kadath.azazel.net ([81.187.231.250]:56280 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfCKP3G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 11:29:06 -0400
X-Greylist: delayed 2144 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2019 11:29:05 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Pp0hqpqjCslrSXAn8lZXFgNmAVElhkqozU+LNwwYcoc=; b=QNiVP2pUTlSijwO1C4VrvXh9GG
        viAE6J/OkOfgOJPMj52jzrhOQURsOKpePd7dDa35h5wwKuyol06DyuVsasCwrsnkf1UwNeALpBcmj
        o4NqzWpw/Q36o9bR0eItIUfDk6S4oxuY8l1HriccPPrK5mGuHCYEiTU/H3MTWknEAWvTt0QhTNFBq
        5RapNy8jAKyqzXSLARg7cCzufXpciqGq/F7/onbQRN8cMOtkZlZh7cbFiDOeQfm5AgeqHtvNfshOh
        aCXsERW3FXbXZFgQTORyTXpuNqiJqWT3K3feRSng3XULbuZZN12RbIOWGGA3Usv4z8T2BPLZo0MbD
        fnypGHXA==;
Received: from kadath.azazel.net ([2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1h3MID-0003PK-TU; Mon, 11 Mar 2019 14:52:41 +0000
Date:   Mon, 11 Mar 2019 14:52:40 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ga58taw@mytum.de, Julius Niedworok <julius.n@gmx.net>,
        linux-wireless@vger.kernel.org, david@redhat.com, nc@net.in.tum.de,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] mac80211: debugfs option to force TX status frames
Message-ID: <20190311145240.akms2pz2hxsalmaz@azazel.net>
References: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
 <20190306200206.60916-1-julius.n@gmx.net>
 <87k1hazo6r.fsf@purkki.adurom.net>
 <20190307193045.a7awwn6mycloccq5@mission-control>
 <87h8c98q4l.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4jlle5knlvfploax"
Content-Disposition: inline
In-Reply-To: <87h8c98q4l.fsf@codeaurora.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--4jlle5knlvfploax
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-03-11, at 16:03:38 +0200, Kalle Valo wrote:
> ga58taw@mytum.de writes:
> > On Thu, Mar 07, 2019 at 05:42:04PM +0200, Kalle Valo wrote:
> > > > +   len = scnprintf(buf, sizeof(buf), "%d\n",
> > > >                    (int)local->force_tx_status);
> > >
> > > I wonder about the cast, is it guaranteed that a bool is always of
> > > the same size as an int?
> >
> > Why is this a problem? If a bool is smaller than an int, the
> > compiler emits code that will prepend the value of force_tx_status
> > with zeros.
>
> Let's say that a bool is a byte and int is four bytes. If you use "%d"
> I would guess that in that case scnprintf() writes 4 bytes, meaning
> that 3 bytes will be overwriting either padding or some other field in
> the struct.

It's the value that matters, not the type.  It will only be too big for
the buffer if the result of casting local->force_tx_status to int is
less than -9 or greeater than 99.

  scnprintf(buf, size(buf), "%lld\n", (long long)local->force_tx_status)

would also be fine if the value were in range.  Note also that scnprintf
will not overrun the buffer: it will truncate the string.

> But I'm no compiler expert so I'm not going to argue about this
> anymore.  I just wanted to point out that that the cast looks
> dangerous and I would not do it.

As it happens, arguments to variadic functions are subject to the
"default argument promotions," so if local->force_tx_status is in fact a
bool (I can't find the definition), it would be promoted to int and the
cast is superfluous.

J.

--4jlle5knlvfploax
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAlyGdjcACgkQ0Z7UzfnX
9sMb1BAAsSESto65kU2vMM1odmXXphdjm3eCo+b7dJE6rHaaAB1IzY16XAGv1R1A
T7vVvm+5Ia1WFFnKNr8VnF1s4gIhzqPCAGqHSuERNyIQKcAAwSVtSZtHpGa+WjrD
qs/gfLXh7AkXQAePZG7p+KIvFVYa4ty94YonfEOE4MQlayUz1TdgwWnXezCk5i7d
89H/rcZbcSQ9osp3+qIDoOGLvZa+nKLCIOrD85LTpfDpYUC3lUetM1byPsudv+5A
HW7TGsbKOBnQLeIPx1o1DZUt0OX7pqlyrsO6K0XkBJHvGTFInP6MRenpDDPswXPn
O8JxtqJ2mwEKj0HKoInopvXesPYY5NrHqML6PlzY3O9j1Wd5rviA6r80Y4MW06kd
fQMoSKhK9nF6nNviaEXNmXCteryPlQTdAm5L05VmK2wiUJcza+ntF4yN6nEryq0a
kd17nFUl+LU0LliCRxFpLSBV6F31s26rUVy9BEqp3q74Yh7Sqg5l5N0ZHInrEc2D
XtJaTf5Nbyh7LHKiiiOpNMPzOD0pxixkmF8HU/2XW34uLl6ojXgvyiSE0EXrYdOM
AjN5dEtxFpnM1dv7cQDoHdNTqYpcDLnstcXuyHcWru4bTXXcrPrVok/tbnsQ5x5m
6Nlqd5G0pK0e2nigrCqBmigZxIPv4AVPRgDrlA/Sik96A9tbsq8=
=KvZy
-----END PGP SIGNATURE-----

--4jlle5knlvfploax--
