Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYFSUSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 16:18:49 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: 11d Handling - Country Information
	Element
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
In-Reply-To: <1ba2fa240806191316h3ca2044o407d094415fa5bf2@mail.gmail.com> (sfid-20080619_221640_296871_611940EE)
References: <1213900512-21565-1-git-send-email-tomas.winkler@intel.com>
	 <1213902216.8967.78.camel@johannes.berg>
	 <1ba2fa240806191316h3ca2044o407d094415fa5bf2@mail.gmail.com>
	 (sfid-20080619_221640_296871_611940EE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S9CbnBRMX5w7K2nV1FE2"
Date: Thu, 19 Jun 2008 22:18:08 +0200
Message-Id: <1213906688.8967.112.camel@johannes.berg> (sfid-20080619_221852_371695_B5C9E119)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S9CbnBRMX5w7K2nV1FE2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> +     if (country_ie_len < 6) {
> >> +             printk(KERN_ERR "%s: country information element shorter=
 (%d)"
> >> +                     " than expected.\n", __func__, country_ie_len);
> >
> > Remotely exploitable security bug.

> Please explain,

Sending broken frames will fill the disk.

johannes

--=-S9CbnBRMX5w7K2nV1FE2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWr77AAoJEKVg1VMiehFY6MsQAKgxj/uf+XCyi34OSiAQ5ihm
0s5hYxGBDBXsTyUEAvJmLNA/h01ymERA81lwLRXRgieZ3FP2j1IKRF0XgWTVCiBM
DvgQVQaiKn4enWvv6/JOQGZQLwvlZjKWyCPqOfAcDxrpq5+6WCXfjG+1LsukI5qn
rgKiYkpg+a7iRys5vPFACwe5JlW5jacLS2CMqWL51PYnPr40FIoAexXDM7NZan/y
37ZCiK9YQcBhNPNyGvotOub8G+e+/XfH1r1NWrRk9vuaXuTmLvYuChsW9Fkl07k4
INLd/xmkDqfe355hqM7cYG0l9Ez7+TyfIrhwHIZnE9LAuwD7TYG7nf7annD5xJtj
X9h76L0I+xc7R5vbcaemXI6yXQqUP7jceCGUzez+pHJLRfGpMnQnvyBZwDLOIPXS
aolR0qCUpAkXcQAxJBb8jcDtokTQongezN7xAfGhHGcByNNaymt+uRtWav3ozo4c
fE1CilTO96Mv8nuIUkNU/uSvh67IVMII6Ds24ng9LyZh8HjodwZmvfrUAzMKk1ok
63jb5KBeQ7iqthyemqVArziwQSHPjfaZsLqL5Gs1qp/TRQch3GANFqM3l1Ttw0C5
ahkwedRbEqOte3HbZWWFKotLIE8zt0BjPgb4Nf7v+LADu6HW4OvvInqyiRyiq+qE
rgmvznm/ovAF+rlSx+kO
=Kr3m
-----END PGP SIGNATURE-----

--=-S9CbnBRMX5w7K2nV1FE2--

