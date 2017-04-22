Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18717 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422773AbdDVJnM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Apr 2017 05:43:12 -0400
Date: Sat, 22 Apr 2017 12:42:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        linuxwifi <linuxwifi@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Sharon, Sara" <sara.sharon@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: pcie: off by one in
 iwl_trans_pcie_dyn_txq_alloc()
Message-ID: <20170422094248.4l2cf6bpgbnqtujd@mwanda> (sfid-20170422_114324_634062_594CF3B1)
References: <20170421194619.sjc33647odsfkcfl@mwanda>
 <1492804774.19290.5.camel@sipsolutions.net>
 <20170421201200.4y4tzlxmktacskr6@mwanda>
 <1492844542.31741.127.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492844542.31741.127.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 22, 2017 at 07:02:23AM +0000, Coelho, Luciano wrote:
> On Fri, 2017-04-21 at 23:12 +0300, Dan Carpenter wrote:
> > Heh.  I raced this one through to see if I could beat you to the punch.
> 
> Yeah, this patch is in our internal tree.  But maybe we can take Dan's
> for upstream for his efforts? :)

No no.

regards,
dan carpenter
