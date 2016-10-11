Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48144 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752274AbcJKLun (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 07:50:43 -0400
Message-ID: <1476186636.5210.18.camel@coelho.fi> (sfid-20161011_135048_362691_1ED95B34)
From: Luca Coelho <luca@coelho.fi>
To: Dan Carpenter <dan.carpenter@oracle.com>, ido@wizery.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Oct 2016 14:50:36 +0300
In-Reply-To: <20161011105027.GA29933@mwanda>
References: <20161011105027.GA29933@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [bug report] iwlwifi: mvm: Add mem debugfs entry
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan.
On Tue, 2016-10-11 at 13:50 +0300, Dan Carpenter wrote:
> Hello Ido Yariv,
> 
> The patch 2b55f43f8e47: "iwlwifi: mvm: Add mem debugfs entry" from
> Aug 23, 2016, leads to the following static checker warning:
> 
> 	drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c:1561 iwl_dbgfs_mem_read()
> 	warn: unsigned 'len' is never less than zero.

Thanks for reporting! I already have a fix for this queued up in our
internal tree.  I'll send it out soon, with my next series.

--
Cheers,
Luca.
