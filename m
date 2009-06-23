Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbZFWKHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 06:07:15 -0400
Subject: Re: open mac comparision
From: Johannes Berg <johannes@sipsolutions.net>
To: Bharat Bhushan <bharat.b.bhushan@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <d9360e520906220251o4a3bdda0k240d5ec9e0dc5b42@mail.gmail.com>
References: <d9360e520906220251o4a3bdda0k240d5ec9e0dc5b42@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3HhyGEi99WnKunhZ9L5Z"
Date: Tue, 23 Jun 2009 12:07:14 +0200
Message-Id: <1245751634.4184.28.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3HhyGEi99WnKunhZ9L5Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

>                     i  am trying to promote open source mac against
> our proprietary mac in my organization ,

There's no opensource MAC, except the Broadcom open firmware. Are you
referring to mac80211? It's not really the MAC, it's more the MLME and
some parts of the MAC. The boundaries aren't really exactly implemented
as specified.

If you were actually asking about the MAC itself, you can stop reading
here, and tell everyone that there is no open source MAC. It's not
really possible either since all hardware is different and this tends to
be implemented close to or even in the hardware.

If you're asking about the host wireless stack, read on.

>  i want to make few slides
> regarding the throughput and performance related comparison.Has any
> one did any performance related study of open mac ? if not then i am
> planning to take this activity ,  i will measure maximum throughput
> achieve the MIPS per mbps ,if any one want to know any other
> particular point then let me know i will measure that and publisize
> the results.

I'm not aware of any speed comparison, especially obviously not compared
to your own implementation of the wireless stack. However, this question
is also quite irrelevant.

By using your own 802.11 stack, you will
 * not get your driver into the kernel, which means having to maintain
   the driver forever out of the tree
 * not be able to take advantage of future performance work other
   companies will do on the open source component

Therefore, the question doesn't make sense -- performance shouldn't be a
criterion since that will be improved. Trying to write a faster stack
might be possible, initially, but at some point you will need to catch
up with features, performance, of both, of the open source wireless
stack. At the same time, a lot of power consumption optimisation work is
going into the open source stack, something which you would have to
duplicate too, eventually.

In my opinion, asking for performance review to base such a decision on
is rather shortsighted. It might make sense to do such a review, and
then decide to improve the open source stack, so you get the best of
both worlds, but doing such a review and then deciding against it would
be painting yourself into a corner you will never get out of again
without significantly more effort.

I would suggest to start by getting your priorities right. Using the
open source stack will allow you to get a driver for Linux out easier,
will mean the community will be impressed, rather than annoyed, by you,
and finally will allow you to take advantage of future enhancements and
new standard amendments easily. Bonus points for improving the open
source stack where you think it's necessary.

johannes

--=-3HhyGEi99WnKunhZ9L5Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKQKlOAAoJEODzc/N7+Qmar+IP/1jk5xwo7GhgN0vcCeSyuZe9
WIPF/BBvW8D+Vaa/rzwGYoLemEiIa4Ua96i5xbGb3Q3tL4x4yro6W3SsdjkPjSOY
8AnUUNSV7pK+vbCQhj/GOnrXYVqNJIuywPhzSaNkaVAJ0DmVxXTF+AhkjVvAzRBX
8jMRxnKR87KD7mNwcj91DuFw/3B1EMA0CJYJY6fmglLgLmgZZRVqJ0N7jcbSLam+
G4Oie7Y0qPa98S58K7RxmuR+t3slbLbjcVI1omCendWASysPrRgR7Z5jo26xINNs
Ozt/05+l3JD8xUhPyGTt27VCr0e3bITuqFzT1a9LNNZSEHph81BVGXeBymS1BMfI
4+NrNTgZUqiKricl46NezdDlRCfLNWEuUm43yBIRsy0FtrR983cfFn44QDDFn1YU
vy88WsE36uhKSm/LHn2jp+NB3FYagBwZ2vrq7VKlBRoIXIPpYDlm892e6NLl/M6A
Oug9V5w0gCHGVvnDapnm0TtUDWzMr6so6i151Vk6uQGY8PTFXZskubMQ48siTubQ
+gxGUvVLvGZP1X+ePvBqlny7s+D6J3h7j3n9FMwM2A8HLKWPT+G3DwooLOnkR4LD
EEk6tUUN828r3yVlUPpZL2PWK590Cjlg93i/vHT7OKf1kKKEWDin+ollELKe08VO
gInVCFss3QHUfU7vRj8k
=kobT
-----END PGP SIGNATURE-----

--=-3HhyGEi99WnKunhZ9L5Z--

