Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:10385 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933815AbXJPUnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 16:43:39 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Mode/Channel/Bitrate API
Date: Tue, 16 Oct 2007 16:40:49 -0400
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <1192222110.4770.81.camel@johannes.berg>
In-Reply-To: <1192222110.4770.81.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2017774.4t3adYvIdB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710161640.54332.flamingice@sourmilk.net> (sfid-20071016_214345_811595_5CF68784)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2017774.4t3adYvIdB
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 12 October 2007 16:48:30 Johannes Berg wrote:
>  (a) the driver registers which channel center frequencies it can
>      operate with, it could in theory just be a range (e.g. 2400-2500
>      MHz) or more practically be list of center frequencies.=20
List would be best, but..

>      Just=20
>      contains frequencies and possibly hardware dependent values for the
>      frequency. This is done in "bands", something like
>      FREQUENCY_BAND_2_4GHZ and FREQUENCY_BAND_5GHZ, "bands" replace the
>      current "modes".
Being able to just register frequency bands would work for many (but not al=
l)=20
drivers out there and would be more convenient than listing everything.

>  (b) additionally, the driver registers as flags
>      - whether it can support G mode short slot operation
>      - whether it can receive B mode short barker preambles
>      (both of which are only relevant if it supports 2.4 GHz operation)
I haven't seen any softmac 11b hardware that doesn't support receiving shor=
t=20
preamble yet.

>  (d) now, selecting a channel by frequency is unique, but we need to
>      give new options to select short slot, short preamble and allowed
>      bitrates.
Short preamble? What would the hardware do with this bit?

> Does anyone see problems with this?
More specific examples of the API you have in mind would be helpful.

Thanks,
=2DMichael Wu

--nextPart2017774.4t3adYvIdB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHFSHWT3Oqt9AH4aERAo5XAKDIPyB+risgLtWqLMqaraWE3OIzbQCgyEp5
ZOCeZ6c028A0CIixYXVfyUc=
=opgg
-----END PGP SIGNATURE-----

--nextPart2017774.4t3adYvIdB--
