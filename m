Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720AbXHALF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 07:05:58 -0400
Subject: Re: libertas: blows chunks on failed firmware load
From: Dan Williams <dcbw@redhat.com>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <46B01F86.5050406@warmcat.com>
References: <46AF913F.9010006@warmcat.com>
	 <1185935705.17940.40.camel@xo-13-A4-25.localdomain>
	 <46B01F86.5050406@warmcat.com>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 07:03:24 -0400
Message-Id: <1185966204.29690.2.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-08-01 at 06:52 +0100, Andy Green wrote:
> Somebody in the thread at some point said:
> 
> >> I realize I am slightly pushing my luck, but I added this el-cheapo
> >> 88W8338 -based "Compoint EVWL-GI-700S" USB stick's USB ID "0x1286,
> >> 0x1fab" to libertas/usb8xxx.c and chanced my arm.
> 
> > If it's 8338, it's certainly not gonna work with this driver.  Did you
> > add the USB ID yourself?
> 
> Yes I do actually say in that rather obfuscated sentence above that I
> added the USB ID and accepted I was pushing my luck doing so.  But...
> the driver took the bold step of calling itself usb8xxx...

Yeah, I'm wondering whether we should change that...  I don't know what
the policy on changing driver names is though, but given that the driver
isn't extensively used yet, we may be able to.

Dan

> 
> > Irregardless of my previous comment, the bug should get fixed of course.
> 
> Right, that's why I reported it like this:
> 
> >> Of course this can be due to the luck-pushing, but it seemed it might
> >> also be a genuine problem with the error handling.
> 
> One of the other cheapo cards I randomly got was a Libertas 88W8335 PC
> Card, I assume I am SOL on that as well.
> 
> -Andy

