Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:58086 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZJQGQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 02:16:44 -0400
Received: by ewy4 with SMTP id 4so19576ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 23:16:48 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: John Willis <John.Willis@Distant-earth.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] WL1251: Very crude EEPROM reading support for the WL1251 driver
References: <01c901ca4daf$6e3d7f20$4ab87d60$@Willis@Distant-earth.com>
	<20091016115909.GB341@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 17 Oct 2009 09:16:46 +0300
In-Reply-To: <20091016115909.GB341@hash.localnet> (Bob Copeland's message of "Fri\, 16 Oct 2009 07\:59\:09 -0400")
Message-ID: <87aazqmto1.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Thu, Oct 15, 2009 at 04:51:49PM +0100, John Willis wrote:
>> The patches are not yet complete but they do work for me (tm) so I would be
>> very interested in seeing if these hacks also allow us to use the EEPROM on
>> the HTC Dream (Bob, can you try that?, no rush however).
>
> Yeah, I'll give it a spin.  It'd be really nice if people don't need to
> use the NVS file.

Didn't HTC Dream store the NVS file in the main flash memory? AFAIK
the EEPROM support in wl1251 needs a separate chip for the EEPROM, so
if someone has stored the NVS file to the main flash memory I really
doubt that they would still use EEPROM with wl1251. So the NVS file is
stored either to somewhere outside wl1251 or to the EEPROM, but not
both.

-- 
Kalle Valo
