Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZFAH1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 03:27:49 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: alan-jenkins@tuffmail.co.uk,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243796628.6570.37.camel@localhost.localdomain>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310651g41babab2hb05729b0699dd81f@mail.gmail.com>
	 <1243778069.5299.0.camel@johannes.local>
	 <1243796628.6570.37.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nO+B8G1kmguDqGI4jHms"
Date: Mon, 01 Jun 2009 09:27:43 +0200
Message-Id: <1243841263.5299.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nO+B8G1kmguDqGI4jHms
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-31 at 21:03 +0200, Marcel Holtmann wrote:

> > Maybe we should add an ioctl that disables rfkill-input if present.
>=20
> I am against it. Can we just add a module parameter that allows us to
> disable it. I am against cluttering a new interface with legacy stuff
> since we are removing rfkill-input and replacing it by rfkilld anyway in
> a near future (meaning when I am back from vacation).

Right. But you'll get a bunch of people get it mixed up. I think I would
prefer adding the ioctl, but having it only when rfkill-input is
compiled in, so userspace would always just get -ENOSYS if there's no
rfkill-input present, which means the "cluttering" of the interface
occurs only for as long as we have rfkill-input and at some point you
would just remove that one line of code from rfkilld.

johannes

--=-nO+B8G1kmguDqGI4jHms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI4LrAAoJEODzc/N7+QmaVEMP/1wQKiRrmj55L5ldm7J0e3EM
Y9XU/dDmEG366/lH5z5h7oaMxj1jz7Dfq6qI8IRRpCTf0ARcVIalx1lwD4uls6KZ
HjeDK1eoyhSGyrNWRZTny1h0mywZZhde8rdQmzPJ6dHipL+qtcC51ByBmOFl//kb
pb/9d0lJJw4gKV6gXOL+XurK/9yfVU5eDDa3xUXBHSyBb+7bzvLeyw+1dwINDzqB
aNtOYXO5zbsKAvl6lqw54/Xt894NjY0qg/qtVdiOfOyN3HfEydP+5B2K4YP1dSXz
yt5DBqvNPt95XAPJtqmqTYRXFDUE2Cx6JMnT8HnHitpiIk1h7xEwUHlc0IJ1Ddam
dLTUz4azggPCP8ANiv7wF4OwnSCjThkH52Q/Vzc5+joZKoooZjxtg+T7W+jrSRTY
laJlxwtCI8V963Kg7sgpgAiWuejImy7GWwhHj0h/ppFq4pt1EL7CwTu0GGtR2hyz
wJZcV+PQ9W+APdWrlMwXT9Q5hTJswMDegc6zrdGxSpjoeptAMLhoy8hoR/hVOwJ5
/FQv7ytKiBG3Y5g5V+SY6GfLjTAYfOXAU6Rk/fVt56xu0nAKfj0uqX7y1Wkj24tu
tw4gsVdA4/rvqf4nsJ0qy6IHaA1kOxdH3cDIoq0ygLkatmCvJyyqIlXPipnAInLD
td2AiLVHR/DzCMJuK5wE
=unmP
-----END PGP SIGNATURE-----

--=-nO+B8G1kmguDqGI4jHms--

