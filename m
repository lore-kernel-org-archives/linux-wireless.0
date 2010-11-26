Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:25509 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab0KZNIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 08:08:48 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAQD8lFb012227
	for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 15:08:48 +0200
Subject: Re: [PATCH] wl12xx: disable 11a channels when regulatory changes
 if 11a is not supported
From: Luciano Coelho <luciano.coelho@nokia.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1290776625.4284.304.camel@wimaxnb.nmp.nokia.com>
References: <1290775390-3391-1-git-send-email-luciano.coelho@nokia.com>
	 <1290776625.4284.304.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 15:08:52 +0200
Message-ID: <1290776932.15341.10.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-26 at 15:03 +0200, Juuso Oikarinen wrote:
> On Fri, 2010-11-26 at 14:43 +0200, luciano.coelho@nokia.com wrote:
> > From: Luciano Coelho <luciano.coelho@nokia.com>
> > 
> > Instead of simply not scanning for the 11a channels when not supported by the
> > hardware, disable the channels in reg_notify.  This centralizes the decision
> > on whether to scan 5GHz channel in one place and allows userspace to know
> > exactly which channels are in use.
> > 
> > Based on Juuso Oikarinen's idea.
> > 
> > Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> > ---

[...]

> I think this is more verbose towards user-space this way.

Yeah, and will help with the sched_scan code too.

> Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Thanks! Applied and pushed to wl12xx.

-- 
Cheers,
Luca.

