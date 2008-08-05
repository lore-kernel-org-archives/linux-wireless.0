Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbYHEDgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 23:36:52 -0400
Subject: Re: [ipw3945-devel] [IWL3945]Fix statistics in monitor mode
From: Zhu Yi <yi.zhu@intel.com>
To: Junty Mesmon <jmesmon@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <f2efd86c0808041847n195ee40k9abe6599d60f51b2@mail.gmail.com>
References: <4892E14A.4000203@gmail.com>
	 <1217820737.3107.15.camel@debian.sh.intel.com>
	 <f2efd86c0808041847n195ee40k9abe6599d60f51b2@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 11:36:38 +0800
Message-Id: <1217907398.3107.51.camel@debian.sh.intel.com> (sfid-20080805_053702_437293_658C48D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-08-04 at 21:47 -0400, Junty Mesmon wrote:
> If we can have this data, what reason is their not to have it
> processed?

They are not for the monitor mode. Not related frames will mess up the
values for associated STA. This is affect the
associated-while-in-monitor mode.

Thanks,
-yi

