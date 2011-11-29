Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:50195 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab1K2NwM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 08:52:12 -0500
Message-ID: <4ED4E388.5060301@allnet.de> (sfid-20111129_145217_546472_984CD20D)
Date: Tue, 29 Nov 2011 14:52:08 +0100
From: Daniel Golle <dgolle@allnet.de>
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v1 0/3] support for antenna configuration profiles
References: <20111128161225.GA25430@localhost>	 (sfid-20111128_171757_078893_7ACF616B) <1322499145.4060.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1322499145.4060.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/28/2011 05:52 PM, Johannes Berg wrote:
> Can you remind us what it is you're trying to achieve? And why it can't
> be done with the antenna selection API today?

I can implement antenna configuration profiles in hwsim or try to get an
ALL0258N hardware sample for someone, given there is a need for that.

Cheers

Daniel

- -- 
ALLNET GmbH ; Maistr. 2 ; D-82110 Germering ; Germany
Tel. +49-89-89422222 - Fax +49-89-89422233
http://www.allnet.de
email: Daniel Golle <dgolle@allnet.de>
Schulungs-/Veranstaltungsprogramm: http://www.802lab.de<http://www.802lab.de/>
Geschäftsführer: Wolfgang Marcus Bauer
Handelsregister München B 95922 ; UST-ID-Nr. DE 128214294 ;
St.-Nr.117/115/00164
WEEE-Reg.-NR. DE 13101093
Bankverbindung:
Sparkasse Fürstenfeldbruck KTO: 2774594 ; BLZ: 70053070
Swift-Code: BYLADEM1FFB ; IBAN: DE61700530700002774594
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO1OOCAAoJEDy9cKN/1Et0bn4QAKjBz7EDTkXnrf9VGA25ClMT
92zTmqJA5WDd75YZGw106o9JxjVWMJ4asK0L2+sLKEUlqJnFu/FpQt1bov8zmxT1
cyEbKRwAetSsaDcgH/v27orhdTusdN1ZhZR/Wv+Gpi+wTsfXfIuDJR8OcJvjPvl8
Bpl5eIWXVs0eMRzdCVmmZksgW7yClZnt/Y4cuda6nNuh/8H5D8XYtR/7i6lQIjGg
vJzfBgsYSya1AhF2yF1LBi7/getp+CK9Meo6qHRa8/CtVLIzOfLxaQ8ObZh7WVfT
PO6Nrw5kL8HkVmwve0W2I4ieNQJJVANe2N5CWpf5Lk4vEjSf38/r+7EXXOtu0bdd
LhyKKQzAhFzp0hEmIgcClSud9n6hbmBOWdkLXeUIbXShm5vddEmXs3Rqzv4UorSQ
4teU7xE4buNOnA+yzE3BUHkdRiVZK3k+iXmnU1sXVMx2ovMAVHa3TKr5yTfdz/sc
ByXC3m1TL/EiY5jzmAbhMfmhKiO/mQcRsBBdHqDFVBMNUkkPO7nFeV3Q3kxhOAOi
qZY09LBoqSd/sITy9BHa4zgLun4dj68F5//cTdOG8KnoOItV9btkoe55e2CvPHmf
6gC6XnNwojsUOc/FlneK9VHWmRs7/kWKJAed9UgPR0IXCy6q7yieCBKJfXx1ku9i
RCzIbTm7jb0YysL+X5Ml
=YIlR
-----END PGP SIGNATURE-----
