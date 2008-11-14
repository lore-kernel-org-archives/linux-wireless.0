Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:56719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbYKNOqL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 09:46:11 -0500
Message-ID: <491D8F23.4030407@suse.de> (sfid-20081114_154614_566835_D68AAE1E)
Date: Fri, 14 Nov 2008 15:45:55 +0100
From: Frank Seidel <fseidel@suse.de>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"hschaa@suse.de" <hschaa@suse.de>
Subject: Re: Problem with Kernel Oops in ipw2200
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de>	 <20081112213350.GJ2411@tuxdriver.com>  <491BF062.4050705@suse.de> <1226631539.2604.411.camel@debian.sh.intel.com>
In-Reply-To: <1226631539.2604.411.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi wrote:
> Please try if attached patch fix the problem.

Unfortunately this bug isn't that easy to reproduce, this
is why my tests took so long.
But finally i can say this if clause really is hit and
circumvents the oops!
Thank you very much!
So, can this patch please be taken?

Thanks,
Frank
