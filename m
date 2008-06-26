Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7314 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598AbYFZTTt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 15:19:49 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	cs010101@gmail.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1214503739.3783.14.camel@johannes.berg>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <200806261821.31643.mb@bu3sch.de> <1214498071.30722.22.camel@dv>
	 <200806261846.17962.mb@bu3sch.de>  <1214501000.3783.0.camel@johannes.berg>
	 <1214503403.18039.6.camel@dv>  <1214503739.3783.14.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 14:18:08 -0400
Message-Id: <1214504288.18039.12.camel@dv> (sfid-20080626_212021_036308_D26E4735)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-26 at 20:08 +0200, Johannes Berg wrote:

> > I also suspect that certain fixed are needed only for 802.11g or 802.11b
> > compliance, but not for the original 802.11 compliance.
> > 
> > Say, if we limit the rate to 1 Mbps, are there any issues that really
> > make us non-compliant?
> 
> The fact that we cannot limit the rate like that that?

That shouldn't be hard to implement.

-- 
Regards,
Pavel Roskin
