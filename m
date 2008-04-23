Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:43913 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYDWVg2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 17:36:28 -0400
Date: Wed, 23 Apr 2008 23:36:25 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Chris Hallinan <challinan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: iwl4965 regression since 2.6.24
Message-ID: <20080423213625.GE4783@ics.muni.cz> (sfid-20080423_233705_377209_E0648A0C)
References: <20080423124105.GA4783@ics.muni.cz> <c4aed99f0804230916h7eeff631ub4bba502844aebdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <c4aed99f0804230916h7eeff631ub4bba502844aebdd@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 23, 2008 at 12:16:34PM -0400, Chris Hallinan wrote:
> I tried associating manually using the AP address itself, to all the
> cells I could see, but could not get past the "Link Quality: 0" issue=
=2E
>=20
> Windows XP on this same laptop connected immediately and worked. :(

I found out that iwconfig wlan0 ap auto (which according to the man pag=
e
should reassociate with the strongest AP) does nothing at all.=20

It seems that once associated with AP, the mac or iwl4965 driver (do no=
t know
which one) is unable to associate with a different AP.

--=20
Luk=E1=B9 Hejtm=E1nek
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
