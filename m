Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48925 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2FGMgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 08:36:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Scbwx-0006I2-4W
	for linux-wireless@vger.kernel.org; Thu, 07 Jun 2012 14:36:27 +0200
Received: from 64.125.71.178 ([64.125.71.178])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 14:36:27 +0200
Received: from viscous.liquid by 64.125.71.178 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 14:36:27 +0200
To: linux-wireless@vger.kernel.org
From: Daniel Smith <viscous.liquid@gmail.com>
Subject: Re: anyone know any dual-band USB devices with monitoring mode in
 Linux?
Date: Thu, 07 Jun 2012 08:36:08 -0400
Message-ID: <jqq77o$u3f$1@dough.gmane.org> (sfid-20120607_143634_552286_E5457607)
References: <CA+7oygd1dfn=Vj7V1h_vVvXPNym_Ake7UNWf1UuVWfxzm5g+NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <CA+7oygd1dfn=Vj7V1h_vVvXPNym_Ake7UNWf1UuVWfxzm5g+NQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/6/2012 11:14 PM, George Nychis wrote:
> Hi all,
>
> I've been using the Sony UWA-BR100 (AR9280) with ath9k_htc, and there
> is clearly a bug with reporting signal strengths which I need to be
> correct.  I've reported the bug, but this might not be fixed in time
> for a deadline I have coming up, and the bug is in the firmware out of
> my reach.
>
> So I was wondering if anyone knows of any alternative USB dual-band
> wireless cards that support monitoring mode in Linux.  I'd _greatly_
> appreciate it... doesn't need to be Atheros based.
>
> - George
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Hi,

Take a look at Ralink. Most if not all of their chips firmware support 
monitor mode. One limitation though is that they are not capable of 
reporting the tsf if that is important to you.

V/r,
Daniel

