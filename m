Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22132 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab1GPC0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 22:26:08 -0400
Message-ID: <20110715222607.jzkg1f4tw8wggog4-cebfxv@webmail.spamcop.net> (sfid-20110716_042619_276891_7A0B859D)
Date: Fri, 15 Jul 2011 22:26:07 -0400
From: Pavel Roskin <proski@gnu.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Binary for carl9170
References: <CACAiNS3-3K06Cro+VWypyWGetUW-v0qeJ29noXi7WNtUaCWzTw@mail.gmail.com>
	<20110715151642.0j86tyrj4k0g4sg4-cebfxv@webmail.spamcop.net>
	<4E20C3DC.3020200@gnu.org> <201107160136.44182.chunkeey@googlemail.com>
In-Reply-To: <201107160136.44182.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Christian Lamparter <chunkeey@googlemail.com>:

>> Oh well, I can upload it to wiki, but not to your page at
>> http://www.kernel.org/pub/linux/kernel/people/chr/carl9170/fw/
> The question is, is kernel.org really a good address to host those firmwares.
> especially in a personal folder.
>
>> I don't want to setup an alternative competing repository for carl9170
>> firmwares. Also, it would be nice to have the 1.9.4 firmware on
>> http://www.kernel.org/pub/linux/kernel/people/chr/carl9170/fw/
>
> I would rather have them on wireless.kernel.org. Just like the ath9k_htc
> firmware.

I don't have access to http://wireless.kernel.org/download/ but I  
think you can get it as the maintainer of carl9170.

>> So I created a separate wiki page for the 1.9.4 version of the firmware
>> and attached the firmware to it as "carl9170-1.fw".  That's an
>> equivalent of having directories with files having the same name.
> Good thinking, we could add a changelog, the configuration and
> some infos like supported features [e.g.: number of supported virtual
> interfaces, supported WoWLAN triggers, etc...] to the same page.

I think it would be better to have one page for all versions, unless  
there are huge changes in every release :)

What I created is just a trick to allow the firmware to be downloaded  
under the same name that the driver is looking for.

>> The carl9170 page recommends 1.9.2 for all kernels up to 3.0.  The 1.9.4
>> is recommended for compat-wireless.  If that's not your recommendation,
>> please feel free to update the wiki.
> oh no, this should be just fine.

Good.

-- 
Regards,
Pavel Roskin
