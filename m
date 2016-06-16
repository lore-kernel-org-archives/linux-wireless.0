Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.glycos.org ([178.62.217.237]:57789 "EHLO mail.glycos.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbcFPQf5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 12:35:57 -0400
From: Ruben De Smet <ruben.de.smet@rubdos.be>
Subject: Re: Intel wifi card + TP-LINK AC1200 rev 1.2 = ???
To: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <59296a1e-7083-a131-ec7c-e1833d4b3c38@rubdos.be>
 <1464069167.30665.23.camel@coelho.fi>
Cc: linuxwifi@intel.com
Message-ID: <df52a5d2-6ef2-d69a-bf54-e4eae3c3c750@rubdos.be> (sfid-20160616_183601_042555_6208E29E)
Date: Thu, 16 Jun 2016 18:35:48 +0200
MIME-Version: 1.0
In-Reply-To: <1464069167.30665.23.camel@coelho.fi>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TsKB7TGtTGr1xeIHARJAB5LWUFsnpFT10"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TsKB7TGtTGr1xeIHARJAB5LWUFsnpFT10
Content-Type: multipart/mixed; boundary="805IMk1wLhwgTJQ3AIHnFMj38B1GA1BLf"
From: Ruben De Smet <ruben.de.smet@rubdos.be>
To: Luca Coelho <luca@coelho.fi>,
 linux-wireless <linux-wireless@vger.kernel.org>
Cc: linuxwifi@intel.com
Message-ID: <df52a5d2-6ef2-d69a-bf54-e4eae3c3c750@rubdos.be>
Subject: Re: Intel wifi card + TP-LINK AC1200 rev 1.2 = ???
References: <59296a1e-7083-a131-ec7c-e1833d4b3c38@rubdos.be>
 <1464069167.30665.23.camel@coelho.fi>
In-Reply-To: <1464069167.30665.23.camel@coelho.fi>

--805IMk1wLhwgTJQ3AIHnFMj38B1GA1BLf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Apparently, this was still in my drafts. Sorry for the delay. I've been
away from home for a couple of weeks, today I'm home for one day, so
I've made the files you suggested.

On 05/24/2016 07:52 AM, Luca Coelho wrote:
> This sounds like an interoperability issue between your AP (AC1200) and=

> Intel's NICs.  Did you try any non-Intel NICs with the same AP?

I have a Broadcom card that I *think* I used it with. But that's a while
ago; I blew that motherboard.

We have another Broadcom in an HP Pavillion, running Ubuntu 14.04. This
one never has problems (on the WiFi. Everything else on that PC is
garbage though. That's why we ordered the T450...)

>=20
> The other AP you mentioned (Archer C2) also supports 802.11ac.  I have
> one and haven't had problems with it (I use OpenWRT in it, though).

Oh, okay, was not sure. Anyhow, I don't have any problems with the C2
neither, with stock firmware.

>=20
> To go forward on this investigation, could you please create a bugzilla=

> entry at bugzilla.kernel.org as described in our debugging wikipage[1]?=

> Please provide at least dmesg and trace-cmd logs of the failing case to=

> start with.

https://bugzilla.kernel.org/show_bug.cgi?id=3D120471

>=20
> Additionally, you could capture sniffer logs with one of your devices
> while the other is having trouble so we can see what is going on.  Let
> us know if you need help with that.

Well... At this point, I do not think I have a device capable of
promiscous mode that's not Intel (and so, failing).


--805IMk1wLhwgTJQ3AIHnFMj38B1GA1BLf--

--TsKB7TGtTGr1xeIHARJAB5LWUFsnpFT10
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXYtVpAAoJEPgmWogSE9wQGfgIAKy0o3/1FcwRWOu7GkByBn/Q
owBxsQ09jQHw1dRUCHFJpGGQL3qyKv5isN4F6DU51HzGxYDwX/enN78seUqrx4TE
WF5zg7vbov9KEQtYbb29s7+mSyn5RjmS9ymn8ikY0RC3KovnFE1tWAaM05p+G0wf
KQfeTe36q6m0kdWmea9L0ZaT4PDlwvAuDv2TUmOlzMhV2b2o9NGP0mdR+715l/45
KllBgZCqJ+pC36+SgY9+DUTbxGQUv05q3Z969Q7RZGJQmgVYQ9AgzDHE2UhgbeEl
8wvOBxMkbwcdZgHBHcWbhSGuOGZ1Knnm+zn/52RN9kRrhGCTpZpXJmy8YN1mLTA=
=npxv
-----END PGP SIGNATURE-----

--TsKB7TGtTGr1xeIHARJAB5LWUFsnpFT10--
