Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:33855 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab0C2TuC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 15:50:02 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: CRDA and ath5k with no country code in EEPROM
References: <m3tys0tbhk.fsf@intrepid.localdomain>
	<43e72e891003281645m1da47a1en882df4432733977d@mail.gmail.com>
	<m3eij3ym5k.fsf@intrepid.localdomain>
	<43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
Date: Mon, 29 Mar 2010 21:49:59 +0200
In-Reply-To: <43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
	(Luis R. Rodriguez's message of "Mon, 29 Mar 2010 12:22:59 -0700")
Message-ID: <m339zizz4o.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

>> I'm not sure how the modified regulatory.bin could work, though:
>> I really don't want to use restricted frequencies etc. when the
>> regulatory domain is set to US (i.e. when operating in USA), I only want
>> to use the extra channels etc. when in e.g. Europe.
>
> I agree with that wishful thinking, however current legislation does
> now allow for dynamic enabling of frequencies on devices certified
> under part 15 rules. We can likely work towards changing the
> legislation for this but that's something I haven't seen many
> companies willing to lobby for. We'd need a big company to help with
> this lobby.

But... isn't the modifying of the regulatory.bin (the US part of it)
to include channels valid in e.g. Europe breaking the (US) rules? I'm
not asking you for a legal advice binding Atheros as the manufacturer in
the USA, I'm asking how to enable the user to be technically compliant
here in Europe where the hardware is sold, and also in the USA if the
user gets there and sets the regdomain (and elsewhere in the world, in
fact).

Modifying regulatory.bin doesn't seem to help here, does it?

>> A driver modification to ignore the default restrictions (while obeying
>> the regulatory.bin, on a 0-country cards only, of course) - that would
>> work.
>
> And it would also make our drivers break regulatory rules. We're not
> going to do that on Linux because proving that we can be responsible
> is in fact what does allow us to get proper vendor support for 802.11
> drivers.

I'm not asking you to do that, I only need to know if it's the correct
(and only?) way of fixing this problem (while still providing
compliance of the whole device). Fortunately I'm not responsible for the
legalities.


The other thing is the meaning of country=0 in case of Mikrotik cards
(and maybe others). Perhaps they should get them back. I wonder if
their drivers break the FCC rules, allowing "0" (=US) cards to use
channels restricted in the US.
-- 
Krzysztof Halasa
