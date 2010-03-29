Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:40996 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab0C2TPi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 15:15:38 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: CRDA and ath5k with no country code in EEPROM
References: <m3tys0tbhk.fsf@intrepid.localdomain>
	<43e72e891003281645m1da47a1en882df4432733977d@mail.gmail.com>
Date: Mon, 29 Mar 2010 21:15:35 +0200
In-Reply-To: <43e72e891003281645m1da47a1en882df4432733977d@mail.gmail.com>
	(Luis R. Rodriguez's message of "Sun, 28 Mar 2010 16:45:59 -0700")
Message-ID: <m3eij3ym5k.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

> I've documented this specific case here:
>
> http://wireless.kernel.org/en/users/Drivers/ath/#The_0x0_regulatory_domain

Thanks.

I'm not sure how the modified regulatory.bin could work, though:
I really don't want to use restricted frequencies etc. when the
regulatory domain is set to US (i.e. when operating in USA), I only want
to use the extra channels etc. when in e.g. Europe. IOW I should be able
to iw reg set US and get the US freqs only.

A driver modification to ignore the default restrictions (while obeying
the regulatory.bin, on a 0-country cards only, of course) - that would
work.
-- 
Krzysztof Halasa
