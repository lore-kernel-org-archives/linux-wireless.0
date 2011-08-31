Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab1HaKRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 06:17:07 -0400
Subject: Re: [patch -next 1/2] iwlwifi: fix double assign in
 iwl_start_tx_ba_trans_ready()
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Carpenter <error27@gmail.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:INTEL WIRELESS WI..." <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <1314772887.4161.17.camel@jlt3.sipsolutions.net>
References: <20110831063742.GC3705@shale.localdomain>
	 (sfid-20110831_084010_132544_82772E48)  <1314772887.4161.17.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 02:34:29 -0700
Message-ID: <1314783269.26890.3.camel@wwguy-huron> (sfid-20110831_121713_422229_33E7FCD9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-30 at 23:41 -0700, Johannes Berg wrote:
> On Wed, 2011-08-31 at 09:37 +0300, Dan Carpenter wrote:
> > "vif" is assigned twice.  We can remove the first one.
> > 
> > This silences a Smatch warning that "ctx" could be one step past the
> > end of the priv->contexts[] array.
> 
> Good catch.
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 

Thanks
Wey

