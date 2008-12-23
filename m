Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYLWUag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 15:30:36 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	mabbaswireless@gmail.com
In-Reply-To: <20081217174244.M36761@bobcopeland.com>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <1229336057.4471.9.camel@johannes.berg>
	 <1229354532.12163.24.camel@localhost.localdomain>
	 <20081217174244.M36761@bobcopeland.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ergYgXb5KP8LVtI+kz9h"
Date: Tue, 23 Dec 2008 21:30:16 +0100
Message-Id: <1230064216.31228.46.camel@johannes> (sfid-20081223_213039_150741_3B12BD9A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ergYgXb5KP8LVtI+kz9h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-17 at 13:21 -0500, Bob Copeland wrote:
> On Mon, 15 Dec 2008 10:22:12 -0500, Dan Williams wrote
> > Could be udev event ordering?  We do need to track this down, otherwise
> > stuff simply won't work when we come back. =20
>=20
> Sorry for not following up on this so far; I don't usually have a lot
> of time on weeknights.  I haven't done any exhaustive testing yet but
> so far, I don't see anything having to do with networking in udev=20
> monitor, just input, cpus, and virtual consoles.
>=20
> logs here: http://bobcopeland.com/kernel/wl/ {udev,dbus,hal}.log
>=20
> Running pm-suspend from pm-utils directly also triggers the problem,=20
> so that would seem to excuse gnome-power-manager at least.

What's the status of this? Should I look into things a bit?

johannes

--=-ergYgXb5KP8LVtI+kz9h
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJUUpVAAoJEKVg1VMiehFYD1QQALr9JgHXF8lV8dmPlbxLCpxH
8vumhnh/nJRw+CLYpYCUslCQmhRnZ8+VPMxeyg6ii8DuvFLNPz636sGHMUTEEumT
COEZY6BReALHm0lfrzsOtOT7xXo1xaJJ0rJoCWV+mqgzkg+ib0nIfmwOJZImnuZJ
cD+5179rZXd1qqk4+Ib/nZ2dqSAq217MQFHzIladVppj/Bw2HFDMEkRa9obz30WN
OOeJXAmIHwLGH5u890US7nukdaXiO2XW9hbzBoyB+ZBERtxq+Mkz2UrKwXPMsOW2
Gd4a3/4i25O3Vep4N9FM12Rc6DQJzUxV1ekFoFaoSXTm2rOBXGjkrOuc7gvLLoFQ
+7tJSwuATWnzs/X37ugvYWMg+C7CU2SKlu5rFt/OP+o8PCT9QwmIV4yhz0EViU6d
gHCXu838aVq1DZUpua5pH2LrK+gUSrtNGneJFRqNUirYS0n3lgocQTRE7hP5XMHH
C9FoQHjBodWNEv18Uf1hcmnTTI5kH4y9nQ9w25BuR0yis/WKm26J7e+qY8EKLLz7
+gHlpqfC3MmTicE9qy0nGx6LaY1AaGx6H6Dzs3yG4DWF/DnhrtLCob88W/EVtfUO
wx4+q6dkjFtyJu2wPI1Gw5JMIIWj6LQ+ZVJQvBZ9ITYsf/EU8ol2cjykVUPC3xDZ
DYWhx38tik4bK6YAT5tx
=cH4Y
-----END PGP SIGNATURE-----

--=-ergYgXb5KP8LVtI+kz9h--

