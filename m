Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34353 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaELOFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 10:05:31 -0400
Message-ID: <1399903516.4337.12.camel@jlt4.sipsolutions.net> (sfid-20140512_160534_228081_A3E858FA)
Subject: pull-request: mac80211 2014-05-12
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 12 May 2014 16:05:16 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-oFJzo/AHxEANw/WS7owR"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oFJzo/AHxEANw/WS7owR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John

Two more fixes - both I've been sitting on, sorry

One fix is to get better VHT performance and the other fixes tracing
garbage or other potential issues with the interface name tracing.

Let me know if there are any issues.

Thanks,
johannes


The following changes since commit e669ba2d06c6195662601956454ac959892f0762=
:

  mac80211: fix nested rtnl locking on ieee80211_reconfig (2014-05-05 15:14=
:58 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git HEAD

for you to fetch changes up to f9ac71bfcc5c937ff02765dc316cf5bc01d21d97:

  mac80211: fix vif name tracing (2014-05-09 14:35:40 +0200)

----------------------------------------------------------------
Eliad Peller (1):
      mac80211: fix vif name tracing

Johannes Berg (1):
      mac80211: allow VHT with peers not capable of 40MHz

 net/mac80211/trace.h | 4 ++--
 net/mac80211/vht.c   | 9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)


--=-oFJzo/AHxEANw/WS7owR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTcNUgAAoJEDBSmw7B7bqrpAQP/jRO2XTEtlq1I6mi3ANIrVEr
VgIMELrR/yf/cvwBtrnNtc3lxtRlx4yGHTORO8b5tfIB+5HcohNSC7tw+i+q2MoH
kGPdw8358ngp58b13LLn8ZCG0bCCxKt3MpQtrSst1p/fXwgiVzXnadRi6IBtav8X
d/fz5VXHnxW+XYyktFOq8vh+Mi/gJ2ti7JkoYx7AK6p2GtnhVxf6PFrjnV7qabCB
KIXUPV5UEzeajGjto4gh4XxL2cmSwSm4KoPMYIYvxzDtOI3QxjEpcyDmM+mwDEnK
hvfmITWVSV7LyfGGR52TBI1OVq8z/ts6UKzAHGoN+pBj/4LZKophsyEb8e+PYZ+L
rxqoaaaJeSakoeKt9FsZM1yTXZfEj9DaoUCI11XnhfDbj14K7HQd9wvUh9u1HC63
mmFvIPq31U1JnnhjHoD8B7NZaCIGp3ZkoAYJjvfXa7Z12wgbl0M9uRaGxb2EUHLV
QQWWa8pB6aymLvlt8mcFc2sgEz9qKtusPOpjJJsx21CI2yxe3/yBLVDBbTI2sXfv
5CviX3hpqmUdrBz9hVHDZJza2nXtq23UgYj72P2YBa9ZligA5IWDLnl7Mn58mNHl
PTx/Zt9D1rKNSehjjmB2evwme6DtGy31GzhmdCguFdzGgu49nTzzHZOXKY8r710G
ev9SArd2RFWOpH6LohLX
=+om3
-----END PGP SIGNATURE-----

--=-oFJzo/AHxEANw/WS7owR--

