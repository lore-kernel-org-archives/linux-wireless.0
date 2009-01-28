Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZA1Vgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 16:36:35 -0500
Subject: Re: [PATCH v2.6.29] iwlwifi: clean key table in
	iwl_clear_stations_table
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1233177944.22831.10.camel@rc-desk>
References: <> <1233164310-22770-1-git-send-email-reinette.chatre@intel.com>
	 (sfid-20090128_183539_794013_573635C8)  <1233169537.16048.4.camel@johannes.local>
	 <1233177944.22831.10.camel@rc-desk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9HGXMfUkz9ea9qjg/Yea"
Date: Wed, 28 Jan 2009 22:35:54 +0100
Message-Id: <1233178554.16048.50.camel@johannes.local> (sfid-20090128_223639_728828_7BEE2B51)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9HGXMfUkz9ea9qjg/Yea
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 13:25 -0800, reinette chatre wrote:
> On Wed, 2009-01-28 at 11:05 -0800, Johannes Berg wrote:
> > On Wed, 2009-01-28 at 09:38 -0800, Reinette Chatre wrote:
> > > Cleans uCode key table bit map iwl_clear_stations_table
> > > since all stations are cleared also the key table must be.
> > >=20
> > > Since the keys are not removed properly on suspend by mac80211
> > > this may result in exhausting key table on resume leading
> > > to memory corruption during removal
> >=20
> > Just FYI, this is fixed now in mac80211.
>=20
> Sorry - I missed this. Could you please point me to the patch?=20
> The problem was encountered in 2.6.29-rc2 (see
> http://bugzilla.kernel.org/show_bug.cgi?id=3D12415 ) and I would like to
> know if this patch you refer to is included there. If so then we have
> another issue.

Sorry, my mistake, the patch to fix mac80211 suspend/resume is in
for .30.

johannes

--=-9HGXMfUkz9ea9qjg/Yea
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgM+3AAoJEKVg1VMiehFYMnkP/jNibaaTdHn01JmCZA92/TvC
H5KQrCusFGM5D5FQHLLQhmzURR9GwP+OnbUEOpvbsiYK4WTJ28JBVfJ1xw2Rvfr6
p9ZEUfm04fzVZpz1vGrHq+k6uYpHAWEUtZez5r7ysFlPewIfGbjI7Mv1vtyRlnKN
DU0kZIoGsL03p8U1xk7Cbod8bKLUaKJ1vsFJFfF2mdCaN2pGiUFKeUTmNtNWD9of
1ialw6w9VFdd/rTFFp3YFxGKGAeMS0vzFNxlDuEgH8IV27y+WxzFnT3Ej8jGUTpt
pmPMLPWlF9/+FR+4VCAsxEdW8iDoQ37fXn3+9wY+cRyyjW1TnZuJxeSNBef7OVRi
HDYNeUfBjNOVJUPC4X3vraGOS7oxkXgUUdquIzVLJL6hUyTU/mXZxA8FPNq7FzZy
9dBh1eqaa1ifhD4OPUZenWrS71SNmdthP5ts0v7hfTZLjczvM8fuxg6b0iAGu7Jc
2czg2XFSejhV7pJzKcsjUC6pylkaiXJsvWl6F/YaVTBkbQOw7JRSQ0cks74ufXAi
gYJ0bMNS+PRIMi9hdW5YbREj4TgLHSMDAUuXGA/RP5KksklrD0tGbqKXLmHldH/X
ktUd1BcspHhsELF621/SkOy0ePGdkEMpF694o7VLbJ7oyPn0ClTNlSSVpWu0711W
284NKTFi/g7ysaeNYlDB
=ZLDJ
-----END PGP SIGNATURE-----

--=-9HGXMfUkz9ea9qjg/Yea--

