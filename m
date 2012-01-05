Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:38599 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932728Ab2AEQas (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 11:30:48 -0500
Message-ID: <1325781045.22154.15.camel@joe2Laptop> (sfid-20120105_173127_667034_7A3BE5B7)
Subject: RE: [PATCH 5/6] ath6kl: convert ath6kl_dbg() and ath6kl_dbg_dump()
 into functions
From: Joe Perches <joe@perches.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, linville@tuxdriver.com,
	sfr@canb.auug.org.au, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org, ath6kl-devel@qualcomm.com,
	davem@davemloft.net
Date: Thu, 05 Jan 2012 08:30:45 -0800
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AF2F@saturn3.aculab.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AF2F@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-05 at 10:41 +0000, David Laight wrote:
> > > +	va_start(args, fmt);
> > > +	ath6kl_printk(KERN_DEBUG, fmt, &args);
> > Passing a va_list as an argument?
> > I believe this doesn't work.
> > I think you'll need to add and use:
> Passing a va_list certainly does work - vprintf() etc.
> What is problematical is taking the address of a va_list.

Nope.  This referred to this specific instance.
Taking the address of a va_list works fine.
Look at the provide example.


