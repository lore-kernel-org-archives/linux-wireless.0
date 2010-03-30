Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:49837 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab0C3Ud2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 16:33:28 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: CRDA and ath5k with no country code in EEPROM
References: <m3tys0tbhk.fsf@intrepid.localdomain>
	<43e72e891003300928qdd70de4vc7585d7e19d36dca@mail.gmail.com>
	<m3wrwtoekv.fsf@intrepid.localdomain>
	<201003302049.24231.chunkeey@googlemail.com>
Date: Tue, 30 Mar 2010 22:33:25 +0200
In-Reply-To: <201003302049.24231.chunkeey@googlemail.com> (Christian
	Lamparter's message of "Tue, 30 Mar 2010 20:49:23 +0200")
Message-ID: <m3mxxpo8h6.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> writes:

> Are you sure, you (or the hw manufacturer for that matter) didn't confuse
> the country code with regdomain code?
>
> because while they have more or less the same function, they do have different
> mappings. The 0x00 country code is reserved for the FCC (US), while the 0x00
> regdomain code is a described as "debug" with supposedly no limitations?!

I meant regdomain, is the country code (two letters) stored in the
EEPROM as well? If so and if others were talking about it instead of
regdomain, then I was/am really confused.

ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a

(This is for other, old card but I think the ones I need to use produce
the same output).

Then again: does the regdomain = 0 means "US" or "default country" (or
something completely different), according to Atheros' docs?
-- 
Krzysztof Halasa
