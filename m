Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770AbZEDSQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:16:16 -0400
Subject: Re: [PATCH] mac80211: report operating frequency rather than
 current
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Farina <sidhayn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49FF2FE8.8010004@gmail.com>
References: <1241452330.8683.49.camel@johannes.local>
	 <49FF2AE5.6040104@gmail.com> <1241460130.8683.85.camel@johannes.local>
	 <49FF2FE8.8010004@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RqorzNlvNzby+Py+ClXj"
Date: Mon, 04 May 2009 20:15:44 +0200
Message-Id: <1241460944.8683.92.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RqorzNlvNzby+Py+ClXj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 14:11 -0400, Richard Farina wrote:

> Yes, and at what point does it seem like a good idea to hide the channel=20
> the wifi card is on?  If I set channel 11 and it is scanning instead of=20
> locked on channel 11 then I should see the current channel the hardware=20
> is on.  This seems like an aweful idea to me, granted, it may help a few=20
> people that don't understand how scanning works, but hiding the truth is=20
> never a good idea. NACK.

It's not really about hiding the truth. Besides, many many devices are
_already_ "hiding the truth" (to use your words) because they do
scanning in firmware and you never know what channel they're on (e.g.
all Intel wireless hardware).

I think it's completely pointless for us to reply to the question "what
channel am I on" with the answer "currently the receiver is tuned to
132", when we can say "you're associated to a network on channel 11".

After all, we don't unset the SSID/BSSID when scanning either, even
though we're currently not talking to the AP.

johannes

--=-RqorzNlvNzby+Py+ClXj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/zDLAAoJEKVg1VMiehFYj3MP/A34EtOmo9BdUwXkmYZjfN89
zZM9Sk2vu+7jo/FndeY20IiGCdSGRGGUIP5Z4j15Nv3xN2Qm9Rptg5MLyW+3ctgd
PdARBKz1hfD6euOdEm+XzihZjpLyqSawOMN2WVlPUJmfTr6M9pjC6J7sPTWOPpvR
d0uQqxnJ8KgVWvWYvu52bNH+WIluTWPMjboNNljo6ABOl93MrtFHwzFn4givSdup
WBpPDuRk2wQJ8ia8M3cYxqrgG/CPq8Qq/MJVG3phOi3pV4mHIqGe03q4nhVS0E/5
0BS6FzbXBl/RYoeISdoHTTudYFIEPQX4kSkxBbBZjXe1t58OceVeQ1ucGSJTHcU5
kcEjcrnliPhdg+TTV13rR4NFaAhSEUz08qxplwcnC+07hDAm202LCJ9rJrgk3eU2
SRJSALz7hdx4z4yU2mIAbLlNfMtxlzEn4KXYNpA9NYXDioA8xZ9pGKlvv/PGURv7
GEBARABIpvptcJoEH4Z5XmatzWxMgEqprgSumPQcrssMLatRbr9vo1yxL3Ms3hXH
NTa4bDefYtzMa0sK80YyLJadt3ih894KsAVYAaL5DA7ZHlsGPUXW+0aAYiqZ01L+
iTntsBiKCU3TIXfVIBMk/flKPEGz3E18T87HeA+ASJq76a6YDDXO8Ji6ypT1I4iv
lFy2xI2nbJlUTRdLhEhL
=Llv6
-----END PGP SIGNATURE-----

--=-RqorzNlvNzby+Py+ClXj--

