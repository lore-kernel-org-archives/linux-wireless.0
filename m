Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19759 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbYAKCDA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 21:03:00 -0500
Subject: Re: [ipw3945-devel] [PATCH 4/5] iwlwifi: iwl3945 eliminate
	sleepable task queue from context
From: Zhu Yi <yi.zhu@intel.com>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <b25c3fa70801101738j512a6189i3e4541bf0348b91f@mail.gmail.com>
References: <11998765783953-git-send-email-joonwpark81@gmail.com>
	 <1200013607.3530.128.camel@debian.sh.intel.com>
	 <b25c3fa70801101738j512a6189i3e4541bf0348b91f@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 10:01:54 +0800
Message-Id: <1200016915.3530.161.camel@debian.sh.intel.com> (sfid-20080111_020306_722822_91F0D16D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2008-01-11 at 10:38 +0900, Joonwoo Park wrote:
> I should have checked code base, it's my fault.
> it's seems very similar, but I could not made build unfortunately.
> Can you introduce to me how to build it please?
> 
> my build error is here:
> jason@ehus ~/SRC/DRIVERS/iwlwifi $
> KSRC=/home/jason/SRC/LINUX/linux-2.6 make

The version doesn't work on a .24-rc kernel. Can you compile it
with .23?

Thanks,
-yi

