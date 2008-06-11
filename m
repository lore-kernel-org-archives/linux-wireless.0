Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6124 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbYFKVxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:53:50 -0400
Subject: Re: Broadcom's Hybrid Driver
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <48504417.7020803@lwfinger.net>
References: <48500F14.8070300@canonical.com>
	 <200806112047.00854.mb@bu3sch.de>	 <1213213666.19106.12.camel@dv>
	 <69e28c910806111326j6922905fq1f67201ab4ce298f@mail.gmail.com>
	 <48504417.7020803@lwfinger.net>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 17:53:48 -0400
Message-Id: <1213221228.3649.15.camel@dv> (sfid-20080611_235353_098144_61F10F7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-11 at 16:31 -0500, Larry Finger wrote:
> I have two ideas about what Broadcom is doing.
> 
> The b/g device with an ID of 0x4315 and an LP-PHY is the one that HP 
> has been shipping in many laptops for the past few months. Perhaps HP 
> wants to offer Linux on those computers, but doesn't want to use 
> ndiswrapper for wireless access. HP might have enough clout to get 
> Broadcom to budge a little on the subject of Linux.

That's sounds plausible.

> It is also possible that they want to stifle our RE efforts.

By releasing the driver?  I don't think so.  They don't think we are
such idiots to take their code and get in trouble, do they?

Besides, Broadcom contributes to the kernel.  There are files with their
copyright, even in the SSB code.  They just don't want to help with the
wireless driver.

> Given some of the other parts of the license relating to penalties, 
> etc., anyone trying to RE this code could be in a heap of trouble.

Reverse engineering efforts should always be careful about the legal
aspects.  Yet I see two possible loopholes.

1) The recipient is not necessarily bound by the license without having
signed it (in some jurisdictions).

2) Reverse engineering to the purpose of compatibility may not be
restricted (in some other jurisdictions).

Even if neither applies, it's not like we are losing anything.  We
should just be careful, as always.

-- 
Regards,
Pavel Roskin
