Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:34549 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699AbXHAFwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 01:52:09 -0400
Message-ID: <46B01F86.5050406@warmcat.com>
Date: Wed, 01 Aug 2007 06:52:06 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: libertas: blows chunks on failed firmware load
References: <46AF913F.9010006@warmcat.com> <1185935705.17940.40.camel@xo-13-A4-25.localdomain>
In-Reply-To: <1185935705.17940.40.camel@xo-13-A4-25.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

>> I realize I am slightly pushing my luck, but I added this el-cheapo
>> 88W8338 -based "Compoint EVWL-GI-700S" USB stick's USB ID "0x1286,
>> 0x1fab" to libertas/usb8xxx.c and chanced my arm.

> If it's 8338, it's certainly not gonna work with this driver.  Did you
> add the USB ID yourself?

Yes I do actually say in that rather obfuscated sentence above that I
added the USB ID and accepted I was pushing my luck doing so.  But...
the driver took the bold step of calling itself usb8xxx...

> Irregardless of my previous comment, the bug should get fixed of course.

Right, that's why I reported it like this:

>> Of course this can be due to the luck-pushing, but it seemed it might
>> also be a genuine problem with the error handling.

One of the other cheapo cards I randomly got was a Libertas 88W8335 PC
Card, I assume I am SOL on that as well.

-Andy
