Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYAXOuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:50:18 -0500
Subject: Re: [PATCH 03/12] mac80211: A-MPDU Tx adding basic functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <12009163393182-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115439_500829_54AD44A6)
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163393182-git-send-email-ron.rindjunsky@intel.com>
	 (sfid-20080121_115439_500829_54AD44A6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wl3Y94glc0nfpzWsrI9L"
Date: Thu, 24 Jan 2008 10:30:39 +0100
Message-Id: <1201167039.3454.61.camel@johannes.berg> (sfid-20080124_145048_524649_7E984AB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wl3Y94glc0nfpzWsrI9L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/* FIXME: need a better way to ensure that TX flow won't interrupt us*/
> +	/* until the end of the call to requeue function */
> +	spin_lock_bh(&local->mdev->queue_lock);

What sort of better way could we have?

johannes

--=-wl3Y94glc0nfpzWsrI9L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5havqVg1VMiehFYAQKyUA/7BwWluUf/oDeAT7v9S+nOG7enbersfF0E
Ki06TyZbnNm2MPdY4Ouf6MOmyzxEgoJyA34vTRLBcHahkLXjQpFt+339TGtkYWrl
0KrqTmbPklne2Qx7VcBs3nPT6cdM206rkS+0s9RnoV7Kv41NM88ODJlmoDPmq8KK
/n+HMxjWIvzKqPF64Gz+n7zOfXyMPc3yKiq+i/VcC2zRqXuCbZkXuxNYiOomlr5f
uhsrwUQ3fmS3oiIbOnuW6hKwR/BCHrLGPPPg5ZY4hg8K2aWcNBWoMtslOtFrARrj
gKR1uQ62tTb/srLT/NoWxqOGpJ5nMtK86LQL52ET0XI7rzZBtO7YfJzBTrH9ynD6
BDI6lfzDlzViId0ATz20hvlSKOYJyleefYbfXbiUuaaLgGsSRHpXUghkY3sQJD3S
/XsxD0KEzmBMs4RarVvU7eEArAF1czMqexY396N7tdh/7WA7QRQ3gRMQ12Jlz4jS
2Ulj4xXzR3DrsnBycAxOEhA1tQEbYnP31ophC+4aKJxe8SXXuFPDvGp8TLgMrZrv
8XF+KCRShR53h9KKO/+XPfWbYSYhuWWjXG0DN5Bl2bJJG/4VpuFjZmhLwxVk+OI8
ViZoIQ2yDxGa1Sz9bGdM1xQFiD3QRgLysZSO43CsnZ+61xungEkxG1d4i4/JFSnD
yYIJRi9c4uk=
=HnVW
-----END PGP SIGNATURE-----

--=-wl3Y94glc0nfpzWsrI9L--

