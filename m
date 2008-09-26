Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43958 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbYIZQ3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 12:29:11 -0400
Date: Fri, 26 Sep 2008 12:28:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Message-ID: <20080926162838.GC3483@tuxdriver.com> (sfid-20080926_182914_192898_FBD4F3A4)
References: <48DBE5E8.2000507@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48DBE5E8.2000507@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 09:26:32PM +0200, Hauke Mehrtens wrote:
> After upgrading from wireless-testing-2008-09-12 to
> wireless-testing-2008-09-24 I got the following kernel panic short after
> starting linux.
> 
> It happens at every start. After starting an older linux version
> everything works as it should.
> 
> I think it happens in the connecting process.
> 
> I am using Ubuntu Hardy with network manager 0.7
> I have got an rtl8187 chip on my Asus P5B Deluxe wifi.

I have applied Johannes's fix (slightly more complete than the one
from Luis) to wireless-testing, and it is available now.  Please verify
that it is working for you.

Thanks!

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
