Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZFPT33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 15:29:29 -0400
Subject: Re: [PATCH] cfg80211: issue netlink notification when scan starts
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1245180177.28992.6.camel@130.81.190.10.in-addr.arpa>
References: <1245175002.21287.3.camel@johannes.local>
	 <1245180177.28992.6.camel@130.81.190.10.in-addr.arpa>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-egC78GVcd0THP04hQaOY"
Date: Tue, 16 Jun 2009 21:28:42 +0200
Message-Id: <1245180522.21287.50.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-egC78GVcd0THP04hQaOY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-16 at 15:22 -0400, Dan Williams wrote:
> On Tue, 2009-06-16 at 19:56 +0200, Johannes Berg wrote:
> > To ease multiple apps working together smoothly,
> > send a notification when a scan is started.
>=20
> Yay.  I like this.  As long as we can guarantee that it will always be
> followed by a scan-done message of course.

Yes, it will. Unless allocation fails or something stupid like that.

johannes

--=-egC78GVcd0THP04hQaOY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKN/JnAAoJEODzc/N7+QmakqgP/A2mX5+o/k3vcn1mqiSbprLE
d7SJpI+Zki2Hk28lY5m2mFcahA3l+IocEm2wOt7tQtB1VmBw5F8R5pCS9eNB6V5z
pbG96uAh68HFaZV6a7aWId9xQe6wyZ1t8P72VNH9sBNxqs0ZDsGqOhRh5CGdzSN7
LF0io8rAyF1pdeGvwYZGylarR+txRsfrlaUdHheljombeKbNkmvcyUdPw917d4JY
5/x3OfJ/eeOqQrpQjca6U+1Qz9EvYbQSuWkN/GX1hB6LidRjIewMJJuiiOdPu1A7
PCox1tQFRoUsCRH1b7LIxzKU0HBCtAXafeSGxnDWUdLt76FY+w2VCWZH65QUJ0qf
r0bhjFWzVz9WMvhIkcSeur3aX31zhOylaJk+HdtWtXbd5gRuJZsyPxgEXvFIP2Vp
vT6C0BUcijFVD7EnLoE8NYrku4+eT3RVcya1JNfdKuFIQmHj1irhTDV40X3xyYvL
FetG3ojhm23BI1uHJ4Fxm7s7V+z+w40tf2+8j8XB6Q+TdZRKe4TBDJ0o+1mfyV8l
mXi3tgLR+Ohtv1cE2+Acc3r8+lPKBi09B0LjTOTuriH1K6PW1CBk3IjVa9R6LH2v
IeNpcUW3l9WpcDkE63Kvga/amIoxxlilCSwXsR1lvkEU/2p6aS8NjVlDoQ6ls58T
/eGCZVPOTciFqWpiYUEU
=phLK
-----END PGP SIGNATURE-----

--=-egC78GVcd0THP04hQaOY--

