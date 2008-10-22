Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYJVH1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 03:27:42 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@linux.intel.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224628088.10863.100.camel@rc-desk>
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y1MnVftgBK9Us5GIuYak"
Date: Wed, 22 Oct 2008 09:27:29 +0200
Message-Id: <1224660449.28639.22.camel@johannes.berg> (sfid-20081022_092745_596645_066B9B73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y1MnVftgBK9Us5GIuYak
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 15:28 -0700, reinette chatre wrote:

> I do not believe our request is unreasonable. If a user runs a new
> kernel the log will print a message that the firmware is incorrect ...
> all the user needs to do is go to
> http://intellinuxwireless.org/?n=3DDownloads and download the latest
> firmware.

And that exactly _is_ a problem, the user may be relying on wireless
connectivity. And they won't know up-front they need new firmware. Since
firmware is loaded from userspace, you're breaking userspace/kernel ABI,
it's pretty simple really.

I really don't know why we let you get away with this and bitch
endlessly when b43 does such a change, to the point where we finally
cave in and support both versions. Why should a community-supported
driver be held to higher standards?

johannes

--=-y1MnVftgBK9Us5GIuYak
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/tXdAAoJEKVg1VMiehFYKX0QALdsZDCMQw8284UPBW6L1nZV
mxxCYDYjRERhoEWuItDar5XA4tYWgPZgfrkHYJqKfQ+0FXkLW0CNQntND/VlpwNq
nYk2p+bLcDbkBlkQ7BznXqWAXTv+keiUdl/uFXmLQEfH0vqpwPmfCZg5c9xOOr6k
LNNhpkxb9PH8lEX50Q84pFvDwRMtnWE1jc5VJ/YZql3SKDMaS+PXcIQ6BKh5jkEp
dpyTp+COh1EWkEOuLogUa8FgmYsusB3aD1Qz6L4C+/DR+1pohjh5+PiQy4PH5NKc
F5jyVNG30Kq2ACDsRWNy3NZb9GK0F2rZW4N+FrXfYopH3dadfGky2LTxVwvrNyCW
MJNqdnxovSk+VCqyXrSou+3n8srct4Ne6bKr4cx2qxKOWHC1f2I92WElpwiVxyHx
8lQik+YLY24WGZcPuMjtjK02t/bbqitSCc/k4nr4d37a2yfr4guL9tNo0KlrcffX
5e8+X2EPR0+A2IruVnh2De9VxSF7xJUANqQ6L83Mg8rZeHawI50B4DBSiADgaj9m
arO4yQ3uZVyPh5Av2gL6fm5wCKd/8BYXFkwUG3L7O8VTG53nygEYXwfUU6eenoRN
DgkdvksUda+8pMuea6+65/yRHG12VTTfgJ8mj7EJn9/Nv7ksxLluy95HOoE3WCty
Zgu969wYC2Z/SpwCpWHm
=k0F+
-----END PGP SIGNATURE-----

--=-y1MnVftgBK9Us5GIuYak--

