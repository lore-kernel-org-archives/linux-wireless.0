Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:42627 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXJFD3E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 23:29:04 -0400
Message-ID: <20071005232901.hp6o9em6ocwc0gws@webmail.spamcop.net> (sfid-20071006_042911_022266_05D29DA8)
Date: Fri, 05 Oct 2007 23:29:01 -0400
From: Pavel Roskin <proski@gnu.org>
To: Greg Johnson <gregfjohnson@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: usb wifi ad-hoc mode suggestions?
References: <371947.67660.qm@web33501.mail.mud.yahoo.com>
In-Reply-To: <371947.67660.qm@web33501.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Quoting Greg Johnson <gregfjohnson@yahoo.com>:

> I'm working on a project where we need to use a USB wifi adapter in ad-hoc
> mode.
>
> We've been struggling with this.  Is there a 'standard' known solid way to
> do this?  What products and/or chipsets and Linux drivers should we be
> looking at?

Two suggestions:

1) at76_usb, available in wireless-2.6/everything (Atmel USB).

2) linux-wlan-ng - separate project, may need updating for the latest  
kernels.  Supports Prism based USB devices.

Both Atmel and Prism devices are 802.11b only and may be hard to find,  
but they would definitely work.

> We're trying the zd1211 with the zd1211rw driver and the mac80211 stack,
> which doesn't seem to have ad-hoc support currently, but their web site says
> it should be easy to add.

That's another approach you can take.  At least you have the hardware,  
and it should be 802.11g capable.  All you need is to fix the code.

-- 
Regards,
Pavel Roskin
