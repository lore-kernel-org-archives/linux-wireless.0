Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbZKQQoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:44:12 -0500
Subject: Re: [RFC] mac80211: disallow bridging managed/adhoc interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Michael Buesch <mb@bu3sch.de>, netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <20091117083741.1b165274@nehalam>
References: <1258465585.3682.7.camel@johannes.local>
	 <200911171504.54170.mb@bu3sch.de> <1258466868.3682.13.camel@johannes.local>
	 <20091117083741.1b165274@nehalam>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ptwFEf4fyZay9gg7e8zo"
Date: Tue, 17 Nov 2009 17:43:43 +0100
Message-ID: <1258476223.21197.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ptwFEf4fyZay9gg7e8zo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-17 at 08:37 -0800, Stephen Hemminger wrote:

> But there are people bridging wireless, and hostap even has a mode for
> that.=20

But that's the AP side, which this patch doesn't attempt to prevent. It
just makes no sense to bridge when connected to an AP or part of an
IBSS.

johannes

--=-ptwFEf4fyZay9gg7e8zo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAtK7AAoJEODzc/N7+QmaKVMQAMj3N0Kfy3bCDMkK7itoK1Rw
HDrkc7tiOfTzgdVD3xsUaZaZcqnsuJi7U7xp0XfwDtkqUGXjQgEzjTrC7cCqPkcE
7H/qeNCfrKIXzNKJF6Cni41U1J088s1ufFsa5PgoH8dJcET8xnys9wQ0jeXxwwFh
BtOXaZngjy0KkP7K/yTVsTMdwAoa3NPg/2yzKRwl7YqDrRxInGeN8pRUEK2dpg0V
qoqMkLJOoJEc4qvwo/3qxkgeiqIA38t0ib9LDT3lbDx+HK+XTG2p33lgvTwNOIFb
hRiIITLcqTK4eY9Z/6PRCQTyhLYr7bkLgKe2BesGw6lFHH7VY/rJvA4UMJzQzx3w
8474UIId1/luY8gpC38Wuo4GcZO/NDgegeX9vsgczoTstq7mUBmfRUEuVeB5cHeu
MVwRGvh6SjzbMkGSlKCHY/hv5cCYl5StxfJRtXIC68+SAuc01tD64WAk2HX9k+px
jTVSZCh4054hpFnfzhoBHW46cSq96DOtbZ83Zltf7yNIuyou2mY2hsedH3qZ6poc
L/XJjUiOuA10fEJji6YW9ZbEpJ0tqGxPsSD1DbCEdVxVwkTs7+c6P/ywF281aLF+
dbKfY7eyWrJ1++1SgyfUOsilwlTASjoa1gtKHIEmI2ba2/Q0Nw2Zjp8vVyAZdm91
AKM6RXZ8+m5uIbuObQVk
=gPCk
-----END PGP SIGNATURE-----

--=-ptwFEf4fyZay9gg7e8zo--

