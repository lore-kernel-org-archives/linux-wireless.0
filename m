Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:40739 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757907AbZKDWea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 17:34:30 -0500
Received: by iwn10 with SMTP id 10so5337024iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 14:34:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911042331.56052.chunkeey@googlemail.com>
References: <4AF0D54D.4090303@irobot.com> <200911042318.13528.chunkeey@googlemail.com>
	<20091104222007.GB2599@bombadil.infradead.org> <200911042331.56052.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 4 Nov 2009 14:34:15 -0800
Message-ID: <43e72e890911041434u78883ce3s5401984688539c1@mail.gmail.com>
Subject: Re: compat-wireless and minstrel
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Adam Wozniak <awozniak@irobot.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 2:31 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Wednesday 04 November 2009 23:20:07 Luis R. Rodriguez wrote:
>> On Wed, Nov 04, 2009 at 11:18:13PM +0100, Christian Lamparter wrote:
>> > On Wednesday 04 November 2009 22:50:46 Luis R. Rodriguez wrote:
>> > > On Wed, Nov 4, 2009 at 1:46 PM, Adam Wozniak <awozniak@irobot.com> wrote:
>> > > >
>> > > > $ ls -la /lib/firmware/ar9170*
>> > > > -rw-r--r-- 1 root root 83968 2009-10-17 15:55 /lib/firmware/ar9170-1.fw
>> > > > -rw-r--r-- 1 root root  3508 2009-10-17 15:55 /lib/firmware/ar9170-2.fw
>> > > > -rw-r--r-- 1 root root 15960 2009-10-17 15:55 /lib/firmware/ar9170.fw
>> > > >
>> > > > It is unclear to me which are actually used.
>> > >
>> > > By default the ar9170.fw is tried first, if that fails then the others
>> > > are tried. The 2-stage firmware will not be tried if your device
>> > > cannot handle it but right now only the AVM Fritz devices can't handle
>> > > the 2-stage firmware.
>> > >
>> > > Christian should we just remove 2-stage fw support?
>> >
>> > I've moved the two-stage fw into the legacy section some time ago :)
>> > Maybe a add printk?
>>
>> Oh sorry didn't notice, I meant complete removal of its support on the
>> driver though :)
> Oh, I've no problem removing two-stage fw support.

Ok cool.

> But then, I don't know much about usability :-D and I've enough of
> people banging their heads against each other.

Not sure I got this part.

 Luis
