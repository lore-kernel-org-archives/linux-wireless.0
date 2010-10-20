Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2256 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0JTVuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 17:50:22 -0400
Message-ID: <4CBF640C.4080405@broadcom.com>
Date: Wed, 20 Oct 2010 14:50:04 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Nohee Ko" <noheek@broadcom.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: Request for free-distributable Broadcom's (G|LP)-PHY
 firmware
References: <AANLkTik45KLdLf5UpjPtXTNgy4Df_BupyQ3SzRr6gZgC@mail.gmail.com>
 <AANLkTin_JcEyT21dTS=Ew868HJvZQ2FVZBGXjCZn=8O_@mail.gmail.com>
In-Reply-To: <AANLkTin_JcEyT21dTS=Ew868HJvZQ2FVZBGXjCZn=8O_@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2010 05:02 PM, Rafał Miłecki wrote:
> W dniu 9 października 2010 00:07 użytkownik Rafał Miłecki
> <zajec5@gmail.com>  napisał:
>> Hi Broadcom fellows!
>>
>> It's great that afters long years of... well, pretty horrible
>> relations with Linux/opensource you have taken actions to change your
>> image. I guess brcm80211 it's perfect yet, and people may like it more
>> or less, but it's no doubt you made step in the right direction.
>> Thanks for that!
>>
>> As you should know, you released driver and firmware for 802.11n
>> devices only. I believe it was right, as these device seem to be the
>> most nowadays and were the only ones without any open source support.
>> For older devices: G-PHY and LP-PHY we have working b43 driver that is
>> in relatively good shape. However... there is one thing we still miss
>> for olders cards.
>>
>> Every time someone wants to use b43 it's necessary to download quite
>> big package from openwrt, unpack it, extract firmware and install it.
>> That simply happens because we don't have just-firmware files with
>> nice licensing. And of course there goes my request:
>>
>> *Can you submit G-PHY and LP-PHY firmware to linux-firmware using some
>> normal licensing, please?*
>>
>> This is of course not the best I could wish for, but is important
>> anyway and it should be easy decision. Ideally you could release
>> sources of firmware (plus toolchain eventualy... however, we have nice
>> toolchain from Michael), but I guess it would need more time and
>> decisions to make it happen. So as for now I guess we would be happy
>> with just closed source but easy-distributable firmware. Could you
>> release, submit it?
>
> Greg: I didn't receive any answer from Broadcom for any mail. Do you
> maybe have any "working" contact with this company? :|
>

Sorry for the delay in responding.  We are exploring what is possible 
but for the moment the answer is no. At present our focus is on 
providing the best open source solution we can for 4313, 43224, 43225, 
4329 and future chips sets.

- Henry


