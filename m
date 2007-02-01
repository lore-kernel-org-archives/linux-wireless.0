Return-path: <wireless-bounces@tuxdriver.com>
Received: from sipsolutions.net (Debian-exim@crystal.sipsolutions.net
	[195.210.38.204])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l11DBgxG013321
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Thu, 1 Feb 2007 08:12:08 -0500
Subject: Re: [RFC] cfg80211 merge
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1ba2fa240701311554i435d28b1x6822803326138cb5@mail.gmail.com>
References: <20070131013717.GA28076@tuxdriver.com>
	<20070131024807.GA7061@jm.kir.nu>
	<20070131182908.13bfc374@griffin.suse.cz>
	<20070131183255.GB8776@tuxdriver.com>
	<20070131202549.5ee47bd4@griffin.suse.cz>
	<20070131200741.GA22448@infradead.org>
	<20070131204438.GB19669@tuxdriver.com>
	<1170277561.2236.6.camel@johannes.berg>
	<1ba2fa240701311554i435d28b1x6822803326138cb5@mail.gmail.com>
Date: Thu, 01 Feb 2007 14:07:42 +0100
Message-Id: <1170335262.17068.6.camel@johannes.berg>
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
Content-Type: multipart/mixed; boundary="===============0223322688=="
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com


--===============0223322688==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-QAHOJhSa29TS8ET3plsT"


--=-QAHOJhSa29TS8ET3plsT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-01 at 01:54 +0200, Tomas Winkler wrote:
> As far as I tested cfg80211 compatibility mode is incomplete. You
> cannot run hostapd over it
> If I recall correctly PRISM2_IOCTL_PRISM2_PARAM and friends are not
> passed to d80211=20

It's a priv ioctl, it's not supposed to be passed on.

johannes (who is getting positively pissed off about such requests)

--=-QAHOJhSa29TS8ET3plsT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFweYd/ETPhpq3jKURAk+KAJ4pjoecJwuRvRy8KXrmQOsSznQpXgCguq6t
GfNncy3bQyiE5Pc494tbGRA=
=QqwD
-----END PGP SIGNATURE-----

--=-QAHOJhSa29TS8ET3plsT--


--===============0223322688==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============0223322688==--
