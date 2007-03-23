Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gundega.hpl.hp.com ([192.6.19.190]:58610 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992466AbXCWPu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 11:50:28 -0400
Date: Fri, 23 Mar 2007 08:48:28 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>, stable@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] fix information leak in wireless extensions on 64-bit platforms
Message-ID: <20070323154828.GA4671@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1174640787.3588.65.camel@johannes.berg> <1174657362.3366.6.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1174657362.3366.6.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 23, 2007 at 02:42:42PM +0100, Johannes Berg wrote:
> On Fri, 2007-03-23 at 14:40 +0100, Johannes Berg wrote:
> > Wireless extensions on 64-bit platforms leak information from the kernel
> > stack due to padding in structs that is copied. This affects any
> > wireless event stream including scan results and so hence is available
> > to unprivileged users.
> 
> Ignore this patch, I see Jean just posted one as well :)
> 
> johannes

	Yes, sorry for the delay, I wanted to make sure I had all the
parts fully fleshed out.
	Thanks !

	Jean

