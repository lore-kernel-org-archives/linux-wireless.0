Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34172 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbZGXPrh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 11:47:37 -0400
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <wfr5w66q8u.fsf@calligramme.charmers>
References: <wfljmpm4xl.fsf@calligramme.charmers>
	 <1247762215.4235.21.camel@mj> <wf1vogmujw.fsf@calligramme.charmers>
	 <1247775641.6841.16.camel@mj> <wfzlau7co1.fsf@calligramme.charmers>
	 <1248449030.21715.23.camel@mj> <1248449371.32151.23.camel@johannes.local>
	 <wfr5w66q8u.fsf@calligramme.charmers>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KPu1ek8wQM2BU+TBIzIW"
Date: Fri, 24 Jul 2009 17:47:37 +0200
Message-Id: <1248450457.32151.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KPu1ek8wQM2BU+TBIzIW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-24 at 16:43 +0100, Jon Fairbairn wrote:

> Speaking as a user, I do want to distinguish them: PCIe fits into a
> physically different slot from PCI, so having only PCIe slots free, I
> really did want to select by socket type. Similarly someone with a PCI
> only motherboard would be looking for PCI and not PCIe.

Right, but that just means we should have a 'form factor' part of the
listing. I don't think a PCI-E listing would have helped you if it also
listed mini-pci-e or expresscard.

I think it would be smarter to group them all under PCI, but have a
form-factor there. While not exactly correct technically, it would be
easier to use.

johannes

--=-KPu1ek8wQM2BU+TBIzIW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKadeWAAoJEODzc/N7+QmafUQQAI9C8TMnyDxECTYWWVUq1QEk
ldM4lGl3xZ+POQ4Vv1IKT0Ow9WBuFjv3r09z2P3Dv0IwMb8dPmHqoDK+n/nX9Up4
4D7ATZAdQnRyo+ncKG3hXTNfVK12XGKduRWRIyr4Om9F4iN7pmtD1qF0DFYo/rMm
bT8utXAk7wZFGaScPfIULP0uHwLWcdjGU4V2AaSj2NZG9wkVXsuj6iK0qGCv+HTO
IR1VFWW4NTYIlJsPjw6sapkR8bjxBzUKq/gwECy/o5s3gs8ncOnC4ccJPuwqo2hj
o/4K7OVHy8M8twn0KkTzAhrZpHFC6Th5yfKFJe1mem69TxYJQ3zZWAGhlBe29MwJ
W0dK9HdroejY0941BW3AJNME0wVyvNGQlhqN/vyn+0u4mKNTCa9VxeeS5q+6/Lgr
Yl73mxDa/x0JRuMxuXbmRfHfJZaPoeMHaEiagkJkVwBtfvttAK55iM6KXdCufd0p
YIRN08EjhSenpX32fKJYohyT/wRKAyfFXWleaBaBwu88sxfJSLliJPB5uEDOB2so
31pyrCCEsUOwHBH7Ks/uROFILh5S6yOVfOLULEP44zS3LrmcQaGEmIQtr7Iv20En
uKwygXhDVQQJE9dpCYPL4kxh9oPwAjVhm5CK5sNeW+nHnjUUb8Nh5qpLJjO3kcCU
EENeii6vk0X0FFLbsOIs
=CKOf
-----END PGP SIGNATURE-----

--=-KPu1ek8wQM2BU+TBIzIW--

