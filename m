Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50593 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283AbbCWL2s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 07:28:48 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Avinash Patil <patila@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 23 Mar 2015 04:28:44 -0700
Subject: RE: [patch] mwifiex: remove an unneede NULL check in
 mwifiex_init_adapter()
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B16B5ECA2@SC-VEXCH1.marvell.com> (sfid-20150323_122853_161504_973C7179)
References: <20150323093551.GC558@mwanda>
In-Reply-To: <20150323093551.GC558@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for the patch.

> Subject: [patch] mwifiex: remove an unneede NULL check in
> mwifiex_init_adapter()
> 
> "adapter->sleep_cfm" is always non-NULL at this point.  Static checkers
> complain that we already dereference it at the start of the function
> when we do:
> 
> 	skb_put(adapter->sleep_cfm, sizeof(struct
> mwifiex_opt_sleep_confirm));
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amit
