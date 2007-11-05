Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4315 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbXKEC5Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2007 21:57:24 -0500
Subject: Re: [PATCH] postfix decrement error in ipw2100_start_adapter();
	drivers/net/wireless/ipw2100.c
From: Zhu Yi <yi.zhu@intel.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <472E671F.80907@tiscali.nl>
References: <472E671F.80907@tiscali.nl>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 10:50:51 +0800
Message-Id: <1194231051.31257.127.camel@debian.sh.intel.com> (sfid-20071105_025730_705575_15D8B68E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-11-05 at 01:43 +0100, Roel Kluin wrote:
> If i reaches zero, the loop ends, but the postfix decrement subtracts
> it to -1.
> Testing for 'i == 0', later in the function, will not fulfill its
> purpose.
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi
