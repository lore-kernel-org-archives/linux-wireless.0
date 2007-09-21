Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:3562 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763189AbXIUUo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 16:44:58 -0400
Received: by an-out-0708.google.com with SMTP id d31so150363and
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 13:44:57 -0700 (PDT)
Date: Fri, 21 Sep 2007 16:46:06 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/5] Add central regulatory domain agent - Patchset I
Message-ID: <20070921204606.GD31768@pogo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Patchset I - Add central regulatory domain agent

This is patchset I of II which adds a central regulatory domain
agent onto the wireless subsystem. I've split it into two patchsets in order
to introduce the agent before affecting mac80211 drivers. This allows work
to continue on the central reg agent independant of mac80211
advancements.

Patch series I adds the central regulatory domain agent and
integrates it with cfg80211. The central reg agent consists of 2
main modules:

* ISO3166-1
* Regdomains

Additionally, changing regulatory domains can be acomplished through
the use of a new configfs module which will be introduced for
the wireless subsystem.

Patch series II will add support for the centreal reglatory agent
onto mac80211, remove mac80211's simple regulatory control and and=20
replace each driver's own regulatory domain implementation with the
central one.

  Luis

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG9C2Oat1JN+IKUl4RAikPAJ0dvfSpCgNRQPzBkdzzAEOQGwPBzwCePtbp
3OdRtLvcA4lO/dOl8Oic5Mg=
=6/aK
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
