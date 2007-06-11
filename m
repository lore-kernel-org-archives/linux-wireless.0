Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:22923 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754084AbXFKWA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 18:00:58 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: Don't stop tx queue on master device while scanning.
Date: Mon, 11 Jun 2007 14:59:45 -0700
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Jiri Benc <jbenc@suse.cz>,
	Mattias Nissler <mattias.nissler@gmx.de>
References: <200706081531.14086.IvDoorn@gmail.com> <20070611212021.GJ10397@tuxdriver.com>
In-Reply-To: <20070611212021.GJ10397@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1764159.auqrFGGxRf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706111459.54871.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1764159.auqrFGGxRf
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 11 June 2007 14:20, John W. Linville wrote:
> On Fri, Jun 08, 2007 at 03:31:13PM +0200, Ivo van Doorn wrote:
> > From: Mattias Nissler <mattias.nissler@gmx.de>
> >
> > mac80211 stops the tx queues during scans. This is wrong with respect
> > to the master deivce tx queue, since stopping it prevents any probes
> > from being sent during the scan. Instead, they accumulate in the queue
> > and are only sent after the scan is finished, which is obviously
> > wrong.
>
> Can I get a quick ACK/NAK on this one from the mac80211 guys?
>
ACK.

Did this actually get to linux-wireless? I never saw it.

-Michael Wu

--nextPart1764159.auqrFGGxRf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGbcXaT3Oqt9AH4aERAnHnAKCj1OQIEI+uTg6xbPoZMnhe2k8DcgCfTadi
OlG5ByE4M4I/2Y9WPusXg+A=
=KFRK
-----END PGP SIGNATURE-----

--nextPart1764159.auqrFGGxRf--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
