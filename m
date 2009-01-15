Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:58772 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbZAOSFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 13:05:13 -0500
Message-ID: <496F7A5E.5070008@linx.net> (sfid-20090115_190518_612035_564EA04B)
Date: Thu, 15 Jan 2009 18:03:10 +0000
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb updated 2009-01-15 (was Re: wireless-regdb updated
 2009-01-14)
References: <20090114162250.GC3854@tuxdriver.com>	 <200901151011.23147.helmut.schaa@gmail.com>	 <20090115134928.GA3241@tuxdriver.com>	 <1232031893.5839.0.camel@johannes>	 <43e72e890901150954t4bc9a390x43a30f287b609173@mail.gmail.com> <43e72e890901151000y4dda530aw96e76f68b72c3fd4@mail.gmail.com>
In-Reply-To: <43e72e890901151000y4dda530aw96e76f68b72c3fd4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Thu, Jan 15, 2009 at 9:54 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I'll set CRDA to pull this latest file upon building too by
> default.

I'd be pleased if that wasn't the default for make all. We explicitly
separate fetching sources and compiling/installing. (And sources are
hashed to confirm integrity)
Otherwise I'd have to patch that out of the Makefile each time.

Regards,
Tony V.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAklvel4ACgkQp5vW4rUFj5o7HACdGL9yjyQn8g6h8KTq6Lqd0QDZ
M+kAn3wMEgvZYBZvDd2jOE1lwSNkHcAx
=wUxW
-----END PGP SIGNATURE-----
