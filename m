Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZCZPef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 11:34:35 -0400
Subject: Re: [PATCH] mac80211: add driver ops debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0903260826t58c8c595ve612fa35ba7c91e4@mail.gmail.com> (sfid-20090326_162639_619200_70BA77E4)
References: <1238066858.4331.30.camel@johannes.local>
	 <b6c5339f0903260741i33264d5dy5e48a5c182cce387@mail.gmail.com>
	 <1238078762.4331.38.camel@johannes.local>
	 <b6c5339f0903260826t58c8c595ve612fa35ba7c91e4@mail.gmail.com>
	 (sfid-20090326_162639_619200_70BA77E4)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-blB+0AF/qAI7LqnSlCl1"
Date: Thu, 26 Mar 2009 16:33:59 +0100
Message-Id: <1238081639.4331.63.camel@johannes.local> (sfid-20090326_163439_069210_EE41211C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-blB+0AF/qAI7LqnSlCl1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-26 at 11:26 -0400, Bob Copeland wrote:
> On Thu, Mar 26, 2009 at 10:46 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >> Could we use some newfangled thing like tracepoints for this
> >> instead of printk?  Disclaimer: I know nothing about such
> >> things.
> >
> > Probably. Want to look at how to do that? :)
>=20
> Sure, I'll do some research and see what's involved.  Don't hold
> up the patch on my account though.

Oh doesn't matter to me -- I was posting it more because I did it, I
don't have an immediate need to have it included. If you want to take
some time to look into that we can hold the patch without any trouble, I
agree it would probably be nicer, just didn't work with any of that
stuff before so I didn't even think of it.

johannes

--=-blB+0AF/qAI7LqnSlCl1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJy6BlAAoJEKVg1VMiehFYj0kP/14aT9S7H2iphtUAjuaOXuDS
acBRyRTuPsubj4FvwYWXxdA9GL1ej3bJavQav6Fzx6SCDCWsYAO+wRY7Hw5L9Ppo
jEc0C/KI57hBMvynHE5xKkWwZx8K6CdRB142Po0uB4m4HywHuQFbYTDmG2ZpbQ0q
LpVCYjnixTn2Z+EFU/vBdhus6Qg2e5spyicp67+JP9EbQLlToqH4ArSi0IwAgX45
TOGBJh3ydWqnHHRtVmdYwIdLWbKZDjKGR+ShRd3ILd7s8bethftrNx2ythOqIS0y
Ti0cQZUNNuScVmsNEugpK2K0T8YJYZnZf43x8CqKF8o7gjy4OCRMefojJGk5xud+
mHRZ/JG1zZqW6ntqDOJlF8uW4XUOpK5L3T+VQZpvtyq70sInDZNgU549LQoDoXIZ
2OD+ZPvJDvEES9H27lkaYnSubQfGjSE0okJ8aGD4XiuFRHt53De4P8RJLVibIUeX
xKsoBMWf+qhjjMljAOdKvq2g26BTYB0AS62rpSpKEnQLpsDl9UzGgjuNe3fPE12n
0r4KH7yMjlAwAZBzXlKjN8BgYJ9EQEBKgd+GCNVeeY/93HoUWcQvrbaRT/WfstE7
PoeJ+BATJJPOwPVur1dqVchtVBtZBmnV+BeBkuFYzOcjY5MDdq4kZ08nC6JvV7Zs
D0spcmfWkzkPbg5jGoD1
=HKDe
-----END PGP SIGNATURE-----

--=-blB+0AF/qAI7LqnSlCl1--

