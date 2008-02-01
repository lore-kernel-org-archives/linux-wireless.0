Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153AbYBAWcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 17:32:17 -0500
Subject: Re: mac80211 QoS/aggregation questions, thoughts
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Tomas Winkler <tomasw@gmail.com>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <200802012325.26163.IvDoorn@gmail.com> (sfid-20080201_222551_358338_76D19317)
References: <1201882512.4188.66.camel@johannes.berg>
	 <1201902217.4188.82.camel@johannes.berg>
	 <200802012325.26163.IvDoorn@gmail.com>
	 (sfid-20080201_222551_358338_76D19317)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-n6pr1gD8tdQH/tomR3Dq"
Date: Fri, 01 Feb 2008 23:32:13 +0100
Message-Id: <1201905133.4188.91.camel@johannes.berg> (sfid-20080201_223239_754981_4CD6F54A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-n6pr1gD8tdQH/tomR3Dq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Like I mentioned earlier, ring/queue handling has received an overhaul,
> so not much of the rt2x00 part of this patch will apply after the update.
> However the change should be easier afterwards. ;)

:)
Keep the patches coming. No need to test them in rt2x00.git first,
wireless-2.6 git is pretty broken anyway right now. Due to me,
unfortunately.

> Personally I think these queue identifiers should be completely seperated=
 from the ieee80211_queue
> enumeration, and not be used inside a variable mixed.
> But that will be implementation details for later, and something I should=
 probably take care of. ;)

Yeah, but this seemed easiest for now. We never use the beacon queue in
mac80211 and I believe that we shouldn't because not all hardware uses a
queue for beacons.

> Other then that, the patch is fine with me, but not this patch probably n=
eeds to be respinned after
> my rt2x00 queue and virtual interfaces overhaul.

Right, no worries, I'm not entirely sure about this patch anyway.

johannes

--=-n6pr1gD8tdQH/tomR3Dq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6Od66Vg1VMiehFYAQJHjxAAthmAebWkW4PJg9miULRr8PUM+royEodA
wz3Z4UNHwJ5yf9fkuGMLNTMzZ9BFSeeSxqz48Qo+1cB8tRo3IInEkXqr+NmQ2KDa
ys3giuZGjufX7NGW+17qETdcyj1roOyc63/1d+uQgSpPY8KAsmGPdNpj6o4FBycX
rq47RH3q5SkB6vasJxfk2jfhUm2NCtQXAXIEyoZElBdHlVpD75wbMG+x9QkqW9J+
hgqmjvLqC7FjERIn2VsSY6TGj0VOYT+x9jlPdLp/hFvuhFSSkOGekMqSOXtaznjS
BS1qzd9sGBMDWuJZQm3jHLs7OLG1fjqb9SPXrGmytX3aFp6au0TnRvUD9LIVDljR
4ZfrSkYV5lCttu+QgZ8pJiS3axuBDRmlFOltVs+MVnaGUrh6Vwd1YZkf0VbR4Xgo
c0sbiMLqejC3BlACXMve07UGgx7rfScFRZh7YQ61OpofYLriWTEcoKw5ctZ06Xb6
WEKYOIPidtxt7a7dQ6TJX5cd1NH0lvB63ltn4kmUc72D+QFZ1j7GKdV6cHKIN43x
fqxPUJBK11JbGs2Vi3j1OGWqTm3B4Rv/9odYN6itbemMUbj9itJul7X9BH15mxnA
KP6nGOzGbUdmLQ+HVbQkwSchA8ITEWyl1ZWSaruGgogYxE+vknSDoCAQoigxA/yf
zgqF6zY3Brs=
=JPxv
-----END PGP SIGNATURE-----

--=-n6pr1gD8tdQH/tomR3Dq--

