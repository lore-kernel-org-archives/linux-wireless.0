Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:43492 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYKLD2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 22:28:00 -0500
Received: by yw-out-2324.google.com with SMTP id 9so121212ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2008 19:27:58 -0800 (PST)
Message-ID: <646765f40811111927y7e25bca1xb2bdb7e2b4db112a@mail.gmail.com> (sfid-20081112_042808_052625_B5643BDC)
Date: Wed, 12 Nov 2008 14:27:58 +1100
From: "Julian Calaby" <julian.calaby@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC PATCH 4/4] net/ieee80211 -> drivers/net/ipw2x00/libipw_* rename
Cc: "Michael Buesch" <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <20081111232102.GA5827@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1226440265-21240-3-git-send-email-linville@tuxdriver.com>
	 <1226440265-21240-4-git-send-email-linville@tuxdriver.com>
	 <200811112322.33623.mb@bu3sch.de>
	 <20081111232102.GA5827@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 12, 2008 at 10:21, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Nov 11, 2008 at 11:22:33PM +0100, Michael Buesch wrote:
>> On Tuesday 11 November 2008 22:51:05 John W. Linville wrote:
>> > +config LIBIPW
>> > +   tristate
>> > +   select WIRELESS_EXT
>> > +   select CRYPTO
>> > +   select CRYPTO_ARC4
>> > +   select CRYPTO_ECB
>> > +   select CRYPTO_AES
>> > +   select CRYPTO_MICHAEL_MIC
>> > +   select CRYPTO_ECB
>> > +   select CRC32
>> > +   select LIB80211
>> > +   select LIB80211_CRYPT_WEP
>> > +   select LIB80211_CRYPT_TKIP
>> > +   select LIB80211_CRYPT_CCMP
>> > +   ---help---
>> > +   This option enables the hardware independent IEEE 802.11
>> > +   networking stack.  This component is deprecated in favor of the
>> > +   mac80211 component.
>>
>> Let's remove this helptext, or replace it by something that's actually true. ;)
>>       ---help---
>>         This option enables common routines for the IPW2100 and IPW2200 drivers.
>
> Yes, good comment.

Does this option even need to be visible?

Only the ipw2x00 drivers use it - and they select it - so do we need
to bother the user with it?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
