Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49683 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2LTDTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 22:19:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TlWg0-0007Uz-Fg
	for linux-wireless@vger.kernel.org; Thu, 20 Dec 2012 04:20:04 +0100
Received: from gate-az2.freescale.com ([192.88.158.212])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 04:20:04 +0100
Received: from cash.q by gate-az2.freescale.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 04:20:04 +0100
To: linux-wireless@vger.kernel.org
From: cashq <cash.q@hotmail.com>
Subject: Re: ath6kl in compat wireless supports AP mode?
Date: Thu, 20 Dec 2012 03:13:11 +0000 (UTC)
Message-ID: <loom.20121220T040301-54@post.gmane.org> (sfid-20121220_041956_631649_A5021A8C)
References: <4F10AA2D.1060000@lenbrook.com>	<4F16AF8D.6070201@qca.qualcomm.com> <20246.46742.295455.729628@gargle.gargle.HOWL> <4F172101.3010207@lenbrook.com> <4F17B712.6020907@qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@...> writes:

> 
> On 01/18/2012 09:44 PM, Jonathan Bagg wrote:
> 
> > I'm running....
> > Compat-wireless 3.1 (ath6kl still in staging) built against kernel 2.6.35.3
> >      mac80211 as module
> >      cfg80211 as module
> > hostapd v2.0-devel (git cloned today)
> > libnl-2.0
> > arm, freescale imx51
> > 
> > I tried hostapd v2.0-devel and no go.
> 
> If ath6kl is still in staging you have an ancient version and it will
> not support AP mode. Please try latest wireless-compat or use the latest
> kernel from ath6kl.git:
> 
> git://github.com/kvalo/ath6kl.git
> 
> Kalle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Hi Kalle,

I've tried ath6kl in compact-wireless-3.6.8-1 built with kernel v3.5.7 on arm 
for AR6003, as well the driver in kernel v3.5.7. Both of them still failed to 
work at AP mode with hostapd 0.7.3 complaining "Failed to create interface 
mon.wlan0: -95 (Operation not supported)". 

Only IBSS(adhoc) mode can work with wpa_supplicant.

Has anyone successfully had AP mode enabled for ath6kl?

Is there any official announcement about the capability of ath6kl driver in 
compact-wireless?

Only thing I found is http://linuxwireless.org/en/users/Drivers. It indicates 
ath6kl does not support AP mode in linux driver. I'm just not sure whether it 
covers the capability of the one in compact-wireless.

Regards,
cashq

