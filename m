Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbYC0M7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 08:59:49 -0400
Subject: Re: hostapd with mac80211 and rt2500pci: hostapd doesn't receive
	clients EAPOL keys unless mon.wlan1 is promiscuous
From: Johannes Berg <johannes@sipsolutions.net>
To: Bas Hulsken <bhulsken@hotmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1206557464.2844.3.camel@Bas>
References: <1206271458.2902.27.camel@Bas>
	 (sfid-20080323_113430_380950_98BCE00E)  <1206274341.16475.185.camel@johannes.berg>
	 <1206277237.2902.37.camel@Bas>  <1206281653.2902.45.camel@Bas>
	 <1206557464.2844.3.camel@Bas>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1AB3PVRhnwJ9NQ+3isUg"
Date: Thu, 27 Mar 2008 13:59:45 +0100
Message-Id: <1206622785.22530.36.camel@johannes.berg> (sfid-20080327_125951_759225_889177F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1AB3PVRhnwJ9NQ+3isUg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Bas,

> don't mean to push you or anything, but I was wondering if you
> overlooked my last mail. You asked me to add some printk's to the
> rt2500pci driver to debug hostapd authentication failure. I did this,
> and these are the results:

Sorry. I'm sure I read it but I must have forgotten, thanks for the
note.

> rt2500pci MAC changed: 00:0c:f6:14:05:19
> rt2500pci filter_flags: 2

> rt2500pci MAC changed: 00:00:00:00:00:00
> rt2500pci MAC changed: 00:0c:f6:14:05:19
> rt2500pci MAC changed: 00:00:00:00:00:00
> rt2500pci MAC changed: 00:0c:f6:14:05:19
> rt2500pci filter_flags: 2
> rt2500pci filter_flags: 0
> rt2500pci MAC changed: 00:00:00:00:00:00
> rt2500pci MAC changed: 00:0c:f6:14:05:19
> rt2500pci filter_flags: 2
> ------------------------------------------------
> this is immediately on startup of hostapd, after that filter and MAC
> remain unchanged (at least if my printk catches everything).

That looks pretty much expected.

> does this look ok to you? Does it explain why I can only receive EOPOL
> keys when in promiscuous mode?

Unfortunately not, it's a bit weird. I think I'll probably have to run
it myself to figure it out and do captures on the various interfaces.

johannes

--=-1AB3PVRhnwJ9NQ+3isUg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+uaQKVg1VMiehFYAQKoZg//T7Vkos1EwX5Qxxs+x5u+fazFZIxkcJJ4
UGuMyIBkTjAIUVmw7PvrnAm029QbFF1RTbW2nEslYSigxItZpzgRTzMxDHWP7rTw
ZjJhFCL8RG007gep4TtowZ/QM1d2p+dFv4cTt7gC+qF8XF9cAqitdSHt5jK/7jmK
j+RJWgsnA79VWnqk4jN5W12SYsteKAC8WwMvwsNF5RbXl2Sa0ppM2Z2vRwPRnaZy
nGzSW1vZbm6ywsoQVs8fzSSMpsGs/50Jl6sEXxYJ/er33k0hZ2nCqDLx0vnqXqcO
o2URGD7vTtwe+H+14Q1Q4NquU+uPZaeCsEjudZApq9cpJmMXDKU/veAWuEUxn34n
J31zjZgNVGUupBNjam6eKk9A+ns5lgC0DHe73sB7eMCaKDob+VKRl1VjfMrR6N4P
jbhcc3/xrTDKQgcToIjlKY/VSU6jfVwFS5V967kTEdCKe1d4kzJt4EDaN+PoE29W
AOzix+iXOpd9EzOV2U9C8tjfEujWEiRes8oaisfk9WgHKgB1kZojmWnA6mEgY3x2
K8b9TNqgY7ZlSVA7pZUjuwkBUFsSoIXBEl/tt4CmwHEoCKolT41ypgpyli0jSArd
z1XtlxH6SIoscmIg2wrWLiwQ5Y7RamTAqBoIHFwdt9U4n3GpQ0+sPLf4FxJYTucQ
UYILNYPW7VQ=
=1SXg
-----END PGP SIGNATURE-----

--=-1AB3PVRhnwJ9NQ+3isUg--

