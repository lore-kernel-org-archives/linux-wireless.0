Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbXJYN4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:56:24 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Zhu Yi <yi.zhu@intel.com>, dragoran <drago01@gmail.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1193320140.5542.11.camel@localhost.localdomain>
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
	 <1193148453.8648.20.camel@localhost.localdomain>
	 (sfid-20071023_150810_118446_E87EE8F5)  <1193161034.7733.38.camel@johannes.berg>
	 <1193238423.2557.41.camel@localhost.localdomain>
	 <1193318969.6092.19.camel@johannes.berg>
	 <1193320140.5542.11.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XryN9ELfgUecLYCm+WHR"
Date: Thu, 25 Oct 2007 15:57:41 +0200
Message-Id: <1193320661.14136.10.camel@johannes.berg> (sfid-20071025_145627_312123_CD94B13B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XryN9ELfgUecLYCm+WHR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-25 at 09:49 -0400, Dan Williams wrote:

> Ok, I'll try to track it down starting with wpa_supplicant then.

If you have a network, it's probably as simple as putting a printk into
the ioctl path and a printf into hostapd's conversion function to see
what it returns.

johannes

--=-XryN9ELfgUecLYCm+WHR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyCg1KVg1VMiehFYAQKKFRAAqXnk4tlpie39qoj+0KMG/NIjGiwS6ZNK
PzaD4x7gM5WHKdnG5ttt94YVCmoDblw3T1ya3XuTUq3llaTfEN6nTAfTEKo6ImjB
qtu0X1JiZ8NBT4i9N+n2n+jCjtyIKGHwpOjl5cPfbDwVyCvNwPZ9de3yZdQ8EgG3
A2eZqAfeW2MLMIf2rl5m6lDsxMd9aY1Fnv2fDagZMG6gk/jhZ3Wvzyi803W1KpM9
WsMsjOKae0mal/PxraAT1Ay7aHtH6roAwVEL7yaa4b4BWGgWgcRqU+LapBTn3fDz
NqciTi7wHcDXBolcwuzQ/wkDIpv6XAnwm16EMLOhrU3sIhY4Rmt5Tg/LhQDRQ6Wr
jpE43p4HXBhLGjOMxHc4mYSJBM4zERKbaAT0QByxmAbAUulIUkjob0Ho9S/Ez9QK
xIGX9lnwrZO6pv2dFhz5W1pDxs1vIu6mv0B6GBUEoy82acsOBUXGmwmzLQTy12Ln
K76f4j9h2ZtDbeckXsXWCjXj35sXppOnPSzv/3+FW/4wx9KdwRt0987xCfx0EX1R
UYWeCCRFXSQI5LbsKQpnR3bW9bCCRI486Nft8x+nzyx3IlfEjVtfVgeD3376yTe2
48/T+52TBqNBSVAjbZaXqh2hM4G7+aXgail5/H2XXUl2fQlfzbRuPl2CBFiK5/xx
DV/z3xEXTWA=
=wT3W
-----END PGP SIGNATURE-----

--=-XryN9ELfgUecLYCm+WHR--

