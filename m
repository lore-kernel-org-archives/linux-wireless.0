Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f186.google.com ([209.85.222.186]:52348 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab0C3Swk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 14:52:40 -0400
Received: by pzk16 with SMTP id 16so7775244pzk.22
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 11:52:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201003302049.24231.chunkeey@googlemail.com>
References: <m3tys0tbhk.fsf@intrepid.localdomain> <43e72e891003300928qdd70de4vc7585d7e19d36dca@mail.gmail.com>
	<m3wrwtoekv.fsf@intrepid.localdomain> <201003302049.24231.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Mar 2010 11:52:19 -0700
Message-ID: <43e72e891003301152l1b0c4c02n706545d51b8d44c9@mail.gmail.com>
Subject: Re: CRDA and ath5k with no country code in EEPROM
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 11:49 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Tuesday 30 March 2010 20:21:36 Krzysztof Halasa wrote:
>> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>>
>> > My point was that this is not something meant to be interpreted by
>> > anyone for what "default country" means, the documentation I pointed
>> > out clearly states that 0x0 is designed to mean to match the "US" by
>> > Atheros hardware as per hardware documentation provided to ODMs.
>>
>> I understand this, but the reality is that I have to work with hardware
>> and software, not with the docs provided by Atheros to some other
>> parties.
>>
>> Software (the official Atheros driver, to be precise) says 0 isn't
>> exactly US.
>> Hardware (card) manufacturer says 0 isn't US.
>
> Are you sure, you (or the hw manufacturer for that matter) didn't confuse
> the country code with regdomain code?
>
> because while they have more or less the same function, they do have different
> mappings. The 0x00 country code is reserved for the FCC (US), while the 0x00
> regdomain code is a described as "debug" with supposedly no limitations?!

That debug regulatory domain is not a valid regulatory domain
supported in the field, it was a debug hack. It is simply not a
regulatory domain which ODMs / OEMs calibrate their cards for.

  Luis
