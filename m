Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYFXLUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 07:20:06 -0400
Subject: Re: [PATCH 3/4] mac80211: add last beacon time in scan list
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1214305753.12270.5.camel@localhost.localdomain>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
	 <1214304433.8967.277.camel@johannes.berg>
	 <1214305753.12270.5.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TKeu45gYZ0YxZZ6uc7bg"
Date: Tue, 24 Jun 2008 13:19:16 +0200
Message-Id: <1214306356.8967.285.camel@johannes.berg> (sfid-20080624_132018_558236_713C1893)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TKeu45gYZ0YxZZ6uc7bg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-24 at 07:09 -0400, Dan Williams wrote:
> On Tue, 2008-06-24 at 12:47 +0200, Johannes Berg wrote:
> > On Tue, 2008-06-24 at 13:38 +0300, Tomas Winkler wrote:
> > > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > >=20
> > > This patch adds the interval between the scan results and the last ti=
me a
> > > beacon was received in the result of the scan.
> >=20
> > Why do we need this?
>=20
> Sometimes it's nice to see when the beacon was last seen, since the
> driver holds onto BSSs for a while, you don't know how long they've been
> in the scan list.  If you only cared about the newest BSSs you could use
> this to ignore certain APs from the scan list.

Well, but you can't really do it in a program since it's a custom type,
or you'd have to parse this.

> Would be nice to push this attribute back with nl80211 as well.

If anybody ever implements anything there...

johannes

--=-TKeu45gYZ0YxZZ6uc7bg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYNgwAAoJEKVg1VMiehFYsyUP/3NDh3g9456+xG3MvFttgUiq
tghOiZk56wWe2/ozKiKnm7H4qX2YjADOloDfu9oHYugM1bULMyUiKIwI3UHAt6s2
flaTHbGqNWx7Xg51mMaLSxx62p+SLFEl4Z94P62Ae97Z3QnQWMYIie6uU14N9xPH
PlDClUknnVem2vUA2ghKg7oIur8/ZteQpJew8M2plfXruwBfccfABAoMEGxRjTIj
X/YPPwY6g7BJe4mgv9lUBWlcLAuUbl6Mtn/TfckOb9Zj5EBXMZaA4Q2h1sonbyy7
ya6x/ZV+sCHB5TEyFvD7qRRHwKn15uKA3nzJeSiPXlhf4zjPF2igUDa3u3l2LCZj
psfSXMLhxo35eYb2F9jVoaKjA5RNwgzFjq7PnawnFw7uYE2zwHPecxShLDt+0WdY
Na3sq7d+OdmdTsJwIgZj16qqpD8exkMCEflHTm6jRCKBZ4SLa48XdWb5ODkFHw0T
PqxEcwJ0tffZOA8P54YPtLXsZh24cdJj/qJnIc2VgfKYIJMcf/EmjoExUPfN696a
fjfheeQx97KOJAsKYt4Jg/zzuMmS8+MWtiSNm2+v/PkP5hZUZ2xl0+JBe6gGjM0p
NSIfG0/mrXIeCg06rCBwPNL91CSDsUi4Nlb1d+SSuqPo3N+gMSFH9j+oB7/jjFw9
LuOGQiC1ZhIhFClq5/+6
=Xhk+
-----END PGP SIGNATURE-----

--=-TKeu45gYZ0YxZZ6uc7bg--

