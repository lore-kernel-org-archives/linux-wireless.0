Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYGYLQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2008 07:16:26 -0400
Subject: Re: question about open11s installation
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?=EC=9E=84=EC=98=81=EB=B9=88?= <ybim@mmlab.snu.ac.kr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <da2e1ddd0807242211n33473f06p74d6acdf75add678@mail.gmail.com> (sfid-20080725_071110_391035_0D41264D)
References: <da2e1ddd0807170905j5121737bia15429aee0f7ffd6@mail.gmail.com>
	 <1216313740.3422.44.camel@johannes.berg>
	 <da2e1ddd0807180151k707c77eeyf31b6ea2948c6ec3@mail.gmail.com>
	 <da2e1ddd0807242211n33473f06p74d6acdf75add678@mail.gmail.com>
	 (sfid-20080725_071110_391035_0D41264D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bz/aivJ0iWDmLdv7YreI"
Date: Fri, 25 Jul 2008 13:16:04 +0200
Message-Id: <1216984564.4758.2.camel@johannes.berg> (sfid-20080725_131629_244831_097AB1C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bz/aivJ0iWDmLdv7YreI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-07-25 at 14:11 +0900, =EC=9E=84=EC=98=81=EB=B9=88 wrote:
> To find the cause I tested whether the mesh nodes send beacons correctly.
> I put a node near mesh nodes, set to the same channel with mesh nodes.
> Then I executed wlanctl(this node's OS is netbsd).
> But I couldn't discover mesh nodes's addresses.
> I'm not sure, but I think that if the mesh nodes send beacons correctly
> the node will recognize mesh nodes, and put them in the list, isn't it?

Have you implemented mesh for netbsd? If not, what makes you think so?

> So there's some problem with mesh beaconing with b43 driver.

Last I tried, it was working fine, and since then pretty much nothing
changed.

johannes

--=-bz/aivJ0iWDmLdv7YreI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIibXvAAoJEKVg1VMiehFY5kEP/iUVvLOGOos9ooMHE6JWEnA2
++31r11wpkPHO/N+AIk1GpVScdFdw4AAwdqurB30hd4RvBh1gqX+f1LEldaSHzu/
MmuBhHd7+1e4y0Yr0dZn0aiu91h+Gnd2BTmQ+XMHRWAZp/oq5ywzPMDlyME58+ET
RRMcN0iGMjSDYgGkP6FQWPaYgTyQvc0AdZdt74c2j739a+joHJ3t6rhY/LHYk+Oh
w4rxbLJrrnCb1SXt2BaUm1HUaNxWlT0N4isYUOdpWy1gAJpahPJrJeNQXaDGpr8A
TPkQxBohAmvIyjbBH1qBzfWgmE0JEMSyOjbFHJoX0fVBQB7PrDQqlckJb9F/21Ab
15Fg52Xo6UfF1IyoPBiWBH6AclSNBLPOdUzloe663x6csTzVMlkelhCZAX4uSfPs
W1Z6IIOFEoHVAjKq737SHJMpFg4heBWRt9F7eT9oS/bE3FkhyHQmQ4Tiu5q5ypxs
d6virf+H7j+B+vniPR5JlHY8WopbTR8CnHMPTMAUHCr2x0qAT0fqdHGJmLpiYTCT
xcqhkItbucdTCbOHY/LnJgUI6rV4WN6ama3bzFT+YNL/Qck75wLtlpX4J+k5eFuK
Nrh93sfAqFiWxZorDjUHueLC7pgWUFf4EW9hm8R4iH8XP3zZqEp0lBAifRF6EDIO
0lLtiQcZFsbaEdiA3g4n
=Lxof
-----END PGP SIGNATURE-----

--=-bz/aivJ0iWDmLdv7YreI--

