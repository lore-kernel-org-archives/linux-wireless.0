Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40627 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751876AbXLIWaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 17:30:14 -0500
Subject: Re: [RFC/T][PATCH 3/3] rc80211-pid: allow for parameters to be set
	through sysfs
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071209212842.1515704c@morte>
References: <20071209211547.2d7fca32@morte>  <20071209212842.1515704c@morte>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 23:30:10 +0100
Message-Id: <1197239410.7543.19.camel@localhost> (sfid-20071209_223021_034557_BD362FF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sun, 2007-12-09 at 21:28 +0100, Stefano Brivio wrote:
> This patch allows for tuning parameters to be set through sysfs. Note that
> this lacks locking, as another copy of the whole parameters data would have
> been needed and this won't be the final approach anyway, so don't bother
> too much.
> 
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> 
> ---
> 
> Mattias: oops. Just noticed that my previous approach to locking here was
> bogus due to misconceptions about sysfs parameters. It's possible to get
> locking right here, but quite troublesome.

Ok, no worries, it's for testing only anyway.

Mattias

