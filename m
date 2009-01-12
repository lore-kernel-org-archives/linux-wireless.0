Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52112 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbZALRff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 12:35:35 -0500
Date: Mon, 12 Jan 2009 19:35:26 +0200
From: Jouni Malinen <j@w1.fi>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] Fixed BSSID step 3: Don't merge with the same BSSID
Message-ID: <20090112173526.GA18470@jm.kir.nu> (sfid-20090112_183552_201610_8DF61CD5)
References: <20090106020130.302750@gmx.net> <20090108091055.GA7009@jm.kir.nu> <20090109205315.277310@gmx.net> <20090110091659.GC1170@jm.kir.nu> <20090112041534.24150@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090112041534.24150@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 12, 2009 at 05:15:34AM +0100, Alina Friedrichsen wrote:
> > For the particular problem that you are
> > seeing, the minimal change would probably be just to make
> > sta_info_flush_delayed() call conditional on SSID change (I don't think
> > this would need to be based on BSSID change).
> 
> If the others agree, I can implement it in the end of the week. Or do you want it the other way?
> I personally don't want change too much...?

Of course I would like to have the full cleanup in the long run, but I
have nothing against first doing the minimal change to fix the
identified issue.

-- 
Jouni Malinen                                            PGP id EFC895FA
