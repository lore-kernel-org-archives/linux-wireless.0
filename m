Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:21828 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3LAJkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 04:40:14 -0500
Message-ID: <529B03D9.5050402@open-mesh.com> (sfid-20131201_104019_520506_2127C1CE)
Date: Sun, 01 Dec 2013 10:39:37 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Antonio Quartulli <antonio@meshcoding.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH mac80211] iwlwifi: don't install GTKs for IBSS vifs on
 resume
References: <1385846658-2294-1-git-send-email-antonio@meshcoding.com> <CANUX_P3tm+Q4R6NNLchtCZCYGxrs-Z8hahp1YrvF_fCbCFavig@mail.gmail.com>
In-Reply-To: <CANUX_P3tm+Q4R6NNLchtCZCYGxrs-Z8hahp1YrvF_fCbCFavig@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/12/13 09:39, Emmanuel Grumbach wrote:
>> +       /* Group keys for IBSS interfaces are not stored in HW
>> */ +       if (vif->type == NL80211_IFTYPE_ADHOC && +
>> !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) +
>> return; +

Well, my knowledge about WoWLAN is really poor (in particular for what
concern IWLWIFI). I think I should have sent this as RFC first.

So isn't it possible to reach this point with a key that satisfies
that condition? If so, we are fine :)


Cheers,

- -- 
Antonio Quartulli
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlKbA9kACgkQpGgxIkP9cwdLPgCfbzHDFGPl73p/a+d0Tf2nEt3t
iPwAmwTxQLYqb9fji3Ld58vgXdsl/Yrw
=sgjH
-----END PGP SIGNATURE-----
