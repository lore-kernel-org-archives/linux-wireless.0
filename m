Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22302 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1040466AbdDUUM0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 16:12:26 -0400
Date: Fri, 21 Apr 2017 23:12:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sara Sharon <sara.sharon@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: off by one in
 iwl_trans_pcie_dyn_txq_alloc()
Message-ID: <20170421201200.4y4tzlxmktacskr6@mwanda> (sfid-20170421_221230_441710_330BB8D6)
References: <20170421194619.sjc33647odsfkcfl@mwanda>
 <1492804774.19290.5.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492804774.19290.5.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heh.  I raced this one through to see if I could beat you to the punch.

regards,
dan carpenter
