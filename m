Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56915 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbYJ1Bij (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 21:38:39 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 18:38:39 -0700
Date: Mon, 27 Oct 2008 18:38:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Davide Pesavento <davidepesa@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tim Gardner <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: crda packaging
Message-ID: <20081028013837.GB27884@tesla> (sfid-20081028_023843_746073_FE558BC7)
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com> <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com> <2da21fe50810201336r29ed4e83g18d57e6d01b97349@mail.gmail.com> <20081020140438.GD9035@tesla> <2da21fe50810201448y6f05770at1d611d5a9ddc7e5b@mail.gmail.com> <43e72e890810201515k79ad4e3cj90643ad853e3acfe@mail.gmail.com> <2da21fe50810201539k74dedcfbwf4d63827e10e6c40@mail.gmail.com> <20081020154315.GL9035@tesla> <2da21fe50810250254w67d0d485v79ffdb40ed2a3b4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <2da21fe50810250254w67d0d485v79ffdb40ed2a3b4b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 25, 2008 at 02:54:30AM -0700, Davide Pesavento wrote:
> Only a couple of issues now remain in crda:
> 
> (1) crda needs <linux/nl80211.h>, thus a kernel source tree is
> required to build it.
> Solution: ship nl80211.h like iw does.

Sure, I'll just steal Johannes' version.

> (2) `make verify` fails to validate the db signature if openssl is
> selected instead of gcrypt.

Hmm, I'll take a look if I can, right now am looking at interesection
though to automatically generate world and to use that later upstream
for 11d.

Thanks,

  Luis
