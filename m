Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab0BFS7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 13:59:13 -0500
Subject: Re: [RFC 0/2] cfg80211: Retrieve missing BSS info after connect
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com,
	sameo@linux.intel.com, dcbw@redhat.com
In-Reply-To: <4B6DB44E.7030201@gmail.com>
References: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
	 <1265464303.4041.24.camel@johannes.local>  <4B6DB44E.7030201@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-68g5l6v+PkIp7LArTubn"
Date: Sat, 06 Feb 2010 19:59:03 +0100
Message-ID: <1265482743.4041.37.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-68g5l6v+PkIp7LArTubn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-06 at 18:26 +0000, Dave wrote:

> Thanks for the feedback. Like I said, the main point of posting was to
> see if this logic helped libertas in any way.

Right.

> Sounds like it doesn't, so
> I won't push this for now. When I get round to looking at orinoco again
> I'll see if I can handle this within the driver. If not I'll address the
> issues you've raised.
>=20
> I don't think orinoco can provide the BSS info without explicitly doing
> the scan (whether internally or via cfg80211). Even if I could get it to
> work for the firmware version I have, there's no guarantee that it'll
> work for the other supported firmware types (that I don't have).

Ok. Don't get me wrong -- I don't really mind doing it in cfg80211, just
wanted to see why, but if it really _requires_ a scan then that's fine.
Maybe in cfg80211 makes more sense, might simplify other drivers too, or
allow us to convert some of the other drivers that might not have such
functionality.

Since your patch creates a directed scan, it should be pretty quick just
scanning one channel, and maybe the driver knows the channel?

johannes

--=-68g5l6v+PkIp7LArTubn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLbbvyAAoJEODzc/N7+QmaY70P/jWcoJb11rT5ZEV3qpvSngO3
G7HSB/fiaExWA5A+DT477GyT6UZ53svbmAE8AjPC/em/+/vzmLCGuMYXY4CVhn5h
S/SW9l6G7SMFrHocc5JkbnE+O6taAWI/wIO0sgC/dVoF9P/vP3c0d7UNxwsKMSrh
zjagxFVa+vyMXaHx3XWMT3YyZpJnBceM/4t74PpGzx51TW0kon7+OHD77Kge9z2C
eFgVuW7K0sjw+aNRzWn9PHlqo89MP3L06E71CJbWWRT1yqiotlRZF07cetVQ/UvL
y6qZkkg7tW+5MNV0kEToR7GdEWIbsyCslsYZkXi9wJ3dlC0WfTwmEY3nm1Z656BA
1uIIzAzNwAqRg0381PWuKx30uHptOm7AXAatqk+9zDY5hnBip+REimVBFIUHZW1g
xo257A71RDR8H4gyhDlpl7OOtOHBomz9zRhTHG7teqo3qqTZnRw9dZdaSVH6e+sZ
ot+ZFxyCpbytEoZxCOtwOoUeQmDHVT59o25CupdOxfHPUiDXRVTlfkAAoAcEX3Y6
WSSfBbyk2/J51SsxNHpJXM8FoQiQiou6CWt7dlwi8gHoSA7jZJPsT4jXBV5vxeYL
yeuiqZxSx8uNpQ8iqjRW651yPBKfS6gcU+XcnxifqJ2tqH/kWQA78tiBQkEQvaRE
mlB7q/hx0o1l0gITRqHf
=PaN5
-----END PGP SIGNATURE-----

--=-68g5l6v+PkIp7LArTubn--

