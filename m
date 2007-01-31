Return-path: <wireless-bounces@tuxdriver.com>
Received: from sipsolutions.net (Debian-exim@crystal.sipsolutions.net
	[195.210.38.204])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0VKxJEt012136
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Wed, 31 Jan 2007 15:59:45 -0500
Subject: Re: [RFC PATCH 2/3] wireless: move wext to net/wireless/
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070131144027.GA9579@infradead.org>
References: <20070131013717.GA28076@tuxdriver.com>
	<20070131013840.GB28076@tuxdriver.com>
	<20070131013943.GC28076@tuxdriver.com>
	<20070131144027.GA9579@infradead.org>
Date: Wed, 31 Jan 2007 20:00:28 +0100
Message-Id: <1170270028.2236.3.camel@johannes.berg>
Mime-Version: 1.0
Cc: wireless@lists.tuxdriver.org
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0112885471=="
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com


--===============0112885471==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-DfXVNSL29HR9ao3DRoag"


--=-DfXVNSL29HR9ao3DRoag
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-01-31 at 14:40 +0000, Christoph Hellwig wrote:

> Is this the right name?  Shouldn't it be wext-ioctl.c given that
> we'll hopefull soon grow a wext implementation with a proper method
> table interface for drivers.

No, wext is dead, the replacement is a mix of cfg80211 and nl80211.
Besides, wext isn't strictly ioctl-based, it does netlink too (but just
puts the ioctl data into netlink messages and has the same braindamage.)

johannes

--=-DfXVNSL29HR9ao3DRoag
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFwOdM/ETPhpq3jKURAmQhAKCofz2fwYU59gvN90rpR27J0356WgCfVX1X
pvBhKqR93UGpOT2bBHOcUEc=
=17ke
-----END PGP SIGNATURE-----

--=-DfXVNSL29HR9ao3DRoag--


--===============0112885471==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============0112885471==--
