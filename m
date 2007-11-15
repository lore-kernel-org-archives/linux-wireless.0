Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42338 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761424AbXKOQth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 11:49:37 -0500
Subject: Re: [PATCH 0/15] mac80211/iwlwifi (#everything): integrate
	IEEE802.11n support
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Cohen <guy.cohen@intel.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com
In-Reply-To: <247d6d340711150233h7988220fifb0d34170d16a979@mail.gmail.com> (sfid-20071115_103946_582002_A2DCEB54)
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
	 <1195056662.4091.29.camel@johannes.berg>
	 <247d6d340711150233h7988220fifb0d34170d16a979@mail.gmail.com>
	 (sfid-20071115_103946_582002_A2DCEB54)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-19wDG5XqI/O2GYoICHib"
Date: Thu, 15 Nov 2007 17:04:43 +0100
Message-Id: <1195142683.13846.62.camel@johannes.berg> (sfid-20071115_164947_547726_6F335E17)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-19wDG5XqI/O2GYoICHib
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Guy,

> We understand that these two issues need to be taken care of, and they
> will be. My concern is that if current patches won't be merged soon,
> we will have to pay the effort to rebase the patches again. We are
> very limited with resources dedicated to supporting the merge of
> 802.11n to wireless-dev. This mailing list taught us in the "hard way"
> in the recent months: submit often submit early... So for making Ron's
> work efficient I suggest to merge his patches and let him do the fixes
> on top of them, specially since the two fixes are not 802.11n core
> critical issues and don't break any existing working flows. Do you
> feel comfortable with this approach?

I understand your concern, however, if for some reason this doesn't
happen quickly enough we'll end up with code that is vulnerable in weird
ways. I'd have no issue with these patches if deaggregation support was
optional until we have the patchset that reworks that code. Can we do
that?

johannes

--=-19wDG5XqI/O2GYoICHib
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzxuGqVg1VMiehFYAQKrFQ/9GFaz37oIjsPtkn8BykJbBSKLE8S8/hdK
0j3m0dvrc6LtjoSdjmLCE7WBDpJ8qKa4yXgccfkAZb8elCNfL/NUMr04c0JwZeO5
32DuDTnXgVJv+VK9+/dRQJNTP9HJYVDVDdAYQ8lagjA12O1PjOmyMMvMdFSCC/mV
vLW/QMWzut2Dpz68bEZRAZon3gW89c6f0ghfuzt1CJVpEk75VeditvIOHMbddZKR
9TMKvqpodVR3fNwR6H9oGRn4ksXJW5QlXmIos8ZVmMcWkXZrY4I3Sqqih7ezZfr7
61PMZ5r+jm1an4NIhQg5oDeV81zLF3QMXX06amMoHDeDakpW2E8dKD+bwT0czKdx
6ODdDevdQhzVPXIskrP6pzJDXLdSwmnuCr1EIZ9M7IUEcKhu6e0QdcJBQwtQPMqQ
hlp/QlV724SA9BxhGQwAoxo6kfEL/ivBeKPSMOjmBfOHzqCU44FNaDWkpDhiTH3a
8KRz+YYzndXC4BvbQLA/sePMhlYdip6FstRv4FyIwENJQw2Sha8O/BHIl4uU+ZYB
NBtpJAvNlj9xDPXdgefPyCXGgswcV7guzMkM+kmqFzlAKIdaYj6gEl/uWBG3kDkr
zClapztuvbrvE5vFWjDea/F2vK+5AS2LUPxv6/dbqhTmc69XdIl+z89s5vfiIqEk
QWhlKl/SiuI=
=Fb4C
-----END PGP SIGNATURE-----

--=-19wDG5XqI/O2GYoICHib--

