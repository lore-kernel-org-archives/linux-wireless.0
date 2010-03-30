Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:51564 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab0C3Llj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 07:41:39 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: CRDA and ath5k with no country code in EEPROM
References: <m3tys0tbhk.fsf@intrepid.localdomain>
	<43e72e891003281645m1da47a1en882df4432733977d@mail.gmail.com>
	<m3eij3ym5k.fsf@intrepid.localdomain>
	<43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
	<m339zizz4o.fsf@intrepid.localdomain>
	<43e72e891003291256t7f53dcfck5f8c8cf94128eeb3@mail.gmail.com>
	<m3y6hayhv1.fsf@intrepid.localdomain>
	<43e72e891003291500w632cb789r6860dae9ccdf744c@mail.gmail.com>
Date: Tue, 30 Mar 2010 13:41:35 +0200
In-Reply-To: <43e72e891003291500w632cb789r6860dae9ccdf744c@mail.gmail.com>
	(Luis R. Rodriguez's message of "Mon, 29 Mar 2010 15:00:47 -0700")
Message-ID: <m3r5n2qbo0.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

>> So what exactly do I change? Can the regulatory.bin change the default
>> country?
>
> Huh?
>
>> Remember I need to be compliant to the US freq sets as well - when the
>> regdomain is set to US. IOW I can't allow the user operating the device
>> to set e.g. channel 12 when the user selects country=US (so there is a
>> big difference between country 0=US and the real country=US).
>
> Huh?

Not sure what do you mean. Are my expectations unrealistic?

>> But the driver says:
>> ath: EEPROM regdomain: 0x0
>> ath: EEPROM indicates default country code should be used
>> ath: doing EEPROM country->regdmn map search
>> ath: country maps to regdmn code: 0x3a
>> ath: Country alpha2 being used: US
>> ath: Regpair used: 0x3a
>>
>> At least for the driver 0 doesn't mean US, it means "default country".
>> Perhaps the meaning of "default country" depends on maybe location of
>> the hw and/or sw manufacturer?
>
> I just pointed to some documentation for you which indicated 0x0 means
> "US".

Yes, but the meaning depends on the POV. What is important to me is what
does that mean to a) the software I use, b) the hardware I use (cards).
The driver doesn't say 0=US, perhaps it should? Then things would be
very different.
-- 
Krzysztof Halasa
