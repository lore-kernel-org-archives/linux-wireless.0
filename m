Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXJWJ57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 05:57:59 -0400
Subject: Re: [PATCH 1/1] mac80211: adding bss_config to low driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindzonski <rindjon@googlemail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <c85cb4470710230045j71339683n10d9807ea23104b3@mail.gmail.com> (sfid-20071023_084547_476398_85AED46D)
References: <11926651061687-git-send-email-tomas.winkler@intel.com>
	 <1192726084.15285.31.camel@johannes.berg>
	 <1ba2fa240710181146t111bd63ek97cf0c102d17369@mail.gmail.com>
	 <1192796744.4167.7.camel@johannes.berg>
	 <c85cb4470710230045j71339683n10d9807ea23104b3@mail.gmail.com>
	 (sfid-20071023_084547_476398_85AED46D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xh9VZ34GkL3YbeeovRco"
Date: Tue, 23 Oct 2007 11:59:05 +0200
Message-Id: <1193133545.9793.53.camel@johannes.berg> (sfid-20071023_105802_690799_9FFD9CE9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Xh9VZ34GkL3YbeeovRco
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-23 at 09:45 +0200, Ron Rindzonski wrote:
> I can see that this structure can be a powerful way to convey
> association data internaly inside mac80211,
> and we will examine this possibility, but our initial primary
> purpose is not to replace existing data exchange
> inside mac80211, but rather to unite data exchange with low level
> driver concerning changing BSS parameters
> such as association state,erp,wmm (and HT in near future), all may
> vary during BSS lifespan, yet all have their
> own ops right now, which complicates tracking them.

Yes, I understand, my main concern with building the structure on the
fly as you've been doing is that drivers are handed a data structure
that is only partially valid which might lead to confusion. That said, I
do understand that it would be significantly more work to make mac80211
use the same structure internally, so if you're unable to do that work
somebody else will have to pick it up at some point.

> I will send you another RFC in this spirit, with your remarks from
> this thread.

Thanks,
johannes

--=-Xh9VZ34GkL3YbeeovRco
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARx3F6KVg1VMiehFYAQI1MA//SvQK0kMUgM8baVddzPqlIT46jn2qtH1X
gEu/lL9cd6bLHZY1z8V9fyDUP4rjJOeITSeLtPiylQOjgjzgYAIfMTZNPNgrdD4c
+OOKrnUghnFsEQIRWnmE5uEJ4lI7ETsKOfo1xzzfbbLfXSO+P+tbbrrO3EEwoahh
jeVNvXIA0X+hayrQrfPn7pEyy0GYLUnMCZ/nJ5DJaxNPW+eAyHzYLzCXm74QzI41
zxThtFSpGrMkzzk3PybmTqUBI+4x6FJAbmgyj2SlTF/zPCYc+ChyeFwe1IepPi9T
laSQgcqHrLfkIEp873ynhXATLWZSOaLVoC9P3FriIL2icBtbnQCQ7Mjwc4xl5QHI
pT6fm3A2kyBRbRu9KScOqurzdX9lyxY/L3/yPKiS3fvHOkI7NLpXNPYRmEecCEfH
sIK85tRdcPhK9i1JYYNyp1L6cYUxYt6lJICssUwPzkcQnqChwEjixQ8tpmENZY6v
l+y9w8HgCnznsUeiv+fyRKQIT69TcK84q3T2GMHpYp5/gfurfl2jnDD7TF2UwUoQ
4azGnGTE6leDJtdPpbE4UGKq6VdIJYQg8mxGLE/62/qLwfyxFogjgTd+iTqIv/XC
xK4H7H68xmTUWJY56zTNq0tejXwNP5PYzpX7k5qVLpiykXoulJXuxtB3oXtrEDH3
RHPlE4hmFWo=
=3iz/
-----END PGP SIGNATURE-----

--=-Xh9VZ34GkL3YbeeovRco--

