Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173001pub.verizon.net ([206.46.173.1]:40368 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3BVKqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 05:46:16 -0500
Received: from odin.tremily.us ([unknown] [72.68.84.219])
 by vms173001.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0MIM006OSB90KV10@vms173001.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Fri, 22 Feb 2013 04:46:13 -0600 (CST)
Date: Fri, 22 Feb 2013 05:46:12 -0500
From: "W. Trevor King" <wking@tremily.us>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>
Subject: Re: [PATCH] mac80211: Allow drivers to differentiate between ROC types
Message-id: <20130222104612.GA25032@odin.tremily.us> (sfid-20130222_114620_657814_D5E3D7A8)
References: <1361525701-26172-1-git-send-email-johannes@sipsolutions.net>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=EeQfGwPcQSOJBaQU
In-reply-to: <1361525701-26172-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 2013 at 10:35:01AM +0100, Johannes Berg wrote:
> + * operations comapred to other operations/flows.

I'm not qualified to review the patch code, but s/comapred/compared/.

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIbBAEBAgAGBQJRJ0xyAAoJEEUbTsx0l5OMZU4P9Ry/moFuw5aYEoUAMM7t/axw
ZwF76eXHFtmJN6j4MYn51Ec81KSU8LIfOaEo179iMBaXCUdl29eiPglqISrsKpUA
vfXwKS4uYjxtgTs95iP8/twQkxtgOBn/wCnZebrOGMBZhni/aRImCXM4Rf3v7IM1
0KbVa3dk1OZ+0MY7KspZyuDxn5VybogKxblF0DYTvpGrqJ570/NRsWMs3gFOW/bU
BhD4Aha53yTA/zU3HJY9X2+8BHuIJHyXwbuiM372XTQMy7gJo6Q1owi89SHUmbn7
Qx/rSYQ0qmAm0QvhowEvooZ/PCyHy+h3ErX+EHaQJ7D+yDLSMEoGC2pvag+0Alek
iuVK2D4JQ/fmAg+dK54CVB+l6PcqSpQ/XUgNLbte76x3WRJGCOHp0rIXeedAm3VK
tm0AG2KGBoYLu8QW3ShcPvaerZtE9RwCsu75Vf7Qi0xCumc2R/bZH3nQMzviC8OV
nA1DPz9IPgTmCUAcaDk75bWrI510GPtsIOp/8mgZjGPwR8gbzOT4dZfEjDoYOQth
rIp9zQKreO2T/4oMyiLg6SDMqZf7ycHUJXUWepjoKug0Evie0yIW0JuHXBkkm/el
Lrfcys8FHAVhTyYyBEWN5h3vuYlUCfF3lYsJSDcj9XMNV3rNN84RRaFs5ETcwBfk
RQS984awu+u+f4ptEFI=
=F8jX
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
