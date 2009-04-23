Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZDWKqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 06:46:06 -0400
Subject: Re: Measure RSSI in adhoc networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Kai Timmer <email@kait.de>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <5b8543210904230336j177998c4m1e0af03fbb3584df@mail.gmail.com> (sfid-20090423_123638_386390_3F8D98D2)
References: <5b8543210904220608l484d0d2dv73b0d66cdc167ce@mail.gmail.com>
	 <1240442334.14995.12.camel@localhost.localdomain>
	 <5b8543210904230336j177998c4m1e0af03fbb3584df@mail.gmail.com>
	 (sfid-20090423_123638_386390_3F8D98D2)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DCkE+aACIFVo/X6F7l1/"
Date: Thu, 23 Apr 2009 12:45:30 +0200
Message-Id: <1240483530.30082.178.camel@johannes.local> (sfid-20090423_124611_128566_7F2B7692)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DCkE+aACIFVo/X6F7l1/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-23 at 12:36 +0200, Kai Timmer wrote:

> I need the RSSI values for distance measurements between the nodes.=20

Note that is very unreliable...

> So
> what i need is not a "quality value" for the whole network, but the
> recieved mW from every reachable point in the network. So i think the
> RSSI value for every network node (if i can print them out seperatly)
> should do the job.

iw dev wlan0 station dump

johannes

--=-DCkE+aACIFVo/X6F7l1/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ8EbGAAoJEKVg1VMiehFYvjUP+wR1nXxsm2BW4YHgUwuRdcGe
xyFGRZcRhytP3H4Sv5v0SRDBVmjehP1Z+nAlMIvq+Yy1BovRR1dQRLQo/5xKx7Uq
6ClxCsMAGF6WAd/pY3plKpbvzYAFiC+E/xmWzgCCYMmPlvswL/BXZzla/AAlhOcy
92Auno4THGqQiZg0vPYbCtQCfeGRf9+nC3xPE+HodNWDR/dA++cHdn7AC2GFDT35
3b4cGmRKVKkofCbejKkLu+gKX5RZKL9CyP6KmkPK8aLlSQEDxybNQxyDng4m5NFV
xvR6R8LDzQfPFCyRmfT3F7C4YuK+r6wKx0m8pdLSdvHad65hS9Wvr0vweLl1vsnA
/HGO6CYHlabbo97RbDw3RgikFKM9qdR7sOjoycsWGHKn3LsK1wfo0iQ4xxEHjS+m
Zwsm6wmj3rwdInEHzYsDvxo8g1W/TITvClUMyoT9ETdgYCzu4/18lZNKOLsEVtCK
Ee+fjzElRxzHtfdvxyE8TqZA4KetSWVtFTZ0xrThJkJ1cTrgX4CYWXX1clmnTdz2
F8/v5wiu8DnrSUhoIM3guO/dduEc+IrYrrmxHeGJp8zMe6kHFZ8iS5qerbaIr2Uc
IdRD7kUI5EPDAJYAhdOn6ByLoPIUEVFpUFWI/iJ/stAUNpPdchChFkikF0SNGD6K
OSuX/KIe8TTeLsPBw/CL
=TcOy
-----END PGP SIGNATURE-----

--=-DCkE+aACIFVo/X6F7l1/--

