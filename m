Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46180 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbbLIKlf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 05:41:35 -0500
Message-ID: <1449657682.2304.1.camel@sipsolutions.net> (sfid-20151209_114219_953889_2606ABCF)
Subject: Re: [patch] iwlwifi: mvm: remove an extra tab
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Golan Ben-Ami <golan.ben.ami@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Wed, 09 Dec 2015 11:41:22 +0100
In-Reply-To: <20151209102608.GF3173@mwanda> (sfid-20151209_112631_985246_0F4FF2B2)
References: <20151209102608.GF3173@mwanda>
	 (sfid-20151209_112631_985246_0F4FF2B2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-12-09 at 13:26 +0300, Dan Carpenter wrote:
> Smatch prints a static checker warning here:
> 
>     drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c:386
> iwl_dump_prph()
>     warn: curly braces intended?
> 
> Curly braces are NOT intended, the extra tab was added by mistake in
> commit 1a616dd2f171 ('iwlwifi: dump prph registers in a common place
> for all transports').
> 

Applied, thanks.

johannes
