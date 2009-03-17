Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38098 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZCQWcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 18:32:36 -0400
Subject: Re: Support for country information
From: Johannes Berg <johannes@sipsolutions.net>
To: Charles Gordon <digigordo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <86201b3f0903171526l62258146q3f9fb15166813484@mail.gmail.com> (sfid-20090317_232642_234193_B4888F7A)
References: <86201b3f0903171526l62258146q3f9fb15166813484@mail.gmail.com>
	 (sfid-20090317_232642_234193_B4888F7A)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MZAPy8ElUCy0yEcmXOrG"
Date: Tue, 17 Mar 2009 23:32:05 +0100
Message-Id: <1237329125.5100.7.camel@johannes.local> (sfid-20090317_233239_261281_4DADC50D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MZAPy8ElUCy0yEcmXOrG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-17 at 18:26 -0400, Charles Gordon wrote:
> I'm writing a wireless driver that will use mac80211.  I am developing
> with a 2.6.28-00106 version kernel.

First of all, let me say that this is a mistake. The API is
ever-evolving, and you want to develop against wireless-testing.

> I took a look at the files in
> net/mac80211 and I don't see any code that looks at the country
> element in beacons and probe responses.  Am I missing something?  Does
> mac80211 handle country specific settings and regulatory domains?  If
> so, could you please tell me where I can find that code?  I need to
> figure out how to support 802.11j.  If country specific information is
> not supported at present, do you have a plan for when it will be?

It is handled in cfg80211, in net/wireless/, in recent wireless-testing
trees.

> Also, does mac80211 handle 802.11a action messages like the ones to
> change channels?

Yes, CSA is supported afaik, also only recently. See my first
sentence :)

johannes

--=-MZAPy8ElUCy0yEcmXOrG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwCTiAAoJEKVg1VMiehFY1IIP/0xq4zoL8KWwKpow71U4SYMj
ITfPoTBXUMWAhe/8oAodHqmsiLabW2qELvtNLiwIRlNiWP/9rZ0XSQsXBYvx+fId
hy1oUqG3Vomsef7FJxMp9uyVQdmoTeTKpD16qfavN4HAMaQOSy6LXDB6ebJy/Lt0
uv+n36s3CAjbPMB8HI4lLezUaUvUWr5sFypQ1sfh8E7SKjOOJsjra0Y6+VfxoKt1
eMg1b/9Hs/J7LAPWjBwLt7ZUjJXDzTPB1Tz3WW9y8CAuhrg1Y8hmZ4neTjk8eHtL
qILBHs5jSLjGndkUUKaFg3tg7RbFSOTcJSvURHYS22n4cvKxR8df2JTmdE1S7SfO
X47MYhPRlWzYTp1zl5zLQTVjpnp23yXzOF2+CSqMj9o5sKGBHNM8ucAxYp4dquqU
3JJAGvcNm4AI2IJG1JoNl9N/b1sB/X6CWh4iKSt6VhRI2eDmTmqpCM3bRGs1Tyxh
aTH2ao1KRz/zYYDCPXSYuRiMyQToxAz9XzwOWjS8+gYlbyczNJPte/C0G7ZW4ahL
OhP1iHFEuhv7SMwpequvPxXTP5pbsNdnsFoOt25ENv65DbURa6GeNA31sKuimiXY
cYt8bgAwQ2SkYSTG4qOmtcXdKcbK3nsITjwevRBQ6YoHVcIFurvEN8V4UnS9ATX/
fisUXxqDNTRaB7jCLElh
=RjaY
-----END PGP SIGNATURE-----

--=-MZAPy8ElUCy0yEcmXOrG--

