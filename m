Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZK3LwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 06:52:17 -0500
Subject: Re: Configuring multicast/NO_ACK  data rate in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: ath5k-devel@lists.ath5k.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <120204.2322.qm@web51404.mail.re2.yahoo.com>
References: <120204.2322.qm@web51404.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-g+FuxsUdtSwanD0zSIQ+"
Date: Mon, 30 Nov 2009 11:05:54 +0100
Message-ID: <1259575554.32171.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-g+FuxsUdtSwanD0zSIQ+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-30 at 00:34 -0800, Joerg Pommnitz wrote:
> Hello all,
> we are currently evaluating whether ath5k/ath9k is able to replace Madwif=
i for
> a project we are working on. We use Madwifi (among other things) to trans=
mit
> Video streams over multicast to a group of nodes in an IBSS network. To g=
et=20
> the required data rate we rely on the Madwifi iwpriv call mcast_rate.
> Is there an equivalent configuration option in mac80211?

No. We briefly talked about this at one of the last wireless summits,
and it could be implemented with the cfg80211 operation
set_bitrate_mask() which we modelled for that, but never implemented all
of it.

johannes

--=-g+FuxsUdtSwanD0zSIQ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLE5j/AAoJEODzc/N7+QmayfEQALadXkU/2pZcFP5YmwLunzAx
TU8nTCxBKIKeatX/9H5OyJpgTQpVko/DQMFoOB1wKf1v8AXkE2FqeTdr+tDPXn9s
60nkKCFRbDveVEeAWW1Rtbn/hKBGEzJ9dZ+Yokr8mQZVteZ5Ik7cGafwSCcZTX1f
FEw9tKzMiOpFLHslV67N5y9miPgzToeec91cqR8+mPjORA2+Lneno6DhjXAVaG8v
j2RJcIPHIYgc0C5YEbKQJ4Ax0NdsPHHyQzxfebZ0riEk6O3yy0zelnHmaEBCvkMo
++lDSLwhVAueayDtj5cYvcKdCD3YZCNcJWlJGMFlQ08WmL0TvPNiv+eat4vuhYGn
u38emakvRm79Llc7P9ljgv8rlHENZCtFULBQXdHZo3jDHKK+pOYsv3rxjFq6l8n0
hykrcMzXvscnRyGylxJ46OFXu3PbUNqG7ORToF41BVMJEv5ckO8bkgmViSz8hz5r
+gLHFIUFlD9wUz9k9KLvPiPDuMS8HCSO68AS++ZGbxXKK5EwzgcpS6xobSVNx2qU
R+AWjPDvb/TJXAv0vcZIPoVwSF3/SQMl8Ws2hdQgBp/4pmxlOesaYlhF62vIUB91
2eBPSGbs/5b50O8QrfTtgNdkcJNkhh81k8JHFw02sIRLo4M80zJnxHuWOX1ferk9
s+JzhwKudaMMuWPbGpI/
=115k
-----END PGP SIGNATURE-----

--=-g+FuxsUdtSwanD0zSIQ+--

