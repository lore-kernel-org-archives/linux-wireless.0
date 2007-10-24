Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbXJXNO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 09:14:59 -0400
Subject: Re: [PATCH 2/2] mac80211: [RFC] eliminating erp_ie_changed from
	low level driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <1193221337148-git-send-email-ron.rindjunsky@intel.com>
References: <11932213323451-git-send-email-ron.rindjunsky@intel.com>
	 <11932213374183-git-send-email-ron.rindjunsky@intel.com>
	 <1193221337148-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ewFPQC4mPEyJRrOR7goe"
Date: Wed, 24 Oct 2007 13:57:41 +0200
Message-Id: <1193227061.4510.29.camel@johannes.berg> (sfid-20071024_141514_339750_0949146C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ewFPQC4mPEyJRrOR7goe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-24 at 12:22 +0200, Ron Rindjunsky wrote:
>  			enum sta_notify_cmd, const u8 *addr);
> -	void (*erp_ie_changed)(struct ieee80211_hw *hw, u8 changes,
> -			       int cts_protection, int preamble);

you forgot to remove those ERP_CHANGE flags that are passed to changes
here.

johannes

--=-ewFPQC4mPEyJRrOR7goe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARx8zNKVg1VMiehFYAQI36w//VahvtVJkLLs5KGcDo7o4kaQW/O4jBzWY
bcvada2pyD0aBnqdQQ8T24zHqUaMj9YBAUgt2dubluOcHmVMPKdZ6TXYo+BMIFYF
+6qyp6zo8bflUCryXmJ7rqcn+9TbKGZk8aXIhZMzm+QBSWwm5sntGWzWoB7D373v
4w1d6bmOeMFZbNQIilF68c1AyPzU5RCXxvkr0W6PqKaXojGtZya+l8+cXzJp4mjF
qWZMz2pc0wY7GgkNLSyKc2RQKwyWntEMFF4K611OOQBMZnJO66fnnwaJz7NAbQSr
YXhQeM5V7qykmNlsOWh8ILxbxIp4bMEWe7dbagWs3vMJRa3ctAq9Kw91UI+ol445
BloY6FSFCMsX1Df2fbSQBMibUTdFAKLrPt2YQoodf4K0qmEaJrWzRR5tHEQtgUey
dulpBaqpHrarrpfEmAe/fCjzcd7Zo7IEgljFjkjjq5W1pVubzztKyKaAvR1I/D44
4rw2ksj/qBIX7ivDEMGwqIv2eki5jJCwoysg5xX2v8AoxSRi/sf1+gu55DTEtwGj
4f6VY5hG47ygAME+DcNnl+cZoL0/KDQ+uaPWcNAYLT35iIOpUEm2YEtKBiX0ADtN
E1ZE+9fbDK5thgG82VhoD6X0nKpbTRixgUgOR+zoo/9TgY/NPX+vqTWn2kF8sSFJ
PDwnxiEmAlQ=
=sLZW
-----END PGP SIGNATURE-----

--=-ewFPQC4mPEyJRrOR7goe--

