Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:59160
        "EHLO stuffed.shaftnet.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1033208AbeBOUDJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 15:03:09 -0500
Date: Thu, 15 Feb 2018 14:05:41 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Iago Abal <iago.abal@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Potential deadlock BUG in drivers/net/wireless/st/cw1200/sta.c
 (Linux 4.9)
Message-ID: <20180215190541.GA27044@shaftnet.org> (sfid-20180215_210333_375097_E103C549)
References: <CAGbDTvrA85Qao_y0FxCFR_cE26WejoLLrA=PA1qhTButiDp3xg@mail.gmail.com>
 <CAGbDTvrfrm5kuWL3SqeDGxyBXYbCyAV0ukah-CNsGqW0ueia3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
In-Reply-To: <CAGbDTvrfrm5kuWL3SqeDGxyBXYbCyAV0ukah-CNsGqW0ueia3w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 06, 2018 at 09:04:29PM +0100, Iago Abal wrote:
> This still looks like a deadlock bug to me, could someone take a look
> as well and confirm? I will help preparing a patch if needed.

The short answer:  yes, it deadlocks.

I'll be glad to review patches (this code is pretty tricky, but I=20
believe the deadlock got introduced/exposed by different code changes)
but unfortunately my last move killed the hardware capable of=20
accepting my SDIO CW1200 dongles.

Hmm, might be worth trolling ebay or something.

 - Solomon
--=20
Solomon Peachy			       pizza at shaftnet dot org
Coconut Creek, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum videtur.

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQR2UQuVfi4HbxEN7SQ+4uCKLbvn0AUCWoXaBAAKCRA+4uCKLbvn
0GnOAKDm3jlaBNkVyhwF/Sv2jaRhUFky8wCfTKBIRJXFSpNNbn0O8yY2DSXYK98=
=3HKl
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
