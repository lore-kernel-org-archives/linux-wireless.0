Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbYG2LJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:09:25 -0400
Subject: Re: oops in cfg80211 doing mesh mpath dump
From: Johannes Berg <johannes@sipsolutions.net>
To: sbrown@cortland.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <488EF6E0.7050209@cortland.com> (sfid-20080729_125437_639538_96B3F8BB)
References: <488EF6E0.7050209@cortland.com>
	 (sfid-20080729_125437_639538_96B3F8BB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0700H/QeOoAyo7nVAkBs"
Date: Tue, 29 Jul 2008 13:09:21 +0200
Message-Id: <1217329761.10489.15.camel@johannes.berg> (sfid-20080729_130957_070426_9ECEFE93)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0700H/QeOoAyo7nVAkBs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 06:54 -0400, Steve Brown wrote:
> I added line numbers to the recursion path. If more are needed, let me kn=
ow.

Thanks, I have a fix already somewhere

johannes

--=-0700H/QeOoAyo7nVAkBs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjvpeAAoJEKVg1VMiehFYTTkQAKFd1ZVoc9Idzb1Th+Oc8JCs
MBBeQhrGOUb2zUcXiQ1J3093kcuC7mTlx7J5ex2wfR1o2/KXs5jprYmPJfyH1+Pt
xpA1zdeAiVtNvsSmQ3ybU/Rkj4COPDdQsAdpZ/IQA5VKoCjA1rgQ/mKZj1nQDCCM
Wv66LMXa0MXZAxUGW7PFAasiFXI/jVZcqBmnw7ke6c8gbtzT9WnsDxKNl9oFJBCU
lmO322u3zXq4X8p6VLvHB6QECoG6a9VLxtPdcw9my777a30UGDpw2OC5aW6Wensj
LwdbPutMulO8LqjXEwT75tsbqgnwWZi58tUI40P8xPGjEYZgHj91hehjsS+go9ZH
TGzC35mneGFLpENnmYa+YHMt21Onu1oQ6hWpThS3U3pjPKnEQFk/HuTljwdF1v44
p2T5wgmOarlNkBAboUo9vMniEgsUBTbkidBHQa+ypEykzfWgU+tVKCqJRHFnZpCM
7ZVll0jWi/wGGmiEDgqQCHQt9nQz1oC2wvnGgzkpQzR1pOTatNqGZYLRIZdhj26e
X7qCTYQBi0zc5acwkS+b8+9E1n0dqkAvRGyDT3MJ44WeRu1Xtbocr0498gDi1F9n
2p4xFiIPSxWVlKL1ru7L1EYygunTIHDk7cwhVu+WYjEgoBzVWaX6rQEytEfqL7CG
+J7KF8gRKPl691fUIweh
=mq/Y
-----END PGP SIGNATURE-----

--=-0700H/QeOoAyo7nVAkBs--

