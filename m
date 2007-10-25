Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40677 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020AbXJYGn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 02:43:26 -0400
Subject: Re: [PATCH 1/3] iwl3945 & iwl4965: mark more functions/variables
	static
From: Zhu Yi <yi.zhu@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071012123258.GA20794@lst.de>
References: <20071012123258.GA20794@lst.de>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 14:36:17 +0800
Message-Id: <1193294177.3069.378.camel@debian.sh.intel.com> (sfid-20071025_074331_280299_7C1E6968)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2007-10-12 at 14:32 +0200, Christoph Hellwig wrote:
>  int iwl_param_disable;      /* def: enable radio */
>  int iwl_param_antenna;      /* def: 0 = both antennas (use diversity)
> */
>  int iwl_param_hwcrypto;     /* def: using software encryption */
> -int iwl_param_qos_enable = 1;
> +static int iwl_param_qos_enable = 1;
>  int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;

I think more of them could be static. Will send a updated patch later.

Thanks,
-yi
