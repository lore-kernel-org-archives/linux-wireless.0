Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbYEPUXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 16:23:22 -0400
Subject: Re: mrv8k vs. mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080516172535.GA9880@tuxdriver.com>
References: <1210694421.24737.19.camel@localhost.localdomain>
	 <20080516172535.GA9880@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PokCoWQekKT8+zJ4nNSs"
Date: Fri, 16 May 2008 22:22:52 +0200
Message-Id: <1210969372.6381.40.camel@johannes.berg> (sfid-20080516_222326_441171_EC686822)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PokCoWQekKT8+zJ4nNSs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-16 at 13:25 -0400, John W. Linville wrote:
> On Tue, May 13, 2008 at 12:00:21PM -0400, Dan Williams wrote:
> > Hi,
> >=20
> > mrv8k has commands that should be sent before a scan is started, and
> > after a scan has finished.  There aren't really pre/post scan hooks in
> > mac80211, though there certainly could be without too much trouble.  Th=
e
> > other possibility is to inspect the filter flags when
> > ops->configure_filter gets called, since FIF_BCN_PRBRESP_PROMISC gets
> > flipped before and after the scan.  But that seems ugly and unstable.
> >=20
> > Any objections to adding ops->pre_scan and ops->post_scan hooks?  Or
> > should I just use the configure_filter hack...  or is there a better
> > way?
>=20
> The pre/post hooks make sense to me...Johannes?

I don't know, sort of makes sense, but on the other hand the userspace
MLME just does it all manually anyway! What exactly do you have to do to
the hardware for scanning?

johannes

--=-PokCoWQekKT8+zJ4nNSs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC3tGqVg1VMiehFYAQKSEw//aW7esQs0dIaGYmSijrPlJv8Isi8jhXFC
iRnedhv/EG1+LYrMVezfS0q4O/mrchw1OtBcL2rmCsOxRnNUw6m3vsJNiHi1w97e
qpyao8gHrm/y928TgI0Ujp6d0nuqKdKlCfHIFmxtfKF9cPTwvO+y/zzNdmatwg+Q
2PQbt1Hx4fKvY5wRJf8ZP9hXyHSSWg721ZzOQ7xSCwkaPnqsyxRUATZTTPqyUivd
efY5Oe2n08knBsRSbug/ADQOItohg1f+8qDEOfufy3YW+FCrep2Qb0NSIG7beKp0
pvCizgmpKO7lBvPhMNT70AKeI74yN6ALpN1FwniGLL+f5KjJ4bMfHyxpi5isZWGy
1d3Ga3pPcXsJCedSVlF4Zs7/bXArgMh15eWPkbxq27ox88ZEwBujKS2QEmx+8uYC
/zdpE82UHOcgec61QBP2gI/GvVIGPuGt1XJrmdavbF68FCXR0vEE3evVFlGGeEyn
Y4RTVSXBMqXKhf/xzUJMtNRqumdoQ40kJdfLK6h2IiCmfrwz7FJw9xWMzGkYXw9i
fxbZIiT45ZeCcUuvfXcAoPaooIvKHRCc3puT3LTDhJ21VUZdvGZYzi7PZTxUmjVp
izxW+ogNHCt5Vj1h8WOJ1nCqH9JOEEpYXtmjHfARP3IYyr2B89A2EyC+oq5g0tIg
Rc2YeMb4l50=
=AiT7
-----END PGP SIGNATURE-----

--=-PokCoWQekKT8+zJ4nNSs--

