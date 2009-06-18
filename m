Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZFRVsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 17:48:41 -0400
Subject: Re: wireless netns work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Georgy Berdyshev <codingmaster@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Netdev <netdev@vger.kernel.org>
In-Reply-To: <43e72e890906181443g54269d1bm7ce24dcb46e7e921@mail.gmail.com>
References: <1245328543.13790.31.camel@johannes.local>
	 <1245329713.13790.37.camel@johannes.local>
	 <40f31dec0906181016nffa031flac8f464c929f1bc9@mail.gmail.com>
	 <43e72e890906181443g54269d1bm7ce24dcb46e7e921@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3abe21AtgDqps6qiskoI"
Date: Thu, 18 Jun 2009 23:48:14 +0200
Message-Id: <1245361694.6495.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3abe21AtgDqps6qiskoI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-18 at 14:43 -0700, Luis R. Rodriguez wrote:

> For example, I see you used mac80211_hwsim and was able to use two
> wlan interfaces to talk to each other. This seems great for testing
> purposes but it remains unclear to me the advantage of testing with
> separate namespaces vs creating two wlan interfaces on one namespace
> with mac80211_hwsim.

You cannot ping within one namespace and have the packets actually flow
over the virtual 'air'.

johannes

--=-3abe21AtgDqps6qiskoI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKOrYaAAoJEODzc/N7+QmaKnMP/jOZMGePN6ZQKvIqaU5BmCb8
KdPVolnOcYE3CX8WifJghf6SLsXVJ/CmaMzm8YHvQSVas4+QnybcxE75Zj6IdQ2B
OL2e/KcEEGMF4cEg21hp48uUe9WRzbHzREZqR1TbIgZB5rQNYCvo5ZMeVDHUcaDZ
EoSP0iOkVWdTS9mS8pOOx4AgxJsWbGBowYhV487JM3TShaWC864CyLsFwbIFOVhr
JUioikdlEAx94uv7CDPGZfJ99nEb1iUlq34Nyu7hSGCZCLN2kwi9tbJAGouGTB3C
hTyFov9hQ+LUwPMO82UH7SATh9aeeF6OYSgpjKYPEuYO/bdhVt1KT9F7SpsAb5Q/
wTPGbxlOwDhegZ/abgZBrRPyidSNIeobgdZLZkynwrDgb3RzK95qetdyCuLQCNRK
Z/PlOeTREjJDr2ZgZwcd0APFWZee/eZflePdSJ2yMeVkhDPn6enUgp+gxdr29ZZl
E5wRs6CrchlFezJtPQuvaMHcLXZEx9GDRJNHOGCxNKQjNrN5x0+bfetGnmb2EP++
3irdfegmZq5Mj911M7r0UZ1ghNSo1SwtM51R2yE9g1zkpRDn77FZmWs+qOcQnSZa
n7ETVaCj1m0QaDuSu4ODqaIp6VkwjM5q8ZYiFYLBOAnVw/4K295/+RQMj1O8RsW8
5hJbKpWe/0/IorFEvdjB
=udJN
-----END PGP SIGNATURE-----

--=-3abe21AtgDqps6qiskoI--

