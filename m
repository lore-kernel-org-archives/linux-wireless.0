Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46194 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbYFLNzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 09:55:41 -0400
Date: Thu, 12 Jun 2008 06:55:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix noise calculation WARN_ON
Message-ID: <20080612065536.73fe1741@infradead.org> (sfid-20080612_155544_163394_D5E7C14D)
In-Reply-To: <200806121236.30255.mb@bu3sch.de>
References: <200806121236.30255.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Jun 2008 12:36:29 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> This removes a WARN_ON that is responsible for the following koops:
> http://www.kerneloops.org/searchweek.php?search=b43_generate_noise_sample
> 
> The comment in the patch describes why it's safe to simply remove
> the check.
> 

thanks a lot for fixing this!

Acked-by: Arjan van de Ven <arjan@linux.intel.com>


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
