Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16819 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757589AbYFZTTt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 15:19:49 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>, cs010101@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080626173645.GB22075@tuxdriver.com>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <69e28c910806260846s3b02cdddlca3ac138acadd8bd@mail.gmail.com>
	 <1214496086.30722.14.camel@dv> <200806261821.31643.mb@bu3sch.de>
	 <20080626173645.GB22075@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 14:08:08 -0400
Message-Id: <1214503688.18039.9.camel@dv> (sfid-20080626_212020_866164_AA52A4D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-26 at 13:36 -0400, John W. Linville wrote:

> I dunno...that last thing I want is to let this go in and then be
> locked-in to the current API no-matter-what like we now are with WEXT.

Is there any API that needs to be _changed_ (not added) for AP support?
I understand it may be hard to anticipate future needs, but some things
should be clear at this point already.

-- 
Regards,
Pavel Roskin
