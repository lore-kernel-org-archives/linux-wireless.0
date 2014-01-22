Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58022 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbaAVMjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 07:39:14 -0500
Date: Wed, 22 Jan 2014 12:38:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexandre Courbot <gnurou@gmail.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Message-ID: <20140122123819.GH17314@sirena.org.uk> (sfid-20140122_133938_091865_2AE9177E)
References: <1389941251-32692-1-git-send-email-wens@csie.org>
 <201401211335.16885.arnd@arndb.de>
 <CAAVeFuKFfAvSPYLmvWV5jjT-peZFJ8sJ2bbh4F=JAYoWLhjZpA@mail.gmail.com>
 <201401211950.07011.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qGF5p/tMraZs2sto"
In-Reply-To: <201401211950.07011.arnd@arndb.de>
Subject: Re: [PATCH RFC 4/6] net: rfkill: gpio: add device tree support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--qGF5p/tMraZs2sto
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2014 at 07:50:06PM +0100, Arnd Bergmann wrote:

> I should have another look at the debugfs representation, but isn't
> there a global namespace that gets used for all gpios?  Neither the
> con_id nor the name that the driver picks would be globally unique
> and stable across kernel versions, so they don't make a good user
> interface.

Currently the globally unique name is the GPIO number but that's not
stable since it gets dynamically assigned. =20

> I think what we want here is a system-wide unique identifier for
> each gpio line that may get represented in debugfs, and use a new
> DT mechanism to communicate that.

We've mostly been using things based off dev_name() for stability.

--qGF5p/tMraZs2sto
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS37u4AAoJELSic+t+oim9G+MQAJErIQGqQz6x1HTjAObSjhOE
CuL1qSxTNyzHD4QvUc9PJ15IEvqe2TK+1AUgYDEGIkZ2kwwGBZAhYPpA0eIzecrO
9u0ZMNvoq+Nw85NjA6/CZCBTJ+fo3vX9E2STkddxez6SE4O21cyRxLJ03QKIuR/5
CsAP2Y7Z4el7aaSeQc/6Aoc1/0Hc93rMYOCNyCou7tWX5HjC+uA+zXaYLh8XetM+
2AlnhqMTl03q6F32t7YxeGcnMxWkV2CaPVEuh1F8oMsSCXTzwOFtOE49N395C8ES
5swiFcL1Z/X6BrfJ7GvMPOrkGFSeEetVzUSUoaHSW1KXtsZfGXxEM2eIX2YnYkbw
olt+eAuQ0HsjKg6iC9SzKa6ykZtdza8owmXVJAyjW+i5l3y+3KNWIO0K1X64lMZA
SJdyoJ77nNtZET6UWF65WvRx8oXK80vdrltWDJ8sHfc0FZ7cPCTeZrZ4QjXcpBMp
lmXCXgKdXhmSQin24V+bdZFj1bwYEOjhrtqgIqVsqJLIHNpqyob+7ik2vv1h4Dzw
U/yQnVdpbns7WELoAzlslQW3t+FVwbeRyhrIRc8cZY4LTKTjfQHfN5bq4z/qgCuN
kA/9NUZpmgpsxAJnEo0iv0b9zE7JEbX/Z38I40E7VurzH65sn9w/kCtGf7G0ffCY
44oDEnRbgyAscMd4tDlQ
=Hgls
-----END PGP SIGNATURE-----

--qGF5p/tMraZs2sto--
