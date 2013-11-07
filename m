Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:43671
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab3KGTqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 14:46:54 -0500
Date: Thu, 7 Nov 2013 14:46:41 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: future of prism2_usb (aka wlan-ng) in staging tree
Message-ID: <20131107194641.GE12612@shaftnet.org> (sfid-20131107_204702_973727_46ABDC15)
References: <20131107160522.GA12612@shaftnet.org>
 <527BC04F.2080000@lwfinger.net>
 <20131107163719.GC12612@shaftnet.org>
 <20131107175201.GA2002@tuxdriver.com>
 <20131107185714.GD12612@shaftnet.org>
 <20131107191122.GD2002@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
In-Reply-To: <20131107191122.GD2002@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2013 at 02:11:23PM -0500, John W. Linville wrote:
> And all of which were nominated by someone (possibly me) to be shuffled
> out of the tree due to lack of users and unknown functional status...

Heh, fair enough!

> I don't want to discourage anyone from working on something that
> scratches their itch, especially if you have working hardware and
> some users.  OTOH, I'd rather not add a long term support burden to
> the kernel if nobody is going to use it...?

On an average month the linux-wlan-ng repository I still host gets 3-4K=20
non-spider hits for the USB firmware files, so in this particular case=20
there are still users out there.

At this point it's a more modern driver than the ones already in the=20
kernel, and I'm willing to maintain it if there's a point to doing so.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQFSe+4hPuLgii2759ARAoW4AJ9TewYar7XOO3SF1rQ4a2L+ulk6cgCg3053
4QvVyAmkvNOczE6ijDFOxKg=
=mZwV
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
