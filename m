Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYJ3Vi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 17:38:58 -0400
Subject: Re: [PATCH v2] don't use net/ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Pavel Roskin <proski@gnu.org>,
	kilroyd <kilroyd@googlemail.com>
In-Reply-To: <1225400994.3690.86.camel@johannes.berg> (sfid-20081030_223730_293626_0C3455A7)
References: <1225243531.1369.18.camel@johannes.berg>
	 (sfid-20081029_125021_786122_12E56128)  <1225400994.3690.86.camel@johannes.berg>
	 (sfid-20081030_223730_293626_0C3455A7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Css0RGkjXOqv/fXtiVYT"
Date: Thu, 30 Oct 2008 22:38:54 +0100
Message-Id: <1225402734.16440.4.camel@johannes.berg> (sfid-20081030_223902_305664_DB05A019)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Css0RGkjXOqv/fXtiVYT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 22:09 +0100, Johannes Berg wrote:
> Convert all the drivers using net/ieee80211.h to use linux/ieee80211.h.
> Contains a bugfix in libertas where the SSID parsing could overrun the
> buffer when the AP sends invalid information.

Sorry, this isn't different than the one I sent before, it just got sent
out again because evolution crashed in the middle of sending the other
one.

johannes

--=-Css0RGkjXOqv/fXtiVYT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCilrAAoJEKVg1VMiehFYEQMP+wVdA3SLOb3rqPuPTPVwWyeP
rgyb+q2WDlr6JJdi3YonodTwZ7mC4aYGQS8WyT45LJArIGvxryOTyFNGgAIivg6b
qw91+4+LieGnRP2X0FZc/GD2uDqw+DfQ5amuO/XZABgQJGcuhiBeYLslrpfFyS5q
iPWxsLDqqvzWW9wrpo/BiYiJKrCE3ywwCpaR03zn7aNcpeVT9p+t+z7WvnHUTZuR
FdseA22z4RnlkapjAGmgoGoFSZbYFCyBIbRI6oJly2Kv7xOYJpyGk5UlWaKbqtgY
ibtffNcL9xnQq4QNqnLxdBjHqDYQdKmHUwCc2XkR2VGYRHrQVLKLFDqRY5NecNbE
RILfoi7foGDlgNLHkHTKeg7u6cefJ1WbGFnMCScxmpoHhudNJJKj5Vsv8JKo6RvQ
DoPNudZ4Z9a+1Sz7mCB0vVmr2DUPCdBHfKtnS7au91AV4yO10YU19nQEptOVSnv8
EHtZogaUBO0x5RwjGMCbpz6CztR7Mrm66icWIEn2hyFmdI3adM0M9ju/dNKU9yP/
oy3VCphazEJfOuhSS+dQ4s66hD0PSllfLZCmDwtQJSybNo6MfGXK4YpNIHGZ/vqy
+QBOefDHJmxWVi2mqtq7D0b+WmULGUh0NAVzb0oQSi+bvaeX6txB98oOb+/hsy0/
WgPyeMUOsQzFwaffLJBN
=bHCQ
-----END PGP SIGNATURE-----

--=-Css0RGkjXOqv/fXtiVYT--

