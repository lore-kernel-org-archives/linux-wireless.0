Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZIXR33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 13:29:29 -0400
Subject: Re: rfkill hard state after booting
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Norbert Preining <preining@logic.at>,
	linux-wireless@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
In-Reply-To: <4ABB8C5E.6070402@tuffmail.co.uk>
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at>
	 <1253801252.3868.108.camel@johannes.local>
	 <4ABB89B2.8070302@tuffmail.co.uk>
	 <1253804713.3868.168.camel@johannes.local>
	 <4ABB8C5E.6070402@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oa5wU4Z90Pa1uHoJSqce"
Date: Thu, 24 Sep 2009 19:29:31 +0200
Message-Id: <1253813371.3868.313.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oa5wU4Z90Pa1uHoJSqce
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 16:12 +0100, Alan Jenkins wrote:

> > Although maybe it should just call sony_nc_rfkill_update() after
> > registering all of them?

> That means the initial "add" uevents etc. will contain wrong values (and
> then be updated immediately after).  Do we care about that?  It's
> unlikely to matter in practice for platform devices which only get
> loaded at boot-time, but perhaps it would set a bad example.

Ah, good point. I was just a little concerned about the logic
difference, but I don't really understand the _update() logic.

johannes

--=-oa5wU4Z90Pa1uHoJSqce
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKu6x4AAoJEODzc/N7+Qma6ycP/3XS6PNdebJIkEoL2/TWrA6i
cQjVDv/+33fzY5OGkt1hF8gBeG2Lyd1GFzQqkoRV9/so8pWullF1T2GndngBWZPj
dH+fVoeA6Xwpzocryw9nNeSmplCp9fmjYLpOSpoF63v/xSgASNTmWpfaCblaOyID
r1IqwETgj29qJLUK3R5QwMDIhjv0CB+AA0jY3c1TTjUO90pXS0E+qJonNvCoLToQ
cG72ix8Aw+TKreKTK76plxI8Si2Q8M1q7TQGTLvEjMZob4qpLyW+5zIN8/0B/rJQ
mn37ws4Gs58K0fezpsWnHqh2Sw6rWGGSwmBUeLPiTDKCWZF7b6SMhO6Iq3n60um0
aUGAJVPp6DCbknCRriMC2Kfqk6rO1c4aPb/IcDon+vA4R21IGprh2VSi50Zob9tu
LkCrwG1IPD2/A63RvwjX+q1siTqIS2vpT8OFYzkDnglFRei4TOVXSFAkp8J2+Woj
fnO4O81PsczRdRQfauhg5UHQOH+flC7DR+qBLPwxOqQgshYZ717HIZ69irnKr0VL
QPBAsR3NaE4dZMUgm9mCJAJ7IXBX6kXqS4lAxlCDQ582wySKBbsynatA2vCAF3up
Z4gAkrTVWOGhj4H2g4uhbCKxoHiNZtjn2nKXg38tzfPiPctpPskvPyXw1P3jF2hO
Eh3Ewhj9Sy8aKl5knL9/
=gMUc
-----END PGP SIGNATURE-----

--=-oa5wU4Z90Pa1uHoJSqce--

