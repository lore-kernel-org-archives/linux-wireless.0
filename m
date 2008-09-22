Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYIVPTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 11:19:15 -0400
Subject: Re: [PATCH 1/1] mac80211: fix led behavior in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240809220812v2d91bb18k4b78072fffd85e2c@mail.gmail.com> (sfid-20080922_171209_006069_187D1529)
References: <1222092610-25374-1-git-send-email-tomas.winkler@intel.com>
	 <1222095543.3023.83.camel@johannes.berg>
	 <1ba2fa240809220812v2d91bb18k4b78072fffd85e2c@mail.gmail.com>
	 (sfid-20080922_171209_006069_187D1529)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KuIrDMv3lfOT7HnlETrw"
Date: Mon, 22 Sep 2008 17:18:29 +0200
Message-Id: <1222096710.3023.85.camel@johannes.berg> (sfid-20080922_171920_110117_4284C0F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KuIrDMv3lfOT7HnlETrw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-22 at 18:12 +0300, Tomas Winkler wrote:
> On Mon, Sep 22, 2008 at 5:59 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2008-09-22 at 17:10 +0300, Tomas Winkler wrote:
> >> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> >>
> >> This patch fixes the led behavior in IBSS. After we joined an IBSS cel=
l we
> >> need to inform the led that we got associated. Although there is no 80=
2.11
> >> association in IBSS mode, the semantic of "There is a link" is relevan=
t.
> >> This allows the led to blink in IBSS mode (at least this solves a bug =
for
> >> iwlwifi).
> >
> > Doesn't it also have to be turned off again at some point? Or is that
> > done? Other than that looks fine to me.
>=20
> I've asked my self the same question  the answer is not clear. We
> switch the led off on close/ifdown by radio led trigger.
> Note in IBSS is always connected, carrier is always on if I'm not mistake=
n.

I think you can configure it off though, by setting the "essid" (oh how
I hate that) to "off" or something? Not sure, and we can always fix it
when we see the problem, I don't really care much about the LEDs, I
don't have any.

johannes

--=-KuIrDMv3lfOT7HnlETrw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI17dBAAoJEKVg1VMiehFY/QYP/A0XyRONv8bL2ugPfPBqyQCx
W5fLAD4BUfJHPCbmPVonGlAytNBSIkR4onGY3DtuJl4/ocCyuUkuWUovQDQ8GYOO
F4vW4pOtAAAT3RaRM8T744rydDZL+ysiCI4Bia2/xRTqAgrERDJxlFDcTEWORdEO
MxGmy9wgBVlenmvnEZ1rHIvEDwow9JVWnvB+ND0Di0IDmm+6VxQagB65yo1fjixp
l+cK12d3PhJRIFexcR7MWaJGU3tzUl0InIJPMBrv57QUSua89AKvKfDylLf7qL+R
K9ALWTHLJHeh8hgeyxzyw6v6hWhcOx8b+DLowDv4kagg56CJmmYpUhYn0RnEHEvC
1N17QanFGwtupxfq0pahpYKQSSjx+fsNwxa5zA+3HDdEpBOSxUNgyonFLYhdksFc
P7hOfaQAoOQciawhbM8M/7hb1XXzqgnJJL6aTAPzyRxoHxiVMO8XgEF6zG3EXqo4
c9PjZ0CUmggMW/+7uWiaMF5GLRCxVQvABVsNK2J95ppDtdW4ERHX+kqRmfk6PpQv
lMCC6lLKvHlpgfi8dpiSf5v/QZnREoxt48+dDRByecm3htQi70WFDOwBr4Px5O1c
qUS/p2qCHoe0N8qf986gATStMYsgYnPYa+wI/mjDQ0+4pfaKdxhvxWmx+CjxnnU1
1ItsApwNkDkM3WRZwYkq
=sC0u
-----END PGP SIGNATURE-----

--=-KuIrDMv3lfOT7HnlETrw--

