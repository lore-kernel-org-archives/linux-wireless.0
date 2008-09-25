Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60100 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbYIYUJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 16:09:43 -0400
Date: Thu, 25 Sep 2008 16:08:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Message-ID: <20080925200851.GE3277@tuxdriver.com> (sfid-20080925_220947_721559_A878BD05)
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

Could you try master-2008-09-22 and master-2008-09-23 as well?
That might help to isolate the issue.

Thanks!

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
