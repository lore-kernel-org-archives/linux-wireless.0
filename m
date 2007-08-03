Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765AbXHCJmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 05:42:54 -0400
Subject: Re: [ipw3945-devel] chaning mode only when interface down?
From: Johannes Berg <johannes@sipsolutions.net>
To: Derek Atkins <warlord@MIT.EDU>
Cc: dragoran <drago01@gmail.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <sjmir7yx7b9.fsf@pgpdev.ihtfp.org>
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
	 <1186058047.24230.38.camel@johannes.berg> <46B1D28F.1080006@gmail.com>
	 <1186059192.24230.44.camel@johannes.berg>
	 <f6ca9fed0708020643p53ceedcav76b14814b1b1cabd@mail.gmail.com>
	 <sjmir7yx7b9.fsf@pgpdev.ihtfp.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-be7bS6cSRUi2KMvxgA3Z"
Date: Fri, 03 Aug 2007 11:41:52 +0200
Message-Id: <1186134112.4647.17.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-be7bS6cSRUi2KMvxgA3Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 11:52 -0400, Derek Atkins wrote:

> Well, for one thing in many cases the interface needs to be "up" in
> order to scan.  Also, many times the driver itself will incorrectly
> associate on insert before NetworkManager gets a chance to chime in
> and then you're stuck in a situation where you never get to the band
> you want.

Driver bug?

> Regardless, you should NEVER require a driver reload to switch bands
> and if you do that's a bug.  If mac80211 requires a driver reload then
> that's a MAJOR flaw in that layer.

Have you read the original mail? We were talking about requiring an
ifdown/ifup cycle.

johannes

--=-be7bS6cSRUi2KMvxgA3Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsvhg/ETPhpq3jKURAtzQAKCminhkUkyaUShHUiDjy1lqkkdrJQCbBYKM
Ulg2AzCGuXVdatz6ndo+zG4=
=WQOW
-----END PGP SIGNATURE-----

--=-be7bS6cSRUi2KMvxgA3Z--

