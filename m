Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60657 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYLAWfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 17:35:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 14:35:08 -0800
Date: Mon, 1 Dec 2008 14:35:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Diego 'Flameeyes' =?iso-8859-1?Q?Petten=F2?= <flameeyes@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [crda PATCH 0/5] Makefile improvement and fixes
Message-ID: <20081201223505.GP5992@tesla> (sfid-20081201_233512_950815_AFADCE4F)
References: <20081201103016.18024.80454.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20081201103016.18024.80454.stgit@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 02:30:44AM -0800, Diego 'Flameeyes' Petten=F2 w=
rote:
>=20
>=20
> I've been asked by a colleague Gentoo developer (Tony Vroon) to look
> at a build failure with parallel make[1] in crda, and I decided to
> take a closer look to the Makefile.
>=20
> With these patches applied, --as-needed build works, as well as
> parallel make, the dependencies are properly handle so that changing =
a
> file will only rebuild the correct one, and it's as parallel as
> feasible with no recursive make.

Thanks applied.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
