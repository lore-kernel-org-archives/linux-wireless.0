Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYGKKhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2008 06:37:47 -0400
Subject: removing STAs while aggregation is in effect?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-82kHCI8/95rKjRIrMbRu"
Date: Fri, 11 Jul 2008 11:55:11 +0200
Message-Id: <1215770111.3483.112.camel@johannes.berg> (sfid-20080711_123749_928106_570C6686)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-82kHCI8/95rKjRIrMbRu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

Quick question: I was looking through the new tx queue rework davem did
and couldn't immediately tell whether or not the right thing happens
when a STA is removed while aggregation is in effect. Say mac80211 is
operating as an AP and a STA disassociates in the middle of an
aggregation session, I can see nothing that guarantees the aggregation
queue will be drained and returned to the pool etc.

Am I missing something?

johannes

--=-82kHCI8/95rKjRIrMbRu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdy37AAoJEKVg1VMiehFYCH4P/j27e4Kjg1ZdHEPXheFqUXQo
QPlum5HK6y1PiTmnTLwE9rWFLrlbdqiTrKgGKp3iihq336ge7JXXEoM/XckOAyBQ
nNzEADfgsoB9FFytPtY5hLRLgn0dDTDPLEQL4dEoIxSpEB+GjJBgrrPmFXujWRpo
geMMiQYWpQRGXN1zuTHC9TGx5rsKCVje6Cw7D6HggNMajdJVsZiw0eaqyQ4tRshQ
QFqIqlN3j/gOsvc76Vd53FU6HHymrwMpyvgwLARLtdqoeBE4DHE5rq0SZlnX6Wtl
Xk0HobIAh0WKfHfnJ0raX7LjuWOaSxYPLZ3R9ZrjTcr6brQwPOaC3YN1X9lY5bqs
WVm8SUaKRHSMt5U1xsjtrs9zFQ62bF+4qsl7XKIybieNdS4aiQOE6IQfI4w1NCI2
kForPOJjOSMReDaP8oN8OYXlY8ty5d/DS6tYyU4yDa5PyTkvwcse+WN6h+CDpNNW
nFGdw/L/lIwDVbfzmOMUcuKVhnJklWaeY/x3hf1zco/LT5JyPXxS/TQOhj9o3Qc9
D5itk5Ml10CRoyVJ4hTZ9/Zz6nkADJVc2hB/iTG9cQ4phSSdjQYSweVrbBdd2TjV
/GUyv8ZlicDZz8DT0h5tJdCe1RZkalAkSUtNHH9OZ+gZpMCL2KvLk3/2vIINLItF
ntbMmfhWXmaN+AAVvWUL
=y0WP
-----END PGP SIGNATURE-----

--=-82kHCI8/95rKjRIrMbRu--

