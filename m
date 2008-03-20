Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbYCTKMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 06:12:09 -0400
Subject: RE: [PATCH] iwlwifi: prevent tuning during scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: "Abbas, Mohamed" <mohamed.abbas@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <33E1C72C74DBE747B7B59C1740F7443702FFB902@orsmsx417.amr.corp.intel.com>
References: <1205970201-22241-1-git-send-email-reinette.chatre@intel.com>
	 (sfid-20080319_234534_228497_EC4DD4E8) <1205971612.16475.87.camel@johannes.berg>
	 <33E1C72C74DBE747B7B59C1740F7443702FFB902@orsmsx417.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qcV5gKtTuLAPye82eQdX"
Date: Thu, 20 Mar 2008 11:11:44 +0100
Message-Id: <1206007904.16475.97.camel@johannes.berg> (sfid-20080320_101216_601687_B1E90AFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qcV5gKtTuLAPye82eQdX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-03-19 at 20:46 -0700, Abbas, Mohamed wrote:
> We can not call any host command that change active channel during
> scanning. Actually we do cancel scan if config callback was called
> during scanning. So if a user tried to change channel while scanning
> this patch will delay the channel change until scan finish, this is the
> same behavior as sw scan.

Ok, nothing against the patch, but please resend it with a proper
subject.

johannes

--=-qcV5gKtTuLAPye82eQdX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+I4X6Vg1VMiehFYAQJHjxAAkEnhdkcvJwy/gVjJawK64ZDIrT8BlYF9
RnOeCMPjPjaL4lbwPkQFuo54F7mWXz+cSIJjCGHOn4cOqZ0NaBy1W/u9dn2TQa/J
cDJUd8ZOhdxzbZJXCSYM5WS5eSFhyrFcd3pZ6r9bldxjdz8hpEPzZ9lzyUcq3YhE
UpbIJ9qzbEbCNT1MexGgZN8yS57HKHWOIACG/2AosJaxdjFytrcUTOzTZ/SxbTPA
yqCo1YFFidkJ0Iz5KPE1ShCa+BAzHTDEnKG6vLst/rXoG5Prro15Sibq4ARQ9cxa
ZwcVulTid3ULxqotuLq5gnmdKzUdhV+3gMWSqLjKr7xCWtJdrVwxLmAZe5GFznZ+
qjn8C7uiKHK11//d+yPRaIlp2pKGLUdqWR7os3jy9ACfFGDSW9lbreDZSgx6Jq+Z
irMOTNciaLz361Dpt2g/AFm1Notf2lk76ea6ulW/+xU1ne/lGbUVtocNatqcBsr+
K4WIYJJ1p3e/ssJS0EEJrpwSQHN9qxrR90pG+v8lj5gYl9aCHyz7FSNmcUtjCOjZ
iOmb6UyErF4Bm+lgrFBM4leY3HqxFIxm0YGR4NEdHqaWKXDVPqiuXjhtLc0IZzuK
xhEwyu52Qxn66LDu9GzuX8pbA9yFlRyKSpWNTNRvG9B3/hsiMGNQN3iEC7C7JmnP
Qu01MJXdyPE=
=XhWb
-----END PGP SIGNATURE-----

--=-qcV5gKtTuLAPye82eQdX--

