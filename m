Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34640 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1F3QAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 12:00:05 -0400
Subject: Re: [PATCH 18/19 v2] iwlwifi: remove unnecessary read of
 PCI_CAP_ID_EXP
From: wwguy <wey-yi.w.guy@intel.com>
To: Jon Mason <jdmason@kudzu.us>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110630154246.GA11407@kudzu.us>
References: <1309196969-16348-1-git-send-email-jdmason@kudzu.us>
	 <20110630154246.GA11407@kudzu.us>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 08:56:08 -0700
Message-ID: <1309449368.25768.12.camel@wwguy-ubuntu> (sfid-20110630_180025_190266_0A1F5500)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-30 at 08:42 -0700, Jon Mason wrote:
> The PCIE capability offset is saved during PCI bus walking.  It will
> remove an unnecessary search in the PCI configuration space if this
> value is referenced instead of reacquiring it.
> 
> Signed-off-by: Jon Mason <jdmason@kudzu.us>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
compile and work for me now

Wey

