Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:39878 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbZAJG2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 01:28:11 -0500
Received: by bwz14 with SMTP id 14so29952031bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 22:28:09 -0800 (PST)
To: "Nick Kossifidis" <mickflemm@gmail.com>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@gmail.com, me@bobcopeland.com, nbd@openwrt.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: Add debug code for EEPROM
References: <20090104173252.GA5944@makis> <49610E8D.9080807@gmail.com>
	<40f31dec0901091637u70ad5c97g3915d5b2b8726e88@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 10 Jan 2009 08:28:06 +0200
In-Reply-To: <40f31dec0901091637u70ad5c97g3915d5b2b8726e88@mail.gmail.com> (Nick Kossifidis's message of "Sat\, 10 Jan 2009 02\:37\:28 +0200")
Message-ID: <874p07llop.fsf@litku.valot.fi> (sfid-20090110_072817_710373_DAD233AE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Nick Kossifidis" <mickflemm@gmail.com> writes:

>>> +     struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
>>> +     unsigned int len = 0;
>>> +     char buf[2000];
>>
>> dtto
>>
>
> What does dtto mean ?

A typo from ditto:

>From WordNet (r) 3.0 (2006) [wn]:

  ditto
      n 1: a mark used to indicate the word above it should be
           repeated [syn: {ditto mark}, {ditto}]
      v 1: repeat an action or statement; "The next speaker dittoed
           her argument"


-- 
Kalle Valo
