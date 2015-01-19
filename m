Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62765 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbASPpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 10:45:11 -0500
Message-ID: <54BD2684.30701@broadcom.com> (sfid-20150119_164515_987458_4AA5BC3D)
Date: Mon, 19 Jan 2015 16:45:08 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
CC: <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43 bcm43228 and linux 3.18.3
References: <CACaajQsqPMzwD=EqdD5_XfWAPmkn-52VVNHF1ntFZ6ofEH4D-w@mail.gmail.com> <CACaajQs1r1tE-GXv7cmAL9w8q2cwn_iiDttp6tLFB7BdSBNDPw@mail.gmail.com>
In-Reply-To: <CACaajQs1r1tE-GXv7cmAL9w8q2cwn_iiDttp6tLFB7BdSBNDPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ b43-dev@lists.infradead.org

On 01/19/15 13:20, Vasiliy Tolstov wrote:
> Anybody can helps me debug this?
>
> 2015-01-17 20:59 GMT+03:00 Vasiliy Tolstov<v.tolstov@selfip.ru>:
>> Hi all. I have 3.18.3 kernel and bcm43228, firstly all works fine, but
>> after connection with my zyxel router i can't ping it ip (after 1-2
>> min). Connection worked fin, but nothing transmitted =(.
>> I'm try to disable qos, but this not helps, i'm try to enable
>> verbose=3, but in dmesg nothing interesting. Time after time b43
>> driver moved from 5Ghz to 2.4Ghz to 5Ghz and so.

What do you mean by "moved from 5Ghz to 2.4Ghz..". You mean it is 
roaming between the two bands? Anyway, there is a b43 specific mailing 
list which I added.

Regards,
Arend

>> How can i debug this issue? I'm realy love free opensource drivers.
>> Thanks
>>
>> --
>> Vasiliy Tolstov,
>> e-mail: v.tolstov@selfip.ru
>> jabber: vase@selfip.ru
>
>
>

