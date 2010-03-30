Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53215 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0C3Q2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 12:28:49 -0400
Received: by pwi5 with SMTP id 5so7883615pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 09:28:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3r5n2qbo0.fsf@intrepid.localdomain>
References: <m3tys0tbhk.fsf@intrepid.localdomain> <43e72e891003281645m1da47a1en882df4432733977d@mail.gmail.com>
	<m3eij3ym5k.fsf@intrepid.localdomain> <43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
	<m339zizz4o.fsf@intrepid.localdomain> <43e72e891003291256t7f53dcfck5f8c8cf94128eeb3@mail.gmail.com>
	<m3y6hayhv1.fsf@intrepid.localdomain> <43e72e891003291500w632cb789r6860dae9ccdf744c@mail.gmail.com>
	<m3r5n2qbo0.fsf@intrepid.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Mar 2010 09:28:28 -0700
Message-ID: <43e72e891003300928qdd70de4vc7585d7e19d36dca@mail.gmail.com>
Subject: Re: CRDA and ath5k with no country code in EEPROM
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 4:41 AM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>
>>> So what exactly do I change? Can the regulatory.bin change the default
>>> country?
>>
>> Huh?
>>
>>> Remember I need to be compliant to the US freq sets as well - when the
>>> regdomain is set to US. IOW I can't allow the user operating the device
>>> to set e.g. channel 12 when the user selects country=US (so there is a
>>> big difference between country 0=US and the real country=US).
>>
>> Huh?
>
> Not sure what do you mean. Are my expectations unrealistic?
>
>>> But the driver says:
>>> ath: EEPROM regdomain: 0x0
>>> ath: EEPROM indicates default country code should be used
>>> ath: doing EEPROM country->regdmn map search
>>> ath: country maps to regdmn code: 0x3a
>>> ath: Country alpha2 being used: US
>>> ath: Regpair used: 0x3a
>>>
>>> At least for the driver 0 doesn't mean US, it means "default country".
>>> Perhaps the meaning of "default country" depends on maybe location of
>>> the hw and/or sw manufacturer?
>>
>> I just pointed to some documentation for you which indicated 0x0 means
>> "US".
>
> Yes, but the meaning depends on the POV. What is important to me is what
> does that mean to a) the software I use, b) the hardware I use (cards).
> The driver doesn't say 0=US, perhaps it should? Then things would be
> very different.

My point was that this is not something meant to be interpreted by
anyone for what "default country" means, the documentation I pointed
out clearly states that 0x0 is designed to mean to match the "US" by
Atheros hardware as per hardware documentation provided to ODMs.

  Luis
