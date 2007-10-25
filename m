Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45631 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbXJYJ0f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:26:35 -0400
Subject: Re: [PATCH] iwl3945: cleanup namespace
From: Zhu Yi <yi.zhu@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071012130500.GA22610@lst.de>
References: <20071012130500.GA22610@lst.de>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 17:19:57 +0800
Message-Id: <1193303997.3069.389.camel@debian.sh.intel.com> (sfid-20071025_102639_215771_0B91D9A6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2007-10-12 at 15:05 +0200, Christoph Hellwig wrote:
> prefix all symbols with iwl3945_ and thus allow building the driver
> into the kernel.  Also remove all the useless default statements in
> Kconfig while we're at it.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Did you do this manually or with a script? If it is the latter, can you
run it again against my latest updates for the driver (30 patches I just
sent to linux-wireless) or share the script with me?

Thanks,
-yi
