Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:33995 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab0C3TG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 15:06:28 -0400
Received: by ewy20 with SMTP id 20so1583118ewy.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 12:06:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1269975753.4938.8.camel@mj>
References: <b170af451003300956r7fbd7812jdb40d125aeaf1b32@mail.gmail.com>
	 <4BB2328D.9010503@lwfinger.net>
	 <b170af451003301031yd06f559j85fd30417af32113@mail.gmail.com>
	 <4BB23953.9010104@lwfinger.net> <1269975753.4938.8.camel@mj>
Date: Tue, 30 Mar 2010 21:06:27 +0200
Message-ID: <b170af451003301206p593cbe3ew582823c75dc06f11@mail.gmail.com>
Subject: Re: Broadcom card totally not visible for system (lspci)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/30 Pavel Roskin <proski@gnu.org>:
> On Tue, 2010-03-30 at 12:48 -0500, Larry Finger wrote:
>> On 03/30/2010 12:31 PM, Rafał Miłecki wrote:
>> >
>> > Is this possible it's disabled in BIOS by default and needs execution
>> > of some ACPI command or sth to make it work?
>> >
>> > Yeah, trying to find some other reason than faulty WiFi... It's weird
>> > it was working fine "before a moment" on Windows.
>>
>> Winblows can fiddle with the "Wake-on-LAN" setting in the BIOS, but AFAIK, the
>> BCM4306 does not have this capability. If the BIOS has that setting, it should
>> be turned off.
>
> Perhaps it's a crazy idea, but what if the Ethernet device and the WiFi
> device are connected to the same SSB bus, an thus sharing the PCI ID?
>
> Is there the full kernel log?  In particular, the lines containing "ssb"
> would be interesting.

You mean dmesg, don't you? I've attached it, but it was stopped by b43
ML. You can see dmesg on marc archive for linux-wireless:
http://marc.info/?l=linux-wireless&m=126996817625998&w=2

Unfortunately I don't have dmesg from some more-debugging kernel.

-- 
Rafał
