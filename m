Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:59423 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbXLJSMC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 13:12:02 -0500
Date: Mon, 10 Dec 2007 10:11:21 -0800
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
Message-ID: <20071210181121.GC7168@bougret.hpl.hp.com> (sfid-20071210_181206_858869_2BEABCA6)
Reply-To: jt@hpl.hp.com
References: <20071206191150.GC5237@bougret.hpl.hp.com> <1197022818.2603.20.camel@localhost.localdomain> <20071207192756.GA15864@bougret.hpl.hp.com> <20071207.180408.55119728.davem@davemloft.net> <1197221706.9149.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197221706.9149.36.camel@localhost.localdomain>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 09, 2007 at 12:35:06PM -0500, Dan Williams wrote:
> 
> So how would _you_ add a scan capabilities bitfield (or a new generic
> capabilities bitfield) to the WEXT range call?
> 
> We need the scan capability flag functionality; I don't care how we get
> it as long as the patch is not too invasive.  But userspace needs to
> know what the driver can do, and the patch needs to be written so that
> drivers that don't have the capabilities don't need to be touched.

	Dan,

	In my first e-mail, I offered you a way to do that without
having to change the API. You rejected it because it means fixing
various drivers. Well, there was a reason why I proposed it...

> Dan

	Regards,

	Jean
