Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYBZIW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 03:22:27 -0500
Subject: Re: [PATCH 00/13 v2] o11s: mesh interface support for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <1203987800.2979.18.camel@shinybook.infradead.org>
References: <47be76f9.03b48c0a.025f.54f4@mx.google.com>
	 (sfid-20080222_071727_691746_9DC8AC76)  <1203693709.7082.35.camel@johannes.berg>
	 <1203968745.6929.30.camel@localhost>
	 (sfid-20080225_194425_609760_1B1ADCFD)  <1203969040.13162.145.camel@johannes.berg>
	 <1203987800.2979.18.camel@shinybook.infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NfA8cgsyGk8L6KGn+w1v"
Date: Tue, 26 Feb 2008 09:22:12 +0100
Message-Id: <1204014132.13162.199.camel@johannes.berg> (sfid-20080226_082234_037826_93EE7D47)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NfA8cgsyGk8L6KGn+w1v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-25 at 20:03 -0500, David Woodhouse wrote:
> On Mon, 2008-02-25 at 20:50 +0100, Johannes Berg wrote:
> > > > >  - We no longer use directly rtnetlink for mesh peer link and mes=
h paths
> > > > >    operation, and use nl80211 instead.
> > > >=20
> > > > Nice too. What does libertas currently do btw?

> Upstream libertas doesn't have the private ioctls. We have them as a
> local hack in the OLPC tree only. I'll be happy to convert to a saner
> generic API.

Oh, cool. The API seems to be there for mesh paths now.

> We also want some way to set the l2 ttl per-socket.

I think you went around with that on netdev before? I don't think we can
do any per-socket special stuff just in wireless since we're not really
handling sockets, so it'll have to be a socket option?

johannes

--=-NfA8cgsyGk8L6KGn+w1v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8PMM6Vg1VMiehFYAQJ6rA//XkIQa3prO7gFXW17GZqbqMhtX4O6O/z2
t0wpvhA9xBeepPRazYzrkxvGXILCSNjh/VcYU0OW0JqfAUXo31fOcd52/7BMXkXx
lvs13dblrKJLW+249QyQace+DFYNSzACNrWSL0BmJcKY3hsJIPjqchukEDMxLSJA
Ck7dSj+W0zc0Cbr9ASg3frJ4qfGDiJGaHm3oUcNxOua+RtFyoMDelH+UuS1rT0Ph
vjxQOzXuD5xNhmWFBxcipGCN60FbS0Rw8sgmxn0HJ9sfRdWMtmLDKgQhWxJ6o0MJ
AYM+w9Y4NTmFqBRbuQrq8Cm7013majNihNMBwRc3sV8kvEJ12CQQBJM/giuylRKT
xvK5+dHZSjmksirda3f+5ExyRG5894UsmP0X3QoJcyYtLs6L0Zb0qXwF8J/I6zAE
NH/Bx4j9d4TUQVlq9WuNxVn8c4Pktfm8dF/AJvf9+DGCc1odwRu/xaKrXeEKzWAV
utEonuz7ZBKXXUpDW+OF8N4MyuqO+wKhLatNLoVSEkmTrh0imRKSvxzOp8WDlQS3
DcMSmuOhG/i/nx61PJR7FmTDZDxD7G4IijnxUlqLOSVJNxwL0lt28plliiP4o6HK
D8Zwsq60RPl4T+v6FHhVapqTdbeXPHzkvi76eJkcAdw7Wbt35eoAR5xOnsCdNN2j
73OnnzfmXwE=
=W4uw
-----END PGP SIGNATURE-----

--=-NfA8cgsyGk8L6KGn+w1v--

