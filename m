Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbYBHN1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 08:27:42 -0500
Subject: iwlwifi aggregation support and queues?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7lrGhfTl4tkih7HFexpG"
Date: Fri, 08 Feb 2008 14:27:25 +0100
Message-Id: <1202477245.5718.43.camel@johannes.berg> (sfid-20080208_132816_353564_170491F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7lrGhfTl4tkih7HFexpG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I just found that iwlwifi has its own queue allocation scheme
(iwl4965_txq_ctx_activate_free) when mac80211 already takes care of
that. Why, and why did you add code for that to mac80211 at all then?

johannes

--=-7lrGhfTl4tkih7HFexpG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6xYvKVg1VMiehFYAQIgdA/+IM60fJ+8VqQ8mon5l4/h06wEEhQh02sb
xeinztU3DPjonfjMrPNlnKhEYNdiqtC8DDcB7rlcHQX9sdMTdYGgnm2sEpPaUY+3
r0xSGRgzrF3PXfCywM28W4zKK8qnxLOaluGcTFFz4DlBdtQrS0sFjIdxgOh8ZSCG
kG/YsDWkGucPSngx+nF8uZVQAIlkYSOKm06wPFSZ1CyEnnq9Np4bD69WozZZrkEq
ZQPp3tSvxjITfqDEo9v9FnZilObBT11L1aDl/sFKk4AKd12cIoKW6/kWt741+2UO
MCb8mf8mSffwawy7Wq+C9ub5zB2yW3fUDO+py/gqiELE6mxFOGaTX3TJwd9U1s18
AifJeRHmkZW0XTRYxRXZcTEobIyPA01m2qExKUMbJy2MWRkiCFqDuJ/40WnCubZ+
GUc2JqWDQ2gMi6PwYm6y7J7fkGlm+vQKRhUBsRMamSFucFEgtSM6nsmmA8iK8jIY
qWvLMDxWfCqkIq3lgYw4afyjSt0xi81dKXGl1gc/GVdOECspC/szxI4pjiAXYy5d
7bcZQXGu+l9wdTBxgFY3BlAUPXIIzzNiOsD5E1pDGvxwG2JEH0kI6fS9FNKUgiUT
k9x14+aBLJu1wBOh2BlnNtO5+Jje1U0pEouKwtDwKJFOz1b4nXw7qNanfmUBpG5B
jmoOMu3trBo=
=6BDs
-----END PGP SIGNATURE-----

--=-7lrGhfTl4tkih7HFexpG--

