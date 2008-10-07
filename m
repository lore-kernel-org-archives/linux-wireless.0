Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYJGQ6B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 12:58:01 -0400
Subject: mac80211 and IEEE80211_CONF_SHORT_SLOT_TIME
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Tomas Winkler <tomasw@gmail.com>, Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chr <chunkeey@web.de>, Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rOeQE3GjZeLoqskGProy"
Date: Tue, 07 Oct 2008 11:05:24 +0200
Message-Id: <1223370325.3778.69.camel@johannes.berg> (sfid-20081007_185810_953941_C2FA81ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rOeQE3GjZeLoqskGProy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I just realised that for whatever reason mac80211 isn't setting the
IEEE80211_CONF_SHORT_SLOT_TIME flag. I'm not sure when or why that was
removed, but clearly it isn't used.

Can you please fix the drivers using it (b43, b43legacy, iwlwifi, p54,
rt2x00, rtl8180, rtl8187) to use the bss_conf's use_short_slot instead?
I'll fix mac80211 to set that appropriately.

johannes

--=-rOeQE3GjZeLoqskGProy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6yZQAAoJEKVg1VMiehFY7b8P/Aw5mydqMkR8/PQMO/7xpwWh
af+vQciCofElSClhDvMX5eih3VJTGCxDqUMsznX+ROre60SzfuRmSdzy8ggZbiNs
/w68ZLfEjuwuh6VLrEsi1BrkwdVrNJzdsr7YVasDCFZBjT+ThCjlHL/y6/lv31JE
xbwfl8rpLcLEED++9G/z3PPzciJzS8VJzDxIZm/RiW0HgDQoGPgZIz0g5eIlbQoc
z44WaAooO+YDRQa/m3REuQsvzjHUXKz6j/INPwpE7/C823Fil4R5P27/SQg71ncO
uAHhoieGeFu+lOz5+WQvs2H7KR1HDKQFvdSy915RKFwmE2VdZ45DKYWWtTRTh0rl
0gIoaQz5ii1c2QlqhgYSYdIcx141gyVu/fzMEusxj86J0mMsZrIlQv83MjVgXSZU
FEz4ga9qBnuAGPrZox6Pa7u9L4bGu6DB7yzlB2HbqdZhYICzuzGwD+Sn1NkWxZ70
xKILAjs7U7dwmjfig7S8ggJF8WhS0MsfVKpyEgjPSpwnSySKrB7sSX0p582AjIg6
tDeUn3CwHrSJGKxkGAD+5dOD4IRRBpOEbFSapAx8wr3gnYSmEC08Ba0t2fVrXWrc
NYvdu/yk46YNPE+MIlo90dyja+Ti28Nc4HPZWgThFMl8ANe84svUmbvojtylmSOp
8jJeyI4cRpBiivaHuHeu
=wN0c
-----END PGP SIGNATURE-----

--=-rOeQE3GjZeLoqskGProy--

