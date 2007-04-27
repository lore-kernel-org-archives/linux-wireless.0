Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4974 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364AbXD0Bd2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 21:33:28 -0400
Date: Thu, 26 Apr 2007 20:55:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/9] wext: remove dead debug code
Message-ID: <20070427005549.GB25332@tuxdriver.com>
References: <20070424180732.371620000@sipsolutions.net> <20070424180847.982382000@sipsolutions.net> <20070426164632.GA22576@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070426164632.GA22576@bougret.hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 26, 2007 at 09:46:32AM -0700, Jean Tourrilhes wrote:

> 	Overall ok with the patches. Comments on a few of them...
> 	I personally would not remove this DEBUG code, because it
> decreases the overall maitainability of the code.
> 	First, it does not only help to debug the API, but it can be
> used to debug userspace and drivers in some extreme cases.
> 	Second, this debugging act as documentation. He points out
> which are the important variables and how they are used at critical
> points of the code.
> 	As this debug is localised, and compiled out, it does not
> bother anybody and should stay.

Jean,

I think the code looks cleaner with the patch applied.  If the
debugging is valuable to you, I recommend that you save this patch
and reverse apply it before future work.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
