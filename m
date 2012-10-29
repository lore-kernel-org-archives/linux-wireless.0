Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57672 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab2J2XAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 19:00:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TSyJY-0006mF-Ik
	for linux-wireless@vger.kernel.org; Tue, 30 Oct 2012 00:00:12 +0100
Received: from 85-211-212-185.dynamic.dsl.as9105.com ([85-211-212-185.dynamic.dsl.as9105.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2012 00:00:12 +0100
Received: from cliffhanger by 85-211-212-185.dynamic.dsl.as9105.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2012 00:00:12 +0100
To: linux-wireless@vger.kernel.org
From: Cliff McDiarmid <cliffhanger@gardener.com>
Subject: Re: RTL8188SU
Date: Mon, 29 Oct 2012 22:59:46 +0000 (UTC)
Message-ID: <loom.20121029T234700-352@post.gmane.org> (sfid-20121030_000014_375219_BD288A86)
References: <loom.20121028T233054-8@post.gmane.org> <201210291257.02249.chunkeey@googlemail.com> <loom.20121029T182405-382@post.gmane.org> <201210292117.45399.chunkeey@googlemail.com> <loom.20121029T214630-424@post.gmane.org> <508EFA5D.8090706@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:


> 
> The "old" driver for the RTL8188SU is r8712u, not 8192u. The USB_DEVICE table 
> for 8192u is:
> 
>          {USB_DEVICE(0x0bda, 0x8709)},
>          {USB_DEVICE(0x07aa, 0x0043)},
>          {USB_DEVICE(0x050d, 0x805E)},
>          {USB_DEVICE(0x0df6, 0x0031)},
>          {USB_DEVICE(0x1740, 0x9201)},
>          {USB_DEVICE(0x2001, 0x3301)},
>          {USB_DEVICE(0x5a57, 0x0290)},
>          {USB_DEVICE(0x043e, 0x7a01)},
> 
> I have an extensive collection of Realtek devices; however, I have never seen 
> any of these.
> 
> Larry


Thanks Larry I'm confusing the issue here, by not getting the no's right.  I was
asking about the rtl8192su driver which I understand works in monitor mode.  I
assume this driver has been 'cleaned up' and become the r8712u.  I was wondering
if I could use an earlier version of the rtl8192su driver with the RTL8188SU and
in doing so have the monitor mode.

regards

Cliff


