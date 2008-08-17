Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3388 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbYHQRci (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 13:32:38 -0400
Date: Sun, 17 Aug 2008 13:07:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Mirco Tischler <mt-ml@gmx.de>,
	Leonid Podolny <leonidp.lists@gmail.com>,
	linux-kernel@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	IvDoorn@gmail.com
Subject: Re: CPU load after killing iwlagn with RF kill switch
Message-ID: <20080817170714.GA29938@tuxdriver.com> (sfid-20080817_193242_984808_EBEF1C60)
References: <48A5EC02.4070303@gmail.com> <20080817035921.4d35ae0e@mtlp.12thdimension> <1ba2fa240808170004p63b76db1l1fdfb1cf1cb41636@mail.gmail.com> <20080817150242.GA23926@tuxdriver.com> <1ba2fa240808170920r67e11567h2da8b396b18729dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240808170920r67e11567h2da8b396b18729dd@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 17, 2008 at 07:20:54PM +0300, Tomas Winkler wrote:
> On Sun, Aug 17, 2008 at 6:02 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Sun, Aug 17, 2008 at 10:04:12AM +0300, Tomas Winkler wrote:
> >
> >> There is gap in current rfkill implementation that we didn't close
> >> yet.  There were also few patches that were not signed by Intel and
> >> are apparently wrong.
> >
> > Can you be more specific?  Do you know which patches are wrong (even
> > if you don't know how to fix them)?
> >
> 
> 80fcc9e28cf3a209fbfb39a7bbddc313c59c7424
> This one  is wrong and there are more then are not acked even though
> they cause no problem. In general I would prefer that patches will be
> acked by Yi or me.

And in general, they are.  In general I would prefer if you would
work upstream instead of working in iwlwifi-2.6 and periodically
dumping a dozen or more patches on me all at once.  C'est la vie...

> I will try to rebase our rfkill fixes ASAP from iwlwifi-2.6. iwl5000 branch.

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
