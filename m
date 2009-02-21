Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:60173
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753401AbZBUVXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 16:23:25 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: [Rt2400-devel] No ProbeResp == dead interface?
Date: Sat, 21 Feb 2009 21:23:21 +0000
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <20090218205849.5723293CD93@tippex.mynet.homeunix.org> <200902202307.34035.linux@baker-net.org.uk> <20090221145528.5B11B2C4090@tippex.mynet.homeunix.org>
In-Reply-To: <20090221145528.5B11B2C4090@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902212123.21950.linux@baker-net.org.uk> (sfid-20090221_222330_342824_951F3D00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 21 February 2009, Anders Eriksson wrote:
>
> What should I look out for wrt the queue counters?
>

The most interesting question would be which (if any) counters continue to 
increment after it has failed.

> > Would be good to know if the legacy driver has the same issue - if it
> > does that might point to a hardware fault.
>
> Is that still maintained and working with new kernels? I recall needing to
> have different a different config setup for with the legacy driver (other
> name, and whatnot), so it's been a while.
>

According to http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=3&t=5174 it 
works on 2.6.27 but a patch still needs writing for 2.6.28 onwards.

> This is a "once is a week" bug, so it's hard to say for sure when it's
> working correctly. If you really want me to, I could try the legay one for
> a couple of weeks...
>

Such low frequency bugs are usually a pain to track down. That also precludes 
some of the more intrusive monitoring options that would result in huge logs 
if applied for that long.

It's often worth checking dmesg output when it does fail too. Sometimes there 
is useful info there that doesn't make it to syslog depending on your log 
level settings.

Adam
