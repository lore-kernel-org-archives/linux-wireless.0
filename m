Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50992 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149Ab1EMNFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 09:05:47 -0400
Received: by qwk3 with SMTP id 3so1268998qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 06:05:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305291653.4065.437.camel@localhost>
References: <13602.31426.qm@web161615.mail.bf1.yahoo.com>
	<1305262715.4065.436.camel@localhost>
	<BANLkTim75f2p8wXyfeoz02asRd+Qm9aepA@mail.gmail.com>
	<1305291653.4065.437.camel@localhost>
Date: Fri, 13 May 2011 15:05:45 +0200
Message-ID: <BANLkTinPGw2jMT-uKYrW5i2pUqxmr3Lo_w@mail.gmail.com> (sfid-20110513_150551_801258_C0534190)
Subject: Re: Bug#596626: [gsimmons@gsimmons.org: Bug#596626: Please support
 Linksys WUSB600N v2 WiFi USB stick]
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Walter Goldens <goldenstranger@yahoo.com>, 596626@bugs.debian.org,
	maximilian attems <max@stro.at>,
	linux-wireless@vger.kernel.org,
	Geoff Simmons <gsimmons@gsimmons.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> >> > As mentioned by Jan, the device contains a RT3572
>> >> > chipset.  Its entry
>> >> > could moved into the section for known RT35XX devices (i.e.
>> >> > "#ifdef
>> >> > CONFIG_RT2800USB_RT35XX") as an alternative.
>> >> >
>> >> > Geoff
>> >>
>> >> This has already been done: http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commitdiff;h=ce2919c9fffe2aa52f9c3e327176d03764dbf9b5
>> >
>> > That's all very well, but that isn't going to get into a stable release
>> > for another 3 months!  Device ID updates that don't require new
>> > supporting code should be sent upstream straight away (and cc'd to
>> > stable@kernel.org).
>>
>> The patch has been send upstream, it has been in wireless-next-2.6.git
>> since April 19...
>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=ce2919c9fffe2aa52f9c3e327176d03764dbf9b5
>> The patch depends on the RT53xx support patch which was also intented
>> for 2.6.40.
>
> What is it, RT35XX or RT53XX?!

Oh sorry, RT35xx in this case, but basically the rest of the reply
still applies.
Both chipsets series have the same experimental state.

Ivo
