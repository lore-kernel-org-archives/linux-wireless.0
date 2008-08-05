Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759614AbYHEP2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 11:28:44 -0400
Subject: Re: [PATCH 1/1] mac80211: filter probes in
	ieee80211_rx_mgmt_probe_resp
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240808050821p1668f54cl9822bf5f82cec49c@mail.gmail.com> (sfid-20080805_172105_813149_346C9431)
References: <1217763121-9057-1-git-send-email-tomas.winkler@intel.com>
	 <1217787259.4721.18.camel@johannes.berg>
	 <1ba2fa240808050014t6e315fe5s607aff1656c1f8d1@mail.gmail.com>
	 <1217927348.3603.29.camel@johannes.berg>
	 <1ba2fa240808050821p1668f54cl9822bf5f82cec49c@mail.gmail.com>
	 (sfid-20080805_172105_813149_346C9431)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vLHyW8/nZW4i8WP1Chto"
Date: Tue, 05 Aug 2008 17:27:45 +0200
Message-Id: <1217950065.3603.48.camel@johannes.berg> (sfid-20080805_172852_787580_9870171A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vLHyW8/nZW4i8WP1Chto
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 18:21 +0300, Tomas Winkler wrote:

> >> Probes are filtered on destination address not on BSSID, to exclude
> >> probe responses not directed to the station.
> >> bss_info treats any BSSID this is what creates the bss list after all
> >> if I'm not mistaken.
> >
> > Eh, right, of course, not sure why I got confused there. Still though,
> > adding a few lines of comments would be nice. If we did that every time
> > we changed a function, we'd have documentation for all functions in no
> > time ;) Oh well...
> >
> I agree, I haven't added any function in this patch so I'm not sure
> it's appropriate to add comments within this patch.
> The statement I've  moved is already commented.
> I can comment the function in a different patch.

Works for me, I don't really care too much either way.

I'm just thinking that when we change behaviour of a function or similar
we could take the opportunity to document the (new) behaviour. Not too
important in this case I guess.

johannes

--=-vLHyW8/nZW4i8WP1Chto
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImHFtAAoJEKVg1VMiehFYppUP/A1N/fKfzdhLxtFvwCw53KhE
vMA0EHnrucGAG4FWpMEW9bQ55vVdTCYRkv1RZR+BK79wq3t3hq7uBkD9bNQrvGpZ
XcLEKG9ff3J75XIoTFoLY9IyiPVfYwxiuYA1FYtY/V4u/tgkisoU4J/x5eCYiCCK
ApMvOP3+PCzL9Jqmhlq1Nn4mKP7BvDcXaw5Kc/dmaErNvRHgfgVfTdU6lYmEoH2f
NHyJkpxf8mMwUCtvfjIcrUDbG3Ms34s9SRya0/h3IK6Vk6ApRUIgQpGligeaOYpq
BY/NqH28YeJKbbxiUU0dH9Av9UtcTChLpt5oRgOdKyFwl0u4+D1pD2YofH3E8GcR
yxrrhhzBz6VWr3nfUMX0l6dQSmYY4q2OwnRtdiZOenyPEI0pUUAXKb4fQDbdO5Ev
wyGp/uYHS+NzCDSoux96oUlI2reSpugV6P6hLRjhOKu4GOQQpM6YQwV0zHu1YQY5
pKh127WMdcTzJTrNKL5NylowVJftCKU9+XGfJcpfZonts6E2VA9f+qi1usKX2Lng
iRep5F+gmH/qzKM8pPrM934YBtV2A8C6fSJfUq96bwPizRvaoFwep2KfPx0LCj7Z
8T1HnoB3zp07aiBwXE5yd56chC5Wn67Gd39fhuGmMrogzUXdo0wJ1o/wjz5tEmh4
nV0N2S6743Zprd73FFEd
=8oOs
-----END PGP SIGNATURE-----

--=-vLHyW8/nZW4i8WP1Chto--

