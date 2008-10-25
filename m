Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35864 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYJYNn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 09:43:28 -0400
Date: Sat, 25 Oct 2008 09:42:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem booting wireless-testing 2.6.28-rc1
Message-ID: <20081025134240.GF19057@tuxdriver.com> (sfid-20081025_154335_647278_6A9A688A)
References: <4902910E.1000604@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4902910E.1000604@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2008 at 08:22:54PM -0700, Larry Finger wrote:
> If you download and boot 2.6.28-rc1 from wireless-testing, you may have a
> problem in the boot process finding your hard drive. The fix has been found in
> mainline and consists of the following patch:
> 
> commit e013e13bf605b9e6b702adffbe2853cfc60e7806
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Oct 24 09:22:42 2008 +0200
> 
>     libata: fix bug with non-ncq devices

Thanks for the heads-up!  This is now part of wireless-testing's
master branch.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
