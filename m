Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64153 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab0DPGVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 02:21:17 -0400
Subject: Re: [RFC PATCHv2 1/2] mac80211: Determine dynamic PS timeout based
 on ps-qos network latency
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Kalle Valo <kvalo@adurom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87aat4lygg.fsf@purkki.valot.fi>
References: <1271228079-27321-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271228079-27321-2-git-send-email-juuso.oikarinen@nokia.com>
	 <87eiigm0vu.fsf@purkki.valot.fi>
	 <1271395747.6205.23.camel@wimaxnb.nmp.nokia.com>
	 <87aat4lygg.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 09:17:12 +0300
Message-ID: <1271398632.6205.27.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 08:10 +0200, ext Kalle Valo wrote:
> Maybe at some point we can talk with QoS framework about this.
> 
> >> I'm mostly worried about timeout 0 case, for example I suspect ath9k
> >> is broken with that value.
> >> 
> >> Also does this patch change the default value of dynamic ps timeout?
> >> 
> >
> > No, the current default does not change. As the default value for the
> > latency is 2000s, we will, by default, get a timeout of 100ms.
> 
> Excellent. Thank you for explaining these.
> 
> From my point of view these patches look good and I have nothing to
> complain. 

You're definitely getting soft. I will stretch my luck by submitting a
v3 with one more latency range, giving a dynamic PS timeout of 50 ms.

> (I hope Juuso didn't hit his head when falling off from his chair when
> reading this.)
> 

*ouch*

-Juuso

