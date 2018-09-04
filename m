Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:35932 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbeIDQln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:41:43 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 9/9] mac80211: Don't wake up from PS for offchannel TX
Date: Tue, 04 Sep 2018 14:16:47 +0200
Message-ID: <2707426.UKz2r40yDP@bentobox> (sfid-20180904_141652_270747_8AD939E6)
In-Reply-To: <8536772.7SmJXvWjMu@bentobox>
References: <20180831083130.15525-1-luca@coelho.fi> <20180904114055.1429-10-luca@coelho.fi> <8536772.7SmJXvWjMu@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7317677.BvZNnZgmtP"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart7317677.BvZNnZgmtP
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Dienstag, 4. September 2018 14:07:54 CEST Sven Eckelmann wrote:
> On Dienstag, 4. September 2018 14:40:55 CEST Luca Coelho wrote:
> > )
> > Sender: linux-wireless-owner@vger.kernel.org
> > Precedence: bulk
> > List-ID: <linux-wireless.vger.kernel.org>
> > X-Mailing-List: linux-wireless@vger.kernel.org
> 
> Looks like the SMTP headers are broken in all your patches. Here the 
> interesting part (as received by me):

I meant mail headers.

>     [...]
>     X-SA-Exim-Scanned: Yes (on 
>     
>     )
>     Sender: linux-wireless-owner@vger.kernel.org
>     Precedence: bulk
>     List-ID: <linux-wireless.vger.kernel.org>
>     X-Mailing-List: linux-wireless@vger.kernel.org

And just as additional info which I forgot: My mail setup is exim free. So 
they were not added by me.

The only exim in the path seems to be:

    Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
            by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
            (Exim 4.91)
            (envelope-from <luca@coelho.fi>)
            id 1fx9hf-00085m-4i; Tue, 04 Sep 2018 14:41:03 +0300

But as Johannes pointed out, they look fine on patch 1-3.

    [...]
    X-SA-Exim-Scanned: Yes (on farmhouse.coelho.fi)
    Sender: linux-wireless-owner@vger.kernel.org
    Precedence: bulk
    List-ID: <linux-wireless.vger.kernel.org>
    X-Mailing-List: linux-wireless@vger.kernel.org

Kind regards,
	Sven
--nextPart7317677.BvZNnZgmtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAluOd68ACgkQXYcKB8Em
e0bWaw//UUcQyb3h9USNcdpACwKFKtR1G6Ybzzx13OPdxvjdyqQcmDO7T4YzpdUu
gQsW1PaMCwcgfMpmWC2e3+k4Esqw9CNEloyCikRzkNptPu6Ueo7iNfK+ohHtukRA
/OL3NC9My4ix+vhTJriennHxa7v7U5UzWneNsLasNJmG96kvj28ZjLCOE6uC6srZ
fT67IMWxLGm1e2qXrlVG9zDu6RhNpn5K+/RWhU8XX1lJPNTNzHqubOnKK+q7+QVr
ERStGSgivBHj0xmjcOyMM+MyRH1wQn3a/hvqk36hObS7O8PPcVbtCeaL4lCI2/j4
BHaqqP4QqBs1pLAJrl+wQkccwOVEzG/QbvNWKg8Wk/vq9Tb4lvtuiCx6UiWlGSjj
2WpzBuQobcwl8u5HFg9ayxWCqCV4aHJ27pb8OLLkThIn8idhe022rjjTuydzaRdV
JnQdMWkYOxoGr9r1HFDqZGmcLWZwOBOQTyzCKb7gZTSmXuT9J5AZqsw74dyZMKlC
0i4AMSXeAnRfLvgG5ynyDWiz8km/zUAInExvjZxzhybUQOzKaxUsOJERdvMSVA6G
LAnIVxa8hES5ROORY4sRGKY2k50RPruNNyqp79ttblPoeTH3gc8ZnD0YNf6oVKxd
dOD2aJQnKOkc+R/rgWSi1FCJDmJgv/ebkWfMeAOYPkAdh76hbwY=
=YmqE
-----END PGP SIGNATURE-----

--nextPart7317677.BvZNnZgmtP--
