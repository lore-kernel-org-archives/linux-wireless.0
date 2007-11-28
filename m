Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbXK1Qua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:50:30 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <474D75D9.7070908@gmail.com> (sfid-20071128_140610_137750_1485A343)
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
	 <20071127033408.GB5698@jm.kir.nu>  <474D75D9.7070908@gmail.com>
	 (sfid-20071128_140610_137750_1485A343)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KDNwmHGgqPMGRmRFxUHz"
Date: Wed, 28 Nov 2007 17:50:12 +0100
Message-Id: <1196268612.6058.157.camel@johannes.berg> (sfid-20071128_165033_398898_CF419B08)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KDNwmHGgqPMGRmRFxUHz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> this does not happen with the ipw3945 driver but with the iwl3945 so its=20
> either something with this driver or mac80211.

I just posted a patch for iwl4965 to make monitoring possible. Maybe you
can port that to iwl3945 and send me a packet dump with that patch
applied where the problem occurs. Or just do it without the patch,
should be good enough too.

Just grap iw (from git.sipsolutions.net) and create a new monitor
interface: ./iw dev wmaster0 interface add moni0 type monitor
and then run tcpdump/wireshark on that.

johannes

--=-KDNwmHGgqPMGRmRFxUHz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR02cRKVg1VMiehFYAQLFmA/+OAlDcJqz+W1uqMlW54+xCFoFqzmH/GI/
hvcqqMRcLCJhTaMWaeq7pya72nuz5xfJb0IiHw4FkMInqiGOAOFBgPwvqyvJLjWx
iAjSQKLFJoaai279boIpk/5GAPXxGyJz5tNq0pStZ3mlBNLo+HFJE+A40nxqiLtc
w79pcuTkZUXOo4J3xt/wFPxi4eC0OVmLiDwEBe0EN6HqYypKaEB1jCgLgjnmhrPb
nZ6H5hbDN5kw3xZTV1egbP9PBCDnntaPaaNyVp8E8FeQshpXAPvRRMZzArYNT8k/
X5FW0ooInLWAj2tUl/ZLd9Fw4Pq+8CDrltt/8P38VO2Kn5bWjHCsuGtSXhwzwfzi
VEGdnzZJnBFC+qmhiETEMYvqiNxGlI2bPT3AaWs3gYc0nyxTw0aL/2xqFMGdtmcU
zQJjxPFotbV94xVgXeoYgmN/lE1JEtSJ0IKSqlIKuB2wX2Z7rzjm6sTEeO5/EWgE
umNi/a789OKPf+yX7m6nwd19Eki71ycwd0XMVAs/LWz3zqtyopv65juNyCBa/Bhb
5mjXNX2NxNte2C+uksfllgtcAJYPzhApuKtjlMMsBVaXQ+7UTeflBcMXeCIwyQKu
PI3NeqqMtcHPmEsm0mk5K5xhTeX6uGdDqAZkXOzZ7WWSEY8xnJlo38BY1+RXHxRb
2CRLphYdLeY=
=vk03
-----END PGP SIGNATURE-----

--=-KDNwmHGgqPMGRmRFxUHz--

