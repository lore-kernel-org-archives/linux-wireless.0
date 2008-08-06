Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31888 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762065AbYHFCxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 22:53:30 -0400
Subject: Re: Future handling of AR5416
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4899106A.9060103@lwfinger.net>
References: <4899106A.9060103@lwfinger.net>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 22:53:27 -0400
Message-Id: <1217991207.4426.6.camel@dv> (sfid-20080806_045336_551574_28E2C17B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-05 at 21:46 -0500, Larry Finger wrote:
> In my helping with wireless on the openSUSE Forums, I recently tried to help a 
> user with an AR5416 (Vendor ID 168c, PCI ID 0023). The user has kernel 2.6.25.11 
> and gets the "Device not yet supported." message. By looking at the code, I see 
> that same situation still exists in wireless-testing.
> 
> So that I may advise the OP accurately, will this chip be supported in the near 
> future, or should I recommend that he use ndiswrapper?

That's a nicely timed question!  Today's (but not yesterday's :-))
wireless-testing does support AR5416 with the new ath9k driver.

Unfortunately, ath9k is not in compat-wireless.  I heard it may be hard
to backport the current wireless drivers.

Anyway, MadWifi trunk (not 0.9.4) supports AR5416, and it's a nicer
driver than ndiswrapper IMHO.

-- 
Regards,
Pavel Roskin
